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
  int? count;

  Data({this.appointments, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['appointments'] != null) {
      appointments = <AppointmentsList>[];
      json['appointments'].forEach((v) {
        appointments!.add(new AppointmentsList.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointments != null) {
      data['appointments'] = this.appointments!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class AppointmentsList {
  String? appointmentId;
  String? userName;
  String? patientName;
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
  String? userMobile;
  List<String>? prescriptionFiles;

  AppointmentsList(
      {this.appointmentId,
        this.userName,
        this.patientName,
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
        this.userMobile,
        this.prescriptionFiles});

  AppointmentsList.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    userName = json['userName'];
    patientName = json['patientName'];
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
    userMobile = json['userMobile'];
    if (json['prescriptionFiles'] != null) {
      prescriptionFiles = json['prescriptionFiles'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['userName'] = this.userName;
    data['patientName'] = this.patientName;
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
    data['userMobile'] = this.userMobile;
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