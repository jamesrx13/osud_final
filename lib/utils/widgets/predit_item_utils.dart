import 'package:flutter/material.dart';
import 'package:osud_final/helpers/request_helper.dart';
import 'package:osud_final/models/address_model.dart';
import 'package:osud_final/models/predition_model.dart';
import 'package:osud_final/providers/app_providers.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/data_utils.dart';
import 'package:osud_final/utils/snackbar_utils.dart';
import 'package:osud_final/utils/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

class PreditItem extends StatelessWidget {
  final PreditionModel prediccionContent;

  const PreditItem({Key? key, required this.prediccionContent})
      : super(key: key);

  void optenerDetallesDireccion(String id, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PogressDialig(
        status: 'Un momento, por favor.',
      ),
    );
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$id&key=$apiKey";
    var respuesta = await RequestHelper.getRequest(Uri.parse(url));

    Navigator.pop(context);

    if (respuesta == 'failed') {
      showSnackBar('Error al realizar la petición', context);
      return;
    }
    if (respuesta['status'] == "OK") {
      AddresModel direccion = AddresModel(
        key: id,
        addressName: respuesta['result']['name'],
        addressFormated: "",
        latitude: respuesta['result']['geometry']['location']['lat'],
        longitude: respuesta['result']['geometry']['location']['lng'],
      );

      Provider.of<ProviderApp>(context, listen: false)
          .updeteDestinationAddress(direccion);
      // ignore: avoid_print
      print("🌹🌹🌹🌹🌹" + direccion.addressName.toString());
      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        onTap: () {
          optenerDetallesDireccion(prediccionContent.id, context);
        },
        leading: const Icon(
          Icons.location_on,
          color: UtilsColors.colorDimText,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: UtilsColors.colorDimText,
        ),
        title: Text(
          prediccionContent.titulo,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          prediccionContent.descripcion,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
