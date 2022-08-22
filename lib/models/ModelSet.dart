import 'OptionSet.dart';
import 'Section.dart';

class ModelSet {
  int? id;
  String? imagepath;
  String? name;
  double? price;
  double? priceuzs;
  String? description;
  String? descriptionuz;
  String? producername;
  Section? section;
  List<OptionSet>? optionSet;

  ModelSet(
      {this.id,
      this.imagepath,
      this.name,
      this.price,
      this.priceuzs,
      this.description,
      this.descriptionuz,
      this.producername,
      this.section,
      this.optionSet});

  factory ModelSet.fromJson(Map<String, dynamic> json) {
    return ModelSet(
      id: json['id'],
      imagepath: json['imagepath'],
      name: json['name'],
      price: json['price'],
      priceuzs: json['priceuzs'],
      description: json['description'],
      descriptionuz: json['descriptionuz'],
      producername: json['producername'],
      section:
          json['section'] != null ? Section.fromJson(json['section']) : null,
      optionSet: json['optionSet'] != null
          ? (json['optionSet'] as List)
              .map((i) => OptionSet.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagepath'] = this.imagepath;
    data['name'] = this.name;
    data['price'] = this.price;
    data['priceuzs'] = this.priceuzs;
    data['description'] = this.description;
    data['descriptionuz'] = this.descriptionuz;
    data['producername'] = this.producername;
    if (this.section != null) {
      data['section'] = this.section?.toJson();
    }
    if (this.optionSet != null) {
      data['optionSet'] = this.optionSet?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
