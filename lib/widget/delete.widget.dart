import 'package:flutter/material.dart';

Widget deleteBg() {
  return const Card(
    color: Colors.red,
    child: ListTile(
      trailing: Icon(
        Icons.delete_rounded,
        color: Colors.white,
      ),
    ),
  );
}
