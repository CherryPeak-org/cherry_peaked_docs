import "dart:io" show File;

import "package:cherry_peaked_docs/cherry_peaked_docs_interface.dart";
import "package:cherry_peaked_docs/cherry_peaked_docs_options.dart";
import "package:cherry_peaked_docs/cherry_peaked_docs_result.dart";

abstract class CherryPeakedDocs {
  static Future<CherryPeakedDocsResult> startScanning({CherryPeakedDocsOptions? options}) async {
    options ??= await CherryPeakedDocsOptions.platformMatching();
    final paths = await CherryPeakedDocsInterface.instance.startScanning(options);
    final files = paths.map((final p) => File(p)).toList();
    return CherryPeakedDocsResult(files: files);
  }

  static Future<void> forceStopScanning() async {
    await CherryPeakedDocsInterface.instance.forceStopScanning();
  }
}
