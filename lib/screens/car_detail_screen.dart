import 'package:flutter/material.dart';
import 'package:flutter_carros/bloc/lorem_ipsum_bloc.dart';
import 'package:flutter_carros/data/api/login_api.dart';
import 'package:flutter_carros/data/api/lorem_ipsum_api.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/util/string_extensions.dart';
import 'package:flutter_carros/widgets/text.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;

  CarDetailScreen(this.car);

  @override
  _CarDetailScreenState createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {

  final LoremIpsumBloc _loremIpsumBloc = LoremIpsumBloc();

  @override
  void initState() {
    super.initState();
    _loremIpsumBloc.fetch();
  }

  @override
  void dispose() {
    _loremIpsumBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onMapButtonClicked,
          ),
          IconButton(
            icon: Icon(Icons.video_library),
            onPressed: _onVideoButtonClicked,
          ),
          PopupMenuButton<_OverflowMenuOption>(
            onSelected: _onOverflowOptionSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: _OverflowMenuOption.edit,
                  child: Text("Edit"),
                ),
                PopupMenuItem(
                  value: _OverflowMenuOption.delete,
                  child: Text("Delete"),
                ),
                PopupMenuItem(
                  value: _OverflowMenuOption.share,
                  child: Text("Share"),
                ),
              ];
            },
          )
        ],
      ),
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      children: <Widget>[
        _createImage(),
        _createTitleBar(context),
        _createDivider(),
        _createDescription(context),
      ],
    );
  }

  Widget _createImage() {
    return widget.car.urlImage != null
        ? Image.network(widget.car.urlImage)
        : Image.asset("assets/images/placeholder_car.png");
  }

  Widget _createTitleBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.car.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4.0),
              Text(
                widget.car.type.capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Color.fromARGB(255, 117, 117, 117)),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.red,
              iconSize: 40,
              onPressed: _onFavoriteButtonClicked,
            ),
            IconButton(
              icon: Icon(Icons.share),
              color: Theme.of(context).primaryColor,
              iconSize: 40,
              onPressed: _onShareButtonClicked,
            ),
          ],
        ),
      ],
    );
  }

  Widget _createDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Divider(),
    );
  }

  Widget _createDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(
          widget.car.description,
          size: 18.0,
          bold: true,
        ),
        SizedBox(height: 4.0),
        StreamBuilder<String>(
          stream: _loremIpsumBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return text(snapshot.data ?? "");
            } else if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    text(
                      "😵",
                      textAlign: TextAlign.center,
                      size: 36.0,
                    ),
                    SizedBox(height: 4.0),
                    text(
                      "Failed to load description.",
                      textAlign: TextAlign.center,
                      color: Colors.red,
                      size: 24.0,
                      bold: true,
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _onOverflowOptionSelected(_OverflowMenuOption option) {
    switch (option) {
      case _OverflowMenuOption.edit:
        _onEditButtonClicked();
        break;
      case _OverflowMenuOption.delete:
        _onDeleteButtonClicked();
        break;
      case _OverflowMenuOption.share:
        _onShareButtonClicked();
        break;
    }
  }

  void _onMapButtonClicked() {}

  void _onVideoButtonClicked() {}

  void _onEditButtonClicked() {}

  void _onDeleteButtonClicked() {}

  void _onShareButtonClicked() {}

  void _onFavoriteButtonClicked() {}
}

enum _OverflowMenuOption { edit, delete, share }
