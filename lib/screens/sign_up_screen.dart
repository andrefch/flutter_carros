import 'package:flutter/material.dart';
import 'package:flutter_carros/screens/home_screen.dart';
import 'package:flutter_carros/service/firebase_service.dart';
import 'package:flutter_carros/util/alert_util.dart';
import 'package:flutter_carros/util/navigator_util.dart';
import 'package:flutter_carros/widgets/app_button.dart';
import 'package:flutter_carros/widgets/app_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo usuário'),
      ),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        child: ListView(
          children: <Widget>[
            AppTextField(
              controller: _nameController,
              label: 'Nome',
              hint: 'Digite seu nome',
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_usernameFocusNode);
              },
              validator: _validateName,
            ),
            _createSpace(),
            AppTextField(
              controller: _usernameController,
              label: 'E-mail',
              hint: 'Digite seu e-mail',
              keyboardType: TextInputType.emailAddress,
              focusNode: _usernameFocusNode,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: _validateUser,
            ),
            _createSpace(),
            AppTextField(
              controller: _passwordController,
              label: 'Senha',
              hint: 'Digite sua senha',
              obscureText: true,
              focusNode: _passwordFocusNode,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              validator: _validatePassword,
            ),
            _createSpace(24),
            AppButton(
              text: 'Cadastrar',
              onPressed: () => _onSubmitSignUpUser(context),
              showProgress: _loading,
            )
          ],
        ),
      ),
    );
  }

  void _onSubmitSignUpUser(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final result = await FirebaseService().signUp(
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        urlPhoto: 'https://s3-sa-east-1.amazonaws.com/livetouch-temp/livrows/foto.png',
      );

      if (result.success) {
        pushScreen(context, HomeScreen(), replace: true);
      } else {
        showAlert(
          context: context,
          title: 'Ops!',
          message: result.message,
        );
      }
    } catch (e) {
      print(e);
      showAlert(
        context: context,
        title: 'Ops!',
        message: 'Não foi cadastrar o usuário!',
      );
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _createSpace([double height = 12]) => SizedBox(height: height);

  String _validateName(String text) {
    if (text?.trim()?.isEmpty ?? true) {
      return 'O nome deve ser informado.';
    }
    return null;
  }

  String _validateUser(String username) {
    if (username.length < 3) {
      return 'O usuário deve conter no mínimo 3 caracteres.';
    }

    if (!username.contains('@')) {
      return 'O email do usuário é inválido.';
    }

    return null;
  }

  String _validatePassword(String password) {
    if (password.length < 6) {
      return "A senha deve possui ao menos seis caracteres.";
    }

    return null;
  }
}
