import 'package:flutter_cache_store/flutter_cache_store.dart';

void demo(String url) async {
  final store = await CacheStore.getInstance();
  final file = await store.getFile(url);
  print('demo??');
  // do something with file...
}