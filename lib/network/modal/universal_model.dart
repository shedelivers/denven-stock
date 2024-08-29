import 'package:denvin_stock/exports.dart';

class UniversalModel extends Serializable {

  String? token;
  String? refreshToken;
  int? totalProducts;
  int? totalQuantity;
  dynamic? totalPrice;
  // List<ProductModal>? response;

  UniversalModel({
    this.token,
    this.refreshToken,
    // this.response,
    this.totalProducts,
    this.totalQuantity,
    this.totalPrice,
  });

  UniversalModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    totalPrice = json['totalPrice'];
    totalQuantity = json['totalQuantity'];
    totalProducts = json['totalProducts'];
    // response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['totalProducts'] = totalProducts;
    data['totalQuantity'] = totalQuantity;
    // data['response'] = response;
    data['totalPrice'] = totalPrice;
    return data;
  }
}


class PolicyModal {
  String? sId;
  String? content;
  int? contentType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PolicyModal({
        this.sId,
        this.content,
        this.contentType,
        this.createdAt,
        this.updatedAt,
        this.iV
  });

  PolicyModal.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    contentType = json['content_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['content_type'] = contentType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
