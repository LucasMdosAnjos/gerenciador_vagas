// ignore_for_file: public_member_api_docs, sort_constructors_first
class GetVagasException implements Exception {
  final String message;
  GetVagasException({
    required this.message,
  });

  @override
  String toString() => message;
}

class AddSaidaException implements Exception {
  final String message;

  AddSaidaException({required this.message});
}
