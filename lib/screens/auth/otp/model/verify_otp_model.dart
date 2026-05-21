class verifyOtp {
  String? mobileNo;
  String? otp;
  String? fcmToken;
  String? deviceId;

  verifyOtp({this.mobileNo, this.otp,this.fcmToken,this.deviceId});

  verifyOtp.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobile'];
    otp = json['otp'];
    fcmToken = json['fcmToken'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobileNo;
    data['otp'] = this.otp;
    data['deviceId'] = this.deviceId;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}