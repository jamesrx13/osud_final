// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osud_final/helpers/methods_helpers.dart';
import 'package:osud_final/models/direccion_data_model.dart';
import 'package:osud_final/providers/app_providers.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/custom_styles.dart';
import 'package:osud_final/utils/data_utils.dart';
import 'package:osud_final/utils/snackbar_utils.dart';
import 'package:osud_final/utils/widgets/divisor_utils.dart';
import 'package:osud_final/utils/widgets/osud_button.dart';
import 'package:osud_final/utils/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // ignore: prefer_final_fields
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController mapController;
  double showDetallesCarrera = 0;
  double principalMenu = 300;
  double mapBotton = 0;
  double panelBusquedavehiculo = 0;
  // var localizador = Geolocator;
  late Position userActualPositioned;
  bool showDrawer = true;
  //
  double searchHeight = 50;
  double searchWidth = 250;
  //
  List<LatLng> cordenadasToLine = [];
  final Set<Polyline> _polyLines = {};
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  DireccionData detallesDeViaje = DireccionData(
    distanceValue: 0,
    durationText: '',
    durationValue: 0,
    distancetext: '',
    encodePoints: '',
  );
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
      try {
        //Código para obtener la ubicación actual y posicionar la cámara
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        userActualPositioned = position;
        LatLng posicion = LatLng(
            userActualPositioned.latitude, userActualPositioned.longitude);
        CameraPosition cameraPosition = CameraPosition(
          target: posicion,
          zoom: 16,
        );
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        String direccion =
            await MethodsHelpers.findCordinateAddress(position, context);
        print("✔✔✔✔" + direccion);
      } catch (e) {
        showSnackBar('Ha ocurrido un error: $e', context);
      }
    }
  }

  void showDetalles() async {
    await getDirection();
    setState(() {
      principalMenu = 0;
      showDetallesCarrera = 250;
      mapBotton = 250;
      showDrawer = false;
      searchHeight = 0;
      searchWidth = 0;
    });
  }

  void showBusquedavehiculo() {
    setState(() {
      showDetallesCarrera = 0;
      panelBusquedavehiculo = 250;
      mapBotton = 250;
      showDrawer = true;
    });
    crearConsultaDeViaje();
  }

  late DatabaseReference referenciaViaje;
  @override
  void initState() {
    super.initState();
    MethodsHelpers.getDataCurrentUser();
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
            myLocationButtonEnabled: false,
            polylines: _polyLines,
            markers: _markers,
            circles: _circles,
            mapToolbarEnabled: false,
            initialCameraPosition: globalInitialCameraPositionet,
            onMapCreated: (GoogleMapController controller) async {
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
            top: 65,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (showDrawer) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  goToInitialApp();
                }
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
                      spreadRadius: 0.7,
                      offset: Offset(
                        0.9,
                        0.9,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    (showDrawer) ? Icons.menu : Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Barra de busqueda

          AnimatedSize(
            // ignore: deprecated_member_use
            vsync: this,
            duration: const Duration(
              seconds: 1,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: searchHeight,
                    width: searchWidth,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          spreadRadius: 0.7,
                          offset: Offset(
                            0.9,
                            0.9,
                          ),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        var respuesta =
                            await Navigator.pushNamed(context, 'search');
                        if (respuesta == 'getDirection') {
                          showDetalles();
                          // showSnackBar('Mejor ruta encontrada', context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Text('¿Dónde te gustaría ir?')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              // ignore: deprecated_member_use
              vsync: this,
              duration: const Duration(
                seconds: 1,
              ),
              child: Container(
                height: principalMenu,
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
                        '¿En que te gusta ir?',
                        style: TextStyle(
                          fontSize: 21.0,
                          fontFamily: 'Brand-Bold',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'images/taxi.png',
                                  width: 60,
                                  height: 60,
                                ),
                                const Text('Carro'),
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  'images/taxi.png',
                                  width: 60,
                                  height: 60,
                                ),
                                const Text('Moto'),
                              ],
                            ),
                          ],
                        ),
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
                              const Text("Añadir lugar de residencia."),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Ruta a casa',
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
          ),
          // Detalles del viaje
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              // ignore: deprecated_member_use
              vsync: this,
              duration: const Duration(
                seconds: 1,
              ),
              curve: Curves.easeIn,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      spreadRadius: 0.7,
                      offset: Offset(
                        0.9,
                        0.9,
                      ),
                    ),
                  ],
                ),
                height: showDetallesCarrera,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(150, 0, 22, 255),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/taxi.png',
                              height: 70,
                              width: 70,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Taxi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Brand-Bold',
                                  ),
                                ),
                                Text(
                                  detallesDeViaje.distancetext,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Text(
                              (detallesDeViaje != null)
                                  ? 'Precio estimado: ${MethodsHelpers.getEstimacionViaje(detallesDeViaje)}'
                                  : 'No hay resultados',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Brand-Bold',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 18,
                            color: UtilsColors.colorTextLight,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text('Efectivo'),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: UtilsColors.colorTextLight,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OsudButton(
                        content: '¡Lo tomo!',
                        color: Colors.blueAccent,
                        onPressed: () {
                          showBusquedavehiculo();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              // ignore: deprecated_member_use
              vsync: this,
              duration: const Duration(milliseconds: 150),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ]),
                height: panelBusquedavehiculo,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          color: UtilsColors.colorTextSemiLight,
                          fontSize: 22.0,
                          fontFamily: 'Brand-Bold',
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText('Un momento, por favor.'),
                            WavyAnimatedText(
                                'Estamos buscando un vehículo para ti :)'),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelarViaje();
                          goToInitialApp();
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(
                                width: 1.0,
                                color: UtilsColors.colorLightGrayFair),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Cancelar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDirection() async {
    var start = Provider.of<ProviderApp>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<ProviderApp>(context, listen: false).destinationAddress;

    var startPositionet = LatLng(start.latitude, start.longitude);
    var destinationPositionet =
        LatLng(destination.latitude, destination.longitude);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PogressDialig(
        status: 'Un momento, por favor.',
      ),
    );
    var detalles = await MethodsHelpers.obtenerDetallesDireccion(
        startPositionet, destinationPositionet, context);

    setState(() {
      detallesDeViaje = detalles;
    });

    Navigator.pop(context);
    // print("👍👍👍👍" + detalles.encodePoints);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> resultados =
        polylinePoints.decodePolyline(detalles.encodePoints);
    print('😂😂😂' + resultados.toString());

    cordenadasToLine.clear();
    if (resultados.isNotEmpty) {
      for (PointLatLng pointLatLng in resultados) {
        cordenadasToLine
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    _polyLines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId('OsudPolyd'),
        color: Colors.blueAccent,
        points: cordenadasToLine,
        jointType: JointType.round,
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polyLines.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (startPositionet.latitude > destinationPositionet.latitude &&
        startPositionet.longitude > destinationPositionet.longitude) {
      latLngBounds = LatLngBounds(
          southwest: destinationPositionet, northeast: startPositionet);
    } else if (startPositionet.longitude > destinationPositionet.longitude) {
      latLngBounds = LatLngBounds(
        southwest:
            LatLng(startPositionet.latitude, destinationPositionet.longitude),
        northeast:
            LatLng(destinationPositionet.latitude, startPositionet.longitude),
      );
    } else if (startPositionet.latitude > destinationPositionet.latitude) {
      latLngBounds = LatLngBounds(
        southwest:
            LatLng(destinationPositionet.latitude, startPositionet.longitude),
        northeast:
            LatLng(startPositionet.latitude, destinationPositionet.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(
        southwest: startPositionet,
        northeast: destinationPositionet,
      );
    }
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
    Marker starMaker = Marker(
      markerId: const MarkerId('StarMarker'),
      position: startPositionet,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: start.addressName, snippet: 'Ubicación actual'),
    );
    Marker destinationMaker = Marker(
      markerId: const MarkerId('DestinationMarker'),
      position: destinationPositionet,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
          title: destination.addressName, snippet: 'Lugar de destino'),
    );
    setState(() {
      _markers.add(starMaker);
      _markers.add(destinationMaker);
    });
    Circle startCircle = Circle(
      circleId: const CircleId('StartCircle'),
      strokeColor: Colors.redAccent,
      strokeWidth: 3,
      radius: 12,
      center: startPositionet,
      fillColor: UtilsColors.colorOrange,
    );
    Circle destinedCircle = Circle(
      circleId: const CircleId('DestinedCircle'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: destinationPositionet,
      fillColor: UtilsColors.colorGreen,
    );
    setState(() {
      _circles.add(startCircle);
      _circles.add(destinedCircle);
    });
  }

  goToInitialApp() {
    setState(() {
      cordenadasToLine.clear();
      _polyLines.clear();
      _markers.clear();
      _circles.clear();
      showDetallesCarrera = 0;
      panelBusquedavehiculo = 0;
      principalMenu = 300;
      mapBotton = 300;
      showDrawer = true;
      searchHeight = 50;
      searchWidth = 250;
    });

    setUserActualPosition();
  }

  void crearConsultaDeViaje() {
    referenciaViaje =
        FirebaseDatabase.instance.reference().child('travelRequest').push();
    var startPositionet =
        Provider.of<ProviderApp>(context, listen: false).pickupAddress;
    var destinationPositionet =
        Provider.of<ProviderApp>(context, listen: false).destinationAddress;
    //
    Map startMap = {
      'latitude': startPositionet.latitude.toString(),
      'longitude': startPositionet.longitude.toString(),
    };
    Map destinatedMap = {
      'latitude': destinationPositionet.latitude.toString(),
      'longitude': destinationPositionet.longitude.toString(),
    };
    Map mapaViaje = {
      'date_create': DateTime.now().toString(),
      'cliente_name': userData.name,
      'cliente_phone': userData.cellPhone,
      'cliente_start_position': startPositionet.addressName,
      'cliente_destination': destinationPositionet.addressName,
      'location': startMap,
      'destino': destinatedMap,
      'method_pay': 'card',
      'driver_id': 'waiting',
    };
    referenciaViaje.set(mapaViaje);
  }

  void cancelarViaje() {
    referenciaViaje.remove();
  }
}
