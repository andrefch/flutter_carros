import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/widgets/app_button.dart';
import 'package:flutter_carros/widgets/app_text_field.dart';

class CarFormScreen extends StatefulWidget {
  final Car car;

  CarFormScreen({this.car});

  @override
  _CarFormScreenState createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Car get car => widget.car;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();

  int _index = 0;
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    if (car != null) {
      _nameController.text = car.name;
      _descriptionController.text = car.description;
      _index = _convertCarTypeToInt(car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car?.name ?? 'Novo carro'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: _createForm(),
      ),
    );
  }

  Widget _createForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _createHeaderPhoto(),
          Text(
            'Clique na imagem para tirar uma foto',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          Text(
            'Tipo',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          _createRadioType(),
          Divider(),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: AppTextField(
              controller: _nameController,
              label: 'Nome',
              hint: 'Nome do carro',
              keyboardType: TextInputType.text,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: _validateName,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: AppTextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              keyboardType: TextInputType.multiline,
              label: 'Descrição',
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            child: AppButton(
              text: 'Salvar',
              onPressed: _saveCar,
              showProgress: _showProgress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeaderPhoto() {
    final url = car?.urlImage?.trim();

    if ((url == null) || (url.isEmpty)) {
      return Image.asset(
        'assets/images/placeholder_camera.png',
        height: 150,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/images/placeholder_camera.png',
            height: 150,
          );
        },
      );
    }
  }

  Widget _createRadioType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: _createRadioItem(0, 'Clássico'),
        ),
        Expanded(
          child: _createRadioItem(1, 'Esportivo'),
        ),
        Expanded(
          child: _createRadioItem(2, 'Luxo'),
        ),
      ],
    );
  }

  Widget _createRadioItem(int index, String text) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: _index,
          onChanged: _onRadioTypeChanged,
          value: index,
        ),
        GestureDetector(
          onTap: () => _onRadioTypeChanged(index),
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  int _convertCarTypeToInt(Car car) {
    switch (car?.type) {
      case 'esportivos':
        return 1;
      case 'luxo':
        return 2;
      default:
        return 0;
    }
  }

  String _convertIntToCarType(int value) {
    switch (value) {
      case 0:
        return 'classicos';
      case 1:
        return 'esportivos';
      case 2:
        return 'luxo';
      default:
        return 'classicos';
    }
  }

  void _onRadioTypeChanged(int value) {
    setState(() {
      _index = value;
    });
  }

  void _saveCar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _showProgress = true;
    });

    final Car newCar = car ?? Car();
    newCar.name = _nameController.text.trim();
    newCar.description = _descriptionController.text.trim();
    newCar.type = _convertIntToCarType(_index);

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _showProgress = false;
    });
  }

  String _validateName(String name) {
    if (name.trim().isEmpty) {
      return 'O nome do carro não foi informado.';
    }
    return null;
  }
}
