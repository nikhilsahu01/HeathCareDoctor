class SymptomsModel {
  bool? success;
  String? message;
  List<symptomsData>? data;

  SymptomsModel({this.success, this.message, this.data});

  SymptomsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <symptomsData>[];
      json['data'].forEach((v) {
        data!.add(new symptomsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class symptomsData {
  String? sId;
  String? name;

  symptomsData({this.sId, this.name});

  symptomsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}