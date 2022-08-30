class ProfileModel {
  late bool status;
  late int id;
  late String name;
  late String email;
  late String phone;
  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    id = json['data']['id'];
    name = json['data']['name'];
    email = json['data']['email'];
    phone = json['data']['phone'];
  }
}
