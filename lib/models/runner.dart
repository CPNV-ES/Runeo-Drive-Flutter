import 'package:equatable/equatable.dart';

import 'package:RuneoDriverFlutter/models/user.dart';
import 'package:RuneoDriverFlutter/models/vehicle.dart';
import 'package:RuneoDriverFlutter/models/vehicle_category.dart';

class Runner extends Equatable {
  int id;
  User user;
  VehicleCategory vehicleCategory;
  Vehicle vehicle;

  Runner({int id, User user, VehicleCategory vehicleCategory, Vehicle vehicle}) {
    this.id = id;
    this.user = user;
    this.vehicleCategory = vehicleCategory;
    this.vehicle = vehicle;
  }

  @override
  List<Object> get props => [id, user, vehicleCategory, vehicle];

  Runner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    vehicleCategory = json['vehiclecategory'] != null ? new VehicleCategory.fromJson(json['vehicleCategory']) : null;
    vehicle = json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    
    if (this.vehicleCategory != null) {
      data['vehiclecategory'] = this.vehicleCategory.toJson();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle.toJson();
    }
    return data;
  }
}
