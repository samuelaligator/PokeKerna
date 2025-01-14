import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManager extends CacheManager {
  static const key = "pokekerna";

  CacheManager()
      : super(
          Config(
            key,
            stalePeriod: Duration(days: 7), // Time before the cache is considered stale
            maxNrOfCacheObjects: 1000,      // Max number of cached items
            repo: JsonCacheInfoRepository(databaseName: key),
            fileService: HttpFileService(),
          ),
        );

  static CacheManager instance = CacheManager();
}
