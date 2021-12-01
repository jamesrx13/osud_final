// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:osud_final/utils/colors_utils.dart';

class PogressDialig extends StatelessWidget {
  const PogressDialig({Key? key, required this.status}) : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(
                width: 5,
              ),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(UtilsColors.colorBlue),
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                status,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
