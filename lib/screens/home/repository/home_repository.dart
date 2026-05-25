import '../../../core/api_service/app_url.dart';
import '../../../core/api_service/network_api_service.dart';
import '../model/dashboard_model.dart';

class HomeRepository {
  final _apiService = NetworkApiServices();

  Future<DashboardModel> getDashboardApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.dashboard);
      return DashboardModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}