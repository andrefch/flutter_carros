import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/service/firebase_service.dart';

class FavoriteService {
  static const _COLLECTION_NAME = "favorites";
  static FavoriteService _instance = FavoriteService._internal();

  FavoriteService._internal();

  factory FavoriteService() => _instance;

  final CollectionReference _collection = FirebaseService()
      .currentUserDocumentReference
      .collection(_COLLECTION_NAME);

  Stream<List<Car>> get favoriteCars => _collection
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map((document) => Car.fromMap(document.data))
          .toList())
      .asBroadcastStream();

  Future<bool> isFavorite(Car car) async {
    final document = _collection.document(car.id.toString());
    return _exists(document);
  }

  Future<bool> toggleFavorite(Car car) async {
    final document = _collection.document(car.id.toString());
    final exists = await _exists(document);

    try {
      if (exists) {
        await document.delete();
        return false;
      } else {
        await document.setData(car.toMap());
        return true;
      }
    } catch (e) {
      print(e);
      return exists;
    }
  }

  Future<bool> _exists(DocumentReference document) async {
    final snapshot = await document.get();
    return snapshot.exists;
  }
}
