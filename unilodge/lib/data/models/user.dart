class UserModel {
  String? id;
  String? full_name;
  String? email;
  String? profile;

  UserModel({this.id, this.full_name, this.email, this.profile});

  UserModel.fromJson(Map<String, dynamic> data) {
    id = data['_id'];
    full_name = data['full_name'];
    email = data['personal_email'];
    profile = data['profile'];
  }
}
