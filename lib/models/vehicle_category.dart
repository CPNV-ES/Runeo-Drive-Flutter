class VehicleCategory {
  String type;
  String description;

  VehicleCategory({this.type, this.description});

  VehicleCategory.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['description'] = this.description;
    return data;
  }
}