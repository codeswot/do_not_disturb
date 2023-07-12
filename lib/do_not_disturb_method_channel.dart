import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'do_not_disturb_platform_interface.dart';

/// An implementation of [DoNotDisturbPlatform] that uses method channels.
class MethodChannelDoNotDisturb extends DoNotDisturbPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('do_not_disturb');

  @override
  Future<bool> setStatus(bool value) async {
    try {
      await methodChannel.invokeMethod('setStatus', value);
      return await status;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error setting Do Not Disturb: ${e.message}');
      }
      rethrow;
    }
  }

  Future<bool> _status() async {
    try {
      final bool status = await methodChannel.invokeMethod('status');
      return status;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error getting Do Not Disturb status: ${e.message}');
      }
      rethrow;
    }
  }

  @override
  Future<bool> get status async => await _status();

  @override
  Stream<bool> statusStream() {
    try {
      return methodChannel
          .invokeMethod<bool>('status')
          .asStream()
          .asyncMap((event) => event as bool);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error getting Do Not Disturb status stream: ${e.message}');
      }
      rethrow;
    }
  }
}
