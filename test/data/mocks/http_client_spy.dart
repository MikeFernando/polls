import 'package:mockito/mockito.dart';

// Definição da classe HttpClient
abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

// Mock da classe HttpClientSpy
class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({required String url, required String method}) async {
    return super.noSuchMethod(
          Invocation.method(#request, [], {#url: url, #method: method}),
          returnValue: Future<void>.value(),
        )
        as Future<void>;
  }
}
