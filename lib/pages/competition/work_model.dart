class CompetitionWorkModel {
  int status;
  String message;
  List<CompetitionWorkItemModel> result;

  CompetitionWorkModel({this.status, this.message, this.result});

  factory CompetitionWorkModel.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['status'] != 200) {
      return CompetitionWorkModel(
          status: json['status'], message: json['message'], result: List());
    }
    final originList = json['data'] as List;

    List<CompetitionWorkItemModel> CompetitionWorkItemModelList = originList
        .map((value) => CompetitionWorkItemModel.fromJson(value))
        .toList();

    return CompetitionWorkModel(
        status: json['status'],
        message: json['message'],
        result: CompetitionWorkItemModelList);
  }

  void printInfo() {
    print("${this.status}----${this.message}----${this.result}");
  }
}

class CompetitionWorkItemModel {
  int id;
  String competition_id;
  String phone;
  String open_id;
  String subject;
  String nick_name;
  String type;
  String url;
  int votes;
  String create_time;
  String update_time;

  CompetitionWorkItemModel(
      {this.id,
        this.competition_id,
      this.phone,
      this.open_id,
      this.subject,
      this.nick_name,
      this.type,
      this.url,
      this.votes,
      // ignore: non_constant_identifier_names
      this.create_time,
      this.update_time});

  factory CompetitionWorkItemModel.fromJson(Map<String, dynamic> json) {
    return CompetitionWorkItemModel(
      id: json['id'],
        competition_id: json['competition_id'],
        phone: json['phone'],
        open_id: json['open_id'],
        subject: json['subject'],
        nick_name: json['nick_name'],
        type: json['type'],
        url: json['url'],
        votes: json['votes'],
        create_time: json['create_time'],
        update_time: json['update_time']);
  }

  void printInfo() {
    print(
        "${this.id}----${this.competition_id}----${this.phone}----${this.open_id}----${this.subject}----"
        "${this.nick_name}----${this.type}----${this.url}----${this.votes}----"
        "${this.create_time}----${this.update_time}");
  }
}
