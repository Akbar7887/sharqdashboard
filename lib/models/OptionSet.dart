import 'OptionConstant.dart';

class OptionSet {
  int? id;
  OptionConstant? optionConstant;
  String? optionname;

  // List<OptionConstant>? listOptionConstant = [];

  OptionSet({this.id, this.optionConstant, this.optionname});

  factory OptionSet.fromJson(Map<String, dynamic> json) {
    return OptionSet(
      id: json['id'],
      optionConstant: json['optionConstant'] != null
          ? OptionConstant.fromJson(json['optionConstant'])
          : null,
      optionname: json['optionname'],
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
    }
    ;
    // if (this.listOptionConstant != null) {
    //     data['listOptionConstant'] = this.listOptionConstant?.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
