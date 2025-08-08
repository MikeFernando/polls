import '../../usecases/usecases.dart';
import '../http/http_client.dart';

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
    await httpClient.request(
      url: url,
      method: 'post',
      body: RemoteAuthenticationParams.fromDomain(params).toJson(),
    );
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(
      email: params.email,
      password: params.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
