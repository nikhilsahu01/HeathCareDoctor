import '../../../core/api_service/app_url.dart';
import '../../../core/api_service/network_api_service.dart';
import '../model/wallet_model.dart';

class WalletRepository {
  final _apiService = NetworkApiServices();

  Future<WalletModel> getWalletApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.wallet);
      return WalletModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
