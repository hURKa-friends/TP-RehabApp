import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier with WidgetsBindingObserver  {
  // Private Fields & Parameters
  Brightness? _brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  double _sliderValue = 1.0;

  // Constructors (if needed)
  SettingsViewModel() {
    _initializeSliderValue();
    WidgetsBinding.instance.addObserver(this);
  }

  // Getters
  Brightness get brightness => (_brightness != null) ? (_brightness!) : (Brightness.light);
  double get sliderValue => _sliderValue;

  // Methods (if needed)
  void setBrightness(Brightness brightness) {
    _brightness = brightness;
    notifyListeners();
  }

  void _initializeSliderValue() {
    _sliderValue = brightness == Brightness.light ? 0.0 : brightness == Brightness.dark ? 2.0 : 1.0;
    notifyListeners();
  }

  void onSliderChanged(double value) {
    _sliderValue = value;
    if (value < 0.5) {
      setBrightness(Brightness.light);
    } else if (value > 1.5) {
      setBrightness(Brightness.dark);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setBrightness(WidgetsBinding.instance.platformDispatcher.platformBrightness);
      });
    }
    notifyListeners();
  }

  @override  // Override the method to handle system theme changes
  void didChangePlatformBrightness() {
    setBrightness(WidgetsBinding.instance.platformDispatcher.platformBrightness);
    super.didChangePlatformBrightness();
  }

  @override  // Don't forget to remove the observer when the view model is disposed
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}