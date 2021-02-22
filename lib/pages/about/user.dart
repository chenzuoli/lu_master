import 'package:flutter/material.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/util.dart';

class UserPage extends StatefulWidget {
  UserModel user;
  UserPage(UserModel user) : this.user = user;

  @override
  _UserPageState createState() => _UserPageState(user);
}

class _UserPageState extends State<UserPage> {
  UserModel user;

  _UserPageState(UserModel user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectTextItem(
          title: Constant.NICK_NAME,
          content: user.nick_name,
          textAlign: TextAlign.end,
          contentStyle: new TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
        SelectTextItem(
          title: Constant.PHONE_NUMBER,
          content: user.phone,
          textAlign: TextAlign.end,
          contentStyle: new TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}

class UserModel {
  String id;
  String phone;
  String open_id;
  String union_id;
  String pwd;
  String user_type;
  String valid_start_date;
  String valid_end_date;
  String token;
  String country;
  String province;
  String city;
  String avatar_url;
  String gender;
  String nick_name;
  String language;
  String birthday;
  String balance;
  String create_time;
  String update_time;

  UserModel(
      {this.id,
      this.phone,
      this.open_id,
      this.union_id,
      this.pwd,
      this.user_type,
      this.valid_start_date,
      this.valid_end_date,
      this.token,
      this.country,
      this.province,
      this.city,
      this.avatar_url,
      this.gender,
      this.nick_name,
      this.language,
      this.birthday,
      this.balance,
      this.create_time,
      this.update_time});

  static Future<UserModel> requestUserInfo(String open_id) async {
    var param = {"open_id": open_id};
    print("get user info params: " + param.toString());
    var result = await DioUtil.get(
        Constant.USER_INFO_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    print("result: " + result.toString());
    print("state: " + result['data'].toString());
    UserModel user = UserModel.fromJson(result['data']);
    return user;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        phone: json['phone'],
        open_id: json['open_id'],
        union_id: json['union_id'],
        pwd: json['pwd'],
        user_type: json['user_type'],
        valid_start_date: json['valid_start_date'],
        valid_end_date: json['valid_end_date'],
        token: json['token'],
        country: json['country'],
        province: json['province'],
        city: json['city'],
        avatar_url: json['avatar_url'],
        gender: json['gender'],
        nick_name: json['nick_name'],
        language: json['language'],
        birthday: json['birthday'],
        balance: json['balance'],
        create_time: json['create_time'],
        update_time: json['update_time']);
  }

  void printInfo() {
    print(
        "----${this.id}----${this.phone}----${this.open_id}----${this.union_id}"
        "----${this.pwd}----${this.user_type}----${this.valid_start_date}----"
        "${this.valid_end_date}----${this.token}----${this.country}----"
        "${this.province}----${this.city}----${this.avatar_url}----${this.gender}----${this.nick_name}"
        "----${this.language}----${this.birthday}----${this.balance}----${this.create_time}----${this.update_time}");
  }
}
