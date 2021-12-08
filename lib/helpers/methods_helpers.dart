import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osud_final/helpers/request_helper.dart';
import 'package:osud_final/models/address_model.dart';
import 'package:osud_final/providers/app_providers.dart';
import 'package:osud_final/utils/data_utils.dart';
import 'package:provider/provider.dart';

class MethodsHelpers {
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
}
