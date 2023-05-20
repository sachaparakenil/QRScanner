import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/model/user.data.model.dart';

UserData userData = UserData(scanResult: []);

Future<bool> setData() async {
  User user = firebaseAuth.currentUser!;
  var document = await fireStore.collection("users").doc(user.uid).get();
  userData = UserData.fromResponse(document.data());
  return true;
}

Future<void> deleteData(int index) async {
  User user = firebaseAuth.currentUser!;
  await fireStore.collection("users").doc(user.uid.toString()).update({
    "scanResult": FieldValue.arrayRemove([userData.scanResult[index]])
  });
}

Future<bool> addData(String qrCodeResult) async {
  int previousResultCount = userData.scanResult.length;
  await fireStore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid.toString())
      .update({
    "scanResult": FieldValue.arrayUnion([qrCodeResult]),
  });
  await setData();
  if (previousResultCount == userData.scanResult.length) {
    return false;
  } else {
    return true;
  }
}

Future<QRUserInfo> getProfileData() async {
  DocumentSnapshot<Map<String, dynamic>> userData = await fireStore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .get();
  String? userUid = firebaseAuth.currentUser?.uid;
  try {
    String profileLink =
        await fireStorage.ref('profiles/$userUid.png').getDownloadURL();
    return QRUserInfo.fromResponse(userData, profileLink);
  } on FirebaseException {
    return QRUserInfo.fromResponse(userData, null);
  }
}

Future<void> updateProfileData(String displayName, String mobileNo) async {
  String uid = firebaseAuth.currentUser!.uid.toString();

  await fireStore.collection("users").doc(uid).set({
    "displayName": displayName,
    "mobileNo": int.parse(mobileNo),
  }, SetOptions(merge: true));
}

Future<void> changePassword(oldPassword, newPassword) async {
  User user = firebaseAuth.currentUser!;
  String emailId = firebaseAuth.currentUser!.email!;
  AuthCredential credential =
      EmailAuthProvider.credential(email: emailId, password: oldPassword);
  await firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
  await user.updatePassword(newPassword);
}

Future<void> sendEmailConfirmation(String email) async {
  await firebaseAuth.sendPasswordResetEmail(email: email);
}
