import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osud_final/helpers/request_helper.dart';
import 'package:osud_final/models/address_model.dart';
import 'package:osud_final/models/direccion_data_model.dart';
import 'package:osud_final/providers/app_providers.dart';
import 'package:osud_final/utils/data_utils.dart';
import 'package:osud_final/utils/snackbar_utils.dart';
import 'package:provider/provider.dart';

class MethodsHelpers {
  // Consumir la API de google geocode
  static Future<String> findCordinateAddress(Position ubicate, context) async {
    String placeAddress = '';
    var internetConnet = await Connectivity().checkConnectivity();
    if (internetConnet != ConnectivityResult.mobile &&
        internetConnet != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${ubicate.latitude},${ubicate.longitude}&key=$apiKey";
    var response = await RequestHelper.getRequest(Uri.parse(url));

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      AddresModel addresModel = AddresModel(
        latitude: ubicate.latitude,
        longitude: ubicate.longitude,
        addressName: placeAddress,
        addressFormated: "",
        key: "",
      );
      Provider.of<ProviderApp>(context, listen: false)
          .updetePickUpAddress(addresModel);
    }
    return placeAddress;
  }

  // Consumir la API directions para trazar la ruta
  static Future<DireccionData> obtenerDetallesDireccion(
      LatLng inicio, LatLng destino, BuildContext context) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${inicio.latitude},${inicio.longitude}&destination=${destino.latitude},${destino.longitude}&mode=driving&key=$apiKey";

    var respuesta = await RequestHelper.getRequest(Uri.parse(url));
    if (respuesta == 'failed') {
      showSnackBar('Error al realizar la petición', context);
      return DireccionData(
        distanceValue: 0,
        distancetext: '',
        durationText: '',
        durationValue: 0,
        encodePoints: '',
      );
    }
    DireccionData direccionData = DireccionData(
      distanceValue: respuesta['routes'][0]['legs'][0]['distance']['value'],
      distancetext: respuesta['routes'][0]['legs'][0]['distance']['text'],
      durationText: respuesta['routes'][0]['legs'][0]['duration']['text'],
      durationValue: respuesta['routes'][0]['legs'][0]['duration']['value'],
      encodePoints: respuesta['routes'][0]['overview_polyline']['points'],
    );
    return direccionData;
  }
}
