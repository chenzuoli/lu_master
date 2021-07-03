class CompetitionModel {
  int status;
  String message;
  List<CompetitionItemModel> result;

  CompetitionModel({this.status, this.message, this.result});

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    final originList = json['data'] as List;

    List<CompetitionItemModel> competitionItemModelList = originList
        .map((value) => CompetitionItemModel.fromJson(value))
        .toList();

    return CompetitionModel(
        status: json['status'],
        message: json['message'],
        result: competitionItemModelList);
  }

  void printInfo() {
    print("${this.status}----${this.message}----${this.result}");
  }
}

class CompetitionItemModel {
  int id;
  String competition_id;
  String name;
  String subject;
  String condition;
  String img_url;
  String start_date;
  String end_date;
  String create_time;
  String update_time;

  CompetitionItemModel(
      {this.id,
      this.competition_id,
      this.name,
      this.subject,
      this.condition,
      this.img_url,
      this.start_date,
      this.end_date,
      // ignore: non_constant_identifier_names
      this.create_time,
      this.update_time});

  factory CompetitionItemModel.fromJson(Map<String, dynamic> json) {
    return CompetitionItemModel(
        id: json['id'],
        competition_id: json['competition_id'],
        name: json['name'],
        subject: json['subject'],
        condition: json['condition'],
        img_url: json['img_url'],
        start_date: json['start_date'],
        end_date: json['end_date'],
        create_time: json['create_time'],
        update_time: json['update_time']);
  }
  void printInfo() {
    print(
        "${this.id}----${this.competition_id}----${this.name}----${this.subject}----${this.condition}----"
        "${this.img_url}----${this.start_date}----${this.end_date}----"
        "${this.create_time}----${this.update_time}");
  }
}
