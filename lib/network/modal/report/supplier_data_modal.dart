import 'package:denvin_stock/exports.dart';

class SupplierDataModal extends Serializable {
  String? name;
  num? supplierId;
  num? total;
  num? count;
  num? avg;
  num? min;
  num? max;

  SupplierDataModal(
      {this.name,
      this.supplierId,
      this.total,
      this.count,
      this.avg,
      this.min,
      this.max});

  SupplierDataModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    supplierId = json['supplierId'];
    total = json['total'];
    count = json['count'];
    avg = json['avg'];
    min = json['min'];
    max = json['max'];
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['supplierId'] = supplierId;
    data['total'] = total;
    data['count'] = count;
    data['avg'] = avg;
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}