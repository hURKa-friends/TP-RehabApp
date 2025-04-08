# Logger Service documentation
`LoggerService` is a singleton class that provides public service API for `LoggerServiceInternal`
that implements asynchronous logging operations using `IOSink` with custom `LogChannel` and 
`ChannelAccess` logic. This allows developers to simply log multiple streams of data without doing
necessary file management whilst keeping some channel access functions.


## Technical Information
Internally in `LoggerServiceInternal` every channel is represented as separate `IOSink`-`File` pair.
Therefore **you can think of a channel as a "FileStream"** of some sort. The main difference is that 
these "FileStreams" have custom features to enhance `LoggerService` functionality.

### 1. Multiple channels
As was mentioned `LoggerService` provides multiple channels each having its own function.
```dart
enum LogChannel { csv, error, event, plain }
```
| Channel Type | Description                                                                                                                                                                                                                          |
|:------------:|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     csv      | Channel that creates local `.csv` file with CSV header in `app\logger\csv\` folder. Data for CSV header are **required** when opening this channel. This channel is intended for general data logging.                               |
|    error     | Channel that creates local `.log` file in `app\logger\error\` folder intended for error logs.                                                                                                                                        |
|    event     | Channel that creates local `.log` file in `app\logger\event\` folder intended for event logs.                                                                                                                                        |
|    plain     | Channel that creates local `.txt` file in `app\logger\plain\subfolder` folder. Subfolder location is **required** when opening this channel. This channel is intended for other use cases when provided channels are not sufficient. |

### 2. Channel access
`LoggerService` uses "Channel Ownership" and simple "Access Management" to ensure channel security.
When developer opens channel he gets `UOID` (Unique Owner ID) that paired with channel access setting
can be used to access and or manage the channel.
```dart
enum ChannelAccess { public, protected, private }
```
| Channel Access | Channel Logging                                       | Channel Management                                 |
|:--------------:|-------------------------------------------------------|----------------------------------------------------|
|    private     | `UOID` **is required** to log into this channel.      | `UOID` **is required** to manage this channel.     |
|   protected    | `UOID` **is NOT required** to log into this channel.  | `UOID` **is required** to manage this channel.     |
|     public     | `UOID` **is NOT required** to log into  this channel. | `UOID` **is NOT required** to manage this channel. |
> [!IMPORTANT]
> Channels that can be managed without `UOID` can be closed by anyone without Owner confirmation.

## Folder Structure
`LoggerService` is implemented in these files.
```plain
lib/
└── services/
    ├── external/
    │   └── logger_service.dart
    └── internal/
        └── logger_service_internal.dart
```

## Example Usage
In this section you can find how exactly you should use this service. We provide examples for the most
common channel type (CSV) and MVVM structured `StatelessPage`. However every other channel works the 
same therefore you should be able to implement them upon seeing these examples.

### Opening new CSV channel
```dart
class FooViewModel extends ChangeNotifier {
  late String? UOID;
  //...
  Future<void> onInit() async {
    UOID = await LoggerService().openCsvLogChannel(access: ChannelAccess.private, fileName: 'fooFile', headerData: 'HeaderData1, HeaderData2, HeaderData3');
  }
}
```
The `onInit()` is called when page is initialized, somewhere here:
```dart
class FooView extends StatelessPage {
  //...
  @override
  void initPage(BuildContext context) {
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false);
    fooViewModel.onInit();
  }
}
```

### Writing to an opened CSV channel
```dart
class FooViewModel extends ChangeNotifier {
  late String? UOID;
  //...
  void onDataChanged() {
    bool wasSuccessful = LoggerService().log(channel: LogChannel.csv, ownerId: UOID!, data: 'Some Data');
  }
}
```
> [!CAUTION]
> If you try to write to un-opened channel it may cause issues.

### Closing CSV channel
```dart
class FooViewModel extends ChangeNotifier {
  late String? UOID;
  //...
  void onClose() {
    LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
  }
}
```
The `onClose()` is called when page is closed, somewhere here:
```dart
class FooView extends StatelessPage {
  //...
  @override
  void closePage(BuildContext context) {
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false);
    fooViewModel.onClose();
  }
}
```

---
### API Documentation

> [!TIP]
> Recommended ONLY for `event`, `error` channel types.

> #### Future<String?> openLogChannel({required ChannelAccess access, required String fileName, required LogChannel channel})
> Function that opens a new channel of type `LogChannel` for data logging.
> - **@access** - Required input argument that specifies `ChannelAccess` property of newly opened channel.
> - **@fileName** - Required input argument that specifies name of created file. Every filename starts with current DateTime in `yyyy_MM_dd-HH_mm` format.
> - **@channel** - Required input argument that specifies what type of channel you want to create. This can either be `csv`, `error`, `event` or `plain`. The file will be saved in corresponding directory.
> - **@returns** - Return parameter of type `String` containing generated unique ownerId.

> #### Future<String?> openCsvLogChannel({required ChannelAccess access, required String fileName, required String headerData})
> Function that opens a new channel of type `csv` for data logging.
> - **@access** - Required input argument that specifies `ChannelAccess` property of newly opened channel.
> - **@fileName** - Required input argument that specifies name of created file. Every filename starts with current DateTime in `yyyy_MM_dd-HH_mm` format.
> - **@headerData** - Required input argument that will be used as CSV header on the first line in the csv file. e.g. `Time, X, Y, Z`.
> - **@returns** - Return parameter of type `String` containing generated unique ownerId.

> #### Future<String?> openPlainLogChannel({required ChannelAccess access, required String fileName, String subChannel = ""})
> Function that opens a new channel of type `plain` for data logging.
> - **@access** - Required input argument that specifies `ChannelAccess` property of newly opened channel.
> - **@fileName** - Required input argument that specifies name of created file. Every filename starts with current DateTime in `yyyy_MM_dd-HH_mm` format.
> - **subChannel** - **Optional** input argument that will be used as additional directory subfolder name. 
> - **@returns** - Return parameter of type `String` containing generated unique ownerId.

> [!CAUTION]
> If you try to write to un-opened channel it may cause issues.

> #### bool log({required LogChannel channel, required String ownerId, required String data})
> This function logs data to specified `LogChannel` channel.
> - **@channel** - Required input argument `LogChannel` where you want to log data.
> - **@ownerId** - Required input argument of unique ownerId that you received when opening a file.
> - **@data** - Required input argument of data to log into file.
> - **@returns** - True if logging was successful. Returns false otherwise _(e.g. if the channel is closed)_.

>#### void closeLogChannelSafely({required String ownerId, required LogChannel channel})
> This function closes opened channel safely. Safely means it flushes _Stream_ into file before closing it.
> - **@channel** - Required input argument `LogChannel` which you want to close.
> - **@ownerId** - Required input argument of unique ownerId that you received when opening a file.

> [!WARNING] 
> This closes channel without flushing the data. Data loss can happen.

>#### void closeLogChannel({required String ownerId, required LogChannel channel})
>  This function closes opened channel. It doesn't flush data from _Stream_ into file, meaning any unflushed data will be lost.
> - **@channel** - Required input argument `LogChannel` which you want to close.
> - **@ownerId** - Required input argument of unique ownerId that you received when opening a file.