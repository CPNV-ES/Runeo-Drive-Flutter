import 'package:equatable/equatable.dart';

class Waypoint extends Equatable{
  String nickname;
  Null geocoding;

  Waypoint({String nickname, Null geocoding}) {
    this.nickname = nickname;
    this.geocoding = geocoding;
  }

  @override
  List<Object> get props => [nickname, geocoding];

  Waypoint.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    geocoding = json['geocoding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['geocoding'] = this.geocoding;
    return data;
  }
}