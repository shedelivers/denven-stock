
import 'package:denvin_stock/exports.dart';

class DatesCalendarModal {
  String title;
  DateTime? startDate;
  DateTime? endDate;
  bool? isCustom;
  DatesCalendarModal(
      {required this.title,
      required this.startDate,
      required this.endDate,
      this.isCustom});
}

class DatesPickerDto {
  String? from;
  String? to;
  String? search;
  List<Supplier>? selectedItem;
  List<Supplier>? selectedStorageItem;
  List<ConsumerModal>? selectedConsumerItem;
  List<ConsumerProductDataModal>? selectedConsumerProductItem;

  DatesPickerDto({this.from, this.to, this.search,this.selectedItem});

  DatesPickerDto.fromJson(Map<String, dynamic> json) {
    from = json['From'];
    to = json['To'];
    search = json['Search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((from ?? "").isNotEmpty && (to ?? "").isNotEmpty) {
      data['From'] = from;
    }
    if ((from ?? "").isNotEmpty && (to ?? "").isNotEmpty) {
      data['To'] = to;
    }
    if ((search ?? "").isNotEmpty) {
      data['Search'] = search;
    }
    return data;
  }
}

class ConsumerProductDataModal{
  final  int id;
  final String title ;
  ConsumerProductDataModal({required this.title,required this.id});
}