import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController txtProva = new TextEditingController();
  TextEditingController txtTutoria = new TextEditingController();
  TextEditingController txtPratica = new TextEditingController();
  TextEditingController txtSeminario = new TextEditingController();

  TextEditingController pesoProvaController = new TextEditingController();
  TextEditingController pesoTutoriaController = new TextEditingController();
  TextEditingController pesoPraticaController = new TextEditingController();
  TextEditingController pesoSeminarioController = new TextEditingController();

  double pesoProva = 5;
  double pesoTutoria = 2;
  double pesoPratica = 2;
  double pesoSeminario = 1;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _mediaFinal = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo de média"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields),
          IconButton(icon: Icon(Icons.info), onPressed: _informacao)
        ],
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[],
                  ),
                  _rowGenerator(
                      "Prova", pesoProva, txtProva, pesoProvaController),
                  Divider(),
                  _rowGenerator("Tutoria", pesoTutoria, txtTutoria,
                      pesoTutoriaController),
                  Divider(),
                  _rowGenerator("Prática", pesoPratica, txtPratica,
                      pesoPraticaController),
                  Divider(),
                  _rowGenerator("Seminário", pesoSeminario, txtSeminario,
                      pesoSeminarioController),
                  Divider(),
                  RaisedButton(
                    child: Text(
                      "Calcular média",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) _calculaMedia();
                    },
                    color: Colors.lightGreen,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(_mediaFinal,
                          style: TextStyle(color: Colors.black, fontSize: 25),
                          textAlign: TextAlign.center)),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _informacao() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Média geométria ponderada'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Este app utiliza o cálculo da média geométrica ponderada para realização da média final'),
                Text('Os pesos são (Por padrão):'),
                Divider(),
                Text('Prova - peso $pesoProva'),
                Text('Tutoria - peso $pesoTutoria'),
                Text('Prática - peso $pesoPratica'),
                Text('Seminário - peso $pesoSeminario'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _rowGenerator(
      String termo,
      double multiplicador,
      TextEditingController ccontroller,
      TextEditingController pesoController) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: ccontroller,
            validator: (value) {
              if (value.isEmpty) {
                return "Insira o valor $termo";
              }
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                labelText: termo,
                hintText: "Digite a nota $termo",
                labelStyle: TextStyle(color: Colors.lightGreen)),
          ),
        ),
        FlatButton(
          child: Text("x${multiplicador.toString()}",
              style: TextStyle(color: Colors.white)),
          onPressed: () {
            _alteraPeso(termo, pesoController, multiplicador);
          },
          color: Colors.lightGreen,
        )
      ],
    );
  }

  Future<void> _alteraPeso(
      String pesoAlteravel,
      TextEditingController controllerPeso,
      double multiplicador) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text("Alterar peso"),
            content: TextField(
              controller: controllerPeso,
              decoration: InputDecoration(
                  hintText: "Digite o novo peso de $pesoAlteravel"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Alterar',
                    style: TextStyle(color: Colors.lightGreen)),
                onPressed: () {
                  var a = controllerPeso.text;
                  multiplicador = double.parse(controllerPeso.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _resetFields() {
    setState(() {
      txtProva.text = "";
      txtTutoria.text = "";
      txtPratica.text = "";
      txtSeminario.text = "";

      _mediaFinal = "";
    });
  }

  void _calculaMedia() {
    setState(() {
      double provaReal = pow(double.parse(txtProva.text), pesoProva);
      double tutoriaReal = pow(double.parse(txtTutoria.text), pesoTutoria);
      double praticaReal = pow(double.parse(txtPratica.text), pesoPratica);
      double seminarioReal =
          pow(double.parse(txtSeminario.text), pesoSeminario);

      double mediaFinal = _raizDecimaDeValores(
          provaReal * tutoriaReal * praticaReal * seminarioReal);

      _mediaFinal = "Media final: ${mediaFinal.toStringAsPrecision(3)}";
    });
  }

  double _raizDecimaDeValores(base) {
    return pow(e, log(base) / 10);
  }
}
