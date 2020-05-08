import 'package:equatable/equatable.dart';

import 'package:RuneoDriverFlutter/models/run.dart';

class User extends Equatable {
  int id;
  String name;
  String firstname;
  String lastname;
  String email;
  String phoneNumber;
  String status;
  String imageProfile;
  bool hasNotificationToken;

  User(
      {int id,
      String name,
      String firstname,
      String lastname,
      String email,
      String phoneNumber,
      String status,
      String imageProfile,
      bool hasNotificationToken}) {
    this.id = id;
    this.name = name;
    this.firstname = firstname;
    this.lastname = lastname;
    this.email = email;
    this.phoneNumber = phoneNumber ?? null;
    this.status = status;
    this.imageProfile = imageProfile ?? 'assets/user/user.jpg';
    this.hasNotificationToken = hasNotificationToken;
  }

	@override
  List<Object> get props => [id, name, firstname, lastname, email, imageProfile, phoneNumber, hasNotificationToken];

	String get fullname => '$firstname $lastname';

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    imageProfile = json['image_profile'];
    hasNotificationToken = json['has_notification_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['image_profile'] = this.imageProfile;
    data['has_notification_token'] = this.hasNotificationToken;
    return data;
  }
}