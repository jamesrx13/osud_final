import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/widgets/divisor_utils.dart';

class HomePage extends StatelessWidget {
  //
  Completer<GoogleMapController> _completer = Completer();
  static const position = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );
  static const CameraPosition _cameraPosition = position;
  late GoogleMapController mapController;
  double mapBotton = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _completer.complete(controller);
              mapController = controller;
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        spreadRadius: 0.7,
                        offset: Offset(
                          0.9,
                          0.9,
                        )),
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Nos alegera tenerte acá!',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    const Text(
                      '¿Dónde te gustaría ir?',
                      style: TextStyle(
                        fontSize: 21.0,
                        fontFamily: 'Brand-Bold',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              spreadRadius: 0.5,
                              offset: Offset(
                                0.7,
                                0.7,
                              ),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Text('Elige tu destino!')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: UtilsColors.colorDimText,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Añadir lugar de residencia.'),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Ruta a tu casa',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: UtilsColors.colorDimText),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divisor(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.work,
                          color: UtilsColors.colorDimText,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text('Añadir lugar de trabajo.'),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              'Ruta a tu lugar de labor',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: UtilsColors.colorDimText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
