class TicketModel {
  bool? success;
  String? message;
  List<TicketData>? data;

  TicketModel({this.success, this.message, this.data});

  TicketModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TicketData>[];
      json['data'].forEach((v) {
        data!.add(TicketData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketData {
  String? sId;
  String? subject;
  String? description;
  String? status;
  String? priority;
  String? attachment;
  String? adminReply;
  String? createdAt;

  TicketData({
    this.sId,
    this.subject,
    this.description,
    this.status,
    this.priority,
    this.attachment,
    this.adminReply,
    this.createdAt,
  });

  TicketData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    subject = json['subject'];
    description = json['description'];
    status = json['status'];
    priority = json['priority'];
    attachment = json['attachment'];
    adminReply = json['adminReply'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['subject'] = subject;
    data['description'] = description;
    data['status'] = status;
    data['priority'] = priority;
    data['attachment'] = attachment;
    data['adminReply'] = adminReply;
    data['createdAt'] = createdAt;
    return data;
  }
}
