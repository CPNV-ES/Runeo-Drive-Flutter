import 'package:equatable/equatable.dart';

import 'package:RuneoDriverFlutter/models/waypoint.dart';
import 'package:RuneoDriverFlutter/models/runner.dart';

class Run extends Equatable {
  int id;
  String status;
  String title;
  String beginAt;
  String startAt;
  List<String> updatedAt;
  int paxTbc;
  int timeTbc;
  String endAt;
  String finishedAt;
  int nbPassenger;
  String runinfo;
  String nameContact;
  String numContact;
  String flight;
	String train;
	bool recentlyCreated;
	bool recentlyUpdated;
  List<Waypoint> waypoints;
  List<Runner> runners;

  Run(
      {int id,
      String status,
      String title,
      String beginAt,
      String startAt,
      List<String> updatedAt,
      int paxTbc,
      int timeTbc,
      String endAt,
      String finishedAt,
      int nbPassenger,
      String runinfo,
      String nameContact,
      String numContact,
      String flight,
			String train,
			bool recentlyCreated,
			bool recentlyUpdated,
      List<Waypoint> waypoints,
      List<Runner> runners}) {
    this.id = id;
    this.status = status;
    this.title = title;
    this.beginAt = beginAt;
    this.startAt = startAt ?? null;
    this.updatedAt = updatedAt;
    this.paxTbc = paxTbc;
    this.timeTbc = timeTbc;
    this.endAt = endAt ?? null;
    this.finishedAt = finishedAt;
    this.nbPassenger = nbPassenger;
    this.runinfo = runinfo;
    this.nameContact = nameContact ?? null;
    this.numContact = numContact ?? null;
    this.flight = flight ?? null;
		this.train = train ?? null;
		this.recentlyCreated = recentlyCreated ?? false;
		this.recentlyUpdated = recentlyUpdated ?? false;
    this.waypoints = waypoints;
    this.runners = runners;
  }

	@override
	List<Object> get props => [id, title, beginAt, finishedAt, startAt, endAt, waypoints, runners, runinfo, status, nameContact, numContact, flight, train, updatedAt, nbPassenger, paxTbc, timeTbc];

	set setRecentlyCreated(bool recentlyCreated) => this.recentlyCreated = recentlyCreated;
	set setRecentlyUpdated(bool recentlyUpdated) => this.recentlyUpdated = recentlyUpdated;

  Run.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    title = json['title'];
    beginAt = json['begin_at'];
    startAt = json['start_at'];
    if (json['updated_at'] != null) {
      new List<String>.from(json['updated_at']);
    }
    paxTbc = json['pax_tbc'];
    timeTbc = json['time_tbc'];
    endAt = json['end_at'];
    finishedAt = json['finished_at'];
    nbPassenger = json['nb_passenger'];
    runinfo = json['runinfo'];
    nameContact = json['name_contact'];
    numContact = json['num_contact'];
    flight = json['flight'];
    train = json['train'];
    if (json['waypoints'] != null) {
      waypoints = new List<Waypoint>();
      json['waypoints'].forEach((v) {
        waypoints.add(new Waypoint.fromJson(v));
      });
    }
    if (json['runners'] != null) {
      runners = new List<Runner>();
      json['runners'].forEach((v) {
        runners.add(new Runner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['title'] = this.title;
    data['begin_at'] = this.beginAt;
    data['start_at'] = this.startAt;
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt;
    }
    data['pax_tbc'] = this.paxTbc;
    data['time_tbc'] = this.timeTbc;
    data['end_at'] = this.endAt;
    data['finished_at'] = this.finishedAt;
    data['nb_passenger'] = this.nbPassenger;
    data['runinfo'] = this.runinfo;
    data['name_contact'] = this.nameContact;
    data['num_contact'] = this.numContact;
    data['flight'] = this.flight;
    data['train'] = this.train;
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints.map((v) => v.toJson()).toList();
    }
    if (this.runners != null) {
      data['runners'] = this.runners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}