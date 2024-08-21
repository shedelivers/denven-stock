
import 'package:denvin_stock/exports.dart';


class ConsumptionPatientDataModal extends Serializable{
  int? id;
  int? productsId;
  int? qty;
  int? cId;
  String? expiry;
  String? lot;
  String? ref;
  String? patientName;
  String? patientDOB;
  String? operationDate;
  int? toothNumber;
  String? notes;
  String? files;
  String? createdAt;
dynamic updatedAt;
  int? createdBy;
  dynamic updatedBy;
  int? status;
  ConsumerModal? consumer;
  ProductModal? product;

  ConsumptionPatientDataModal(
      {this.id,
        this.productsId,
        this.qty,
        this.cId,
        this.expiry,
        this.lot,
        this.ref,
        this.patientName,
        this.patientDOB,
        this.operationDate,
        this.toothNumber,
        this.notes,
        this.files,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.status,
        this.consumer,
        this.product});

  ConsumptionPatientDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productsId = json['productsId'];
    qty = json['qty'];
    cId = json['cId'];
    expiry = json['expiry'];
    lot = json['lot'];
    ref = json['ref'];
    patientName = json['patientName'];
    patientDOB = json['patientDOB'];
    operationDate = json['operationDate'];
    toothNumber = json['toothNumber'];
    notes = json['notes'];
    files = json['files'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    status = json['status'];
    consumer = json['consumer'] != null
        ?  ConsumerModal.fromJson(json['consumer'])
        : null;
    product =
    json['product'] != null ?  ProductModal.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['productsId'] = productsId;
    data['qty'] = qty;
    data['cId'] = cId;
    data['expiry'] = expiry;
    data['lot'] = lot;
    data['ref'] = ref;
    data['patientName'] = patientName;
    data['patientDOB'] = patientDOB;
    data['operationDate'] = operationDate;
    data['toothNumber'] = toothNumber;
    data['notes'] = notes;
    data['files'] = files;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['status'] = status;
    if (consumer != null) {
      data['consumer'] = consumer!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}