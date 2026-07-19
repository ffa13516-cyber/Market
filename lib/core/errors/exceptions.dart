class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Unexpected server error']);
}

class InsufficientStockException implements Exception {
  final String productName;
  const InsufficientStockException(this.productName);
}
