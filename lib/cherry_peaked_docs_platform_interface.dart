import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cherry_peaked_docs_method_channel.dart';

abstract class CherryPeakedDocsPlatform extends PlatformInterface {
  /// Constructs a CherryPeakedDocsPlatform.
  CherryPeakedDocsPlatform() : super(token: _token);

  static final Object _token = Object();

  static CherryPeakedDocsPlatform _instance = MethodChannelCherryPeakedDocs();

  /// The default instance of [CherryPeakedDocsPlatform] to use.
  ///
  /// Defaults to [MethodChannelCherryPeakedDocs].
  static CherryPeakedDocsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CherryPeakedDocsPlatform] when
  /// they register themselves.
  static set instance(CherryPeakedDocsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
