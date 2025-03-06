import "package:cherry_peaked_docs/cherry_peaked_docs_platform_interface.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

/// An implementation of [CherryPeakedDocsPlatform] that uses method channels.
class MethodChannelCherryPeakedDocs extends CherryPeakedDocsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("cherry_peaked_docs");

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>("getPlatformVersion");
    return version;
  }
}
