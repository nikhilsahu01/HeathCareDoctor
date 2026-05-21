class InviteDoctorModel {
  bool? success;
  String? message;
  Data? data;

  InviteDoctorModel({this.success, this.message, this.data});

  InviteDoctorModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? user;
  String? patient;
  String? vendor;
  String? category;
  String? orderId;
  String? appointmentDate;
  String? timeSlot;
  List<String>? reminder;
  String? type;
  String? status;
  String? notes;
  bool? rescheduled;
  String? rescheduleReason;
  String? cancellReason;
  String? isReminder;
  String? isEmergency;
  String? inviteDoctor;
  List<String>? rescheduleHistory;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.user,
        this.patient,
        this.vendor,
        this.category,
        this.orderId,
        this.appointmentDate,
        this.timeSlot,
        this.reminder,
        this.type,
        this.status,
        this.notes,
        this.rescheduled,
        this.rescheduleReason,
        this.cancellReason,
        this.isReminder,
        this.isEmergency,
        this.inviteDoctor,
        this.rescheduleHistory,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    patient = json['patient'];
    vendor = json['vendor'];
    category = json['category'];
    orderId = json['orderId'];
    appointmentDate = json['appointmentDate'];
    timeSlot = json['timeSlot'];
    reminder = json['reminder'].cast<String>();
    type = json['type'];
    status = json['status'];
    notes = json['notes'];
    rescheduled = json['rescheduled'];
    rescheduleReason = json['rescheduleReason'];
    cancellReason = json['cancellReason'];
    isReminder = json['isReminder'];
    isEmergency = json['isEmergency'];
    inviteDoctor = json['inviteDoctor'];
    rescheduleHistory = json['rescheduleHistory'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['patient'] = this.patient;
    data['vendor'] = this.vendor;
    data['category'] = this.category;
    data['orderId'] = this.orderId;
    data['appointmentDate'] = this.appointmentDate;
    data['timeSlot'] = this.timeSlot;
    data['reminder'] = this.reminder;
    data['type'] = this.type;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['rescheduled'] = this.rescheduled;
    data['rescheduleReason'] = this.rescheduleReason;
    data['cancellReason'] = this.cancellReason;
    data['isReminder'] = this.isReminder;
    data['isEmergency'] = this.isEmergency;
    data['inviteDoctor'] = this.inviteDoctor;
    data['rescheduleHistory'] = this.rescheduleHistory;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
