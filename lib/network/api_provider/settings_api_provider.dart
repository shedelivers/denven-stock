import 'package:dio/dio.dart';
import 'package:denvin_stock/exports.dart';

class SettingApiProvider {

  late Dio _dio;
  late StorageHelper helper;
  String? clinicId;
  int? clinicCode;

  SettingApiProvider() {
    _dio = Injector().getDio();
    setClientID();
  }

  setClientID(){
    helper = StorageHelper();
    if(helper.getClinicId() != null){
      clinicId = helper.getClinicId();
      clinicCode = helper.getClinicCode();
    } else {
      Get.toNamed(AppRoutes.authClinicSelection);
    }
  }

  Future<DataResponse<UniversalModel?>> addConsumer(Map<String, dynamic> data,{bool isEdit = false, String? consumerId}) async {
    try {
      Response response;
      if(isEdit){
        response = await _dio.patch("${ApiConstants.customers}/$clinicId/$consumerId", data: data, options: Injector.getHeaderToken());
      } else {
        response = await _dio.post("${ApiConstants.customers}/$clinicId", data: data, options: Injector.getHeaderToken());
      }
      var dataResponse = DataResponse<UniversalModel>.fromJson(response.data, (data) => UniversalModel.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => UniversalModel.fromJson(json as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<ComanResponseModal> deleteConsumer(String consumerId) async {
    try {
      Response response = await _dio.delete("${ApiConstants.customers}/$clinicId/$consumerId", options: Injector.getHeaderToken());
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

  Future<ComanResponseModal> addClinic(Map<String, dynamic> data,{bool isEdit = false, String? consumerId,ClinicDetails? clinicDetails}) async {
    try {
      Response response;
      if(isEdit){
        response = await _dio.patch("${ApiConstants.clinic}/${clinicDetails?.key}/${clinicDetails?.id}", data: data, options: Injector.getHeaderToken());
      } else {
        response = await _dio.post("${ApiConstants.clinic}/$clinicCode/AddClinic", data: data, options: Injector.getHeaderToken());
      }
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

  Future<DataResponse<ClinicDetails?>> getClinicById({ClinicDetails? clinicDetails}) async {
    try {
      Response response = await _dio.get("${ApiConstants.clinic}/${clinicDetails?.key}/${clinicDetails?.id}", options: Injector.getHeaderToken());
      var dataResponse = DataResponse<ClinicDetails>.fromJson(response.data, (data) => ClinicDetails.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => ClinicDetails.fromJson(json as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }



  Future<DataResponse<PaginationResponseModal<ClinicDetails>>> getClinics() async {
    try {
      Response response = await _dio.get("${ApiConstants.clinic}/${StorageHelper().getUserId()}/GetByUserId", options: Injector.getHeaderToken(),queryParameters: {"pageSize" : "100"});
      var dataResponse = DataResponse<PaginationResponseModal<ClinicDetails>>.fromJson(response.data, (data) => PaginationResponseModal<ClinicDetails>.fromJson(data as Map<String, dynamic>,(data) => ClinicDetails.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<ClinicDetails>.fromJson(json as Map<String, dynamic>,(data) => ClinicDetails.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }




  Future<ComanResponseModal> changePassword(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.patch("${ApiConstants.users}/${StorageHelper().getUserId()}/ChangePassword", data: data, options: Injector.getHeaderToken());
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
}