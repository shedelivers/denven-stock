class DeleteBarCodeDto {
  int? id;
  List<DeletedBarcodesDto>? barcodes;

  DeleteBarCodeDto({required this.id, this.barcodes});

  DeleteBarCodeDto.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    if (json['Barcodes'] != null) {
      barcodes = <DeletedBarcodesDto>[];
      json['Barcodes'].forEach((v) {
        barcodes!.add(new DeletedBarcodesDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    if (this.barcodes != null) {
      data['Barcodes'] = this.barcodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeletedBarcodesDto {
  String? barcode;
  String? type;

  DeletedBarcodesDto({this.barcode, this.type});

  DeletedBarcodesDto.fromJson(Map<String, dynamic> json) {
    barcode = json['Barcode'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Barcode'] = this.barcode;
    data['Type'] = this.type;
    return data;
  }
}
