import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GameoliveCacheManager {
  static const key = 'GAMEOLIVE_CACHE';
  static CacheManager instance = CacheManager(
    Config(key, stalePeriod: const Duration(days: 1), maxNrOfCacheObjects: 20),
  );
  static void clearCache() {
    try {
      instance.emptyCache();
    } catch (ex) {
      print("Some exception happened while clearing the cache");
    }
  }
}
