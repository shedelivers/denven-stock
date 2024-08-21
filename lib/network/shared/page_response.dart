class PaginationResponseModal<T extends Serializable> {

  int? page;
  int? pageSize;
  int? total;
  List<T>? data;
  List<T>? response;

  PaginationResponseModal({required this.data,
    this.response,
    this.page,
    this.pageSize,
    this.total,
  });

  PaginationResponseModal.fromJson(Map<String, dynamic> json,T Function(dynamic) create) {
    if (json['data'] != null) {
      data = <T>[];
      json['data'].forEach((v) {
        data!.add(create(v));
      });
    }
    page = json['page'];
    pageSize = json['pageSize'];
    total = json['total'];
    if (json['response'] != null) {
      response = <T>[];
      json['response'].forEach((v) {
        response!.add(create(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['total'] = total;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}