#include "include/gameolive/gameolive_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "gameolive_plugin.h"

void GameolivePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  gameolive::GameolivePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
