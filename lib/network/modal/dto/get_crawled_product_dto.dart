class GetCrawledProductDto {
  int? internalSupplierId;
  int? externalSupplierId;
  String? search;

  GetCrawledProductDto(
      {this.internalSupplierId, this.externalSupplierId, this.search});

  GetCrawledProductDto.fromJson(Map<String, dynamic> json) {
    internalSupplierId = json['InternalSupplierId'];
    externalSupplierId = json['ExternalSupplierId'];
    search = json['Search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InternalSupplierId'] = internalSupplierId;
    data['ExternalSupplierId'] = externalSupplierId;
    data['Search'] = search;
    return data;
  }
}
