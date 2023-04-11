class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override //over writing the general toString method
  String toString() {
    return message;
    //  return super.toString(); //instance of httpException
  }
}
