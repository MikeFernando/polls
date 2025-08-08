import 'package:mockito/mockito.dart';

import 'package:polls/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    return super.noSuchMethod(
          Invocation.method(#request, [], {
            #url: url,
            #method: method,
            #body: body,
          }),
          returnValue: Future<void>.value(),
        )
        as Future<void>;
  }
}
