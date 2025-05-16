import 'package:denvin_stock/network/modal/arrived_item_modal.dart';
import 'package:denvin_stock/network/modal/baske_modal.dart';
import 'package:denvin_stock/network/modal/dto/return_product_dto.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:denvin_stock/exports.dart';

import '../modal/add_to_draft_model.dart';
import '../modal/extra_item_model.dart';

class ProductApiProvider {

  late Dio _dio;
  late StorageHelper helper;
  String? clinicId;
  int? userId;
  int? clinicCode;
  ProductApiProvider() {
    _dio = Injector().getDio();
    if (kDebugMode) {
      _dio.interceptors.add(CustomLogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
    setClientID();
  }

  setClientID(){
    helper = StorageHelper();
    userId = helper.getUserId();
    if(helper.getClinicId() != null){
      clinicId = helper.getClinicId();
      clinicCode = helper.getClinicCode();

    } else {
      Get.toNamed(AppRoutes.authClinicSelection);
    }
  }

  Future<DataResponse<PaginationResponseModal<ArrivedItemModal>>> getArrivedItems({int? pageNo = 0,String? searchKeyWord}) async {
    try {
      Response response = await _dio.get("${ApiConstants.inventoryStock}/$clinicId/ArrivedOrderList/$clinicCode", options: Injector.getHeaderToken(), queryParameters: {"page": pageNo,"search" : searchKeyWord, "OrderCol":10,"OrderDir":"desc"});
      var dataResponse = DataResponse<PaginationResponseModal<ArrivedItemModal>>.fromJson(response.data, (data) => PaginationResponseModal<ArrivedItemModal>.fromJson(data as Map<String, dynamic>,(data) => ArrivedItemModal.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<ArrivedItemModal>.fromJson(json as Map<String, dynamic>,(data) => ArrivedItemModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<PaginationResponseModal<ProductModal>>> getInventoryStock({int? pageNo = 0,Map<String,dynamic>? filters}) async {
    try {
      Response response = await _dio.get("${ApiConstants.inventoryStock}/$clinicId/Stock/$clinicCode", options: Injector.getHeaderToken(),
          queryParameters: filters);
      var dataResponse = DataResponse<PaginationResponseModal<ProductModal>>.fromJson(response.data, (data) => PaginationResponseModal<ProductModal>.fromJson(data as Map<String, dynamic>,(data) => ProductModal.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<ProductModal>.fromJson(json as Map<String, dynamic>,(data) => ProductModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<PaginationResponseModal<ConsumerModal>>> getConsumer({String? search}) async {
    try {
      Response response = await _dio.get("${ApiConstants.customers}/$clinicId", options: Injector.getHeaderToken(),
      queryParameters: {
        if((search??"").isNotEmpty)
          "Search":search
      }
      );
      var dataResponse = DataResponse<PaginationResponseModal<ConsumerModal>>.fromJson(response.data, (data) => PaginationResponseModal<ConsumerModal>.fromJson(data as Map<String, dynamic>,(data) => ConsumerModal.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<ConsumerModal>.fromJson(json as Map<String, dynamic>,(data) => ConsumerModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse<PaginationResponseModal<Supplier>>> getSupplier({String? search}) async {
    try {
      Response response = await _dio.get("${ApiConstants.supplier}/$clinicId/Implant/$clinicCode", options: Injector.getHeaderToken(),

          queryParameters: {
        "pageSize" : 100,
        "OrderCol" : 0,
        "OrderDir" : "Asc",
        if((search??"").isNotEmpty)
          "Search":search
      }

      );
      var dataResponse = DataResponse<PaginationResponseModal<Supplier>>.fromJson(response.data,
              (data) => PaginationResponseModal<Supplier>.fromJson(data as Map<String, dynamic>,(data) => Supplier.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<Supplier>.fromJson(json as Map<String, dynamic>,(data) => Supplier.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<PaginationResponseModal<Supplier>>> getStorage({String? search, bool? boolValue}) async {
    try {
      // move to storage
     // Response response = await _dio.get("${ApiConstants.storage}/$clinicId/false/true", options: Injector.getHeaderToken(), queryParameters: {


      Response response = await _dio.get("${ApiConstants.storage}/$clinicId/false/${boolValue??false}", options: Injector.getHeaderToken(), queryParameters: {
          "pageSize" : 100,
          "page": 1,
            if((search??"").isNotEmpty)
              "Search":search
          });
      var dataResponse = DataResponse<PaginationResponseModal<Supplier>>.fromJson(response.data,
              (data) => PaginationResponseModal<Supplier>.fromJson(data as Map<String, dynamic>,(data) => Supplier.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<Supplier>.fromJson(json as Map<String, dynamic>,(data) => Supplier.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<PaginationResponseModal<TagModal>>> getTags({String? search, int? pageNo,int pageSize = 20}) async {
    try {
      Response response = await _dio.get("${ApiConstants.sampleData}/$clinicId/Tag_Name", options: Injector.getHeaderToken(), queryParameters: {"pageSize" : pageSize, "page": pageNo, if((search??"").isNotEmpty)"Search":search});
      var dataResponse = DataResponse<PaginationResponseModal<TagModal>>.fromJson(response.data, (data) => PaginationResponseModal<TagModal>.fromJson(data as Map<String, dynamic>,(data) => TagModal.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<TagModal>.fromJson(json as Map<String, dynamic>,(data) => TagModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<TagSuggestion> getSuggestionTags({String? searchKeyword}) async {
    try {
      Response response = await _dio.get("${ApiConstants.productScan}/$clinicId/CombinedTagList", options: Injector.getHeaderToken(),queryParameters: {"search" : searchKeyword});
      var dataResponse = TagSuggestion.fromJson(response.data as Map<String, dynamic>);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return TagSuggestion(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return TagSuggestion(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return TagSuggestion.fromJson(response);
        } else {
          return TagSuggestion(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return TagSuggestion(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<PaginationResponseModal<Supplier>>> postStorage(Map<String, dynamic> payload) async {
    try {

      Response response = await _dio.post("${ApiConstants.storage}/$clinicId/false/false",data: payload, options: Injector.getHeaderToken(),);
      var dataResponse = DataResponse<PaginationResponseModal<Supplier>>.fromJson(response.data, (data) => PaginationResponseModal<Supplier>.fromJson(data as Map<String, dynamic>,(data) => Supplier.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<Supplier>.fromJson(json as Map<String, dynamic>,(data) => Supplier.fromJson(data)));
        } else {
          print('error is here 2');
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      print('error is here 1');
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<PaginationResponseModal<BasketModal>>>  getBasket({String? search}) async {
    try {
      Response response = await _dio.get("${ApiConstants.basketUri}/$clinicId/1", options: Injector.getHeaderToken(),
          queryParameters: {
            "pageSize" : 100,
            "page": 1,
            if((search??"").isNotEmpty)
              "Search":search
          }
      );
      var dataResponse = DataResponse<PaginationResponseModal<BasketModal>>.fromJson(response.data, (data) => PaginationResponseModal<BasketModal>.fromJson(data as Map<String, dynamic>,(data) => BasketModal.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<BasketModal>.fromJson(json as Map<String, dynamic>,(data) => BasketModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<Supplier>> addSupplier({Map<String, dynamic>? payload}) async {
    try {
      Response response = await _dio.post("${ApiConstants.supplier}/$clinicId", options: Injector.getHeaderToken(), data: payload);
      var dataResponse = DataResponse<Supplier>.fromJson(response.data, (data) => Supplier.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => Supplier.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<ProductModal>> addProduct({dio.FormData? payload}) async {
    try {
      Response response = await _dio.post("${ApiConstants.implantStock}/$clinicId/CustomMobile", options: Injector.getHeaderToken(), data: payload);
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<ProductModal>> editProduct({Map<String, dynamic>? payload, String? productId}) async {
    try {
      Response response = await _dio.patch("${ApiConstants.inventoryStock}/$clinicId/$productId/Mobile", options: Injector.getHeaderToken(), data: payload);
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<MoveStorageResponse> moveStorage({Map<String, dynamic>? payload, }) async {
    try {
      Response response = await _dio.post("${ApiConstants.inventoryStock}/$clinicId/MoveStorage", options: Injector.getHeaderToken(), data: payload);
      var dataResponse = MoveStorageResponse(
        successful: response.data["successful"],
        response: response.data["response"],
        error: response.data["error"]
      );
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return MoveStorageResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return MoveStorageResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return MoveStorageResponse(error: "");
        } else {
          return MoveStorageResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return MoveStorageResponse(error: e.toString(), successful: false);
    }
  }



  Future<ConsumptionResponse>  postConsumption({Map<String, dynamic>? payload, }) async {
    try {
      Response response = await _dio.post("${ApiConstants.inventoryStock}/$clinicId/StockConsumption", options: Injector.getHeaderToken(), data: payload);
      var dataResponse = ConsumptionResponse(
        successful: response.data["successful"],
        response: response.data["response"],
        error: response.data["error"]
      );
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return ConsumptionResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return ConsumptionResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return ConsumptionResponse(error: "");
        } else {
          return ConsumptionResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return ConsumptionResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<ProductModal>> editProductV2({dio.FormData? payload, String? productId}) async {
    try {
      Response response = await _dio.patch("${ApiConstants.inventoryStock}/$clinicId/$productId/Mobile", options: Injector.getHeaderToken(), data: payload);
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse> deleteProduct({String? productId}) async {
    try {
      Response response = await _dio.delete("${ApiConstants.implantStock}/$clinicId/$productId", options: Injector.getHeaderToken());
      var dataResponse = DataResponse.fromJson(response.data, (data) => null);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse> deleteBasketItem({String? id}) async {
    try {
      Response response = await _dio.delete("${ApiConstants.basketUri}/$clinicId/1/$id", options: Injector.getHeaderToken());
      var dataResponse = DataResponse.fromJson(response.data, (data) => null);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse> hideUnHideProduct({String? id, Map<String, dynamic>? payload}) async {
    try {
      Response response = await _dio.patch("${ApiConstants.productScan}/$clinicId/HideUnhide/$id", data: payload,options: Injector.getHeaderToken());
      var dataResponse = DataResponse.fromJson(response.data, (data) => null);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response,(json)=> null,);
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse<ProductModal>> updateQty({String? productId,Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.patch("${ApiConstants.implantStock}/$clinicId/$productId", options: Injector.getHeaderToken(), data: data);
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }

  }

  Future<CustomScanResponseModal<ProductModal>> searchProductFromScan({Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post("${ApiConstants.implantStock}/$clinicId/SearchBarcode",
          options: Injector.getHeaderToken(), data: data);
      CustomScanResponseModal<ProductModal> dataResponse = CustomScanResponseModal.fromJson(response.data,
              (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return CustomScanResponseModal(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return CustomScanResponseModal(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return CustomScanResponseModal.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return CustomScanResponseModal(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      print(e.toString());

      return CustomScanResponseModal(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse<PaginationResponseModal<ProductModal>>> searchProductFromScanStock({String? barcode, String? type }) async {
    try {
      Response response = await _dio.get("${ApiConstants.productScan}/$clinicId/barcode/$barcode/$type/list", options: Injector.getHeaderToken());
      return DataResponse.fromJson(response.data, (json) => PaginationResponseModal<ProductModal>.fromJson(json as Map<String, dynamic>,(data) => ProductModal.fromJson(data)));
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<ProductModal>.fromJson(json as Map<String, dynamic>,(data) => ProductModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      print(e.toString());
      return DataResponse(error: e.toString(), successful: false);
    }

  }
  Future<DataResponse<ProductModal>> postProsthetic({Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post("${ApiConstants.implantStock}/$clinicId/ImplantProstheticsMobile", options: Injector.getHeaderToken(), data: data);
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }

  }

  Future<DataResponse<UniversalModel>> getSummary() async {
    try {
      Response response = await _dio.get("${ApiConstants.inventoryStock}/GetMobileDetailCounts/$clinicCode", options: Injector.getHeaderToken());
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
          return DataResponse.fromJson(response, (data) => UniversalModel.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<BasketCount> getBasketCount() async {
    try {
      Response responseData = await _dio.get("${ApiConstants.basketUri}/$clinicId/1/count", options: Injector.getHeaderToken());
      var dataResponse = BasketCount.fromJson(responseData.data);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return BasketCount(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return BasketCount(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return BasketCount(error: "Receive Timeout Exception", successful: false);;
        } else {
          return BasketCount(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return BasketCount(error: e.toString(), successful: false);
    }

  }


  Future<BasketCount> getArrivedCount() async {
    try {
      Response responseData = await _dio.get("${ApiConstants.inventoryStock}/$clinicId/ArrivedOrderCount/$clinicCode", options: Injector.getHeaderToken());
      var dataResponse = BasketCount.fromJson(responseData.data);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return BasketCount(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return BasketCount(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return BasketCount(error: "Receive Timeout Exception", successful: false);;
        } else {
          return BasketCount(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return BasketCount(error: e.toString(), successful: false);
    }

  }

  Future<DataResponse<ProductModal>> postPlacement({dio.FormData? data}) async {
    try {
      Response response = await _dio.post("${ApiConstants.implantStock}/$clinicId/ImplantPlacementMobile", options: Injector.getHeaderToken(), data: data);
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }

  }

  Future<DataResponse<ProductModal>> getProductById({int? productId}) async {
    try {
      Response response = await _dio.get("${ApiConstants.inventoryStock}/$clinicId/$productId", options: Injector.getHeaderToken());
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse<ArrivedItemModal>> getOrderById({int? productId}) async {
    try {
      Response response = await _dio.get("${ApiConstants.inventoryStock}/$clinicId/ArrivedOrderById/$productId", options: Injector.getHeaderToken(),queryParameters: {
        "items" : 1,
      });
      var dataResponse = DataResponse<ArrivedItemModal>.fromJson(response.data, (data) => ArrivedItemModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ArrivedItemModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse<ExtraItemModel>> getExtraItems({required String searchText, required String externalSupplierId,required String internalSupplierId,}) async {
    Map<String, dynamic>? data = {
      "ExternalSupplierId" : externalSupplierId,
      "InternalSupplierId" : internalSupplierId,
      "Search" : searchText,
    };

    try {
      Response response = await _dio.post("${ApiConstants.extraItem}/$clinicId/search/", options: Injector.getHeaderToken(),data: data);
      var dataResponse = DataResponse<ExtraItemModel>.fromJson(response.data, (data) => ExtraItemModel.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ExtraItemModel.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }


  Future<AddToDraftResponseModal> addToDraft({required String productId,required Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post("${ApiConstants.inventoryStock}/$clinicId/${ApiConstants.addToDraft}/$productId", options: Injector.getHeaderToken(),data: data);
      var dataResponse = AddToDraftResponseModal.fromJson(response.data);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return AddToDraftResponseModal(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return AddToDraftResponseModal(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return AddToDraftResponseModal.fromJson(response);
        } else {
          return AddToDraftResponseModal(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return AddToDraftResponseModal(error: e.toString(), successful: false);
    }
  }


  Future<DataResponse<ProductModal>> getInventoryProductById({int? productId}) async {
    try {
      Response response = await _dio.get("${ApiConstants.inventoryStock}/$clinicId/Stock/$productId", options: Injector.getHeaderToken());
      var dataResponse = DataResponse<ProductModal>.fromJson(response.data, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (data) => ProductModal.fromJson(data as Map<String, dynamic>));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }

  }




  Future<ComanResponseModal> addBarCode({required AddBarcodeDto addBarcodeDto}) async {
    try {
      Response response = await _dio.patch("${ApiConstants.inventoryStock}/$clinicId/UpdateBarcode", data: addBarcodeDto.toJson(), options: Injector.getHeaderToken());
      print("BARCODEDATAFINAL -----> ${addBarcodeDto.toJson()}");
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

  Future<DataResponse> addToBasket({Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post("${ApiConstants.basketUri}/$clinicId/1", data: data, options: Injector.getHeaderToken());
      var dataResponse = DataResponse.fromJson(response.data,(json)=> null,);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response,(json)=> null,);
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<DataResponse> openThePackage({Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post("${ApiConstants.inventoryStock}/$clinicId/OpenProduct", data: data, options: Injector.getHeaderToken());
      var dataResponse = DataResponse.fromJson(response.data,(json)=> null,);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response,(json)=> null,);
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<ComanResponseModal> addReturnProduct({required ReturnProductDto returnProductDto}) async {
    try {
      Response response = await _dio.post("${ApiConstants.implantStock}/$clinicId/ImplantReturnItemMobile",

          data: returnProductDto.toJson(),
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





  Future<DataResponse<PaginationResponseModal<CrawledProductDataModal>>> getCrawledProduct({int? pageNo = 0,required GetCrawledProductDto getCrawledProductDto}) async {
    try {
      Response response = await _dio.post("${ApiConstants.implantStock}/$clinicId/search/", options: Injector.getHeaderToken(),
          data: getCrawledProductDto.toJson(),
          queryParameters: {"page": pageNo,"OrderCol": 1, "OrderDir": "Asc"});
      var dataResponse = DataResponse<PaginationResponseModal<CrawledProductDataModal>>.fromJson(response.data, (data) =>
      PaginationResponseModal<CrawledProductDataModal>.fromJson(data as Map<String, dynamic>,(data) => CrawledProductDataModal.fromJson(data)));
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
      } else {
        final response = error.response?.data;
        if (response != null && response is Map<String, dynamic>) {
          return DataResponse.fromJson(response, (json) => PaginationResponseModal<CrawledProductDataModal>.fromJson(json as Map<String, dynamic>,(data) => CrawledProductDataModal.fromJson(data)));
        } else {
          return DataResponse(error: error.toString(), successful: false);
        }
      }
    } catch (e) {
      return DataResponse(error: e.toString(), successful: false);
    }
  }

  Future<ComanResponseModal> deleteAllBarCode({required String barcodeUniqueId}) async {
    try {

      Response response = await _dio.delete("${ApiConstants.localMapping}/$clinicId/$barcodeUniqueId",
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


  Future<ComanResponseModal> deleteOneBarCOde({required DeleteBarCodeDto deleteBarCodeDto}) async {
    try {
        Response response = await _dio.patch("${ApiConstants.implantStock}/$clinicId/${deleteBarCodeDto.id}/DeleteBarcode",

          data: deleteBarCodeDto.toJson(),
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

  Future<DataResponse> verifySubscription(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post("${ApiConstants.inAppPurchase}/$clinicId/InAppPurchaseApple/$userId", data: data, options: Injector.getHeaderToken());
      var dataResponse = DataResponse(error: response.data["error"], response: response.data['response'], successful: response.data['successful']);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
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


  Future<DataResponse> submitArrivedItems({var data, String? orderId}) async {
    try {
      Response response = await _dio.post("${ApiConstants.inventoryStock}/$clinicId/UpdateArrivedOrder/$orderId", data: data, options: Injector.getHeaderToken());
      var dataResponse = DataResponse(error: response.data["error"], response: response.data['response'], successful: response.data['successful']);
      return dataResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return DataResponse(error: "Connection Timeout Exception", successful: false);
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return DataResponse(error: "Receive Timeout Exception", successful: false);
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

