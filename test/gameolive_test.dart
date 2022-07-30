import 'package:flutter_test/flutter_test.dart';
import 'package:gameolive/gameolive.dart';
import 'package:gameolive/gameolive_platform_interface.dart';
import 'package:gameolive/gameolive_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGameolivePlatform 
    with MockPlatformInterfaceMixin
    implements GameolivePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GameolivePlatform initialPlatform = GameolivePlatform.instance;

  test('$MethodChannelGameolive is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGameolive>());
  });

  test('getPlatformVersion', () async {
    Gameolive gameolivePlugin = Gameolive();
    MockGameolivePlatform fakePlatform = MockGameolivePlatform();
    GameolivePlatform.instance = fakePlatform;
  
    expect(await gameolivePlugin.getPlatformVersion(), '42');
  });
}
