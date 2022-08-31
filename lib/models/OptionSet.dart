import 'OptionConstant.dart';

class OptionSet {
  int? id;
  OptionConstant? optionConstant;
  String? optionname;
  String? active;

  // List<OptionConstant>? listOptionConstant = [];

  OptionSet({this.id, this.optionConstant, this.optionname, this.active});

  factory OptionSet.fromJson(Map<String, dynamic> json) {
    return OptionSet(
        id: json['id'],
        optionConstant: json['optionConstant'] != null
            ? OptionConstant.fromJson(json['optionConstant'])
            : null,
        optionname: json['optionname'],
        active: json['active']
      // listOptionConstant: json['listOptionConstant'] != null
      //     ? (json['listOptionConstant'] as List)
      //     .map((i) => OptionConstant.fromJson(i))
      //     .toList()
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['optionname'] = this.optionname;
    if (this.optionConstant != null) {
      data['optionConstant'] = this.optionConstant?.toJson();
    };
    data['active'] = this.active;
    // if (this.listOptionConstant != null) {
    //     data['listOptionConstant'] = this.listOptionConstant?.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
