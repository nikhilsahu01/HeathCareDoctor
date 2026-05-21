class DoctorsCategories {
  bool? success;
  String? message;
  List<DoctorCategoryData>? data;

  DoctorsCategories({this.success, this.message, this.data});

  DoctorsCategories.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DoctorCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new DoctorCategoryData.fromJson(v));
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

class DoctorCategoryData {
  String? sId;
  String? name;

  DoctorCategoryData({this.sId, this.name});

  DoctorCategoryData.fromJson(Map<String, dynamic> json) {
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