import 'Customer.dart';
import 'ModelSet.dart';

class CustomerOrder {
  String? currentdate;
  int? id;
  ModelSet? modelset;
  Customer? customer;
  String? description;
  String? active;

  CustomerOrder(
      {this.currentdate,
      this.id,
      this.modelset,
      this.customer,
      this.description,
      this.active});

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
        currentdate: json['currentdate'],
        id: json['id'],
        modelset:
            json['model'] != null ? ModelSet.fromJson(json['model']) : null,
        customer: json['customer'] != null
            ? Customer.fromJson(json['customer'])
            : null,
        description: json['description'],
        active: json['active']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentdate'] = this.currentdate;
    data['id'] = this.id;
    if (this.modelset != null) {
      data['model'] = this.modelset?.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer?.toJson();
    }
    data['description'] = this.description;
    data['active'] = this.active;
    return data;
  }
}
