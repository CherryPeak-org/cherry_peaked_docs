import "package:cherry_peaked_docs/cherry_peaked_docs_interface.dart";
import "package:cherry_peaked_docs/cherry_peaked_docs_options.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

/// An implementation of [CherryPeakedDocsInterface] that uses method channels.
class CherryPeakedDocsChannel extends CherryPeakedDocsInterface {
  /// The method channel used to interact with the native platform.
  /// Supported data types: https://docs.flutter.dev/platform-integration/platform-channels
  @visibleForTesting
  final methodChannel = const MethodChannel("cherry_peaked_docs");

  @override
  Future<List<String>> startScanning(final CherryPeakedDocsOptions options) async {
    final paths = await methodChannel.invokeListMethod<String>("startScanning", options.toMap());
    return paths!;
  }

  @override
  Future<void> forceStopScanning() async {
    await methodChannel.invokeMethod<void>("forceStopScanning");
  }
}
