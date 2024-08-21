import 'package:denvin_stock/exports.dart';

class ConsumerModal  extends Serializable {
  int? id;
  int? title;
  String? firstname;
  String? lastname;
  List<String>? lActions;
  String? formatedName;
  String? description;

  ConsumerModal(
      {this.id,
        this.title,
        this.firstname,
        this.lastname,
        this.description,
        this.lActions,
        this.formatedName});

  ConsumerModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    description = json['description'];
    lActions = json['_Actions'].cast<String>();
    formatedName = json['formatedName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['description'] = description;
    data['_Actions'] = lActions;
    data['formatedName'] = formatedName;
    return data;
  }
}
