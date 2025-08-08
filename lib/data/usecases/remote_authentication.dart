import '../http/http_client.dart';
import '../../usecases/usecases.dart';

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
