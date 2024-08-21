import 'package:denvin_stock/exports.dart';

class InvoiceHistoryDataModal extends Serializable {
  num? traceId;
  String? createdAt;
  num? createdBy;
  String? uploadedAt;
  String? fileUrl;
  String? processedAt;
  String? confirmedAt;
  num? invoiceType;
  String? invoiceContent;
  String? invoiceNo;
  String? supplier;
  Null? shipmentNo;
  String? invoiceDate;
  num? vatRate;
  num? vatPrice;
  num? total;
  num? totalWithVat;
  num? shippingCost;
  num? discount;
  num? clinicId;
  num? status;
  List<InvoiceItemsDataModal>? invoiceItems;
  bool? isImplant;

  InvoiceHistoryDataModal(
      {this.traceId,
        this.createdAt,
        this.createdBy,
        this.uploadedAt,
        this.fileUrl,
        this.processedAt,
        this.confirmedAt,
        this.invoiceType,
        this.invoiceContent,
        this.invoiceNo,
        this.supplier,
        this.shipmentNo,
        this.invoiceDate,
        this.vatRate,
        this.vatPrice,
        this.total,
        this.totalWithVat,
        this.shippingCost,
        this.discount,
        this.clinicId,
        this.status,
        this.invoiceItems,
        this.isImplant});

  InvoiceHistoryDataModal.fromJson(Map<String, dynamic> json) {
    traceId = json['traceId'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    uploadedAt = json['uploadedAt'];
    fileUrl = json['fileUrl'];
    processedAt = json['processedAt'];
    confirmedAt = json['confirmedAt'];
    invoiceType = json['invoiceType'];
    invoiceContent = json['invoiceContent'];
    invoiceNo = json['invoiceNo'];
    supplier = json['supplier'];
    shipmentNo = json['shipmentNo'];
    invoiceDate = json['invoiceDate'];
    vatRate = json['vatRate'];
    vatPrice = json['vatPrice'];
    total = json['total'];
    totalWithVat = json['totalWithVat'];
    shippingCost = json['shippingCost'];
    discount = json['discount'];
    clinicId = json['clinicId'];
    status = json['status'];
    if (json['invoiceItems'] != null) {
      invoiceItems = <InvoiceItemsDataModal>[];
      json['invoiceItems'].forEach((v) {
        invoiceItems!.add( InvoiceItemsDataModal.fromJson(v));
      });
    }
    isImplant = json['isImplant'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['traceId'] = traceId;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['uploadedAt'] = uploadedAt;
    data['fileUrl'] = fileUrl;
    data['processedAt'] = processedAt;
    data['confirmedAt'] = confirmedAt;
    data['invoiceType'] = invoiceType;
    data['invoiceContent'] = invoiceContent;
    data['invoiceNo'] = invoiceNo;
    data['supplier'] = supplier;
    data['shipmentNo'] = shipmentNo;
    data['invoiceDate'] = invoiceDate;
    data['vatRate'] = vatRate;
    data['vatPrice'] = vatPrice;
    data['total'] = total;
    data['totalWithVat'] = totalWithVat;
    data['shippingCost'] = shippingCost;
    data['discount'] = discount;
    data['clinicId'] = clinicId;
    data['status'] = status;
    if (invoiceItems != null) {
      data['invoiceItems'] = invoiceItems!.map((v) => v.toJson()).toList();
    }
    data['isImplant'] = isImplant;
    return data;
  }
}

class InvoiceItemsDataModal {
  num? invoiceUploadId;
  num? orderItemId;
  String? createdAt;
  Null? updatedAt;
  num? recordNumber;
  String? name;
  String? productCode;
  num? unitPrice;
  num? price;
  num? quantity;
  num? quantityToFollow;
  bool? isReturned;
  bool? isHistorical;
  Null? historicalBy;
  Null? historicalAt;
  Null? discountValue;
  Null? discountType;
  Null? discountPrice;
  String? processError;
  String? processedAt;
  Null? releasedAt;
  String? partCollection;
  List<PartCollectionObj>? partCollectionObj;
  num? clinicId;
  num? status;
  num? id;

  InvoiceItemsDataModal(
      {this.invoiceUploadId,
        this.orderItemId,
        this.createdAt,
        this.updatedAt,
        this.recordNumber,
        this.name,
        this.productCode,
        this.unitPrice,
        this.price,
        this.quantity,
        this.quantityToFollow,
        this.isReturned,
        this.isHistorical,
        this.historicalBy,
        this.historicalAt,
        this.discountValue,
        this.discountType,
        this.discountPrice,
        this.processError,
        this.processedAt,
        this.releasedAt,
        this.partCollection,
        this.partCollectionObj,
        this.clinicId,
        this.status,
        this.id});

  InvoiceItemsDataModal.fromJson(Map<String, dynamic> json) {
    invoiceUploadId = json['invoiceUploadId'];
    orderItemId = json['orderItemId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    recordNumber = json['recordNumber'];
    name = json['name'];
    productCode = json['productCode'];
    unitPrice = json['unitPrice'];
    price = json['price'];
    quantity = json['quantity'];
    quantityToFollow = json['quantityToFollow'];
    isReturned = json['isReturned'];
    isHistorical = json['isHistorical'];
    historicalBy = json['historicalBy'];
    historicalAt = json['historicalAt'];
    discountValue = json['discountValue'];
    discountType = json['discountType'];
    discountPrice = json['discountPrice'];
    processError = json['processError'];
    processedAt = json['processedAt'];
    releasedAt = json['releasedAt'];
    partCollection = json['partCollection'];
    if (json['partCollectionObj'] != null) {
      partCollectionObj = <PartCollectionObj>[];
      json['partCollectionObj'].forEach((v) {
        partCollectionObj!.add(new PartCollectionObj.fromJson(v));
      });
    }
    clinicId = json['clinicId'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceUploadId'] = invoiceUploadId;
    data['orderItemId'] = orderItemId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['recordNumber'] = recordNumber;
    data['name'] = name;
    data['productCode'] = productCode;
    data['unitPrice'] = unitPrice;
    data['price'] = price;
    data['quantity'] = quantity;
    data['quantityToFollow'] = quantityToFollow;
    data['isReturned'] = isReturned;
    data['isHistorical'] = isHistorical;
    data['historicalBy'] = historicalBy;
    data['historicalAt'] = historicalAt;
    data['discountValue'] = discountValue;
    data['discountType'] = discountType;
    data['discountPrice'] = discountPrice;
    data['processError'] = processError;
    data['processedAt'] = processedAt;
    data['releasedAt'] = releasedAt;
    data['partCollection'] = partCollection;
    if (partCollectionObj != null) {
      data['partCollectionObj'] =
          partCollectionObj!.map((v) => v.toJson()).toList();
    }
    data['clinicId'] = clinicId;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class PartCollectionObj {
  num? pId;
  num? part;

  PartCollectionObj({this.pId, this.part});

  PartCollectionObj.fromJson(Map<String, dynamic> json) {
    pId = json['pId'];
    part = json['part'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pId'] = this.pId;
    data['part'] = this.part;
    return data;
  }
}