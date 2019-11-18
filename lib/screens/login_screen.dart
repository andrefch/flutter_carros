import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameRegex = RegExp(r"^([A-z][A-z0-9\.\_]{3,})$", multiLine: true);
  final passwordRegex =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$\%\^&])(?=.{6,})");

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
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            _createTextField(
              context: context,
              label: "Usuário",
              hint: "Digite seu usuário",
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              validator: _validateUser,
            ),
            SizedBox(height: 8),
            _createTextField(
              context: context,
              label: "Senha",
              hint: "Digite sua senha",
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              validator: _validatePassword,
            ),
            SizedBox(height: 36),
            _createButton(
              context: context,
              onPressed: _onClickLoginButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createTextField(
      {@required BuildContext context,
      String label,
      String hint,
      bool obscureText = false,
      TextCapitalization textCapitalization = TextCapitalization.sentences,
      TextInputType keyboardType = TextInputType.text,
      FormFieldValidator<String> validator}) {
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
        ),
        errorMaxLines: 3,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 18,
      ),
      textCapitalization: textCapitalization,
      validator: validator,
    );
  }

  Widget _createButton(
      {@required BuildContext context, @required VoidCallback onPressed}) {
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
        onPressed: onPressed,
      ),
    );
  }

  void _onClickLoginButton() {
    _formKey.currentState.validate();
  }

  String _validateUser(String username) {
    if (username.length < 4) {
      return "O usuário deve conter no mínimo 4 caracteres.";
    }

    if (!usernameRegex.hasMatch(username)) {
      return "O usuário deve conter somente letras, números, \".\" ou \"_\"";
    }

    return null;
  }

  String _validatePassword(String password) {
    if (!passwordRegex.hasMatch(password)) {
      return "A senha deve possuir ao menos seis caracteres, sendo uma letra maiúscula, uma minúscula, um número e um caractere especial";
    }

    return null;
  }
}
