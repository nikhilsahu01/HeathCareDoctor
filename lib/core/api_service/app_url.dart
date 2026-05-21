class AppUrl {
  //local
  // static const String baseUrl = 'http://192.168.1.11:5002';

  //live
 // static const String baseUrl = 'https://94np5jjf-5003.inc1.devtunnels.ms';
 //  static const String baseUrl = 'http://192.168.1.9:5003';
  static const String baseUrl = 'http://159.89.146.245:4587';
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
}
