class ClientError implements Exception {
  final String message;

  ClientError(this.message);

  @override
  String toString() {
    return message;
  }
}
