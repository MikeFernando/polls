import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth({required String email, required String password}) async {
    await httpClient.request(url: url, method: 'post');
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
    // Arrange
    when(httpClient.request(url: url, method: 'post')).thenAnswer((_) async {});

    // Act
    await sut.auth(email: email, password: password);

    // Assert
    verify(httpClient.request(url: url, method: 'post')).called(1);
  });
}
