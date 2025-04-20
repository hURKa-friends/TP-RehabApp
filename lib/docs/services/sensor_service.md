[Back to **Documentation for `Tele-Rehabilitation` mobile application and its components**](../rehab_app.md)
# Sensor Service documentation
`SensorService` is a singleton class that provides public service API for `SensorServiceInternal`
that wraps asynchronous periodic data polling from sensors (`accl`,`gyro`,`mag`,`lux`) through data
streams and `StreamSubscription`s. This allows developer to turn on and off streams easily, get
singular samples of data or continuous data stream from sensor.

## Technical Information
Internally `SensorServiceInternal` uses data streams implemented in `sensors_plus` and `light_sensor`
libraries and encapsulates them in custom data streams that add more information to gathered data.
Goal of this service is to provide global and easy service which can turn on/off data streams from
sensors and expose sensor data as single samples or continuous streams.

## Folder Structure
`LoggerService` is implemented in these files.
```plain
lib/
└── services/
    ├── external/
    │   └──sensor_service.dart
    └── internal/
        └── sensor_service_internal.dart
```

## Example Usage
In this section you can find how `SensorService` can be used inside `StatelessPage` `Widget` in MVVM
structure on examples using Accelerometer sensor. However every other sensor works in a similar way
so you should be able to figure out how to implement them upon seeing these examples.

### Registering `onDataChanged(<T> data)` callback / Starting sensor data stream
```dart
class FooViewModel extends ChangeNotifier {
  void registerSensorService() {
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => onDataChanged(data));
  }

  void onDataChanged(ImuSensorData data) {
    // Do anything with current sample of `data`
  }
}
```
> [!TIP]
> The `registerSensorService()` should be called when page is initialized, somewhere in your `foo_view.dart`.
```dart
class FooView extends StatelessPage {
  //...
  @override
  void initPage(BuildContext context) {
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false);
    fooViewModel.registerSensorService();
  }
}
```

### Disposing of / Stopping sensor data stream
```dart
class FooViewModel extends ChangeNotifier {
  void onClose() {
    SensorService().stopGyroDataStream();
  }
}
```
> [!TIP]
> The `onClose()` should be called when page is closing, somewhere in your `foo_view.dart`.
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

[Back to **Documentation for `Tele-Rehabilitation` mobile application and its components**](../rehab_app.md)

---

## API Documentation
> [!WARNING]
> This section was Semi-auto generated. If you encounter any issues report them.

> #### bool isAcclOn()
> Checks whether the accelerometer sensor is currently active.
> - **@returns** - Returns `true` if the accelerometer stream is on, otherwise `false`.

> #### bool isGyroOn()
> Checks whether the gyroscope sensor is currently active.
> - **@returns** - Returns `true` if the gyroscope stream is on, otherwise `false`.

> #### bool isMagOn()
> Checks whether the magnetometer sensor is currently active.
> - **@returns** - Returns `true` if the magnetometer stream is on, otherwise `false`.

> #### bool isLuxOn()
> Checks whether the lux (light) sensor is currently active.
> - **@returns** - Returns `true` if the lux sensor stream is on, otherwise `false`.
 
---

> #### bool startAcclDataStream({required Duration samplingPeriod})
> Starts the accelerometer data stream with a specified sampling period.
> - **@samplingPeriod** - Required input argument that specifies the rate at which data should be collected.
> - **@returns** - Returns `true` if the stream started successfully, otherwise `false`.

> #### bool startGyroDataStream({required Duration samplingPeriod})
> Starts the gyroscope data stream with a specified sampling period.
> - **@samplingPeriod** - Required input argument that specifies the rate at which data should be collected.
> - **@returns** - Returns `true` if the stream started successfully, otherwise `false`.

> #### bool startMagDataStream({required Duration samplingPeriod})
> Starts the magnetometer data stream with a specified sampling period.
> - **@samplingPeriod** - Required input argument that specifies the rate at which data should be collected.
> - **@returns** - Returns `true` if the stream started successfully, otherwise `false`.

> #### bool startLuxDataStream()
> Starts the lux (light) sensor data stream.
> - **@returns** - Returns `true` if the stream started successfully, otherwise `false`.

---

> #### bool registerAcclDataStream({required Function(ImuSensorData) callback})
> Registers a callback function to receive accelerometer data.
> - **@callback** - Required input argument a function that processes incoming `ImuSensorData`.
> - **@returns** - Returns `true` if registration was successful, otherwise `false`.

> #### bool registerGyroDataStream({required Function(ImuSensorData) callback})
> Registers a callback function to receive gyroscope data.
> - **@callback** - Required input argument; a function that processes incoming `ImuSensorData`.
> - **@returns** - Returns `true` if registration was successful, otherwise `false`.

> #### bool registerMagDataStream({required Function(ImuSensorData) callback})
> Registers a callback function to receive magnetometer data.
> - **@callback** - Required input argument; a function that processes incoming `ImuSensorData`.
> - **@returns** - Returns `true` if registration was successful, otherwise `false`.

> #### bool registerLuxDataStream({required Function(LuxSensorData) callback})
> Registers a callback function to receive lux (light) sensor data.
> - **@callback** - Required input argument; a function that processes incoming `LuxSensorData`.
> - **@returns** - Returns `true` if registration was successful, otherwise `false`.

---

> #### ImuSensorData getAcclData()
> Returns the latest available accelerometer data.
> - **@returns** - Returns an instance of `ImuSensorData` containing accelerometer readings.

> #### ImuSensorData getGyroData()
> Returns the latest available gyroscope data.
> - **@returns** - Returns an instance of `ImuSensorData` containing gyroscope readings.

> #### ImuSensorData getMagData()
> Returns the latest available magnetometer data.
> - **@returns** - Returns an instance of `ImuSensorData` containing magnetometer readings.

> #### LuxSensorData getLuxData()
> Returns the latest available lux (light) sensor data.
> - **@returns** - Returns an instance of `LuxSensorData` containing lux readings.

---

> #### bool stopAcclDataStream()
> Stops the accelerometer data stream.
> - **@returns** - Returns `true` if the stream was successfully stopped, otherwise `false`.

> #### bool stopGyroDataStream()
> Stops the gyroscope data stream.
> - **@returns** - Returns `true` if the stream was successfully stopped, otherwise `false`.

> #### bool stopMagDataStream()
> Stops the magnetometer data stream.
> - **@returns** - Returns `true` if the stream was successfully stopped, otherwise `false`.

> #### bool stopLuxDataStream()
> Stops the lux (light) sensor data stream.
> - **@returns** - Returns `true` if the stream was successfully stopped, otherwise `false`.

[Back to **Documentation for `Tele-Rehabilitation` mobile application and its components**](../rehab_app.md)