import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/pages/about/user.dart';

class UserUtil {
  static Future<UserModel> get_user_info() async {
    var param = {"open_id": Data.open_id, "token": Data.token};
    var result = await DioUtil.get(
        Constant.USER_INFO_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    UserModel user = UserModel.fromJson(result['data']);
    return user;
  }
}
