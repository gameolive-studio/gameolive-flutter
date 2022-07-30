#ifndef FLUTTER_PLUGIN_GAMEOLIVE_PLUGIN_H_
#define FLUTTER_PLUGIN_GAMEOLIVE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace gameolive {

class GameolivePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  GameolivePlugin();

  virtual ~GameolivePlugin();

  // Disallow copy and assign.
  GameolivePlugin(const GameolivePlugin&) = delete;
  GameolivePlugin& operator=(const GameolivePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace gameolive

#endif  // FLUTTER_PLUGIN_GAMEOLIVE_PLUGIN_H_
