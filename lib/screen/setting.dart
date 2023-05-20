import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool soundOn = false;
  bool vibrationOn = false;

  void getUserSetting() async {
    soundOn = await getUserSoundSettingState();
    vibrationOn = await getUserVibrationSettingState();
    setState(() {});
  }

  Future<bool> saveUserSoundSettingState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("userSoundSettingState", value);
  }

  Future<bool> saveUserVibrationSettingState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("userVibrationSettingState", value);
  }

  Future<bool> getUserSoundSettingState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      soundOn = prefs.getBool("userSoundSettingState")!;
    } catch (e) {
      await saveUserSoundSettingState(false);
      soundOn = false;
    }
    return soundOn;
  }

  Future<bool> getUserVibrationSettingState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      vibrationOn = prefs.getBool("userVibrationSettingState")!;
    } catch (e) {
      await saveUserVibrationSettingState(false);
      vibrationOn = false;
    }
    return vibrationOn;
  }

  @override
  void initState() {
    super.initState();
    getUserSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Settings"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Conf",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.volume_up_rounded),
              title: const Text("Beep Sound"),
              horizontalTitleGap: 0,
              trailing: Switch(
                value: soundOn,
                onChanged: (value) async {
                  await saveUserSoundSettingState(value);
                  setState(() {
                    soundOn = value;
                  });
                },
                activeTrackColor: Colors.green.shade300,
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.vibration_rounded),
              title: const Text("Vibration"),
              horizontalTitleGap: 0,
              trailing: Switch(
                value: vibrationOn,
                onChanged: (value) async {
                  await saveUserVibrationSettingState(value);
                  setState(() {
                    vibrationOn = value;
                  });
                },
                activeTrackColor: Colors.green.shade300,
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Misc",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.policy_rounded),
              title: const Text("Privacy Policy"),
              horizontalTitleGap: 0,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Privacy Policy"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "We respect the privacy of user and we do not sell or misused your data."),
                        ],
                      ),
                      actions: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text("Version 1.0.4"),
              horizontalTitleGap: 0,
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Version 1.0.4 ~ Mr. Grey",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
