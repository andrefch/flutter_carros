import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        centerTitle: true,
      ),
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          _createTextField(
            context: context,
            label: "Usuário",
            hint: "Digite seu usuário",
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
          ),
          SizedBox(height: 8),
          _createTextField(
            context: context,
            label: "Senha",
            hint: "Digite sua senha",
            textCapitalization: TextCapitalization.none,
            obscureText: true,
          ),
          SizedBox(height: 36),
          _createLoginButton(context),
        ],
      ),
    );
  }

  Widget _createTextField(
      {@required BuildContext context,
      String label,
      String hint,
      bool obscureText = false,
      TextCapitalization textCapitalization = TextCapitalization.sentences,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 18,
          )),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 18,
      ),
      textCapitalization: textCapitalization,
    );
  }

  Widget _createLoginButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
