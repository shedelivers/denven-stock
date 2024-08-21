import 'package:denvin_stock/exports.dart';
class CustomScanResponseModal <T extends Serializable>  {
  // int? error;
  bool? successful;
  String? error;
  List<T>? list;

  // String? successful;
  // var totalBalance;
  // var balance;

  CustomScanResponseModal({this.list, this.error,this.successful });

  CustomScanResponseModal.fromJson(Map<String, dynamic> json, T Function(dynamic) create) {
    successful = json['successful'];
    error = json['error'];

    if (json['response'] != null) {
      list = <T>[];
      json['response'].forEach((v) {
        list!.add(create(v));
      });
    }

    // totalBalance = json['totalBalance'];
    // balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};


    if (this.list != null) {
      data['response'] = this.list!.map((v) => v.toJson()).toList();
    }
    data["error"] = error;
    data["successful"] = successful;


    return data;
  }
}