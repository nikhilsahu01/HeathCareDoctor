
import '../../../../core/api_service/app_url.dart';
import '../../../../core/api_service/network_api_service.dart';

class LoginRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> getOtpApi(var data) async {
    try {
      dynamic response =
      await _apiService.postApi(data, AppUrl.getOtp);
      return response;
    } catch (e) {
      throw e;
    }
  }
}