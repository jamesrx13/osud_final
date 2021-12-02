import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/snackbar_utils.dart';
import 'package:osud_final/utils/widgets/osud_button.dart';
import 'package:osud_final/utils/widgets/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void singIn(BuildContext context) async {
    // Espera
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const PogressDialig(
        status: 'Iniciando sesión',
      ),
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      if (userCredential.user != null) {
        // Autenticacion exitosa
        DatabaseReference userData = FirebaseDatabase.instance
            .reference()
            .child('users/${userCredential.user?.uid}');
        userData.once().then((DataSnapshot snapshot) => {
              if (snapshot.value != null)
                {
                  // Navigator.pop(context),
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false),
                  showSnackBar('Bienvenido!', context)
                }
            });
      } else {
        showSnackBar('Ha surgido un error', context);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar('Usuario no encontrado', context);
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        showSnackBar('Contraseña incorrecta', context);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _space(70.0, 0.0),
                _logo(Alignment.center, 100.0, 100.0, 'images/logo.png'),
                _space(40.0, 0.0),
                _texto('Inicia sesión en Osud'),
                // _space(10.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _campoEmail(),
                      _space(10.0, 0.0),
                      _campoPassword(),
                      _space(40.0, 0.0),
                      _goButtom('INICIAR'),
                      _space(10.0, 0.0),
                    ],
                  ),
                ),
                _goToRegisterButtom(
                    '¿No tienes una cuenta creada? Registrate', context),
              ],
            ),
          ),
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

  Widget _campoEmail() {
    const decoration = InputDecoration(
      labelText: 'Correo electrónico',
      labelStyle: TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: emailController,
      onChanged: (text) {},
      keyboardType: TextInputType.emailAddress,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPassword() {
    const decoration = InputDecoration(
      labelText: 'Contraseña',
      labelStyle: TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: passwordController,
      onChanged: (text) {},
      obscureText: true,
      decoration: decoration,
      style: style,
    );
  }

  Widget _goButtom(content) {
    return OsudButton(
      content: content,
      color: UtilsColors.colorBlue,
      onPressed: () async {
        // Validar la conectividad
        var conectivity = await Connectivity().checkConnectivity();
        if (conectivity != ConnectivityResult.wifi &&
            conectivity != ConnectivityResult.mobile) {
          showSnackBar('No hay acceso a internet', context);
          return;
        }
        // Validar el campos
        if (!emailController.text.contains('@')) {
          showSnackBar('Ingresar un correo electrónico válido', context);
          return;
        }
        if (passwordController.text.length < 6) {
          showSnackBar(
              'La contraseña debe tener como mínimo 6 carácteres', context);
          return;
        }
        singIn(context);
      },
    );
  }

  Widget _goToRegisterButtom(content, context) {
    return TextButton(
      child: Text(content),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, 'register', (route) => false);
      },
    );
  }
}
