import '../shared/page_response.dart';
import 'arrived_item_modal.dart';

class ExtraItemModel extends Serializable {
  int? page;
  int? pageSize;
  int? total;
  List<ExtraItemDataModel>? data;

  ExtraItemModel({this.page, this.pageSize, this.total, this.data});

  ExtraItemModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['pageSize'];
    total = json['total'];
    if (json['data'] != null) {
      data = <ExtraItemDataModel>[];
      json['data'].forEach((v) {
        data!.add(new ExtraItemDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExtraItemDataModel {
  String? internalProductId;
  int? externalProductId;
  String? name;
  String? link;
  String? manufacturer;
  String? type;
  String? supplierCode;
  String? method;

  ExtraItemDataModel(
      {this.internalProductId,
        this.externalProductId,
        this.name,
        this.link,
        this.manufacturer,
        this.type,
        this.supplierCode,
        this.method});

  ExtraItemDataModel.fromJson(Map<String, dynamic> json) {
    internalProductId = json['internalProductId'];
    externalProductId = json['externalProductId'];
    name = json['name'];
    link = json['link'];
    manufacturer = json['manufacturer'];
    type = json['type'];
    supplierCode = json['supplierCode'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['internalProductId'] = this.internalProductId;
    data['externalProductId'] = this.externalProductId;
    data['name'] = this.name;
    data['link'] = this.link;
    data['manufacturer'] = this.manufacturer;
    data['type'] = this.type;
    data['supplierCode'] = this.supplierCode;
    data['method'] = this.method;
    return data;
  }
}

