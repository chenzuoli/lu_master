import 'package:tuple/tuple.dart';

enum EnumCode {
  NETWORK_ERROR,
  INVALID_PARAMS,
  OBTAIN_OPENID_ERROR,
  UNKOWN_ERROR,
  NO_USER,
  SIGNATURE_ERROR,
  CODE_INVALID,
  CODE_EXPIRED
}

Tuple2 enumCodeToString(EnumCode code) {
  switch (code) {
    case EnumCode.NETWORK_ERROR:
      return Tuple2<int, String>(1001, "网络错误，请重试");
    case EnumCode.INVALID_PARAMS:
      return Tuple2<int, String>(1002, "参数传递有误");
    case EnumCode.OBTAIN_OPENID_ERROR:
      return Tuple2<int, String>(1003, "登录失败，请重新尝试");
    case EnumCode.UNKOWN_ERROR:
      return Tuple2<int, String>(1004, "未知错误，请重试");
    case EnumCode.NO_USER:
      return Tuple2<int, String>(1005, "登录异常，请重新登录");
    case EnumCode.SIGNATURE_ERROR:
      return Tuple2<int, String>(1006, "验证失败，传递信息有误");
    case EnumCode.CODE_INVALID:
      return Tuple2<int, String>(1007, "验证码错误");
    case EnumCode.CODE_EXPIRED:
      return Tuple2<int, String>(1008, "验证码失效");
    default:
      return Tuple2<int, String>(1200, "未知错误");
  }
}
