class Utils{
  static bool verificaPlaca(String placa) {
    // Expressão regular para o formato antigo (ex: ABC-1234)
    RegExp padraoAntigo = RegExp(r'^[A-Z]{3}-\d{4}$');

    // Expressão regular para o formato Mercosul (ex: ABC1D23)
    RegExp padraoMercosul = RegExp(r'^[A-Z]{3}\d{1}[A-Z]{1}\d{2}$');

    // Verifica se a placa corresponde a algum dos padrões
    return padraoAntigo.hasMatch(placa) || padraoMercosul.hasMatch(placa);
  }

  static bool verificaTimestampISO8601(String timestamp) {
    try {
      DateTime.parse(timestamp);  // Tenta analisar a string como uma data/hora
      return true;  // Retorna verdadeiro se a análise for bem-sucedida
    } on FormatException {
      return false;  // Retorna falso se ocorrer um erro de formatação
    }
  }
}