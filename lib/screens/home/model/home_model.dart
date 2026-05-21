import 'dart:math';

class HomeDataModel {
  bool? success;
  String? message;
  HomeDataModelData? data;

  HomeDataModel({this.success, this.message, this.data});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? HomeDataModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HomeDataModelData {
  List<Appointment>? upcomingAppointment;
  List<DoseReminder>? dailyDoseReinder;
  List<Categories>? categories;
  List<Symptoms>? symptoms;

  HomeDataModelData({
    this.upcomingAppointment,
    this.dailyDoseReinder,
    this.categories,
    this.symptoms,
  });

  HomeDataModelData.fromJson(Map<String, dynamic> json) {
    if (json['upcomingAppointment'] != null) {
      upcomingAppointment = <Appointment>[];
      json['upcomingAppointment'].forEach((v) {
        upcomingAppointment!.add(Appointment.fromJson(v));
      });
    }
    if (json['dailyDoseReinder'] != null) {
      dailyDoseReinder = <DoseReminder>[];
      json['dailyDoseReinder'].forEach((v) {
        dailyDoseReinder!.add(DoseReminder.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['symtomps'] != null) { // Corrected from 'symptoms' to 'symtomps'
      symptoms = <Symptoms>[];
      json['symtomps'].forEach((v) {
        symptoms!.add(Symptoms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (upcomingAppointment != null) {
      data['upcomingAppointment'] =
          upcomingAppointment!.map((v) => v.toJson()).toList();
    }
    if (dailyDoseReinder != null) {
      data['dailyDoseReinder'] =
          dailyDoseReinder!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (symptoms != null) {
      data['symtomps'] = symptoms!.map((v) => v.toJson()).toList(); // Corrected from 'symptoms' to 'symtomps'
    }
    return data;
  }
}

class Appointment {
  String? description;
  DateTime? timestamp;

  Appointment({this.description, this.timestamp});

  Appointment.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    timestamp = DateTime.tryParse(json['timestamp'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['timestamp'] = timestamp?.toIso8601String();
    return data;
  }

  static Appointment random() {
    return Appointment(
      description: 'Random Appointment ${Random().nextInt(100)}',
      timestamp: DateTime.now(),
    );
  }
}

class DoseReminder {
  String? status;

  DoseReminder({this.status});

  DoseReminder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }

  static DoseReminder random() {
    return DoseReminder(
      status: 'Pending',
    );
  }
}

class Categories {
  String? sId;
  String? name;
  String? image;

  Categories({this.sId, this.name, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['image'] = image;
    return data;
  }

  static Categories random() {
    return Categories(
      sId: 'cat_${Random().nextInt(100)}',
      name: 'Random Category ${Random().nextInt(100)}',
      image: 'https://example.com/image.png',
    );
  }
}

class Symptoms {
  String? sId;
  String? name;
  String? image;

  Symptoms({this.sId, this.name, this.image});

  Symptoms.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['image'] = image;
    return data;
  }

  static Symptoms random() {
    return Symptoms(
      sId: 'symptom_${Random().nextInt(100)}',
      name: 'Random Symptom ${Random().nextInt(100)}',
      image: 'https://example.com/symptom.png',
    );
  }
}