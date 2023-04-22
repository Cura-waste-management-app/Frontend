import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../providers/firebase_provider.dart';

void callAPI(String url) {
  http.get(Uri.parse(url));
}

final callAPIProvider = FutureProvider.family<void, String>((ref, url) async {
  print('calling firebase');
  ref.read(firebaseIdTokenProvider).when(data: (data) {
    print('data loaded');
  }, error: (e, stackTrace) {
    print(e);
    print(stackTrace);
  }, loading: () {
    print('loading..');
  });
});
