import "package:cherry_peaked_docs/cherry_peaked_docs_interface.dart";

class CherryPeakedDocs {
  Future<String?> getPlatformVersion() {
    return CherryPeakedDocsInterface.instance.getPlatformVersion();
  }
}
