import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osud_final/helpers/methods_helpers.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/custom_styles.dart';
import 'package:osud_final/utils/snackbar_utils.dart';
import 'package:osud_final/utils/widgets/divisor_utils.dart';

class HomePage extends StatefulWidget {
  //
  static const position = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );
  static const CameraPosition _cameraPosition = position;

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController mapController;
  double mapBotton = 0;
  // var localizador = Geolocator;
  late Position userActualPositioned;

  void setUserActualPosition() async {
    // Código para la gestión de los permisos de localización
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //
    if (!serviceEnabled) {
      showSnackBar('Los servicios de locación están desactivados.', context);
      return;
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar('Ha denegado los permisos de localización.', context);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showSnackBar(
            'Los permisos de localización han sido denegados de forma permanente...',
            context);
        return;
      }
      //Código para obtener la ubicación actial y posicionar la cámara
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      userActualPositioned = position;
      LatLng posicion =
          LatLng(userActualPositioned.latitude, userActualPositioned.longitude);
      CameraPosition cameraPosition = CameraPosition(
        target: posicion,
        zoom: 19,
      );
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      String direccion = await MethodsHelpers.findCordinateAddress(position);
      print("✔✔✔✔" + direccion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        color: Colors.white,
        width: 250,
        child: Drawer(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Container(
                color: Colors.white,
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/user_icon.png',
                        height: 60,
                        width: 60,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Nombre',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Brand-Bold',
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('Ver perfil'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Divisor(),
              const SizedBox(
                height: 10.0,
              ),
              const ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  'Destinos gratuitos',
                  style: customDrawerListTitleStyle,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.credit_card),
                title: Text(
                  'Pagos',
                  style: customDrawerListTitleStyle,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'Historial de carreras',
                  style: customDrawerListTitleStyle,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.support),
                title: Text(
                  'Soporte',
                  style: customDrawerListTitleStyle,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'Sobre nosotros',
                  style: customDrawerListTitleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Mapa
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBotton),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            initialCameraPosition: HomePage._cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _completer.complete(controller);
              mapController = controller;
              setState(() {
                mapBotton = 300;
              });
              setUserActualPosition();
            },
          ),

          // Boton del Drawer
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Menu inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
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
                          // ignore: prefer_const_literals_to_create_immutables
                          boxShadow: [
                            const BoxShadow(
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
                        const Icon(
                          Icons.home,
                          color: UtilsColors.colorDimText,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text('Añadir lugar de residencia.'),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
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
                                  fontSize: 13,
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
