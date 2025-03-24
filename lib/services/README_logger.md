# Logger tutorial

This tutorial covers all of the available functions in file **logger_service.dart**, which you can access from `Logger()`.
You can basically see channel as a 'file'.

### `Future<String> openLogChannel({required ChannelAccess access, required String fileName, required LogChannel channel})`
- This function opens new channel for logging data.
- **@access** - If others can access this channel. This can either be private, protected or public.
  - _private_ - You will need ownerId to log into this channel.
  - _protected_ - You will need ownerId to log into, unless you are just logging (not managing).
  - _public_ - You won't need ownerId to log into this channel
- **@fileName** - Name of created file. Every filename starts with current DateTime.
- **@channel** - What type of channel do you want to create. This can either be csv, error, event or plain. The file will be saved in corresponding directory.
- **@returns** - String containing generated ownerId.

### `Future<String?> openCsvLogChannel({required ChannelAccess access, required String fileName, required String headerData})`
- This function opens new _csv_ channel for logging data.
- **@access** - If others can access this channel. This can either be private, protected or public.
    - _private_ - You will need ownerId to log into this channel.
    - _protected_ - You will need ownerId to log into, unless you are just logging (not managing).
    - _public_ - You won't need ownerId to log into this channel
- **@fileName** - Name of created file. Every filename starts with current DateTime.
- **@headerData** - String that will appear on the first line in the file. _e.g. "Time, X, Y, Z"_
- **@returns** - String containing generated ownerId.

### `Future<String?> openPlainLogChannel({required ChannelAccess access, required String fileName, String subChannel = ""})`
- This function opens new _txt_ channel for logging data.
- **@access** - If others can access this channel. This can either be private, protected or public.
    - _private_ - You will need ownerId to log into this channel.
    - _protected_ - You will need ownerId to log into, unless you are just logging (not managing).
    - _public_ - You won't need ownerId to log into this channel
- **@fileName** - Name of created file. Every filename starts with current DateTime.
- **@subChannel (optional)** - File will be saved in additional directory called _subChannel_
- **@returns** - String containing generated ownerId.

### `bool log({required LogChannel channel, required String ownerId, required String data})`
- This function logs data to specified open channel.
- **@channel** - Channel where you want to log.
- **@ownerId** - ownerId you received from opening channel.
- **@data** - Data to log into file.
- **@returns** - True if logging was successful. Returns false otherwise (e.g. if the channel is closed).

### `void closeLogChannelSafely({required String ownerId, required LogChannel channel})`
- This function closes opened channel safely. Safely means it flushes _Stream_ into file before closing it.
- **@channel** - Channel which you want to close.
- **@ownerId** - ownerId you received from opening channel.

### `void closeLogChannel({required String ownerId, required LogChannel channel})`
- This function closes opened channel. It doesn't flush data from _Stream_ into file, meaning any unflushed data will be lost.
- **@channel** - Channel which you want to close.
- **@ownerId** - ownerId you received from opening channel.