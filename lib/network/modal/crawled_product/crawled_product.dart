import 'package:denvin_stock/exports.dart';

class CrawledProductDataModal  extends Serializable{
  String? internalProductId;
  int? externalProductId;
  String? name;
  String? link;
  String? manufacturer;
  String? type;
  String? supplierCode;
  String? method;

  CrawledProductDataModal(
      {this.internalProductId,
      this.externalProductId,
      this.name,
      this.link,
      this.manufacturer,
      this.type,
      this.supplierCode,
      this.method});

  CrawledProductDataModal.fromJson(Map<String, dynamic> json) {
    internalProductId = json['internalProductId'];
    externalProductId = json['externalProductId'];
    name = json['name'];
    link = json['link'];
    manufacturer = json['manufacturer'];
    type = json['type'];
    supplierCode = json['supplierCode'];
    method = json['method'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalProductId'] = internalProductId;
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
