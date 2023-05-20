import 'package:flutter/material.dart';

Widget copyElement() {
  return const Card(
    color: Colors.green,
    child: ListTile(
      leading: Icon(
        Icons.copy_rounded,
        color: Colors.white,
      ),
    ),
  );
}
