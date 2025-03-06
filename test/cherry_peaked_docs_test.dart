import 'package:flutter_test/flutter_test.dart';
import 'package:cherry_peaked_docs/cherry_peaked_docs.dart';
import 'package:cherry_peaked_docs/cherry_peaked_docs_platform_interface.dart';
import 'package:cherry_peaked_docs/cherry_peaked_docs_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCherryPeakedDocsPlatform
    with MockPlatformInterfaceMixin
    implements CherryPeakedDocsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CherryPeakedDocsPlatform initialPlatform = CherryPeakedDocsPlatform.instance;

  test('$MethodChannelCherryPeakedDocs is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCherryPeakedDocs>());
  });

  test('getPlatformVersion', () async {
    CherryPeakedDocs cherryPeakedDocsPlugin = CherryPeakedDocs();
    MockCherryPeakedDocsPlatform fakePlatform = MockCherryPeakedDocsPlatform();
    CherryPeakedDocsPlatform.instance = fakePlatform;

    expect(await cherryPeakedDocsPlugin.getPlatformVersion(), '42');
  });
}
