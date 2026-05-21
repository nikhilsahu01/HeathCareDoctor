class CheckDoctorExistingModel {
  var success;
  var message;
  Data? data;

  CheckDoctorExistingModel({this.success, this.message, this.data});

  CheckDoctorExistingModel.fromJson(Map<String, dynamic> json) {
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
  var sId;
  var name;
  var mobile;

  Data({this.sId, this.name, this.mobile});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['Name'] = this.name;
    data['mobile'] = this.mobile;
    return data;
  }
}
