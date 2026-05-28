
class AppointmentsListModel {
  bool? success;
  String? message;
  Data? data;

  AppointmentsListModel({this.success, this.message, this.data});

  AppointmentsListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<AppointmentsList>? appointments;
  Pagination? pagination; // Updated from count to pagination

  Data({this.appointments, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['appointments'] != null) {
      appointments = <AppointmentsList>[];
      json['appointments'].forEach((v) {
        appointments!.add(new AppointmentsList.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null; // Updated
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointments != null) {
      data['appointments'] = this.appointments!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) { // Updated
      data['pagination'] = this.pagination!.toJson(); // Updated
    }
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalResults;

  Pagination({this.currentPage, this.totalPages, this.totalResults});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalResults'] = this.totalResults;
    return data;
  }
}

class AppointmentsList {
  String? appointmentId;
  String? inviteDoctor;
  String? userName;
  String? userMobile;
  String? patientName;
  String? patientImage;
  String? patientAge;
  String? patientGender;
  String? categoryName;
  String? orderId;
  String? appointmentDate;
  String? timeSlot;
  String? status;
  String? type;
  bool? isReminder;
  String? notes;
  bool? rescheduled;
  List<RescheduleHistory>? rescheduleHistory;
  String? rescheduleReason;
  String? cancellReason;
  String? createdAt;
  num? appointmentFee;
  num? commissionAmount;
  num? netEarnings;
  List<String>? prescriptionFiles;

  AppointmentsList(
      {this.appointmentId,
      this.inviteDoctor,
        this.userName,
        this.userMobile,
        this.patientName,
        this.patientImage,
        this.patientAge,
        this.patientGender,
        this.categoryName,
        this.orderId,
        this.appointmentDate,
        this.timeSlot,
        this.status,
        this.type,
        this.isReminder,
        this.notes,
        this.rescheduled,
        this.rescheduleHistory,
        this.rescheduleReason,
        this.cancellReason,
        this.createdAt,
        this.appointmentFee,
        this.commissionAmount,
        this.netEarnings,
        this.prescriptionFiles});

  AppointmentsList.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    inviteDoctor = json['inviteDoctor'];
    userName = json['userName'];
    userMobile = json['userMobile'];
    patientName = json['patientName'];
    patientImage = json['patientImage'];
    patientAge = json['patientAge'];
    patientGender = json['patientGender'];
    categoryName = json['categoryName'];
    orderId = json['orderId'];
    appointmentDate = json['appointmentDate'];
    timeSlot = json['timeSlot'];
    status = json['status'];
    type = json['type'];
    isReminder = json['isReminder'];
    notes = json['notes'];
    rescheduled = json['rescheduled'];
    if (json['rescheduleHistory'] != null) {
      rescheduleHistory = <RescheduleHistory>[];
      json['rescheduleHistory'].forEach((v) {
        rescheduleHistory!.add(new RescheduleHistory.fromJson(v));
      });
    }
    rescheduleReason = json['rescheduleReason'];
    cancellReason = json['cancellReason'];
    createdAt = json['createdAt'];
    appointmentFee = json['appointmentFee'];
    commissionAmount = json['commissionAmount'];
    netEarnings = json['netEarnings'];
    if (json['prescriptionFiles'] != null) {
      prescriptionFiles = List<String>.from(json['prescriptionFiles']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['inviteDoctor'] = this.inviteDoctor;
    data['userName'] = this.userName;
    data['userMobile'] = this.userMobile;
    data['patientName'] = this.patientName;
    data['patientImage'] = this.patientImage;
    data['patientAge'] = this.patientAge;
    data['patientGender'] = this.patientGender;
    data['categoryName'] = this.categoryName;
    data['orderId'] = this.orderId;
    data['appointmentDate'] = this.appointmentDate;
    data['timeSlot'] = this.timeSlot;
    data['status'] = this.status;
    data['type'] = this.type;
    data['isReminder'] = this.isReminder;
    data['notes'] = this.notes;
    data['rescheduled'] = this.rescheduled;
    if (this.rescheduleHistory != null) {
      data['rescheduleHistory'] =
          this.rescheduleHistory!.map((v) => v.toJson()).toList();
    }
    data['rescheduleReason'] = this.rescheduleReason;
    data['cancellReason'] = this.cancellReason;
    data['createdAt'] = this.createdAt;
    data['appointmentFee'] = this.appointmentFee;
    data['commissionAmount'] = this.commissionAmount;
    data['netEarnings'] = this.netEarnings;
    if (this.prescriptionFiles != null) {
      data['prescriptionFiles'] = this.prescriptionFiles;
    }
    return data;
  }
}

class RescheduleHistory {
  String? appointmentDate;
  String? timeSlot;
  String? rescheduledAt;
  String? sId;

  RescheduleHistory(
      {this.appointmentDate, this.timeSlot, this.rescheduledAt, this.sId});

  RescheduleHistory.fromJson(Map<String, dynamic> json) {
    appointmentDate = json['appointmentDate'];
    timeSlot = json['timeSlot'];
    rescheduledAt = json['rescheduledAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentDate'] = this.appointmentDate;
    data['timeSlot'] = this.timeSlot;
    data['rescheduledAt'] = this.rescheduledAt;
    data['_id'] = this.sId;
    return data;
  }
}
