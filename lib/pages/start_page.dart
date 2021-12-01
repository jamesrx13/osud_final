import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osud_final/utils/colors_utils.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

void validateSesion(BuildContext context) {
  if (FirebaseAuth.instance.currentUser != null) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  } else {
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo(Alignment.center, 100.0, 100.0, 'images/logo.png'),
            _space(10.0, 0.0),
            _texto('Bienvenido a Osud'),
            _space(10.0, 0.0),
            _carga(),
          ],
        ),
      ),
    );
  }

  Widget _space(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _logo(aliniamiento, height, width, imageURL) {
    imageURL = AssetImage(imageURL);
    return Image(
      alignment: aliniamiento,
      height: height,
      width: width,
      image: imageURL,
    );
  }

  Widget _texto(content) {
    const style = TextStyle(
      fontSize: 25,
      fontFamily: 'Brand-Bold',
    );
    return Text(
      content,
      textAlign: TextAlign.center,
      style: style,
    );
  }

  Widget _carga() {
    const progressIndicator = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(UtilsColors.colorBlue),
    );
    return progressIndicator;
  }
}
