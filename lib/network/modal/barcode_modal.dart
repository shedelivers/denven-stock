class BarcodeModal {
  bool? removeAll;
  String? barcode;
  String? symbology;
  String? uniqueId;

  BarcodeModal({this.removeAll, this.barcode, this.symbology,this.uniqueId});

  BarcodeModal.fromJson(Map<String, dynamic> json) {
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