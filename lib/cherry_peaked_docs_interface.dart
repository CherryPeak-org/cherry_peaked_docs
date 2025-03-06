import "package:cherry_peaked_docs/cherry_peaked_docs_channel.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

abstract class CherryPeakedDocsInterface extends PlatformInterface {
  /// Constructs a CherryPeakedDocsPlatform.
  CherryPeakedDocsInterface() : super(token: _token);

  static final Object _token = Object();

  static CherryPeakedDocsInterface _instance = CherryPeakedDocsChannel();

  /// The default instance of [CherryPeakedDocsInterface] to use.
  ///
  /// Defaults to [CherryPeakedDocsChannel].
  static CherryPeakedDocsInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CherryPeakedDocsInterface] when
  /// they register themselves.
  static set instance(final CherryPeakedDocsInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError("getPlatformVersion() has not been implemented.");
  }
}
