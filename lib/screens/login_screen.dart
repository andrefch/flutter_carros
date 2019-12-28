import 'package:flutter/material.dart';
import 'package:flutter_carros/bloc/login_bloc.dart';
import 'package:flutter_carros/screens/home_screen.dart';
import 'package:flutter_carros/util/navigator_util.dart';
import 'package:flutter_carros/widgets/app_button.dart';
import 'package:flutter_carros/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  final _passwordFocusNode = FocusNode();

  final _usernameRegex = RegExp(r"^([A-z][A-z0-9\.\_]{3,})$", multiLine: true);
  final _passwordRegex =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$\%\^&])(?=.{6,})");

  final LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.user.listen(
      (user) => _showHomeScreen(),
      onError: (error) => _showMessage(context, error.message),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        centerTitle: true,
      ),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            AppTextField(
              controller: _usernameTextEditingController,
              label: "Usuário",
              hint: "Digite seu usuário",
              keyboardType: TextInputType.emailAddress,
              onFieldSubmitted: (String text) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              validator: _validateUser,
            ),
            SizedBox(height: 8),
            AppTextField(
              controller: _passwordTextEditingController,
              focusNode: _passwordFocusNode,
              label: "Senha",
              hint: "Digite sua senha",
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              onFieldSubmitted: (String text) => _onClickLoginButton(context),
              validator: _validatePassword,
            ),
            SizedBox(height: 36),
            StreamBuilder<bool>(
                stream: _loginBloc.progress,
                initialData: false,
                builder: (context, snapshot) {
                  return AppButton(
                    text: "Login",
                    onPressed: () => _onClickLoginButton(context),
                    showProgress: snapshot.data,
                  );
                }),
          ],
        ),
      ),
    );
  }

  void _onClickLoginButton(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final String username = _usernameTextEditingController.text;
    final String password = _passwordTextEditingController.text;

    _loginBloc.login(username, password);
  }

  String _validateUser(String username) {
    if (username.length < 4) {
      return "O usuário deve conter no mínimo 4 caracteres.";
    }

    if (!_usernameRegex.hasMatch(username)) {
      return "O usuário deve conter somente letras, números, \".\" ou \"_\"";
    }

    return null;
  }

  String _validatePassword(String password) {
    if (password.length < 3) {
      return "A senha deve possui ao menos três caracteres.";
    }
//    if (!_passwordRegex.hasMatch(password)) {
//      return "A senha deve possuir ao menos seis caracteres, sendo uma letra maiúscula, uma minúscula, um número e um caractere especial";
//    }

    return null;
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ops!"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => popScreen(context),
              )
            ],
          );
        });
  }

  void _showHomeScreen() {
    pushScreen(
      context,
      HomeScreen(),
      replace: true,
    );
  }
}
