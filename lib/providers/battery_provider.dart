import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';

class BatteryProvider with ChangeNotifier {
  final Battery _battery = Battery();
  late StreamSubscription<BatteryState> _batteryStateSubscription;
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.unknown;

  int get batteryLevel => _batteryLevel;
  BatteryState get batteryState => _batteryState;
  
  bool get isCharging => _batteryState == BatteryState.charging;
  bool get isLowBattery => _batteryLevel < 20;
  bool get isCriticalBattery => _batteryLevel < 10;

  String get batteryIcon {
    if (isCharging) return '⚡';
    if (_batteryLevel > 75) return '🔋';
    if (_batteryLevel > 50) return '🔋';
    if (_batteryLevel > 25) return '🪫';
    return '🪫';
  }

  String get batteryText {
    return '$_batteryLevel%';
  }

  BatteryProvider() {
    _initBattery();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen(_updateBatteryState);
  }

  Future<void> _initBattery() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      _batteryLevel = level;
      _batteryState = state;
      notifyListeners();
    } catch (e) {
      print('Could not get battery info: $e');
      // Set default values for web
      _batteryLevel = 100;
      _batteryState = BatteryState.unknown;
    }
  }

  void _updateBatteryState(BatteryState state) async {
    try {
      _batteryState = state;
      final level = await _battery.batteryLevel;
      _batteryLevel = level;
      notifyListeners();
    } catch (e) {
      print('Could not update battery state: $e');
    }
  }

  @override
  void dispose() {
    _batteryStateSubscription.cancel();
    super.dispose();
  }
}
