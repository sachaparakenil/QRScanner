// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/signup.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final GlobalKey<FormState> _formForgotKey = GlobalKey<FormState>();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formForgotKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 50, bottom: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Email";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Enter Valid Email";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter your email'),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () async {
                  if (_formForgotKey.currentState!.validate()) {
                    try {
                      await sendEmailConfirmation(email);
                      Navigator.of(context).pop();
                      Flushbar(
                        title: "Email Sent",
                        message: "Password Reset Link has been sended to your email",
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 28.0,
                          color: Colors.green,
                        ),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    } catch (e) {
                      Flushbar(
                        title: "Email not found!!",
                        message: "Singup now",
                        icon: const Icon(
                          Icons.error,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  }
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  'New User? Create Account',
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
