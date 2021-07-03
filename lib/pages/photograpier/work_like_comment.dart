// dart model
class WorkLikeCommentModel {
  int status;
  String message;
  List<WorkLikeCommentItemModel> result;

  WorkLikeCommentModel({this.status, this.message, this.result});

  factory WorkLikeCommentModel.fromJson(Map<String, dynamic> json) {
    final originList = json['data'] as List;
    if (originList == null) return WorkLikeCommentModel();
    List<WorkLikeCommentItemModel> workItemModelList = originList
        .map((value) => WorkLikeCommentItemModel.fromJson(value))
        .toList();
    return WorkLikeCommentModel(
        status: json['status'],
        message: json['message'],
        result: workItemModelList);
  }
  void printInfo() {
    print("${this.status}----${this.message}----${this.result}");
  }
}

class WorkLikeCommentItemModel {
  int id;
  String photography_id;
  String competition_id;
  String open_id;
  int comment_id;
  String comment;
  bool is_vote;
  String create_time;
  String update_time;
  WorkLikeCommentItemModel(
      {this.id,
      this.photography_id,
      this.competition_id,
      this.open_id,
      this.comment_id,
      this.comment,
      this.is_vote,
      this.create_time,
      this.update_time});

  factory WorkLikeCommentItemModel.fromJson(Map<String, dynamic> json) {
    return WorkLikeCommentItemModel(
        id: json['id'],
        photography_id: json['photography_id'],
        competition_id: json['competition_id'],
        open_id: json['open_id'],
        comment_id: json['comment_id'],
        comment: json['comment'],
        is_vote: json['is_vote'],
        create_time: json['create_time'],
        update_time: json['update_time']);
  }
  void printInfo() {
    print(
        "${this.id}----${this.photography_id}----${this.competition_id}----${this.open_id}----${this.comment_id}----${this.comment}----${this.is_vote}----${this.create_time}----${this.update_time}");
  }
}
