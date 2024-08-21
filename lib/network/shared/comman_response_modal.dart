class ComanResponseModal {
  var response;
  String? error;
  bool? successful;

  ComanResponseModal({this.response, this.error, this.successful});

  ComanResponseModal.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    error = json['error'];
    successful = json['successful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['error'] = this.error;
    data['successful'] = this.successful;
    return data;
  }
}

class MoveStorageResponse {
  String? response;
  String? error;
  bool? successful;

  MoveStorageResponse({this.response, this.error, this.successful});

  MoveStorageResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    error = json['error'];
    successful = json['successful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['error'] = this.error;
    data['successful'] = this.successful;
    return data;
  }
}

class ConsumptionResponse {
  Map<String, dynamic>? response;
  String? error;
  bool? successful;

  ConsumptionResponse({this.response, this.error, this.successful});

  ConsumptionResponse.fromJson(Map<String, dynamic> json) {
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
