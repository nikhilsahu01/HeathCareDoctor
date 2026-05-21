
import '../../../../core/api_service/app_url.dart';
import '../../../../core/api_service/network_api_service.dart';

class VerifyOtpRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> verifyOtpApi(var data) async {
    try {
      dynamic response =
      await _apiService.postApi(data, AppUrl.verifyOtp);
      return response;
    } catch (e) {
      throw e;
    }
  }
}