import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carros/screens/home_screen.dart';
import 'package:flutter_carros/service/firebase_service.dart';
import 'package:flutter_carros/util/alert_util.dart';
import 'package:flutter_carros/util/navigator_util.dart';
import 'package:flutter_carros/widgets/app_button.dart';
import 'package:flutter_carros/widgets/app_text_field.dart';
import 'package:image_picker/image_picker.dart';

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
  File _selectedFile;

  final ImagePicker _imagePicker = ImagePicker();

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
            _createHeaderPhoto(context),
            _createSpace(),
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
      String imageUrl = 'https://s3-sa-east-1.amazonaws.com/livetouch-temp/livrows/foto.png';
      if (_selectedFile != null) {
        imageUrl = await FirebaseService().uploadFile(_selectedFile);
      }

      final result = await FirebaseService().signUp(
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        urlPhoto: imageUrl,
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

  Widget _createHeaderPhoto(BuildContext context) {
    Widget imageWidget;
    if (_selectedFile != null) {
      imageWidget = CircleAvatar(
        backgroundImage: FileImage(_selectedFile),
        backgroundColor: Colors.transparent,
      );
    } else {
      imageWidget = Image.asset('assets/images/placeholder_camera.png');
    }

    return InkWell(
      onTap: () => _openImagePicker(context),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: imageWidget,
        ),
      ),
    );
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                'De onde deseja carregar a imagem?',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.photo_camera,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Câmera'),
              onTap: () {
                popScreen(context);
                _selectImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Galeria'),
              onTap: () {
                popScreen(context);
                _selectImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _selectImage(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        _selectedFile = imageFile;
      });
    }
  }
}
