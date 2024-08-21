class AddBarcodeDto {
  List<CommandsDto>? commands;
  int? localMappingId;
  int? supplierId;
  String? supplierCode;
  bool? ApiRequest;

  AddBarcodeDto({required this.commands, this.localMappingId, required this.supplierId, this.ApiRequest = false, required this.supplierCode});

  AddBarcodeDto.fromJson(Map<String, dynamic> json) {
    if (json['Commands'] != null) {
      commands = <CommandsDto>[];
      json['Commands'].forEach((v) {
        commands!.add(CommandsDto.fromJson(v));
      });
    }
    localMappingId = json['LocalMappingId'];
    ApiRequest = json['ApiRequest'];
    supplierId = json['SupplierId'];
    supplierCode = json['SupplierCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (commands != null) {
      data['Commands'] = commands!.map((v) => v.toJson()).toList();
    }
    data['LocalMappingId'] = localMappingId;
    data['ApiRequest'] = ApiRequest;
    data['SupplierId'] = supplierId;
    data['SupplierCode'] = supplierCode;
    return data;
  }
}

class CommandsDto {
  int? command;
  String? barcode;
  String? symbology;

  CommandsDto({this.command, this.barcode, this.symbology});

  CommandsDto.fromJson(Map<String, dynamic> json) {
    command = json['Command'];
    barcode = json['Barcode'];
    symbology = json['Symbology'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Command'] = this.command;
    data['Barcode'] = this.barcode;
    data['Symbology'] = this.symbology;
    return data;
  }
}
