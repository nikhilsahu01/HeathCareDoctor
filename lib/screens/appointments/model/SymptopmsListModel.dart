class SymptomsListModel {
  bool? success;
  String? message;
  List<Symtomps>? symtomps;

  SymptomsListModel({this.success, this.message, this.symtomps});

  SymptomsListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['symtomps'] != null) {
      symtomps = <Symtomps>[];
      json['symtomps'].forEach((v) {
        symtomps!.add(new Symtomps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.symtomps != null) {
      data['symtomps'] = this.symtomps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Symtomps {
  String? sId;
  String? name;

  Symtomps({this.sId, this.name});

  Symtomps.fromJson(Map<String, dynamic> json) {
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