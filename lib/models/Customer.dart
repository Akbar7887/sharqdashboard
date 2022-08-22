

class Customer {
  String? email;
  int? id;
  String? name;
  String? phone;

  Customer({this.email, this.id, this.name, this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      email: json['email'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}
