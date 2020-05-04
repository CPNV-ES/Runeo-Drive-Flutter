import 'package:equatable/equatable.dart';

import 'package:RuneoDriverFlutter/models/comment.dart';
import 'package:RuneoDriverFlutter/models/vehicle_category.dart';
import 'package:RuneoDriverFlutter/models/user.dart';

class Vehicle extends Equatable {
  int id;
  String name;
  String plateNumber;
  int gasLevel;
  int nbPlace;
  String status;
  User user;
  VehicleCategory type;
  List<Comment> comments;

  Vehicle(
      {int id,
      String name,
      String plateNumber,
      int gasLevel,
      int nbPlace,
      String status,
      User user,
      VehicleCategory type,
      List<Comment> comments}) {
    this.id = id;
    this.name = name;
    this.plateNumber = plateNumber;
    this.gasLevel = gasLevel;
    this.nbPlace = nbPlace;
    this.status = status;
    this.user = user;
    this.type = type;
    this.comments = comments;
  }

  @override
  List<Object> get props => [id, name, plateNumber, gasLevel, nbPlace, status, user, type, comments];

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    plateNumber = json['platenumber'];
    gasLevel = json['gaslevel'];
    nbPlace = json['nbplace'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']): null;
    type = json['type'] != null ? new VehicleCategory.fromJson(json['type']) : null;
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['platenumber'] = this.plateNumber;
    data['gaslevel'] = this.gasLevel;
    data['nbplace'] = this.nbPlace;
    data['status'] = this.status;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((e) => e.toJson()).toList();
    }
    return data;
  }
}