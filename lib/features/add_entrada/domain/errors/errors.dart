class AddEntradaException implements Exception{
  final String message;
  AddEntradaException({
    required this.message,
  });

  @override
  String toString() => message;
}