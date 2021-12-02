import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osud_final/helpers/request_helper.dart';
import 'package:osud_final/utils/data_utils.dart';

class MethodsHelpers {
  static Future<String> findCordinateAddress(Position ubicate) async {
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
    }
    return placeAddress;
  }
}
