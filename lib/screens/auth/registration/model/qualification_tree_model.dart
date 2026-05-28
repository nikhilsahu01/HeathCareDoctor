class QualificationTreeResponse {
  bool? success;
  String? message;
  List<QualificationNode>? data;

  QualificationTreeResponse({this.success, this.message, this.data});

  QualificationTreeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <QualificationNode>[];
      json['data'].forEach((v) {
        data!.add(QualificationNode.fromJson(v));
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

class QualificationNode {
  String? sId;
  String? name;
  String? parentId;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<QualificationNode>? children;

  QualificationNode(
      {this.sId,
      this.name,
      this.parentId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.children});

  QualificationNode.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    parentId = json['parentId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['children'] != null) {
      children = <QualificationNode>[];
      json['children'].forEach((v) {
        children!.add(QualificationNode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['parentId'] = parentId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
