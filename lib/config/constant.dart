class Constant {
  static const String APP_NAME = "Lu Master";

  static const String LOGIN = 'login';
  static const String BASE_URL = "https://pipilong.pet:7449/photography/";
  static const String COMPETITION_LIST_URL = BASE_URL + "get_competitions";
  static const String PHOTOGRAPHY_LIST_URL = BASE_URL + "get_photographies";
  static const String REGISTER_APP_URL = BASE_URL + "register_app";
  static const String LOGIN_APP_URL = BASE_URL + "login_app";
  static const String UPLOAD_FILE_URL = BASE_URL + "upload_file";
  static const String UPDATE_PASSWORD_URL = BASE_URL + "update_app_pass";

  static const String PHOTOGRAPHY_LIST_API = "get_photographies";
  static const String PHOTOGRAPHY_ADD_API = "add_photography";
  static const String WORK_ADD_API = "add_photo";
  static const String WORK_LIKE_COMMENT_API = "get_comment_by_id";
  static const String WORK_UPDATE_VOTE_API = "update_vote";
  static const String WORK_ADD_LIKE_API = "add_like";
  static const String COMMENT_ADD_LIKE_API = "add_comment_like";
  static const String WORK_COMMENT_API = "comment";
  static const String WORK_DELETE_COMMENT_API = "delete_comment";
  static const String COMPETITION_WORK_LIST_API = "get_votes";
  static const String REGISTER_APP_API = "register_app";
  static const String UPLOAD_FILE_API = "upload_file";
  static const String UPDATE_PASSWORD_API = "update_app_pass";
  static const String USER_INFO_API = "get_app_user";
  static const String UPDATE_NICKNAME_API = "update_nick_name";
  static const String ADD_FEEDBACK_API = "add_feedback";

  static const String MASTER_PAGE_NAME = "撸大师";
  static const String HOME_PAGE_NAME = "首页";
  static const String ABOUT_PAGE_NAME = "我的";
  static const String CONTACT_PAGE_NAME = "通讯录";
  static const String BLANK_PAGE_NAME = "空页面";
  static const String ADD_WORK_PAGE_NAME = "添加作品";
  static const String PASSWORD_PAGE_NAME = "更新密码";
  static const String NICKNAME_PAGE_NAME = "更新昵称";
  static const String FEEDBACK_PAGE_NAME = "添加反馈";

  static const String COMPETITION_CONDITION_BTN_NAME = "比赛条件";
  static const String COMPETITION_LIST_PAGE_NAME = "比赛列表";
  static const String COMPETITION_INFO_NAME = "比赛详情";
  static const String WORK_LIST_START_DATE = "比赛开始时间";
  static const String WORK_LIST_END_DATE = "比赛结束时间";
  static const String WORK_LIST_NAME = "作品列表";
  static const String WORK_COMMENT_PAGE_NAME = "评论";
  static const String WORK_COMMENT_BTN_NAME = "发表评论";
  static const String WORK_COMMENT_EMPTY_CONTENT = "暂时还没人评论呢...";

  static const String LOGIN_PAGE_NAME = "登录";
  static const String REGISTER_PAGE_NAME = "注册";

  static const String NICK_NAME = "噜噜名";
  static const String PHONE_NUMBER = "手机号";

  static const String CONTENT_TYPE_JSON = "application/json";
  static const String CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static const String CONTENT_TYPE_TEXT = "text/plain";
  static const String CONTENT_TYPE_FILE = "multipart/form-data;charset=utf-8";
}

class Data {
  static String open_id = "";
  static String token = "";
}
