class AppointmentDetailsModel {
  bool? status;
  String? message;
  AppointmentDetailsData? data;

  AppointmentDetailsModel({this.status, this.message, this.data});

  AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AppointmentDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AppointmentDetailsData {
  String? sId;
  User? user;
  User? patient;
  Vendor? vendor;
  User? category;
  String? appointmentDate;
  String? timeSlot;
  List<String>? reminder; // Changed from List<Null> to List<String>
  String? type;
  String? status;
  String? notes;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AppointmentDetailsData({
    this.sId,
    this.user,
    this.patient,
    this.vendor,
    this.category,
    this.appointmentDate,
    this.timeSlot,
    this.reminder,
    this.type,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AppointmentDetailsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    patient = json['patient'] != null ? User.fromJson(json['patient']) : null;
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    category = json['category'] != null ? User.fromJson(json['category']) : null;
    appointmentDate = json['appointmentDate'];
    timeSlot = json['timeSlot'];

    // Changed to parse a list of strings
    reminder = json['reminder'] != null ? List<String>.from(json['reminder']) : null;

    type = json['type'];
    status = json['status'];
    notes = json['notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['appointmentDate'] = this.appointmentDate;
    data['timeSlot'] = this.timeSlot;

    // Changed to serialize a list of strings
    if (this.reminder != null) {
      data['reminder'] = this.reminder!;
    }

    data['type'] = this.type;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String? sId;
  String? name;

  User({this.sId, this.name});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Vendor {
  String? sId;
  String? name;
  String? profileImage;
  String? mobile;
  List<String>? department;

  Vendor({this.sId, this.name, this.mobile, this.department});

  Vendor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'];
    profileImage = json['profileImage'];
    mobile = json['mobile'];
    department = json['department']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['Name'] = this.name;
    data['profileImage'] = this.profileImage;
    data['mobile'] = this.mobile;
    data['department'] = this.department;
    return data;
  }
}