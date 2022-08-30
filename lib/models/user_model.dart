class UserModel {
  late bool status;
  late String message;
  String? token;
  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      token = json['data']['token'];
    }
  }
}
