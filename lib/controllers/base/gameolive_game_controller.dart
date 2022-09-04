typedef GameOliveGameControllerCallback = void Function(
    GameOliveGameController controller);

abstract class GameOliveGameController {
  GameOliveGameController();

  Future<void> openGameMenu() async {}

  Future<void> closeGameMenu() async {}

  Future<void> pauseGame() async {}

  Future<void> resumePausedGame() async {}

  Future<void> reloadBalance() async {}

  Future<void> reloadGame() async {}
}
