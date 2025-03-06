import "package:cherry_peaked_docs/cherry_peaked_docs_format.dart";

class CherryPeakedDocsResult {
  final CherryPeakedDocsFormat format;
  final List<String> paths;

  CherryPeakedDocsResult({required this.format, required this.paths});

  @override
  bool operator ==(final Object other) {
    return identical(this, other) ||
        other is CherryPeakedDocsResult &&
            runtimeType == other.runtimeType &&
            format == other.format &&
            paths == other.paths;
  }

  @override
  int get hashCode {
    return Object.hash(format, paths);
  }
}
