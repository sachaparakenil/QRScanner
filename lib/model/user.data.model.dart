import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  List<String> scanResult;

  UserData({required this.scanResult});

  factory UserData.fromResponse(dynamic data) {
    return UserData(scanResult: List<String>.from(data['scanResult']));
  }
}

class QRUserInfo {
  String? displayName;
  String? mobileNo;
  String? profileLink;

  QRUserInfo(
      {required this.displayName,
      required this.mobileNo,
      required this.profileLink});

  factory QRUserInfo.fromResponse(
      DocumentSnapshot<Map<String, dynamic>> userInfo, String? profileLink) {
    return QRUserInfo(
      displayName: userInfo.data()?['displayName'].toString(),
      mobileNo: userInfo.data()?['mobileNo'].toString(),
      profileLink: profileLink,
    );
  }
}
