
import 'package:denvin_stock/exports.dart';

class ReturnProductDto {
  int? pId;
  int? sId;
  int? minLevel;
  List<Expiries>? expiries;
  List<ReturnsDto>? returns;

  ReturnProductDto(
      {this.pId, this.sId, this.minLevel, this.expiries, this.returns});

  ReturnProductDto.fromJson(Map<String, dynamic> json) {
    pId = json['PId'];
    sId = json['SId'];
    minLevel = json['MinLevel'];
    if (json['Expiries'] != null) {
      expiries = <Expiries>[];
      json['Expiries'].forEach((v) {
        expiries!.add(new Expiries.fromJson(v));
      });
    }
    if (json['Returns'] != null) {
      returns = <ReturnsDto>[];
      json['Returns'].forEach((v) {
        returns!.add(new ReturnsDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PId'] = this.pId;
    data['SId'] = this.sId;
    data['MinLevel'] = this.minLevel;
    if (this.expiries != null) {
      data['Expiries'] = this.expiries!.map((v) => v.toJson()).toList();
    }
    if (this.returns != null) {
      data['Returns'] = this.returns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnsDto {
  String? qty;
  String? expiry;
  String? returnDate;
  String? notes;

  ReturnsDto({this.qty, this.expiry, this.returnDate, this.notes});

  ReturnsDto.fromJson(Map<String, dynamic> json) {
    qty = json['Qty'];
    expiry = json['Expiry'];
    returnDate = json['ReturnDate'];
    notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((qty ?? "").isNotEmpty) {
      data['Qty'] = qty;
    }
    // if ((expiry ?? "").isNotEmpty)
    {
      data['Expiry'] = expiry;
    }
    if ((returnDate ?? "").isNotEmpty) {
      data['ReturnDate'] = returnDate;
    }
    if ((notes ?? "").isNotEmpty) {
      data['Notes'] = notes;
    }

    return data;
  }
}
