import 'package:flutter/material.dart';
import 'package:flutter_carros/model/favorite_model.dart';
import 'package:flutter_carros/screens/splash_screen.dart';
import 'package:flutter_carros/util/eventbus/event_bus.dart';
import 'package:provider/provider.dart';

void main() => runApp(CarApp());

class CarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteModel>(
          create: (_) => FavoriteModel(),
        ),
        Provider<EventBus>(
          create: (_) => EventBus(),
          dispose: (_, eventBus) {
            eventBus.dispose();
          },
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
//        scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
