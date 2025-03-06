import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:cherry_peaked_docs/cherry_peaked_docs_channel.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = CherryPeakedDocsChannel();
  const MethodChannel channel = MethodChannel("cherry_peaked_docs");

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      final MethodCall methodCall,
    ) async {
      return "42";
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test("getPlatformVersion", () async {
    expect(await platform.getPlatformVersion(), "42");
  });
}
