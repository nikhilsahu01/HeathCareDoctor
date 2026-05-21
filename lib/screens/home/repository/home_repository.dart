// import '../../../core/api_service/app_url.dart';
// import '../../../core/api_service/network_api_service.dart';
// import '../model/home_model.dart';
//
//
// class HomeRepository {
//   final _apiService = NetworkApiServices();
//
//   Future<HomeDataModel> getProfileApi() async {
//     try {
//       final response = await _apiService.getApiWithToken(AppUrl.homeData);
//       print('resssposssnscee:$response');
//       return HomeDataModel.fromJson(response);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }