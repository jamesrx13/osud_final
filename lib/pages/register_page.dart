// ignore_for_file: avoid_print
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:osud_final/utils/colors_utils.dart';
import 'package:osud_final/utils/snackbar_utils.dart';
import 'package:osud_final/utils/widgets/osud_button.dart';
import 'package:osud_final/utils/widgets/progress_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void registerNewUser(BuildContext context) async {
    // Espera
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const PogressDialig(
              status: 'Registrando el usuario',
            ));
    try {
      UserCredential userData = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      if (userData.user != null) {
        DatabaseReference newUser = FirebaseDatabase.instance
            .reference()
            .child('users/${userData.user?.uid}');
        Map userDataMap = {
          'fullName': fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text
        };
        newUser.set(userDataMap);
        const content = "El usuario se ha creado de forma correcta";
        showSnackBar(content, context);
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      } else {
        Navigator.pop(context);
        showSnackBar("Error al crear el usuario", context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        const content = "La contraseña ingresada es muy débil.";
        showSnackBar(content, context);
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        const content = "El correo ingresado ya se encuentra en uso.";
        showSnackBar(content, context);
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar("Error desconocido: $e", context);
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
                _texto('Registrate en Osud'),
                // _space(10.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _campoName(),
                      _space(10.0, 0.0),
                      _campoPhone(),
                      _space(10.0, 0.0),
                      _campoEmail(),
                      _space(10.0, 0.0),
                      _campoPassword(),
                      _space(40.0, 0.0),
                      _goButtom('REGISTRAR', context),
                      _space(10.0, 0.0),
                    ],
                  ),
                ),
                _goToRegisterButtom(
                    '¿Ya tienes una cuenta? Inicia sesión', context),
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

  Widget _campoPhone() {
    const decoration = InputDecoration(
      labelText: 'Numero de teléfono',
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
      controller: phoneController,
      onChanged: (text) {},
      keyboardType: TextInputType.phone,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoName() {
    const decoration = InputDecoration(
      labelText: 'Nombre completo',
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
      controller: fullNameController,
      onChanged: (text) {},
      keyboardType: TextInputType.text,
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

  Widget _goButtom(content, BuildContext context) {
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
        if (fullNameController.text.length < 3) {
          showSnackBar('Ingresar un nombre válido', context);
          return;
        }
        if (phoneController.text.length < 10) {
          showSnackBar('Ingresar un número de teléfono válido', context);
          return;
        }
        if (!emailController.text.contains('@')) {
          showSnackBar('Ingresar un correo electrónico válido', context);
          return;
        }
        if (passwordController.text.length < 6) {
          showSnackBar(
              'La contraseña debe tener como mínimo 6 carácteres', context);
          return;
        }
        registerNewUser(context);
      },
    );
  }

  Widget _goToRegisterButtom(content, context) {
    return TextButton(
      child: Text(content),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      },
    );
  }
}
