import 'package:denvin_stock/exports.dart';

class BasketModal extends Serializable {
  int? id;
  int? createdBy;
  Product? product;
  SupplierBasket? supplier;
  List<String>? lActions;

  BasketModal(
      {this.id, this.createdBy, this.product, this.supplier, this.lActions});

  BasketModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['createdBy'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    supplier = json['supplier'] != null
        ? SupplierBasket.fromJson(json['supplier'])
        : null;
    lActions = json['_Actions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdBy'] = createdBy;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    data['_Actions'] = lActions;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? manufacturer;
  String? link;
  String? oldLink;
  int? quantity;
  int? minLevel;
  String? price;
  List<ExpiriesBasket>? expiries;
  String? orderedAt;
  String? supplierCode;
  int? type;
  int? invoiceUploadId;
  bool? hidden;
  String? invoiceDate;
  // List<Null>? tags;
  String? note;
  List<String>? lActions;
  int? storageId;
  dynamic localMappingId;
  dynamic globalMappingId;
  dynamic storage;
  SupplierBasket? supplier;
  int? status;
  dynamic productImage;
  dynamic upc;

  Product(
      {this.id,
        this.name,
        this.manufacturer,
        this.link,
        this.oldLink,
        this.quantity,
        this.minLevel,
        this.price,
        this.expiries,
        this.orderedAt,
        this.supplierCode,
        this.type,
        this.invoiceUploadId,
        this.hidden,
        this.invoiceDate,
        // this.tags,
        this.note,
        this.lActions,
        this.storageId,
        this.localMappingId,
        this.globalMappingId,
        this.storage,
        this.supplier,
        this.status,
        this.productImage,
        this.upc});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    link = json['link'];
    oldLink = json['oldLink'];
    quantity = json['quantity'];
    minLevel = json['minLevel'];
    price = json['price'].toString();
    if (json['expiries'] != null) {
      expiries = <ExpiriesBasket>[];
      json['expiries'].forEach((v) {
        expiries!.add(ExpiriesBasket.fromJson(v));
      });
    }
    orderedAt = json['orderedAt'];
    supplierCode = json['supplierCode'];
    type = json['type'];
    invoiceUploadId = json['invoiceUploadId'];
    hidden = json['hidden'];
    invoiceDate = json['invoiceDate'];
    // if (json['tags'] != null) {
    //   tags = <Null>[];
    //   json['tags'].forEach((v) {
    //     tags!.add(new Null.fromJson(v));
    //   });
    // }
    note = json['note'];
    lActions = json['_Actions'].cast<String>();
    storageId = json['storageId'];
    localMappingId = json['localMappingId'];
    globalMappingId = json['globalMappingId'];
    storage = json['storage'];
    supplier = json['supplier'] != null
        ? new SupplierBasket.fromJson(json['supplier'])
        : null;
    status = json['status'];
    productImage = json['productImage'];
    upc = json['upc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['link'] = link;
    data['oldLink'] = oldLink;
    data['quantity'] = quantity;
    data['minLevel'] = minLevel;
    data['price'] = price;
    if (expiries != null) {
      data['expiries'] = expiries!.map((v) => v.toJson()).toList();
    }
    data['orderedAt'] = orderedAt;
    data['supplierCode'] = supplierCode;
    data['type'] = type;
    data['invoiceUploadId'] = invoiceUploadId;
    data['hidden'] = hidden;
    data['invoiceDate'] = invoiceDate;
    // if (tags != null) {
    //   data['tags'] = tags!.map((v) => v.toJson()).toList();
    // }
    data['note'] = note;
    data['_Actions'] = lActions;
    data['storageId'] = storageId;
    data['localMappingId'] = localMappingId;
    data['globalMappingId'] = globalMappingId;
    data['storage'] = storage;
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    data['status'] = status;
    data['productImage'] = productImage;
    data['upc'] = upc;
    return data;
  }
}

class ExpiriesBasket {
  int? qty;
  String? at;

  ExpiriesBasket({this.qty, this.at});

  ExpiriesBasket.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    at = json['at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['at'] = at;
    return data;
  }
}

class SupplierBasket {
  int? id;
  String? name;
  String? phoneNo;
  String? email;
  int? invoiceType;
  int? productLibraryId;
  String? link;
  String? salesRepName;
  String? salesRepEmail;
  dynamic salesRepPhone;
  String? accountID;
  bool? sendEmail;
  List<String>? lActions;

  SupplierBasket(
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

  SupplierBasket.fromJson(Map<String, dynamic> json) {
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
    lActions = json['_Actions'].cast<String>();
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
}
