// dart model
import 'package:lu_master/pages/photograpier/work_like_comment.dart';

class WorkModel {
  int status;
  String message;
  List<WorkItemModel> result;

  WorkModel({this.status, this.message, this.result});

  factory WorkModel.fromJson(Map<String, dynamic> json) {
    final originList = json['data'] as List;

    List<WorkItemModel> WorkItemModelList =
        originList.map((value) => WorkItemModel.fromJson(value)).toList();

    return WorkModel(
        status: json['status'],
        message: json['message'],
        result: WorkItemModelList);
  }

  void printInfo() {
    print("${this.status}----${this.message}----${this.result}");
  }
}

class WorkItemModel {
  int id;
  String phone;
  String open_id;
  String url;
  String type;
  String subject;
  String nick_name;
  String photographer;
  int votes;
  String tag_id;
  String create_time;
  String update_time;
  WorkLikeCommentModel comments;

  WorkItemModel(
      {this.id,
      this.phone,
      this.open_id,
      this.url,
      this.type,
      this.subject,
      this.nick_name,
      this.photographer,
      this.votes,
      this.tag_id,
      this.create_time,
      this.update_time,
      this.comments});

  factory WorkItemModel.fromJson(Map<String, dynamic> json) {
    return WorkItemModel(
        id: json['id'],
        phone: json['phone'],
        open_id: json['open_id'],
        url: json['url'],
        type: json['type'],
        subject: json['subject'],
        nick_name: json['nick_name'],
        photographer: json['photographer'],
        votes: json['votes'],
        tag_id: json['tag_id'],
        create_time: json['create_time'],
        update_time: json['update_time'],
        comments: json['comments']);
  }

  List<WorkLikeCommentItemModel> filterNoComment(
      List<WorkLikeCommentItemModel> comments) {
    List<WorkLikeCommentItemModel> list = List();
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].comment != null && comments[i] != '') {
        list.add(comments[i]);
      }
    }
    return list;
  }

  void printInfo() {
    print(
        "----${this.id}----${this.phone}----${this.open_id}----${this.url}---" + 
        "-${this.type}----${this.subject}----${this.nick_name}----" + 
        "${this.photographer}----${this.votes}----${this.tag_id}-----${this.create_time}----"+
        "${this.update_time}----${this.comments}");
  }
}
