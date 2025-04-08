import 'package:denvin_stock/exports.dart';

class FilterModal {

  String? search;
  String? expiryState;
  String? openProducts;
  String? barcodeStatus;
  String? showHiddenProduct;
  List<Supplier>? selectedItem;
  List<Supplier>? selectedStorageItem;

  FilterModal({ this.search, this.selectedItem, this.selectedStorageItem,this.showHiddenProduct, this.openProducts});

  FilterModal.fromJson(Map<String, dynamic> json) {
    search = json['Search'];
    expiryState = json['expiryState'];
    openProducts = json['openProducts'];
    barcodeStatus = json['barcodeStatus'];
    showHiddenProduct = json['showHiddenProduct'];
    if (json['selectedItem'] != null) {
      selectedItem = <Supplier>[];
      json['selectedItem'].forEach((v) {
        selectedItem!.add(Supplier.fromJson(v));
      });
    }

    if (json['selectedStorageItem'] != null) {
      selectedStorageItem = <Supplier>[];
      json['selectedStorageItem'].forEach((v) {
        selectedStorageItem!.add(Supplier.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if ((search ?? "").isNotEmpty) {
      data['Search'] = search;
    }

    if ((expiryState ?? "").isNotEmpty) {
          data['expiryState'] = expiryState;
    }

    if ((openProducts ?? "").isNotEmpty) {
          data['openProducts'] = openProducts;
    }

    if ((barcodeStatus ?? "").isNotEmpty) {
          data['barcodeStatus'] = barcodeStatus;
    }

    if ((showHiddenProduct ?? "").isNotEmpty) {
      data['showHiddenProduct'] = showHiddenProduct;
    }

    if (selectedStorageItem != null) {
      data['selectedStorageItem'] = selectedStorageItem!.map((v) => v).toList();
    }
     if (selectedItem != null) {
      data['selectedItem'] = selectedItem!.map((v) => v).toList();
    }

    return data;
  }
}
