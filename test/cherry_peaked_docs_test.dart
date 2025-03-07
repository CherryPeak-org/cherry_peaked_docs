// import "package:flutter_test/flutter_test.dart";
// import "package:cherry_peaked_docs/cherry_peaked_docs.dart";
// import "package:cherry_peaked_docs/cherry_peaked_docs_interface.dart";
// import "package:cherry_peaked_docs/cherry_peaked_docs_channel.dart";
// import "package:plugin_platform_interface/plugin_platform_interface.dart";

// class MockCherryPeakedDocsPlatform with MockPlatformInterfaceMixin implements CherryPeakedDocsInterface {
//   @override
//   Future<String?> getPlatformVersion() => Future.value("42");
// }

// void main() {
//   final CherryPeakedDocsInterface initialPlatform = CherryPeakedDocsInterface.instance;

//   test("$CherryPeakedDocsChannel is the default instance", () {
//     expect(initialPlatform, isInstanceOf<CherryPeakedDocsChannel>());
//   });

//   test("getPlatformVersion", () async {
//     final cherryPeakedDocsPlugin = CherryPeakedDocs();
//     final fakePlatform = MockCherryPeakedDocsPlatform();
//     CherryPeakedDocsInterface.instance = fakePlatform;
//     expect(await cherryPeakedDocsPlugin.getPlatformVersion(), "42");
//   });
// }
