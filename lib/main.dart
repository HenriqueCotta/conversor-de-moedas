import 'package:conversor_de_moedas/conversor_moeda.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var request = Uri.https(
    'api.hgbrasil.com', '/finance', {'key': 'a02463a6', 'symbol': 'bidi4'});
//'https://api.hgbrasil.com/finance?key=a02463a6&symbol=bidi4'

TextField textMoeda(String label, String prefix,
    TextEditingController controller, Function(String) f) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

SizedBox box() {
  return SizedBox(
    height: 20,
  );
}

void main() async {
  //print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.amber,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  var conversor = ConversorDeMoeda();

  void _realChanged(String text) {
    //double real = double.parse(text);
    dolarController.text =
        conversor.converter(text, 'BRL', 'USD').toStringAsFixed(2);
    euroController.text =
        conversor.converter(text, 'BRL', 'EUR').toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    //double dolar = double.parse(text);
    realController.text =
        conversor.converter(text, 'USD', 'BRL').toStringAsFixed(2);
    euroController.text =
        conversor.converter(text, 'USD', 'EUR').toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    //double euro = double.parse(text);
    dolarController.text =
        conversor.converter(text, 'EUR', 'USD').toStringAsFixed(2);
    realController.text =
        conversor.converter(text, 'EUR', 'BRL').toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      "Erro de carregamento de dados!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25.0,
                      ),
                    ),
                  );
                } else {
                  var dolar = snapshot.data?["results"]["currencies"]['USD'];
                  var euro = snapshot.data?["results"]["currencies"]["EUR"];
                  conversor.cotacao = {
                    'USD': dolar, 
                    'EUR': euro, 
                    'BRL': {
                      'sell': 1,
                      'buy': 1,
                    }
                  };
                  return SingleChildScrollView(
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.88,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.monetization_on,
                              size: 150.0,
                              color: Colors.amber,
                            ),
                            box(),
                            textMoeda(
                                "Reais", "R\$", realController, _realChanged),
                            box(),
                            textMoeda("Dólares", "\$", dolarController,
                                _dolarChanged),
                            box(),
                            textMoeda(
                                "Euros", "€", euroController, _euroChanged),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}
