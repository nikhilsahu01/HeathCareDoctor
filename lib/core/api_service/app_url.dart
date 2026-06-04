class AppUrl {
  //local
  // static const String baseUrl = 'http://192.168.1.11:5002';

  //live
 // static const String baseUrl = 'https://94np5jjf-5003.inc1.devtunnels.ms';
  // static const String baseUrl = 'http://192.168.1.22:9003';
  static const String baseUrl = 'https://admin.olcure.com';
  static const String getOtp = '$baseUrl/api/vendor/auth/sendOtp';
  static const String verifyOtp = '$baseUrl/api/vendor/auth/verifyOtp';
  static const String signUp = '$baseUrl/api/vendor/auth/register';
  static const String appointmentsList = '$baseUrl/api/vendor/appointment/list';
  static const String symptomsListNew= '$baseUrl/api/vendor/common/symptomsData';

  static const String commonDoctorList = '$baseUrl/api/vendor/common/doctor/list';
  static const String invite = '$baseUrl/api/vendor/appointment/update';
  static const String appointmentDetails = '$baseUrl/api/vendor/appointment/details';
  static const String videoCall = '$baseUrl/api/join-call';
  static const String doctorsCategory = '$baseUrl/api/vendor/common/category/list';
  static const String symptomsList = '$baseUrl/api/vendor/common/symptoms/list';
  static const String profile = '$baseUrl/api/vendor/auth/profile';

  // New endpoints
  static const String uploadPrescription = '$baseUrl/api/vendor/appointment/upload-prescription';
  static const String degreeList = '$baseUrl/api/vendor/common/degree/list';
  static const String dashboard = '$baseUrl/api/vendor/auth/dashboard';
  static const String wallet = '$baseUrl/api/vendor/auth/wallet';
  static const String notifications = '$baseUrl/api/vendor/notifications';
  static const String qualificationTree = '$baseUrl/api/vendor/common/qualification/tree';
  static const String cms = '$baseUrl/api/vendor/common/cms';
  static const String ticketCreate = '$baseUrl/api/vendor/ticket/create';
  static const String ticketList = '$baseUrl/api/vendor/ticket/list';
}
