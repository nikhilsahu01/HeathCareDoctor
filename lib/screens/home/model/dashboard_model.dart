class DashboardModel {
  bool? success;
  String? message;
  DashboardData? data;

  DashboardModel({this.success, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    success = json['status'] ?? json['success'];
    message = json['message'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }
}

class DashboardData {
  int? todayAppointmentsCount;
  int? pendingRequests;
  int? totalEarningsToday;
  int? growth;
  int? monthlyAppointments;
  int? totalAppointments;
  double? profileCompletion;
  LiveOrUpcomingAppointment? liveOrUpcomingAppointment;

  DashboardData({
    this.todayAppointmentsCount,
    this.pendingRequests,
    this.totalEarningsToday,
    this.growth,
    this.monthlyAppointments,
    this.totalAppointments,
    this.profileCompletion,
    this.liveOrUpcomingAppointment,
  });

  DashboardData.fromJson(Map<String, dynamic> json) {
    todayAppointmentsCount = json['today_appointments_count'];
    pendingRequests = json['pending_requests'];
    totalEarningsToday = json['total_earnings_today'];
    growth = json['growth'];
    monthlyAppointments = json['monthly_appointments'];
    totalAppointments = json['total_appointments'];
    profileCompletion = (json['profile_completion'] as num?)?.toDouble();
    liveOrUpcomingAppointment = json['live_or_upcoming_appointment'] != null
        ? LiveOrUpcomingAppointment.fromJson(json['live_or_upcoming_appointment'])
        : null;
  }
}

class LiveOrUpcomingAppointment {
  String? id;
  String? patientName;
  String? time;
  String? status;
  String? type;

  LiveOrUpcomingAppointment({
    this.id,
    this.patientName,
    this.time,
    this.status,
    this.type,
  });

  LiveOrUpcomingAppointment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    patientName = json['patient']?['name'];
    time = json['timeSlot'];
    status = json['status'];
    type = json['type'];
  }
}
