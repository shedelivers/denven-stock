
import 'package:dio/dio.dart';
import 'package:denvin_stock/exports.dart';

class AuthApiProvider {

  late Dio _dio;

  AuthApiProvider() {
    _dio = Injector().getDio();
  }

  Future<DataResponse<UniversalModel?>> signIn(
      Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.signIn, data: data);
      var dataResponse = DataResponse<UniversalModel>.fromJson(
          response.data, (data) =>
          UniversalModel.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(
            error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(
            error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) =>
              UniversalModel.fromJson(json as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<UserModal?>> getMyProfile() async {
    try {
      Response response = await _dio.get(ApiConstants.profile, options: Injector.getHeaderToken());
      var dataResponse = DataResponse<UserModal>.fromJson(response.data, (data) => UserModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(
            error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(
            error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => null);
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<ComanResponseModal> updateProfile({required String userId, required Map<String, dynamic> data}) async {
    try {
      Response response = await _dio.patch('${ApiConstants.updateProfile}/$userId',
          data: data,
          options: Injector.getHeaderToken());
      var dataResponse = ComanResponseModal.fromJson(response.data);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return ComanResponseModal(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return ComanResponseModal(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return ComanResponseModal.fromJson(response);
        } else {
          return ComanResponseModal(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return ComanResponseModal(error: e.toString(), successful: false);
    }

  }



  Future<DataResponse> signUp(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.signUpUri, data: data);
      var dataResponse = DataResponse(error: response.data["error"],
          response: response.data['response'],
          successful: response.data['successful']);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(
            error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(
            error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => null);
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }




}

