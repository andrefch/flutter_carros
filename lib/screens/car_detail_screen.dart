import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carros/bloc/lorem_ipsum_bloc.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/screens/car_form_screen.dart';
import 'package:flutter_carros/screens/map_screen.dart';
import 'package:flutter_carros/screens/video_screen.dart';
import 'package:flutter_carros/service/favorite_service.dart';
import 'package:flutter_carros/util/alert_util.dart';
import 'package:flutter_carros/util/eventbus/event/car_event.dart';
import 'package:flutter_carros/util/eventbus/event_bus.dart';
import 'package:flutter_carros/util/navigator_util.dart';
import 'package:flutter_carros/util/string_extensions.dart';
import 'package:flutter_carros/widgets/text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;

  CarDetailScreen(this.car);

  @override
  _CarDetailScreenState createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final LoremIpsumBloc _loremIpsumBloc = LoremIpsumBloc();
  bool favorite = false;

  Car get car => widget.car;

  @override
  void initState() {
    super.initState();
    _loremIpsumBloc.fetch();
    FavoriteService().isFavorite(car).then((value) {
      setState(() {
        favorite = value;
      });
    });
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
        title: Text(car.name),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(Icons.place),
              onPressed: () => _onMapButtonClicked(context),
            ),
          ),
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(Icons.video_library),
              onPressed: () => _onVideoButtonClicked(context),
            ),
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
    return car.urlImage != null
        ? CachedNetworkImage(
            imageUrl: car.urlImage,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            },
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/placeholder_car.png"),
          )
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
                car.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4.0),
              Text(
                car.type.trim().capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Color.fromARGB(255, 117, 117, 117)),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
              color: favorite ? Colors.red : Theme.of(context).primaryColor,
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
          car.description,
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

  void _onMapButtonClicked(BuildContext context) {
    if ((car.latitude == null) || (car.longitude == null)) {
      final snackBar = SnackBar(
        content: Text('${car.name} não possui localização definida.'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }

    pushScreen(context, MapScreen(car: car));
  }

  void _onVideoButtonClicked(BuildContext context) async {
    final String url = car.urlVideo;
    if ((url?.isNotEmpty ?? false) && (await canLaunch(url))) {
//      await launch(url);
      pushScreen(context, VideoScreen(car: car));
    } else {
      final snackBar = SnackBar(
        content: Text('Não foi possível reproduzir o vídeo.'),
        action: SnackBarAction(
          label: 'TENTAR NOVAMENTE',
          textColor: Theme.of(context).primaryColorLight,
          onPressed: () {
            _onVideoButtonClicked(context);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _onEditButtonClicked() {
    pushScreen(context, CarFormScreen(car: car));
  }

  void _onDeleteButtonClicked() async {
    final result = await CarApi.delete(car);
    if (result.success) {
      showAlert(
          context: context,
          title: 'Excluir veículo?',
          message: 'Veículo excluído com sucesso.',
          callback: () {
            EventBus.get(context).sendEvent(CarEvent(
              action: CarEventAction.DELETED,
              carType: getCarTypeByValue(car.type),
            ));
            popScreen(context);
          });
    } else {
      showAlert(
        context: context,
        title: 'Ops!',
        message: result.message,
      );
    }
  }

  void _onShareButtonClicked() {
    Share.share(car.urlImage, subject: car.name);
  }

  void _onFavoriteButtonClicked() async {
    setState(() {
      this.favorite = !this.favorite;
    });

    final bool favorite = await FavoriteService().toggleFavorite(car);
    if (this.favorite != favorite) {
      setState(() {
        this.favorite = favorite;
      });
    }
  }
}

enum _OverflowMenuOption { edit, delete, share }
