import 'package:flutter/material.dart';
import 'package:osud_final/helpers/request_helper.dart';
import 'package:osud_final/models/predition_model.dart';
import 'package:osud_final/providers/app_providers.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/data_utils.dart';
import 'package:osud_final/utils/widgets/divisor_utils.dart';
import 'package:osud_final/utils/widgets/predit_item_utils.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var actualDirrecion = TextEditingController();
  var destinoDirrecion = TextEditingController();
  var destinoFocus = FocusNode();
  bool focuset = false;
  void ftnDestinoFocus() {
    if (!focuset) {
      FocusScope.of(context).requestFocus(destinoFocus);
      focuset = true;
    }
  }

  List<PreditionModel> listaPrediccionDestinos = [];
  void preddition(String busqueda) async {
    if (busqueda.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$busqueda&key=$apiKey&sessiontoken=123254251&components=country:co";
      var respuesta = await RequestHelper.getRequest(Uri.parse(url));
      if (respuesta == 'failed') {
        return;
      }
      // ignore: avoid_print
      // print('😁😁😁😁' + respuesta.toString());
      if (respuesta['status'] == "OK") {
        var predicciones = respuesta['predictions'];
        var listaPredicciones = (predicciones as List)
            .map((e) => PreditionModel.fromJson(e))
            .toList();
        setState(() {
          listaPrediccionDestinos = listaPredicciones;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ftnDestinoFocus();
    String direccion =
        Provider.of<ProviderApp>(context).pickupAddress.addressName;
    actualDirrecion.text = direccion;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Encuentra tu destino',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Brand-Bold',
          ),
        ),
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 130,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ))
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 5,
                right: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: UtilsColors.colorLightGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: actualDirrecion,
                              decoration: const InputDecoration(
                                hintText: 'Dirección actual',
                                fillColor: UtilsColors.colorLightGray,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: UtilsColors.colorLightGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value) {
                                preddition(value);
                              },
                              focusNode: destinoFocus,
                              controller: destinoDirrecion,
                              decoration: const InputDecoration(
                                hintText: '¿Dónde te gustaría ir?',
                                fillColor: UtilsColors.colorLightGray,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (listaPrediccionDestinos.isNotEmpty)
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return PreditItem(
                      prediccionContent: listaPrediccionDestinos[index],
                    );
                  },
                  separatorBuilder: (context, index) => const Divisor(),
                  itemCount: listaPrediccionDestinos.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                )
              : Container(),
        ],
      ),
    );
  }
}
