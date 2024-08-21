import 'package:denvin_stock/exports.dart';

class ReturnItemDataModal extends Serializable {
  int? id;
  String? expiry;
  int? qty;
  String? returnDate;
  String? notes;
  String? createdAt;
  String? updatedAt;
  // int? createdBy;
  int? status;

  String? name;
  String? manufacturer;
  String? supplier;
  String? storages;
  String? price;
  int? quantity;
  String? type;
  String? upc;
  String? supplierCode;
  List<ExpiredAt>? expiredAt;

  ReturnItemDataModal(
      {this.id,
      this.expiry,
      this.qty,
      this.returnDate,
      this.notes,
      this.createdAt,
      this.updatedAt,
      // this.createdBy,
      this.status,

      this.name,
      this.manufacturer,
      this.supplier,
      this.storages,
      this.price,
      this.quantity,
      this.type,
      this.upc,
      this.supplierCode,
      this.expiredAt,
      });
  ReturnItemDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expiry = json['expiry'];
    qty = json['qty'];
    returnDate = json['returnDate'];
    notes = json['notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // createdBy = json['createdBy'];
    status = json['status'];

    name = json['name'];
    manufacturer = json['manufacturer'];
    supplier = json['supplier'];
    storages = json['storages'];
    price = json['price'];
    quantity = json['quantity'];
    type = json['type'];
    upc = json['upc'];
    supplierCode = json['supplierCode'];
    if (json['expiredAt'] != null) {
      expiredAt = <ExpiredAt>[];
      json['expiredAt'].forEach((v) {
        expiredAt!.add(ExpiredAt.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expiry'] = expiry;
    data['qty'] = qty;
    data['returnDate'] = returnDate;
    data['notes'] = notes;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // data['createdBy'] = createdBy;
    data['status'] = status;
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['supplier'] = supplier;
    data['storages'] = storages;
    data['price'] = price;
    data['quantity'] = quantity;
    data['type'] = type;
    data['upc'] = upc;
    data['supplierCode'] = supplierCode;
    if (expiredAt != null) {
      data['expiredAt'] = expiredAt!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ExpiredAt {
  String? date;
  int? level;

  ExpiredAt({this.date, this.level});

  ExpiredAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =<String, dynamic>{};
    data['date'] = date;
    data['level'] = level;
    return data;
  }
}

class InventoryReportModal extends Serializable {
  String? name;
  String? manufacturer;
  int? type;
  int? quantity;
  double? price;
  int? changes;
  int? supplierId;
  String? supplierName;
  int? storageId;
  String? storageName;
  dynamic location1;
  dynamic location2;
  int? consume;
  String? supplierCode;

  InventoryReportModal(
      {this.name,
        this.manufacturer,
        this.type,
        this.quantity,
        this.price,
        this.changes,
        this.supplierId,
        this.supplierName,
        this.storageId,
        this.storageName,
        this.location1,
        this.location2,
        this.consume,
        this.supplierCode});

  InventoryReportModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    manufacturer = json['manufacturer'];
    type = json['type'];
    quantity = json['quantity'];
    price = json['price'];
    changes = json['changes'];
    supplierId = json['supplierId'];
    supplierName = json['supplierName'];
    storageId = json['storageId'];
    storageName = json['storageName'];
    location1 = json['location1'];
    location2 = json['location2'];
    consume = json['consume'];
    supplierCode = json['supplierCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['type'] = type;
    data['quantity'] = quantity;
    data['price'] = price;
    data['changes'] = changes;
    data['supplierId'] = supplierId;
    data['supplierName'] = supplierName;
    data['storageId'] = storageId;
    data['storageName'] = storageName;
    data['location1'] = location1;
    data['location2'] = location2;
    data['consume'] = consume;
    data['supplierCode'] = supplierCode;
    return data;
  }
}



class ReturnReportModal extends Serializable {
  int? id;
  String? createdAt;
  CreatedBy? createdBy;
  int? qty;
  String? returnDate;
  String? expiry;
  String? notes;
  int? productId;
  String? productName;
  String? supplier;
  int? supplierId;
  String? storage;
  String? productCode;
  double? price;

  ReturnReportModal(
      {this.id,
        this.createdAt,
        this.createdBy,
        this.qty,
        this.returnDate,
        this.expiry,
        this.notes,
        this.productId,
        this.productName,
        this.supplier,
        this.supplierId,
        this.storage,
        this.productCode,
        this.price});

  ReturnReportModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'] != null ?  CreatedBy.fromJson(json['createdBy']) : null;
    qty = json['qty'];
    returnDate = json['returnDate'];
    expiry = json['expiry'];
    notes = json['notes'];
    productId = json['productId'];
    productName = json['productName'];
    supplier = json['supplier'];
    supplierId = json['supplierId'];
    storage = json['storage'];
    productCode = json['productCode'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['qty'] = qty;
    data['returnDate'] = returnDate;
    data['expiry'] = expiry;
    data['notes'] = notes;
    data['productId'] = productId;
    data['productName'] = productName;
    data['supplier'] = supplier;
    data['supplierId'] = supplierId;
    data['storage'] = storage;
    data['productCode'] = productCode;
    data['price'] = price;
    return data;
  }
}

class CreatedBy {
  String? firstname;
  String? lastname;

  CreatedBy({this.firstname, this.lastname});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    return data;
  }
}
