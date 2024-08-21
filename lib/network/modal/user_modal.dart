import 'package:denvin_stock/exports.dart';


class UserModal {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  bool? emailConfirmed;
  String? phoneNumber;
  bool? phoneNumberConfirmed;
  int? securityId;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? status;
  String? updatedBy;
  int? scope;
  ClinicIds? clinicIds;
  List<ClinicDetails>? clinicDetails;
  SubscriptionDetails? subscriptionDetails;


  UserModal(
      {this.id,
        this.firstname,
        this.lastname,
        this.subscriptionDetails,
        this.email,
        this.emailConfirmed,
        this.phoneNumber,
        this.phoneNumberConfirmed,
        this.securityId,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.status,
        this.updatedBy,
        this.scope,
        this.clinicIds,
        this.clinicDetails});

  UserModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    emailConfirmed = json['emailConfirmed'];
    phoneNumber = json['phoneNumber'];
    phoneNumberConfirmed = json['phoneNumberConfirmed'];
    securityId = json['securityId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    status = json['status'];
    updatedBy = json['updatedBy'];
    scope = json['scope'];
    clinicIds = json['clinicIds'] != null ?  ClinicIds.fromJson(json['clinicIds']) : null;
    subscriptionDetails = json['subscriptionDetails'] != null ? new SubscriptionDetails.fromJson(json['subscriptionDetails']) : null;
    if (json['clinicDetails'] != null) {
      clinicDetails = <ClinicDetails>[];
      json['clinicDetails'].forEach((v) {
        clinicDetails!.add(ClinicDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['emailConfirmed'] = emailConfirmed;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberConfirmed'] = phoneNumberConfirmed;
    data['securityId'] = securityId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['createdBy'] = createdBy;
    data['status'] = status;
    data['updatedBy'] = updatedBy;
    data['scope'] = scope;
    if (subscriptionDetails != null) {
      data['subscriptionDetails'] = subscriptionDetails!.toJson();
    }
    if (clinicIds != null) {
      data['clinicIds'] = clinicIds!.toJson();
    }
    if (clinicDetails != null) {
      data['clinicDetails'] = clinicDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClinicIds {
  int? efe249062b234a1a;
  int? i428f37d91f2d4cdd;

  ClinicIds({this.efe249062b234a1a, this.i428f37d91f2d4cdd});

  ClinicIds.fromJson(Map<String, dynamic> json) {
    efe249062b234a1a = json['efe249062b234a1a'];
    i428f37d91f2d4cdd = json['428f37d91f2d4cdd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['efe249062b234a1a'] = efe249062b234a1a;
    data['428f37d91f2d4cdd'] = i428f37d91f2d4cdd;
    return data;
  }
}

class ClinicDetails extends Serializable{
  int? id;
  String? groupKey;
  String? key;
  String? name;
  String? createdAt;
  String? expiredAt;
  String? logo;
  String? website;
  String? addressLine1;
  String? addressLine2;
  String? addressPostCode;
  String? addressTown;
  String? addressCountry;
  String? phoneNo;
  int? ownerId;
  int? status;
  Setting? setting;

  ClinicDetails(
      {this.id,
        this.groupKey,
        this.key,
        this.name,
        this.createdAt,
        this.expiredAt,
        this.logo,
        this.website,
        this.addressLine1,
        this.addressLine2,
        this.addressPostCode,
        this.addressTown,
        this.addressCountry,
        this.phoneNo,
        this.ownerId,
        this.status,
        this.setting,
       });

  ClinicDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupKey = json['groupKey'];
    key = json['key'];
    name = json['name'];
    createdAt = json['createdAt'];
    expiredAt = json['expiredAt'];
    logo = json['logo'];
    website = json['website'];
    addressLine1 = json['address_Line1'];
    addressLine2 = json['address_Line2'];
    addressPostCode = json['address_PostCode'];
    addressTown = json['address_Town'];
    addressCountry = json['address_Country'];
    phoneNo = json['phoneNo'];
    ownerId = json['ownerId'];
    status = json['status'];
    setting =
    json['setting'] != null ? Setting.fromJson(json['setting']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groupKey'] = groupKey;
    data['key'] = key;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['expiredAt'] = expiredAt;
    data['logo'] = logo;
    data['website'] = website;
    data['address_Line1'] = addressLine1;
    data['address_Line2'] = addressLine2;
    data['address_PostCode'] = addressPostCode;
    data['address_Town'] = addressTown;
    data['address_Country'] = addressCountry;
    data['phoneNo'] = phoneNo;
    data['ownerId'] = ownerId;
    data['status'] = status;
    if (setting != null) {
      data['setting'] = setting!.toJson();
    }
    return data;
  }
}

class Setting {
  dynamic initialledBy;
  String? initialledAt;
  String? timeZone;
  String? culture;

  Setting({this.initialledBy, this.initialledAt, this.timeZone, this.culture});

  Setting.fromJson(Map<String, dynamic> json) {
    initialledBy = json['initialledBy'];
    initialledAt = json['initialledAt'];
    timeZone = json['timeZone'];
    culture = json['culture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['initialledBy'] = initialledBy;
    data['initialledAt'] = initialledAt;
    data['timeZone'] = timeZone;
    data['culture'] = culture;
    return data;
  }
}

class SubscriptionDetails {
  int? id;
  SubscriptionDetailV2? subscriptionDetail;
  int? platForm;
  String? platformTypeName;
  String? createdAt;

  SubscriptionDetails({this.id, this.subscriptionDetail, this.platForm, this.platformTypeName, this.createdAt});
  SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionDetail = json['subscriptionDetail'] != null ?  SubscriptionDetailV2.fromJson(json['subscriptionDetail']) : null;
    platForm = json['platForm'];
    platformTypeName = json['platformTypeName'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (subscriptionDetail != null) {
      data['subscriptionDetail'] = subscriptionDetail!.toJson();
    }
    data['platForm'] = platForm;
    data['platformTypeName'] = platformTypeName;
    data['createdAt'] = createdAt;
    return data;
  }
}

class SubscriptionDetailV2 {
  int? id;
  String? planId;
  String? title;
  String? imagePath;
  int? durationtype;
  String? durationtypeName;
  int? durationCount;
  double? price;
  String? description;
  String? createdAt;

  SubscriptionDetailV2(
      {this.id,
        this.planId,
        this.title,
        this.imagePath,
        this.durationtype,
        this.durationtypeName,
        this.durationCount,
        this.price,
        this.description,
        this.createdAt});

  SubscriptionDetailV2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planId = json['planId'];
    title = json['title'];
    imagePath = json['imagePath'];
    durationtype = json['durationtype'];
    durationtypeName = json['durationtypeName'];
    durationCount = json['durationCount'];
    price = json['price'];
    description = json['description'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['planId'] = planId;
    data['title'] = title;
    data['imagePath'] = imagePath;
    data['durationtype'] = durationtype;
    data['durationtypeName'] = durationtypeName;
    data['durationCount'] = durationCount;
    data['price'] = price;
    data['description'] = description;
    data['createdAt'] = createdAt;
    return data;
  }
}



