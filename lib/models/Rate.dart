class Rate {
    double? course;
    String? exchange;
    int? id;
    String? currentdate;

    Rate({ this.course, this.exchange, this.id, this.currentdate});

    factory Rate.fromJson(Map<String, dynamic> json) {
        return Rate(
            course: json['course'], 
            exchange: json['exchange'], 
            id: json['id'],
            currentdate: json['currentdate']
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['course'] = this.course;
        data['exchange'] = this.exchange;
        data['id'] = this.id;
        data['currentdate'] = this.currentdate;
        return data;
    }
}