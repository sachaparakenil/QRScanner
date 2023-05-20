// ignore_for_file: use_build_context_synchronously, avoid_single_cascade_in_expression_statements, empty_catches

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/model/user.data.model.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/widget/change_password.widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.profileData}) : super(key: key);
  final QRUserInfo profileData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  File? _cameraImage;
  String displayName = "";
  String mobileNo = "";
  String profileLink = "https://i.pravatar.cc/130?img=56";

  Future<void> getImageFromPhone(ImageSource imageSource) async {
    final selectedImage = await imagePicker.pickImage(source: imageSource);
    if (selectedImage != null) {
      setState(() {
        _cameraImage = File(selectedImage.path);
      });
    }
  }

  Future<void> uploadFileFunc(BuildContext context, File uploadFile) async {
    try {
      var userUid = firebaseAuth.currentUser!.uid;
      await fireStorage.ref('profiles/$userUid.png').putFile(uploadFile);
      profileLink =
          await fireStorage.ref('profiles/$userUid.png').getDownloadURL();
      setState(() {});
    } on FirebaseException {}
  }

  @override
  void initState() {
    setState(() {
      displayName = widget.profileData.displayName ?? '';
      mobileNo = widget.profileData.mobileNo ?? '';
      profileLink =
          widget.profileData.profileLink ?? 'https://i.pravatar.cc/130?img=56';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(profileLink),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => selectProfile()),
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Name";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      displayName = value!;
                    },
                    initialValue: displayName,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.only(top: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Enter your name"),
                    onChanged: (value) {
                      setState(() {
                        displayName = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_rounded),
                      contentPadding: const EdgeInsets.only(top: 15),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: firebaseAuth.currentUser?.email ??
                          'username@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Mobile No";
                      } else if (value.length != 10) {
                        return "Enter valid Mobile No";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      mobileNo = value!;
                    },
                    initialValue: mobileNo,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      contentPadding: EdgeInsets.only(top: 15),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter Mobile Number",
                    ),
                    onChanged: (value) {
                      setState(() {
                        mobileNo = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.security),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return changePasswordAlert(context);
                        });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 35),
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 35),
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await updateProfileData(displayName, mobileNo);
                            Flushbar(
                              title: "Profile Updated",
                              message:
                                  "Profile has been successfully updated !!",
                              icon: const Icon(
                                Icons.check_circle_rounded,
                                size: 28.0,
                                color: Colors.green,
                              ),
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          }
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectProfile() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Choose Image From",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black.withOpacity(0.8)),
                  icon: const Icon(Icons.photo_camera_rounded),
                  onPressed: () async {
                    try {
                      await getImageFromPhone(ImageSource.camera);
                      await uploadFileFunc(context, _cameraImage!);
                      Navigator.pop(context);
                    } catch (e) {
                      Flushbar(
                        title: "Could Not Update Profile",
                        message: "Select Smaller Image",
                        icon: const Icon(
                          Icons.error,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black.withOpacity(0.8)),
                  icon: const Icon(Icons.image_rounded),
                  onPressed: () async {
                    try {
                      await getImageFromPhone(ImageSource.gallery);
                      await uploadFileFunc(context, _cameraImage!);
                      Navigator.pop(context);
                    } catch (e) {}
                  },
                  label: const Text("Gallary"),
                )
              ],
            ),
          ],
        ));
  }
}
