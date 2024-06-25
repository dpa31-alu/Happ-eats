import 'package:flutter/material.dart';


loadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text("Procesando...")),
          ],
        ),
      );
    },
  );
}