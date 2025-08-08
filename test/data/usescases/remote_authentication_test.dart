import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:polls/data/http/http.dart';
import 'package:polls/data/usecases/usecases.dart';
import 'package:polls/domain/helpers/helpers.dart';
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

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(email: email, password: password);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
