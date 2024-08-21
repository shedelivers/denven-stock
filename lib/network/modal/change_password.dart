class ChangePasswordModel {
  Response? response;
  String? error;
  bool? successful;

  ChangePasswordModel({this.response, this.error, this.successful});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    error = json['error'];
    successful = json['successful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['error'] = this.error;
    data['successful'] = this.successful;
    return data;
  }
}

class Response {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  int? securityId;
  int? status;

  Response(
      {this.id,
        this.firstname,
        this.lastname,
        this.email,
        this.phoneNumber,
        this.securityId,
        this.status});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    securityId = json['securityId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['securityId'] = this.securityId;
    data['status'] = this.status;
    return data;
  }
}
