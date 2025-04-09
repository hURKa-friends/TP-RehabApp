# Sensor Service documentation
`SensorService` is a singleton class that provides public service API for `SensorServiceInternal`
that wraps asynchronous periodic data polling from sensors (`accl`,`gyro`,`mag`,`lux`) through data
streams and `StreamSubscription`s. This allows developer to turn on and off streams easily, get
singular samples of data or continuous data stream from sensor.

## Technical Information
> [!WARNING]
> Work in progress!

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
> [!WARNING]
> Work in progress!

## API Documentation
## Example Usage
> [!WARNING]
> This section was Semi-auto generated. If you encounter any issues report them.
>
> Work in progress!