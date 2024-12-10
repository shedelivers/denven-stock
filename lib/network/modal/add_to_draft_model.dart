class AddToDraftResponseModal {
  String? error;
  bool? successful;

  AddToDraftResponseModal({ this.error, this.successful});

  AddToDraftResponseModal.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    successful = json['successful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['successful'] = this.successful;
    return data;
  }
}