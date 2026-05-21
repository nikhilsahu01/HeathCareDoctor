class DoctorsProfileDetails {
  bool? success;
  String? message;
  ProfileData? data;

  DoctorsProfileDetails({this.success, this.message, this.data});

  DoctorsProfileDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileData {
  String? otp;
  String? sId;
  Category? category;
  String? type;
  String? name;
  String? mobile;
  String? dob;
  String? gender;
  String? address;
  List<String>? department;
  List<String>? symptoms;
  String? qualification;
  String? yearOfExp;
  String? licOrRegNumber;
  String? certificate;
  String? state;
  String? district;
  String? pincode;
  String? lat;
  String? long;
  String? startTime;
  String? endTime;
  var rating;
  var commission;
  var walletBalance;
  bool? isBlocked;
  String? agreementAccepted;
  bool? status;
  String? createdAt;
  var iV;
  bool? isEmergency;
  bool? inClinicAvaialble;
  bool? videoConsultAvailable;
  String? inClinicFee;
  String? profileImage;
  String? videoConsultFee;
  String? closingTime;
  String? openingTime;
  List<SelectDay>? selectDays;
  var breakTime;
  String? lunchEnd;
  String? lunchStart;
  var sessionTime;
  String? countryCode;
  String? country;
  String? deviceId;
  String? fcmToken;
  String? otpExpires;

  // New fields
  String? city;               // New field
  String? email;              // New field
  String? licenseAuthority;   // New field
  String? specialization;    // New field

  ProfileData({
    this.otp,
    this.sId,
    this.category,
    this.type,
    this.name,
    this.mobile,
    this.dob,
    this.gender,
    this.address,
    this.department,
    this.symptoms,
    this.qualification,
    this.yearOfExp,
    this.licOrRegNumber,
    this.certificate,
    this.state,
    this.district,
    this.pincode,
    this.lat,
    this.long,
    this.startTime,
    this.endTime,
    this.rating,
    this.commission,
    this.walletBalance,
    this.isBlocked,
    this.agreementAccepted,
    this.status,
    this.createdAt,
    this.iV,
    this.isEmergency,
    this.inClinicAvaialble,
    this.videoConsultAvailable,
    this.inClinicFee,
    this.profileImage,
    this.videoConsultFee,
    this.closingTime,
    this.openingTime,
    this.selectDays,
    this.breakTime,
    this.lunchEnd,
    this.lunchStart,
    this.sessionTime,
    this.countryCode,
    this.country,
    this.deviceId,
    this.fcmToken,
    this.otpExpires,
    this.city,               // New field
    this.email,              // New field
    this.licenseAuthority,   // New field
    this.specialization,     // New field
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    sId = json['_id'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    type = json['type'];
    name = json['Name'];
    mobile = json['mobile'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
    department = json['department']?.cast<String>();
    symptoms = json['symptoms']?.cast<String>();
    qualification = json['qualification'];
    yearOfExp = json['yearOfExp'];
    licOrRegNumber = json['licOrRegNumber'];
    certificate = json['certificate'];
    state = json['state'];
    district = json['district'];
    pincode = json['pincode'];
    lat = json['lat'];
    long = json['long'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    rating = json['rating'];
    commission = json['commission'];
    walletBalance = json['wallet_balance'];
    isBlocked = json['isBlocked'];
    agreementAccepted = json['agreementAccepted'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    isEmergency = json['isEmergency'];
    inClinicAvaialble = json['inClinicAvaialble'];
    videoConsultAvailable = json['videoConsultAvailable'];
    inClinicFee = json['inClinicFee'];
    profileImage = json['profileImage'];
    videoConsultFee = json['videoConsultFee'];
    closingTime = json['closingTime'];
    openingTime = json['openingTime'];

    if (json['selectDays'] != null) {
      selectDays = [];
      json['selectDays'].forEach((v) {
        selectDays!.add(SelectDay.fromJson(v));
      });
    }

    breakTime = json['breakTime'];
    lunchEnd = json['lunchEnd'];
    lunchStart = json['lunchStart'];
    sessionTime = json['sessionTime'];
    countryCode = json['countryCode'];
    country = json['country'];
    deviceId = json['deviceId'];
    fcmToken = json['fcmToken'];
    otpExpires = json['otpExpires'];

    // New fields
    city = json['city'];                       // New field
    email = json['email'];                     // New field
    licenseAuthority = json['licenseAuthority']; // New field
    specialization = json['specialization'];  // New field
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['otp'] = otp;
    data['_id'] = sId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['type'] = type;
    data['Name'] = name;
    data['mobile'] = mobile;
    data['dob'] = dob;
    data['gender'] = gender;
    data['address'] = address;
    data['department'] = department;
    data['symptoms'] = symptoms;
    data['qualification'] = qualification;
    data['yearOfExp'] = yearOfExp;
    data['licOrRegNumber'] = licOrRegNumber;
    data['certificate'] = certificate;
    data['state'] = state;
    data['district'] = district;
    data['pincode'] = pincode;
    data['lat'] = lat;
    data['long'] = long;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['rating'] = rating;
    data['commission'] = commission;
    data['wallet_balance'] = walletBalance;
    data['isBlocked'] = isBlocked;
    data['agreementAccepted'] = agreementAccepted;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    data['isEmergency'] = isEmergency;
    data['inClinicAvaialble'] = inClinicAvaialble;
    data['videoConsultAvailable'] = videoConsultAvailable;
    data['inClinicFee'] = inClinicFee;
    data['profileImage'] = profileImage;
    data['videoConsultFee'] = videoConsultFee;
    data['closingTime'] = closingTime;
    data['openingTime'] = openingTime;
    if (selectDays != null) {
      data['selectDays'] = selectDays!.map((v) => v.toJson()).toList();
    }
    data['breakTime'] = breakTime;
    data['lunchEnd'] = lunchEnd;
    data['lunchStart'] = lunchStart;
    data['sessionTime'] = sessionTime;
    data['countryCode'] = countryCode;
    data['country'] = country;
    data['deviceId'] = deviceId;
    data['fcmToken'] = fcmToken;
    data['otpExpires'] = otpExpires;

    // New fields
    data['city'] = city;                       // New field
    data['email'] = email;                     // New field
    data['licenseAuthority'] = licenseAuthority; // New field
    data['specialization'] = specialization;  // New field

    return data;
  }
}

class Category {
  String? sId;
  String? name;

  Category({this.sId, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class SelectDay {
  String? day;
  bool? available;
  String? sId;

  SelectDay({this.day, this.available, this.sId});

  SelectDay.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    available = json['available'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['day'] = day;
    data['available'] = available;
    data['_id'] = sId;
    return data;
  }
}

