import "package:cherry_peaked_docs/cherry_peaked_docs_platform_interface.dart";

class CherryPeakedDocs {
  Future<String?> getPlatformVersion() {
    return CherryPeakedDocsPlatform.instance.getPlatformVersion();
  }
}
