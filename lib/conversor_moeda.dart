class ConversorDeMoeda {
  String relativo = "BRL";
  Map<String, dynamic> cotacao = {};
  double converter(dynamic valor, String de, String para) {
    if (valor is String) {
      valor = double.tryParse(valor);
      if (valor == null) {
        valor = 0;
      }
    }
    if (de == relativo) {
      if (cotacao[para] == null) {
        throw Exception('currency not found for $para.');
      }
      return valor / cotacao[para]['buy']!;
    } else {
      if (cotacao[de] == null) {
        throw Exception('currency not found for $de.');
      }
      var valorReal = valor * cotacao[de]["sell"]!;
      return converter(valorReal, relativo, para);
    }
  }
}



//afjiabsdfuadns ihybefpksafm dafád,foja 