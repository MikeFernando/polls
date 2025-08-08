import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:polls/usecases/usecases.dart';

import '../mocks/mocks.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  final Map<String, dynamic>? body;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
    this.body,
  });

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }
}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late String email;
  late String password;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    email = faker.internet.email();
    password = faker.internet.password();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(email: email, password: password);
    final body = params.toJson();
    when(
      httpClient.request(url: url, method: 'post', body: body),
    ).thenAnswer((_) async {});

    await sut.auth(params);

    verify(httpClient.request(url: url, method: 'post', body: body)).called(1);
  });
}
