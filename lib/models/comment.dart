import 'package:RuneoDriverFlutter/models/user.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
	int id;
	String content;
	User user;
	String created_at;

	Comment(
		{
			int id,
			String content,
			User user,
			String created_at
		}
	) {
		this.id = id;
		this.content = content;
		this.user = user;
		this.created_at = created_at;
	}

	@override
  List<Object> get props => [id, content, user, created_at];

	Comment.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		content = json['content'];
		user = json['user'] != null ? new User.fromJson(json['user']): null;
		created_at = json['created_at'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['content'] = this.content;
		if (this.user != null) {
			data['user'] = this.user.toJson();
		}
		data['created_at'] = this.created_at;
	}
}