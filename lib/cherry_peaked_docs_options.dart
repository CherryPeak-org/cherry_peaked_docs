import "package:path/path.dart" show join;
import "package:path_provider/path_provider.dart" show getApplicationDocumentsDirectory;

class CherryPeakedDocsOptions {
  final String path;
  final int androidPageLimit;
  final bool isAndroidGalleryImportAllowed;

  CherryPeakedDocsOptions({
    required this.path,
    required this.androidPageLimit,
    required this.isAndroidGalleryImportAllowed,
  }) : assert(!androidPageLimit.isNegative, "androidPageLimit MUST NOT be negative (set 0 for no limit)");

  static Future<CherryPeakedDocsOptions> platformMatching() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "cherry-peaked-docs");

    return CherryPeakedDocsOptions(
      path: path,
      // values below match iOS limitations
      androidPageLimit: 24,
      isAndroidGalleryImportAllowed: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "path": path,
      "androidPageLimit": androidPageLimit,
      "isAndroidGalleryImportAllowed": isAndroidGalleryImportAllowed,
    };
  }

  CherryPeakedDocsOptions copyWith({
    final String? path,
    final int? androidPageLimit,
    final bool? isAndroidGalleryImportAllowed,
  }) {
    return CherryPeakedDocsOptions(
      path: path ?? this.path,
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
            androidPageLimit == other.androidPageLimit &&
            isAndroidGalleryImportAllowed == other.isAndroidGalleryImportAllowed;
  }

  @override
  int get hashCode {
    return Object.hash(path, androidPageLimit, isAndroidGalleryImportAllowed);
  }
}
