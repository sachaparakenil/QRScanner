// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/screen/forgot.dart';
import 'package:qrscanner/screen/home.dart';
import 'package:qrscanner/screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("QR Scanner Login"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
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
                  onSaved: (email) {
                    _email = email!;
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                  obscureText: true,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPage()),
                  );
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    try {
                      await firebaseAuth.signInWithEmailAndPassword(
                          email: _email, password: _password);
                      User user = firebaseAuth.currentUser!;
                      if (user.emailVerified) {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        user.sendEmailVerification();
                        await firebaseAuth.signOut();
                        setState(() {});
                        showDialog(
                          context: context,
                          builder: (BuildContext contex) {
                            return AlertDialog(
                              title: const Text("Verify Your Email"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 25),
                                    child: Text(
                                      "A verification mail has been sent to your email",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Flushbar(
                          title: "User Not Found !",
                          message: "Email is not registerd! Signup now",
                          icon: const Icon(
                            Icons.error,
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
                            Icons.error,
                            size: 28.0,
                            color: Colors.red,
                          ),
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      } else if (e.code == 'too-many-requests') {
                        Flushbar(
                          title: "Too Many Requests !",
                          message: "Try after some time",
                          icon: const Icon(
                            Icons.error,
                            size: 28.0,
                            color: Colors.red,
                          ),
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      } else {
                        Flushbar(
                          title: "Internal Error !",
                          message: "Try after some time",
                          icon: const Icon(
                            Icons.error,
                            size: 28.0,
                            color: Colors.red,
                          ),
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      }
                    }
                  } else {}
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    'New User? Create Account',
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
