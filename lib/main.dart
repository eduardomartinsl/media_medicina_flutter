import 'dart:math';

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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _mediaFinal = "Média final: ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo de média"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
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
                  _textFieldGenerator("Prova", txtProva),
                  Divider(),
                  _textFieldGenerator("Tutoria", txtTutoria),
                  Divider(),
                  _textFieldGenerator("Prática", txtPratica),
                  Divider(),
                  _textFieldGenerator("Seminário", txtSeminario),
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

  Widget _textFieldGenerator(String termo, TextEditingController ccontroller) {
    return TextFormField(
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
            labelStyle: TextStyle(color: Colors.lightGreen)
        )
    );
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
      double provaReal = pow(double.parse(txtProva.text), 5);
      double tutoriaReal = pow(double.parse(txtTutoria.text), 2);
      double praticaReal = pow(double.parse(txtPratica.text), 2);
      double seminarioReal = pow(double.parse(txtSeminario.text), 1);

      double mediaFinal = _raizDecimaDeValores(
          provaReal * tutoriaReal * praticaReal * seminarioReal);

      _mediaFinal = "Media final: ${mediaFinal.toStringAsPrecision(3)}";
    });
  }

  double _raizDecimaDeValores(base) {
    return pow(e, log(base) / 10);
  }
}
