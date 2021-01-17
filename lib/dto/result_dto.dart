import 'package:lu_master/code/code.dart';

class ResultDTO {
  int status;
  var data;
  String message;
  ResultDTO(int status, var data, String message) {
    this.status = status;
    this.data = data;
    this.message = message;
  }
  static ResultDTO ok(var data) {
    return new ResultDTO(200, data, "请求成功");
  }

  static ResultDTO fail(EnumCode resultCode) {
    return new ResultDTO(enumCodeToString(resultCode).item1, "",
        enumCodeToString(resultCode).item2);
  }
}
