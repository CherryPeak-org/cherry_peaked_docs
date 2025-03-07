import "dart:io" show File;

class CherryPeakedDocsResult {
  final List<File> files;

  CherryPeakedDocsResult({required this.files});

  @override
  bool operator ==(final Object other) {
    return identical(this, other) ||
        other is CherryPeakedDocsResult && runtimeType == other.runtimeType && files == other.files;
  }

  @override
  int get hashCode {
    return files.hashCode;
  }
}
