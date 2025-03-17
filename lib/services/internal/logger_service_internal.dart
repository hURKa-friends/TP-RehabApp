import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rehab_app/main.dart';
import 'package:rehab_app/services/models/logger_exception.dart';

final String loggerDirectoryPath = '$baseAppDirectoryPath/logger';

enum LogChannel { csv, error, event, plain }
enum ChannelAccess { public, protected, private }
enum ChannelStates { closed, open, busy }
enum LogOperation { log, manage }

class LoggerServiceInternal {
  final Map<LogChannel, ChannelAccess> _channelAccessLevels = {};
  final Map<LogChannel, ChannelStates?> _channelStates = {};
  final Map<LogChannel, String?> _channelOwnerUIDs = {};
  final Map<LogChannel, File?> _channelFiles = {};
  final Map<LogChannel, IOSink?> _channelSinks = {};

  initialize() async {
    final permissionState = await _managePermissions();
    final directoryState = await _initializeStorage();

    if(!(permissionState && directoryState)) {
      throw LoggerException("Permission or directory creation failed.");
    }

    for (var channel in LogChannel.values) {
      _channelAccessLevels[channel] = ChannelAccess.private;
      _channelStates[channel] = ChannelStates.closed;
      _channelOwnerUIDs[channel] = null;
      _channelFiles[channel] = null;
      _channelSinks[channel] = null;
    }
  }
  Future<bool> _managePermissions() async {
    final storagePermission = await Permission.storage.request().isGranted;
    final externalPermission = await Permission.manageExternalStorage.request().isGranted;
    return storagePermission && externalPermission;
  }
  Future<bool> _initializeStorage() async {
    try {
      for (var channel in LogChannel.values) {
        final dir = Directory('$loggerDirectoryPath/${channel.name}');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }

  String _generateOwnerUID() {
    int hash = Object.hashAll([DateTime.now(), Random().nextInt(1 << 32)]);
    return hash.abs().toString();
  }
  bool _checkAccess(LogChannel channel, String ownerUID, LogOperation operation) {
    switch (_channelAccessLevels[channel]!) {
      case ChannelAccess.public:
        return true;
      case ChannelAccess.protected:
        if(operation == LogOperation.log) {
          return true;
        } else if(operation == LogOperation.manage) {
          if (ownerUID == _channelOwnerUIDs[channel]!) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      case ChannelAccess.private:
        if (ownerUID == _channelOwnerUIDs[channel]!) {
          return true;
        } else {
          return false;
        }
    }
  }

  Future<String?> initializeChannel (LogChannel channel, ChannelAccess access, String fileName, {String subChannel = "", String headerData = ""}) async {
    if(_channelStates[channel]! != ChannelStates.closed) {
      return null;
    }

    // Check for channel and sub-channel directory
    Directory? dir = (channel == LogChannel.plain)?
                     (Directory('$loggerDirectoryPath/${channel.name}/$subChannel')):
                     (Directory('$loggerDirectoryPath/${channel.name}'));

    if(!await dir.exists()) {
      Directory? newDir = await dir.create(recursive: true);
      if(!await newDir.exists()) {
        return null;
      }
    }

    switch(channel) {
      case LogChannel.csv:
        _channelFiles[channel] = File('${dir.path}/${DateFormat('yyyy_MM_dd-HH_mm').format(DateTime.now())}-$fileName.txt');
        break;
      case LogChannel.error:
        _channelFiles[channel] = File('${dir.path}/${DateFormat('yyyy_MM_dd-HH_mm').format(DateTime.now())}-$fileName.log');
        break;
      case LogChannel.event:
        _channelFiles[channel] = File('${dir.path}/${DateFormat('yyyy_MM_dd-HH_mm').format(DateTime.now())}-$fileName.log');
        break;
      case LogChannel.plain:
        _channelFiles[channel] = File('${dir.path}/${DateFormat('yyyy_MM_dd-HH_mm').format(DateTime.now())}-$fileName.txt');
        break;
    }

    _channelSinks[channel] = _channelFiles[channel]!.openWrite(mode: FileMode.append);
    _channelAccessLevels[channel] = access;
    _channelStates[channel] = ChannelStates.open;
    _channelOwnerUIDs[channel] = _generateOwnerUID();

    if (channel == LogChannel.csv) {
      log(channel, _channelOwnerUIDs[channel]!, '$headerData\n');
    }

    return _channelOwnerUIDs[channel];
  }
  bool log(LogChannel channel, String ownerUID, String data) {
    if(!_checkAccess(channel, ownerUID, LogOperation.log)) {
      return false;
    }
    if(_channelStates[channel]! != ChannelStates.closed) {
      _channelSinks[channel]!.write(data);
      return true;
    }
    return false;
  }

  Future<void> _flushChannelDataToFile({required LogChannel channel}) async {
    await _channelSinks[channel]!.flush();
  }
  Future<void> disposeOfChannel({required String ownerId, required LogChannel channel, required bool safeDisposal}) async {
    if (safeDisposal) {
      await _flushChannelDataToFile(channel: channel);
    }

    await _channelSinks[channel]!.close();
    _channelStates[channel] = ChannelStates.closed;
    _channelFiles[channel] = null;
    _channelOwnerUIDs[channel] = null;
  }
}