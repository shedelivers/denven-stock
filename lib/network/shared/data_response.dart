class DataResponse<TModel>{
  bool? successful;
  String? error;
  TModel? response;
  DataResponse({this.successful, this.error, this.response});

  factory DataResponse.fromJson(Map<String, dynamic> json, TModel Function(Object? json) fromJsonT,) => _$DataResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(TModel value) toJsonT) => _$DataResponseToJson(this, toJsonT);
}

DataResponse<TModel> _$DataResponseFromJson<TModel>(Map<String, dynamic> json, TModel Function(Object? json) fromJsonTModel,) => DataResponse<TModel>(
      successful: json['successful'] as bool?,
  error: json['error'] as String?,
  response: _$nullableGenericFromJson(json['response'], fromJsonTModel),
    );

Map<String, dynamic> _$DataResponseToJson<TModel>(DataResponse<TModel> instance, Object? Function(TModel value) toJsonTModel,) {
  final val = <String, dynamic>{};
  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }
  writeNotNull('successful', instance.successful);
  writeNotNull('error', instance.error);
  writeNotNull('response', _$nullableGenericToJson(instance.response, toJsonTModel));
  return val;
}

T? _$nullableGenericFromJson<T>(Object? input, T Function(Object? json) fromJson,) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(T? input, Object? Function(T value) toJson,) => input == null ? null : toJson(input);


class BasketCount {
  int? response;
  String? error;
  bool? successful;

  BasketCount({this.response, this.error, this.successful});

  BasketCount.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    error = json['error'];
    successful = json['successful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response'] = response;
    data['error'] = error;
    data['successful'] = successful;
    return data;
  }
}
