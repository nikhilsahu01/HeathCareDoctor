class NotificationModel {
  bool? success;
  String? message;
  NotificationDataWrapper? data;

  NotificationModel({this.success, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? NotificationDataWrapper.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationDataWrapper {
  List<NotificationData>? list;
  int? unreadCount;

  NotificationDataWrapper({this.list, this.unreadCount});

  NotificationDataWrapper.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <NotificationData>[];
      json['list'].forEach((v) {
        list!.add(NotificationData.fromJson(v));
      });
    }
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['unreadCount'] = unreadCount;
    return data;
  }
}

class NotificationData {
  String? sId;
  String? userId;
  String? userType;
  String? title;
  String? message;
  String? type;
  String? referenceId;
  bool? isRead;
  String? createdAt;

  NotificationData({
    this.sId,
    this.userId,
    this.userType,
    this.title,
    this.message,
    this.type,
    this.referenceId,
    this.isRead,
    this.createdAt,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    userType = json['userType'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    referenceId = json['referenceId'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['userType'] = userType;
    data['title'] = title;
    data['message'] = message;
    data['type'] = type;
    data['referenceId'] = referenceId;
    data['isRead'] = isRead;
    data['createdAt'] = createdAt;
    return data;
  }
}
