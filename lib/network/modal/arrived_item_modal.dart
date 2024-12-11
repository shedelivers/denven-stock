import 'package:denvin_stock/exports.dart';

class ArrivedItemModal   extends Serializable {
  int? id;
  int? supplierId;
  int? extSupplierId;
  int? clinicId;
  int? enqueryId;
  String? orderCode;
  String? supplierName;
  int? orderStatus;
  int? orderType;
  String? invoiceUploadType;
  dynamic invoiceUploadId;
  String? createdAt;
  String? updatedAt;
  dynamic percent;
  int? createdBy;
  int? status;
  double? discount;
  int? updatedBy;
  int? issuedBy;
  String? issuedAt;
  int? totalUnits;
  double? totalTax;
  double? itemsTotal;
  int? notAddedItemToStock;
  double? shippingCost;
  double? totalCost;
  String? planedDeliveryAt;
  String? receivedAt;
  double? vatRate;
  bool? vatIncluded;
  List<Items>? items;
  List<DraftIItemModel>? draftNewItems;
  // List<Null>? changes;
  // List<Null>? comments;
  // List<Null>? emails;

  ArrivedItemModal(
      {this.id,
        this.supplierId,
        this.extSupplierId,
        this.clinicId,
        this.supplierName,
        this.notAddedItemToStock,
        this.enqueryId,
        this.orderCode,
        this.orderStatus,
        this.orderType,
        this.invoiceUploadType,
        this.invoiceUploadId,
        this.createdAt,
        this.updatedAt,
        this.percent,
        this.createdBy,
        this.status,
        this.discount,
        this.updatedBy,
        this.issuedBy,
        this.issuedAt,
        this.totalUnits,
        this.totalTax,
        this.itemsTotal,
        this.shippingCost,
        this.totalCost,
        this.planedDeliveryAt,
        this.receivedAt,
        this.vatRate,
        this.vatIncluded,
        this.items,
        this.draftNewItems,
        // this.changes,
        // this.comments,
        // this.emails
      });

  ArrivedItemModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplierId'];
    extSupplierId = json['extSupplierId'];
    clinicId = json['clinicId'];
    supplierName = json['supplierName'];
    enqueryId = json['enqueryId'];
    orderCode = json['orderCode'];
    orderStatus = json['orderStatus'];
    orderType = json['orderType'];
    invoiceUploadType = json['invoiceUploadType'];
    notAddedItemToStock = json['notAddedItemToStock'];
    invoiceUploadId = json['invoiceUploadId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    percent = json['percent'];
    createdBy = json['createdBy'];
    status = json['status'];
    discount = json['discount'];
    updatedBy = json['updatedBy'];
    issuedBy = json['issuedBy'];
    issuedAt = json['issuedAt'];
    totalUnits = json['totalUnits'];
    totalTax = json['totalTax'];
    itemsTotal = json['itemsTotal'];
    shippingCost = json['shippingCost'];
    totalCost = json['totalCost'];
    planedDeliveryAt = json['planedDeliveryAt'];
    receivedAt = json['receivedAt'];
    vatRate = json['vatRate'];
    vatIncluded = json['vatIncluded'];
    // if (json['changes'] != null) {
    //   changes = <Null>[];
    //   json['changes'].forEach((v) {
    //     // changes!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    if (json['draftNewItems'] != null) {
      draftNewItems = <DraftIItemModel>[];
      json['draftNewItems'].forEach((v) {
        draftNewItems!.add(DraftIItemModel.fromJson(v));
      });
    }
    // if (json['comments'] != null) {
    //   comments = <Null>[];
    //   json['comments'].forEach((v) {
    //     // comments!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['emails'] != null) {
    //   emails = <Null>[];
    //   json['emails'].forEach((v) {
    //     // emails!.add( Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =<String, dynamic>{};
    data['id'] = id;
    data['supplierId'] = supplierId;
    data['extSupplierId'] = extSupplierId;
    data['clinicId'] = clinicId;
    data['enqueryId'] = enqueryId;
    data['orderCode'] = orderCode;
    data['orderStatus'] = orderStatus;
    data['orderType'] = orderType;
    data['invoiceUploadType'] = invoiceUploadType;
    data['supplierName'] = supplierName;
    data['notAddedItemToStock'] = notAddedItemToStock;
    data['invoiceUploadId'] = invoiceUploadId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['percent'] = percent;
    data['createdBy'] = createdBy;
    data['status'] = status;
    data['discount'] = discount;
    data['updatedBy'] =updatedBy;
    data['issuedBy'] = issuedBy;
    data['issuedAt'] = issuedAt;
    data['totalUnits'] = totalUnits;
    data['totalTax'] = totalTax;
    data['itemsTotal'] = itemsTotal;
    data['shippingCost'] = shippingCost;
    data['totalCost'] = totalCost;
    data['planedDeliveryAt'] = planedDeliveryAt;
    data['receivedAt'] = receivedAt;
    data['vatRate'] = vatRate;
    data['vatIncluded'] = vatIncluded;
    // if (changes != null) {
    //   // data['changes'] = changes!.map((v) => v.toJson()).toList();
    // }
    if (items != null) {
      // data['items'] = items!.map((v) => v.toJson()).toList();
    }
    // if (comments != null) {
    //   // data['comments'] = comments!.map((v) => v.toJson()).toList();
    // }
    // if (emails != null) {
    //   // data['emails'] = emails!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Items {
  int? id;
  int? quanitity;
  int? orderStatus;
  String? productName;
  int? productId;
  double? tax;
  String? supplierCode;
  String? supplierName;
  double? price;
  double? totalCost;
  String? createdAt;
  int? createdBy;
  int? issuedBy;
  bool? isHistorical;
  String? updatedAt;
  String? receivedAt;
  DraftIItemModel? draftItems;
  dynamic discountType;
  dynamic discountValue;
  dynamic discountPrice;
  dynamic receivedQuanitity;
  dynamic addedToDraftStockAt;
  dynamic addedToDraftStockProcessError;
  dynamic stockVersionInvoiceItemId;
  dynamic backupProductName;
  dynamic backupPrice;
  dynamic backupTotalCost;
  dynamic backupTax;
  dynamic backupVATRate;
  dynamic backupDiscountValue;
  dynamic backupDiscountType;
  dynamic backupDiscountPrice;
  dynamic backupQuanitity;
  dynamic backupSupplierCode;

  Items(
      {this.id,
        this.quanitity,
        this.orderStatus,
        this.productName,
        this.productId,
        this.tax,
        this.supplierCode,
        this.supplierName,
        this.price,
        this.totalCost,
        this.createdAt,
        this.createdBy,
        this.issuedBy,
        this.isHistorical,
        this.updatedAt,
        this.receivedAt,
        this.draftItems,
        this.discountType,
        this.discountValue,
        this.discountPrice,
        this.receivedQuanitity,
        this.addedToDraftStockAt,
        this.addedToDraftStockProcessError,
        this.stockVersionInvoiceItemId,
        this.backupProductName,
        this.backupPrice,
        this.backupTotalCost,
        this.backupTax,
        this.backupVATRate,
        this.backupDiscountValue,
        this.backupDiscountType,
        this.backupDiscountPrice,
        this.backupQuanitity,
        this.backupSupplierCode});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quanitity = json['quanitity'];
    orderStatus = json['orderStatus'];
    productName = json['productName'];
    productId = json['productId'];
    tax = json['tax'];
    supplierCode = json['supplierCode'];
    supplierName = json['supplierName'];
    price = json['price'];
    totalCost = json['totalCost'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    issuedBy = json['issuedBy'];
    isHistorical = json['isHistorical'];
    updatedAt = json['updatedAt'];
    receivedAt = json['receivedAt'];
    draftItems = json['draftItems'] != null ? new DraftIItemModel.fromJson(json['draftItems']) : null;
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    discountPrice = json['discountPrice'];
    receivedQuanitity = json['receivedQuanitity'];
    addedToDraftStockAt = json['addedToDraftStockAt'];
    addedToDraftStockProcessError = json['addedToDraftStockProcessError'];
    stockVersionInvoiceItemId = json['stockVersionInvoiceItemId'];
    backupProductName = json['backup_ProductName'];
    backupPrice = json['backup_Price'];
    backupTotalCost = json['backup_TotalCost'];
    backupTax = json['backup_Tax'];
    backupVATRate = json['backup_VATRate'];
    backupDiscountValue = json['backup_DiscountValue'];
    backupDiscountType = json['backup_DiscountType'];
    backupDiscountPrice = json['backup_DiscountPrice'];
    backupQuanitity = json['backup_Quanitity'];
    backupSupplierCode = json['backup_SupplierCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quanitity'] = quanitity;
    data['orderStatus'] = orderStatus;
    data['productName'] = productName;
    data['productId'] = productId;
    data['tax'] = tax;
    data['supplierCode'] = supplierCode;
    data['supplierName'] = supplierName;
    data['price'] = price;
    data['totalCost'] = totalCost;
    data['createdAt'] =createdAt;
    data['createdBy'] = createdBy;
    data['issuedBy'] = issuedBy;
    data['isHistorical'] = isHistorical;
    data['updatedAt'] = updatedAt;
    data['receivedAt'] = receivedAt;
    if (this.draftItems != null) {
      data['draftItems'] = this.draftItems!.toJson();
    }
    data['discountType'] = discountType;
    data['discountValue'] = discountValue;
    data['discountPrice'] = discountPrice;
    data['receivedQuanitity'] = receivedQuanitity;
    data['addedToDraftStockAt'] = addedToDraftStockAt;
    data['addedToDraftStockProcessError'] = addedToDraftStockProcessError;
    data['stockVersionInvoiceItemId'] = stockVersionInvoiceItemId;
    data['backup_ProductName'] = backupProductName;
    data['backup_Price'] = backupPrice;
    data['backup_TotalCost'] = backupTotalCost;
    data['backup_Tax'] = backupTax;
    data['backup_VATRate'] = backupVATRate;
    data['backup_DiscountValue'] = backupDiscountValue;
    data['backup_DiscountType'] = backupDiscountType;
    data['backup_DiscountPrice'] = backupDiscountPrice;
    data['backup_Quanitity'] = backupQuanitity;
    data['backup_SupplierCode'] = backupSupplierCode;
    return data;
  }
}


class DraftIItemModel {
  int? id;
  int? minLevel;
  int? quantity;
  int? orderQuantity;
  double? price;
  String? name;
  String? manufacturer;
  String? type;
  String? supplierCode;
  String? supplier;
  String? status;
  bool? isNew;
  List<Storages>? storages;
  List<BarcodeDTO>? barcodes;

  DraftIItemModel(
      {this.id,
        this.minLevel,
        this.quantity,
        this.orderQuantity,
        this.price,
        this.name,
        this.manufacturer,
        this.type,
        this.supplierCode,
        this.supplier,
        this.status,
        this.isNew,
        this.storages,
        this.barcodes});

  DraftIItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minLevel = json['minLevel'];
    quantity = json['quantity'];
    orderQuantity = json['orderQuantity'];
    price = json['price'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    type = json['type'];
    supplierCode = json['supplierCode'];
    supplier = json['supplier'];
    status = json['status'];
    isNew = json['isNew'];
    if (json['storages'] != null) {
      storages = <Storages>[];
      json['storages'].forEach((v) {
        storages!.add(new Storages.fromJson(v));
      });
    }
    if (json['barcodes'] != null) {
      barcodes = <BarcodeDTO>[];
      json['barcodes'].forEach((v) {
        barcodes!.add(BarcodeDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['minLevel'] = this.minLevel;
    data['quantity'] = this.quantity;
    data['orderQuantity'] = this.orderQuantity;
    data['price'] = this.price;
    data['name'] = this.name;
    data['manufacturer'] = this.manufacturer;
    data['type'] = this.type;
    data['supplierCode'] = this.supplierCode;
    data['supplier'] = this.supplier;
    data['status'] = this.status;
    data['isNew'] = this.isNew;
    if (this.storages != null) {
      data['storages'] = this.storages!.map((v) => v.toJson()).toList();
    }
    if (barcodes != null) {
      data['barcodes'] = barcodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Storages {
  int? sId;
  int? qty;
  String? name;
  List<String>? expiredAt;

  Storages({this.sId, this.qty, this.expiredAt, this.name});

  Storages.fromJson(Map<String, dynamic> json) {
    sId = json['sId'];
    qty = json['qty'];
    name = json['name'];
    if (json['expiredAt'] != null) {
      expiredAt = <String>[];
      json['expiredAt'].forEach((v) {
        expiredAt!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sId'] = sId;
    data['qty'] = qty;
    data['name'] = name;
    if (expiredAt != null) {
      data['expiredAt'] = expiredAt!.map((v) => v).toList();
    }
    return data;
  }
}

class ItemDTO {
  int? id;
  bool? isNew;
  String? name;
  String? status;
  int? quantity;
  int? orderedQuantity;
  String? supplierCode;
  String? supplier;
  double? unitPrice;
  List<Storages>? storages;
  List<BarcodeDTO>? barcodes;
  int? minLevel;
  String? type;
  String? manufacturer;

  ItemDTO(
      {this.id,
        this.isNew,
        this.name,
        this.status,
        this.quantity,
        this.orderedQuantity,
        this.supplierCode,
        this.supplier,
        this.unitPrice,
        this.type,
        this.minLevel,
        this.manufacturer,
        this.storages,
        this.barcodes});

  ItemDTO.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    isNew = json['IsNew'];
    type = json['type'];
    minLevel = json['minLevel'];
    manufacturer = json['manufacturer'];
    name = json['Name'];
    status = json['Status'];
    quantity = json['Quantity'];
    orderedQuantity = json['OrderedQuantity'];
    supplierCode = json['SupplierCode'];
    supplier = json['supplier'];
    unitPrice = json['price'];
    if (json['storages'] != null) {
      storages = <Storages>[];
      json['storages'].forEach((v) {
        storages!.add(Storages.fromJson(v));
      });
    }
    if (json['barcodes'] != null) {
      barcodes = <BarcodeDTO>[];
      json['barcodes'].forEach((v) {
        barcodes!.add(BarcodeDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['IsNew'] = isNew;
    data['Name'] = name;
    data['type'] = type;
    data['minLevel'] = minLevel;
    data['manufacturer'] = manufacturer;
    data['Status'] = status;
    data['Quantity'] = quantity;
    data['OrderedQuantity'] = orderedQuantity;
    data['SupplierCode'] = supplierCode;
    data['supplier'] = supplier;
    data['price'] = unitPrice;
    if (storages != null) {
      data['storages'] = storages!.map((v) => v.toJson()).toList();
    }
    if (barcodes != null) {
      data['barcodes'] = barcodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class BarcodeDTO {
  bool? removeAll;
  String? barcode;
  String? symbology;

  BarcodeDTO({this.removeAll, this.barcode, this.symbology});

  BarcodeDTO.fromJson(Map<String, dynamic> json) {
    removeAll = json['removeAll'];
    barcode = json['barcode'];
    symbology = json['symbology'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['removeAll'] = removeAll;
    data['barcode'] = barcode;
    data['symbology'] = symbology;
    return data;
  }
}
