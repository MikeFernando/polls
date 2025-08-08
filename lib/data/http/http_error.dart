class HttpError implements Exception {
  final String message;

  HttpError(this.message);

  static HttpError get badRequest => HttpError('Bad Request');
}
