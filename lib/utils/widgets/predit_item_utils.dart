import 'package:flutter/material.dart';
import 'package:osud_final/models/predition_model.dart';
import 'package:osud_final/utils/colors_utils.dart';

class PreditItem extends StatelessWidget {
  final PreditionModel prediccionContent;

  const PreditItem({Key? key, required this.prediccionContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.location_on,
        color: UtilsColors.colorDimText,
      ),
      title: Text(prediccionContent.titulo),
      subtitle: Text(prediccionContent.descripcion),
    );
  }
}
