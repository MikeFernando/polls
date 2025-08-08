import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:polls/data/usecases/usecases.dart';
import 'package:polls/usecases/usecases.dart';

import '../mocks/mocks.dart';

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
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    when(
      httpClient.request(url: url, method: 'post', body: body),
    ).thenAnswer((_) async {});

    await sut.auth(params);

    verify(httpClient.request(url: url, method: 'post', body: body)).called(1);
  });
}
