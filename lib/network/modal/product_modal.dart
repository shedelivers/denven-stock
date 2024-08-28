import 'package:denvin_stock/exports.dart';

class ProductModal extends Serializable{
  int? id;
  String? name;
  String? manufacturer;
  String? link;
  int? quantity;
  int? minLevel;
  num? price;
  List<Expiries>? expiries;
  String? orderedAt;
  String? supplierCode;
  int? type;
  int? invoiceUploadId;
  bool? hidden;
  String? invoiceDate;
  List<String>? tags;
  String? note;
  List<String>? lActions;
  int? storageId;
  int? localMappingId;
  String? globalMappingId;
  String? updatedAt;
  String? createdAt;
  String? productImage;
  Storage? storage;
  Supplier? supplier;
  int? status;
  List<BarcodeAPIModal>? barcode;
  List<ExpiryLevel>? expiryLevel;
  List<ExpiriesWithPrice>? expiriesWithPrice;

  ProductModal(
      {this.id,
        this.name,
        this.expiryLevel,
        this.expiriesWithPrice,
        this.manufacturer,
        this.updatedAt,
        this.createdAt,
        this.link,
        this.quantity,
        this.minLevel,
        this.barcode,
        this.productImage,
        this.price,
        this.expiries,
        this.orderedAt,
        this.supplierCode,
        this.type,
        this.invoiceUploadId,
        this.hidden,
        this.invoiceDate,
        this.tags,
        this.note,
        this.lActions,
        this.storageId,
        this.localMappingId,
        this.globalMappingId,
        this.storage,
        this.supplier,
        this.status});

  ProductModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    link = json['link'];
    quantity = json['quantity'];
    minLevel = json['minLevel'];
    price = json['price'];
    if (json['expiries'] != null) {
      expiries = <Expiries>[];
      json['expiries'].forEach((v) {
        expiries!.add(Expiries.fromJson(v));
      });
    }
    orderedAt = json['orderedAt'];
    productImage = json['productImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    supplierCode = json['supplierCode'];
    type = json['type'];
    invoiceUploadId = json['invoiceUploadId'];
    hidden = json['hidden'];
    invoiceDate = json['invoiceDate'];
    if (json['tags'] != null) {
      tags = <String>[];
      json['tags'].forEach((v) {
        tags!.add(v);
      });
    }
    note = json['note'];
    lActions = json['_Actions'] != null ?  json['_Actions'].cast<String>() : [];
    storageId = json['storageId'];
    localMappingId = json['localMappingId'];
    globalMappingId = json['globalMappingId'];
    productImage = json['productImage'];
    storage =
    json['storage'] != null ? Storage.fromJson(json['storage']) : null;
    supplier = json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null;
    if (json['barcode'] != null) {
      barcode = <BarcodeAPIModal>[];
      json['barcode'].forEach((v) {
        barcode!.add(BarcodeAPIModal.fromJson(v));
      });
    }

    if (json['expiryLevel'] != null) {
      expiryLevel = <ExpiryLevel>[];
      json['expiryLevel'].forEach((v) {
        expiryLevel!.add(ExpiryLevel.fromJson(v));
      });
    }
    if (json['expiriesWithPrice'] != null) {
      expiriesWithPrice = <ExpiriesWithPrice>[];
      json['expiriesWithPrice'].forEach((v) {
        expiriesWithPrice!.add(ExpiriesWithPrice.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['link'] = link;
    data['quantity'] = quantity;
    data['minLevel'] = minLevel;
    data['price'] = price;
    if (expiries != null) {
      data['expiries'] = expiries!.map((v) => v.toJson()).toList();
    }
    if (expiries != null) {
      data['barcode'] = barcode!.map((v) => v.toJson()).toList();
    }
    data['orderedAt'] = orderedAt;
    data['supplierCode'] = supplierCode;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    data['type'] = type;
    data['invoiceUploadId'] = invoiceUploadId;
    data['hidden'] = hidden;
    data['invoiceDate'] = invoiceDate;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v).toList();
    }
    data['note'] = note;
    data['_Actions'] = lActions;
    data['storageId'] = storageId;
    data['localMappingId'] = localMappingId;
    data['globalMappingId'] = globalMappingId;
    if (storage != null) {
      data['storage'] = storage!.toJson();
    }
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    if (expiryLevel != null) {
      data['expiryLevel'] = expiryLevel!.map((v) => v).toList();
    }

    data['status'] = status;
    return data;
  }
}

class Expiries {
  int? qty;
  String? at;
  dynamic? price;

  Expiries({this.qty, this.at, this.price});

  Expiries.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    at = json['at'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['at'] = at;
    data['price'] = price;
    return data;
  }
}

class ExpiriesWithPrice {
  int? qty;
  String? date;
  int? level;
  dynamic? price;

  ExpiriesWithPrice({this.level, this.date, this.qty, this.price});

  ExpiriesWithPrice.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    date = json['date'];
    qty = json['qty'];
    price = json['price'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['date'] = date;
    data['level'] = level;
    data['price'] = price;
    return data;
  }
}


class ExpiryLevel {
  int? qty;
  String? at;
  int? level;

  ExpiryLevel({this.level, this.at, this.qty});

  ExpiryLevel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    at = json['at'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['at'] = at;
    data['level'] = level;
    return data;
  }
}

class Storage {
  int? id;
  String? name;
  String? location1;
  String? location2;
  String? note;
  List<String>? lActions;

  Storage(
      {this.id,
        this.name,
        this.location1,
        this.location2,
        this.note,
        this.lActions});

  Storage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location1 = json['location1'];
    location2 = json['location2'];
    note = json['note'];
    lActions = json['_Actions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['location1'] = location1;
    data['location2'] = location2;
    data['note'] = note;
    data['_Actions'] = lActions;
    return data;
  }
}

class Supplier extends Serializable with CustomDropdownListFilter{
  int? id;
  String? name;
  String? phoneNo;
  String? email;
  int? invoiceType;
  int? productLibraryId;
  String? link;
  String? salesRepName;
  String? salesRepEmail;
  String? salesRepPhone;
  String? accountID;
  bool? sendEmail;
  List<String>? lActions;
  Supplier(
      {this.id,
        this.name,
        this.phoneNo,
        this.email,
        this.invoiceType,
        this.productLibraryId,
        this.link,
        this.salesRepName,
        this.salesRepEmail,
        this.salesRepPhone,
        this.accountID,
        this.sendEmail,
        this.lActions});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    email = json['email'];
    invoiceType = json['invoiceType'];
    productLibraryId = json['productLibraryId'];
    link = json['link'];
    salesRepName = json['salesRepName'];
    salesRepEmail = json['salesRepEmail'];
    salesRepPhone = json['salesRepPhone'];
    accountID = json['accountID'];
    sendEmail = json['sendEmail'];
    lActions = json['_Actions'] != null ? json['_Actions'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phoneNo'] = phoneNo;
    data['email'] = email;
    data['invoiceType'] = invoiceType;
    data['productLibraryId'] = productLibraryId;
    data['link'] = link;
    data['salesRepName'] = salesRepName;
    data['salesRepEmail'] = salesRepEmail;
    data['salesRepPhone'] = salesRepPhone;
    data['accountID'] = accountID;
    data['sendEmail'] = sendEmail;
    data['_Actions'] = lActions;
    return data;
  }

  @override
  bool filter(String query) {

    throw UnimplementedError();
  }
}

class BarcodeAPIModal {
  int? id;
  List<Barcodes>? barcodes;
  String? barcodesHash;
  String? supplierCode;
  int? supplierId;
  int? extSupplierId;
  String? createdAt;
  int? createdBy;
  int? clinicId;
  int? status;

  BarcodeAPIModal(
      {this.id,
        this.barcodes,
        this.barcodesHash,
        this.supplierCode,
        this.supplierId,
        this.extSupplierId,
        this.createdAt,
        this.createdBy,
        this.clinicId,
        this.status});

  BarcodeAPIModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['barcodes'] != null) {
      barcodes = <Barcodes>[];
      json['barcodes'].forEach((v) {
        barcodes!.add(Barcodes.fromJson(v));
      });
    }
    barcodesHash = json['barcodesHash'];
    supplierCode = json['supplierCode'];
    supplierId = json['supplierId'];
    extSupplierId = json['extSupplierId'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    clinicId = json['clinicId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (barcodes != null) {
      data['barcodes'] = barcodes!.map((v) => v.toJson()).toList();
    }
    data['barcodesHash'] = barcodesHash;
    data['supplierCode'] = supplierCode;
    data['supplierId'] = supplierId;
    data['extSupplierId'] = extSupplierId;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['clinicId'] = clinicId;
    data['status'] = status;
    return data;
  }
}

class Barcodes {
  String? barcode;
  String? type;
  String? uniqueId;

  Barcodes({this.barcode, this.type, this.uniqueId});

  Barcodes.fromJson(Map<String, dynamic> json) {
    barcode = json['barcode'];
    type = json['type'];
    uniqueId = json['uniqueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barcode'] = barcode;
    data['type'] = type;
    data['uniqueId'] = uniqueId;
    return data;
  }
}

class TagModal extends Serializable {
  int? id;
  String? name;
  String? value;

  TagModal({this.id, this.name, this.value});

  TagModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class TagSuggestion {

  MyResponse? response;
  String? error;
  bool? successful;

  TagSuggestion({this.response, this.error, this.successful});

  TagSuggestion.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? MyResponse.fromJson(json['response']) : null;
    error = json['error'];
    successful = json['successful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    data['error'] = error;
    data['successful'] = successful;
    return data;
  }
}

class MyResponse {
  int? page;
  int? pageSize;
  int? total;
  List<String>? data;

  MyResponse({this.page, this.pageSize, this.total, this.data});

  MyResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['pageSize'];
    total = json['total'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['total'] = total;
    data['data'] = data;
    return data;
  }
}

