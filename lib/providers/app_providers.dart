import 'package:flutter/material.dart';
import 'package:osud_final/models/address_model.dart';

class ProviderApp extends ChangeNotifier {
  late AddresModel pickupAddress = AddresModel(
      key: "",
      addressName: "",
      addressFormated: "",
      latitude: 0.0,
      longitude: 0.0);

  void updetePickUpAddress(AddresModel pickUp) {
    pickupAddress = pickUp;
    notifyListeners();
  }
}
