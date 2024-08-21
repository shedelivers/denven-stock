// import 'package:denvin_stock/exports.dart';
//
// class ScanResponseModal {
//   List<ProductModal>? response;
//   String? error;
//   bool? successful;
//
//   ScanResponseModal({this.response, this.error, this.successful});
//
//   ScanResponseModal.fromJson(Map<String, dynamic> json) {
//     if (json['response'] != null) {
//       response = <ProductModal>[];
//       json['response'].forEach((v) {
//         response!.add(ProductModal.fromJson(v));
//       });
//     }
//     error = json['error'];
//     successful = json['successful'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (response != null) {
//       data['response'] = response!.map((v) => v.toJson()).toList();
//     }
//     data['error'] = error;
//     data['successful'] = successful;
//     return data;
//   }
// }