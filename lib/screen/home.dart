// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/model/user.data.model.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/login.dart';
import 'package:qrscanner/screen/profile.dart';
import 'package:qrscanner/screen/setting.dart';
import 'package:qrscanner/widget/copy.widget.dart';
import 'package:qrscanner/widget/delete.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

String userEmail = 'username@example.com';
var userUid = firebaseAuth.currentUser!.uid;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  String qrResult = 'Unknown';

  Future<bool> confirmDismiss(DismissDirection direction, index) async {
    if (direction == DismissDirection.endToStart) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to Delete?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    } else {
      Clipboard.setData(ClipboardData(text: userData.scanResult[index]));
      Fluttertoast.showToast(
        msg: "Copied!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("QR Scanner"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Stack(
                children: const <Widget>[
                  Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text(
                      "QR Scanner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () async {
                  QRUserInfo profileData = await getProfileData();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              profileData: profileData,
                            )),
                  );
                }),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text("QR Codes"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await firebaseAuth.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await setData();
          setState(() {});
        },
        child: FutureBuilder<bool>(
          future: setData(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: userData.scanResult.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (direction) =>
                        confirmDismiss(direction, index),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        Fluttertoast.showToast(
                          msg: "Deleted Successfully !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                        await deleteData(index);
                        setState(() {
                          userData.scanResult.removeAt(index);
                          userData = userData;
                        });
                      }
                    },
                    background: copyElement(),
                    secondaryBackground: deleteBg(),
                    child: Card(
                      child: ListTile(
                        title: Text(userData.scanResult[index]),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () async {
            try {
              bool soundOnbool;
              bool vibrationOnbool;
              ScanResult qrCode = await BarcodeScanner.scan();
              if (qrCode.rawContent != "") {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                soundOnbool = prefs.getBool("userSoundSettingState") ?? false;
                vibrationOnbool =
                    prefs.getBool("userVibrationSettingState") ?? false;
                if (soundOnbool) {
                  Soundpool beepQR = Soundpool(streamType: StreamType.ring);
                  ByteData soundData =
                      await rootBundle.load("asset/sound/beep.ogg");
                  int soundId = await beepQR.load(soundData);
                  beepQR.play(soundId);
                }
                if (vibrationOnbool) {
                  if (await Vibrate.canVibrate) {
                    Vibrate.feedback(FeedbackType.heavy);
                  }
                }
                bool isAdded = await addData(qrCode.rawContent);
                if (!isAdded) {
                  Fluttertoast.showToast(
                    msg: "Already Scanned !!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                }
                setState(() {
                  userData = userData;
                });
              }
            } on PlatformException catch (e) {
              if (e.code == BarcodeScanner.cameraAccessDenied) {
                setState(() {
                  qrResult = 'No camera permission!';
                });
              } else {
                setState(() => qrResult = 'Unknown error: $e');
              }
            } on FormatException {
              setState(() => qrResult = 'Nothing captured.');
            } catch (e) {
              setState(() => qrResult = 'Unknown error: $e');
            }
          },
          backgroundColor: Colors.green,
          tooltip: "Scan QR Code",
          child: const Icon(Icons.camera_alt_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
