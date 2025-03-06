import "package:cherry_peaked_docs/cherry_peaked_docs_format.dart";
import "package:path/path.dart" show join;
import "package:path_provider/path_provider.dart" show getApplicationDocumentsDirectory;

class CherryPeakedDocsOptions {
  final String path;
  final CherryPeakedDocsFormat format;
  final int androidPageLimit;
  final bool isAndroidGalleryImportAllowed;

  CherryPeakedDocsOptions({
    required this.path,
    required this.format,
    required this.androidPageLimit,
    required this.isAndroidGalleryImportAllowed,
  });

  static Future<CherryPeakedDocsOptions> platformMatching() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "cherry-peaked-docs");

    return CherryPeakedDocsOptions(
      path: path,
      format: CherryPeakedDocsFormat.jpg,
      // values below match iOS limitations
      androidPageLimit: 24,
      isAndroidGalleryImportAllowed: false,
    );
  }

  CherryPeakedDocsOptions copyWith({
    final String? path,
    final CherryPeakedDocsFormat? format,
    final int? androidPageLimit,
    final bool? isAndroidGalleryImportAllowed,
  }) {
    return CherryPeakedDocsOptions(
      path: path ?? this.path,
      format: format ?? this.format,
      androidPageLimit: androidPageLimit ?? this.androidPageLimit,
      isAndroidGalleryImportAllowed: isAndroidGalleryImportAllowed ?? this.isAndroidGalleryImportAllowed,
    );
  }

  @override
  bool operator ==(final Object other) {
    return identical(this, other) ||
        other is CherryPeakedDocsOptions &&
            runtimeType == other.runtimeType &&
            path == other.path &&
            format == other.format &&
            androidPageLimit == other.androidPageLimit &&
            isAndroidGalleryImportAllowed == other.isAndroidGalleryImportAllowed;
  }

  @override
  int get hashCode {
    return Object.hash(path, format, androidPageLimit, isAndroidGalleryImportAllowed);
  }
}
