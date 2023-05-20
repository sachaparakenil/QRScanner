// ignore_for_file: use_build_context_synchronously, empty_catches, unused_local_variable

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/repository/request.repository.dart';

Widget changePasswordAlert(BuildContext context) {
  final GlobalKey<FormState> formChangekey = GlobalKey<FormState>();
  String oldPass = "";
  String newPass = "";
  String newPassConf = "";

  return AlertDialog(
    actionsAlignment: MainAxisAlignment.spaceEvenly,
    title: const Text("Change Password"),
    content: Form(
      key: formChangekey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else if (value.length < 6) {
                  return "Password should be atleast 6 characters";
                } else if (value.length > 15) {
                  return "Password should not be greater than 15 characters";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                oldPass = value!;
              },
              obscureText: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Enter Old Password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "Enter Password",
              ),
              onChanged: (value) {
                oldPass = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else if (value.length < 6) {
                  return "Password should be atleast 6 characters";
                } else if (value.length > 15) {
                  return "Password should not be greater than 15 characters";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                newPass = value!;
              },
              obscureText: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Enter New Password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "Enter Password",
              ),
              onChanged: (value) {
                newPass = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              validator: (value) {
                if (value != newPass) {
                  return "Password does not match";
                }
                return null;
              },
              onSaved: (value) {
                newPassConf = value!;
              },
              obscureText: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3),
                labelText: "Conform New Password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "Enter Password",
              ),
              onChanged: (value) {
                newPassConf = value;
              },
            ),
          ),
        ],
      ),
    ),
    actions: [
      // ignore: deprecated_member_use
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 35),
          primary: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          "CLOSE",
          style: TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.white),
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 35),
          primary: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        onPressed: () async {
          if (formChangekey.currentState!.validate()) {
            try {
              await changePassword(oldPass, newPass);
              Navigator.of(context).pop();

              Flushbar(
                message: "Password Changed Successfully !!",
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 28.0,
                  color: Colors.green,
                ),
                duration: const Duration(seconds: 3),
              ).show(context);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                Flushbar(
                  title: "User Not Found !",
                  message: "Email is not registerd! Signup now",
                  icon: const Icon(
                    Icons.error_outline_rounded,
                    size: 28.0,
                    color: Colors.red,
                  ),
                  duration: const Duration(seconds: 3),
                ).show(context);
              } else if (e.code == 'wrong-password') {
                Flushbar(
                  title: "Wrong Password !",
                  message: "Forgot password for recovery",
                  icon: const Icon(
                    Icons.error_outline_rounded,
                    size: 28.0,
                    color: Colors.red,
                  ),
                  duration: const Duration(seconds: 3),
                ).show(context);
              }
            } catch (e) {}
          }
        },
        child: const Text(
          "CHANGE",
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
