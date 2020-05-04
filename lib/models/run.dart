import 'package:RuneoDriverFlutter/models/waypoint.dart';
import 'package:RuneoDriverFlutter/models/runner.dart';
import 'package:equatable/equatable.dart';

class Run extends Equatable {
  int id;
  String status;
  String title;
  DateTime beginAt;
  DateTime startAt;
  List<String> updatedAt;
  int paxTbc;
  int timeTbc;
  DateTime endAt;
  DateTime finishedAt;
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
      DateTime beginAt,
      DateTime startAt,
      List<String> updatedAt,
      int paxTbc,
      int timeTbc,
      DateTime endAt,
      DateTime finishedAt,
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
		this.recentlyCreated = recentlyCreated;
		this.recentlyUpdated = recentlyUpdated;
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
    beginAt = json['beginat'];
    startAt = json['startat'];
    if (json['updatedat'] != null) {
      new List<String>.from(json['updatedat']);
    }
    paxTbc = json['paxtbc'];
    timeTbc = json['timetbc'];
    endAt = json['endat'];
    finishedAt = json['finishedat'];
    nbPassenger = json['nbpassenger'];
    runinfo = json['runinfo'];
    nameContact = json['namecontact'];
    numContact = json['numcontact'];
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
    data['beginat'] = this.beginAt;
    data['startat'] = this.startAt;
    if (this.updatedAt != null) {
      data['updatedat'] = this.updatedAt;
    }
    data['paxtbc'] = this.paxTbc;
    data['timetbc'] = this.timeTbc;
    data['endat'] = this.endAt;
    data['finishedat'] = this.finishedAt;
    data['nbpassenger'] = this.nbPassenger;
    data['runinfo'] = this.runinfo;
    data['namecontact'] = this.nameContact;
    data['numcontact'] = this.numContact;
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