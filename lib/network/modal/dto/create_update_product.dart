import 'dart:io';
import 'package:dio/src/form_data.dart' as dio;
import 'package:dio/src/multipart_file.dart' as multipart;
import 'package:http_parser/src/media_type.dart' as mediaType;
import 'package:denvin_stock/exports.dart';

class CreateUpdateProductDto {
  int? id;
  String? name;
  String? manufacturer;
  String? createdAt;
  String? dontHaveSupplierCode;
  String? updatedAt;
  int? storageId;
  String? supplierName;
  String? supplierCode;
  int? quantity;
  String? minLevel;
  String? price;
  String? hidden;
  int? internalSupplierId;
  List<ExpiryDataDto>? expiryData;
  List<BarCodeDataDto>? barCode;
  String? orderedAt;
  String? note;
  bool? isImageRemoved;
  String? TagCollection;
  File? productImage;
  CreateUpdateProductDto(
      {this.id,
      this.name,
      this.manufacturer,
      this.TagCollection,
      this.isImageRemoved,
      this.note,
      this.createdAt,
      this.updatedAt,
      this.storageId,
      this.supplierName,
      this.supplierCode,
      this.quantity,
      this.minLevel,
      this.price,
      this.hidden,
      this.expiryData,
      this.barCode,
      this.productImage,
      this.orderedAt,
        this.dontHaveSupplierCode,this.internalSupplierId

      });
  Future<dio.FormData> toJson() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((id??-1)!=-1) {
      data['id'] = id;
    }
    if ((name??"").isNotEmpty) {
      data['name'] = name;
    }
    if ((manufacturer??"").isNotEmpty) {
      data['manufacturer'] = manufacturer;
    }
    if ((createdAt??"").isNotEmpty) {
      data['createdAt'] = createdAt;
    }
    if ((internalSupplierId??-1)!=-1) {
      data['InternalSupplierId'] = internalSupplierId;
    }
    if ((updatedAt??"").isNotEmpty) {
      data['updatedAt'] = updatedAt;
    }
    if ((storageId??-1)!=-1)  {
      data['storageId'] = storageId;
    }
    if ((dontHaveSupplierCode??"").isNotEmpty) {
      data['DontHaveSupplierCode'] = dontHaveSupplierCode;
    }
    if ((supplierName??"").isNotEmpty) {
      data['supplierName'] = supplierName;
    }
    if ((supplierCode??"").isNotEmpty) {
      data['supplierCode'] = supplierCode;
    }
    if ((quantity??-1)!=-1) {
      data['quantity'] = quantity;
    }
    if ((minLevel??"").isNotEmpty) {
      data['minLevel'] = minLevel;
    }
    if ((price??"").isNotEmpty) {
      data['price'] = price;
    }
    if ((hidden??"").isNotEmpty) {
      data['hidden'] = hidden;
    }
    if ((orderedAt??"").isNotEmpty) {
      data['orderedAt'] = orderedAt;
    }
    if ((note??"").isNotEmpty) {
      data['note'] = note;
    }

    if ((TagCollection??"").isNotEmpty) {
      data['TagCollection'] = TagCollection;
    }
    data['isImageRemoved'] = isImageRemoved;
    if (productImage != null) {
      data['ProductImageMobile'] = (productImage?.path ?? "").isNotEmpty
          ? await multipart.MultipartFile.fromFile(productImage?.path ?? "",
              filename: productImage?.path ?? "",
              contentType: mediaType.MediaType(
                  Utils.getFileType((productImage?.path ?? ""))!,
                  (productImage?.path ?? "")))
          : null;
    }
    if ((expiryData ?? []).isNotEmpty) {
      for (int i = 0; i < (expiryData ?? []).length; i++) {
        data['Expiries[$i].At'] = expiryData?[i].at;
        data['Expiries[$i].Qty'] = expiryData?[i].quantity;
        data['Expiries[$i].Price'] = expiryData?[i].price;
      }
    }
    if ((barCode ?? []).isNotEmpty) {
      for (int i = 0; i < (barCode ?? []).length; i++) {
        data['barcode[$i].removeAll'] = barCode?[i].removeAll.toString();
        data['barcode[$i].barcode'] = barCode?[i].barcode;
        data['barcode[$i].symbology'] = barCode?[i].symbol;
      }
    }


    return dio.FormData.fromMap(data);
  }
}

class ExpiryDataDto {
  String? quantity;
  String? at;
  dynamic price;
  ExpiryDataDto({this.quantity,this.at, this.price});
}

class BarCodeDataDto {
  String? barcode;
  String? symbol;
  String? uniqueID;
  String? removeAll;BarCodeDataDto({this.symbol,this.removeAll,this.barcode,this.uniqueID});
}



// dio.FormData formData = dio.FormData.fromMap({
//   ApiConstants.supplierName: products.value?.supplier?.name,
//   ApiConstants.price: priceController.text,
//   ApiConstants.hidden: false,
//
//   ///Static Now but will be changed in the future
//   ApiConstants.DontHaveSupplierCode: false,
//   "ProductImage": imagePath.value.isNotEmpty
//       ? [
//           await multipart.MultipartFile.fromFile(imagePath.value,
//               filename: fileName.value,
//               contentType: mediaType.MediaType(
//                   Utils.getFileType(imagePath.value)!, fileType.value)),
//         ]
//       : null
// });