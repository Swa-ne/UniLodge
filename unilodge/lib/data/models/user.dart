class UserModel {
  String? fullName;
  String? email;
  String? imageURL;

  UserModel({this.fullName, this.email, this.imageURL});

  UserModel.fromJson(Map<String, dynamic> data) {
    fullName = data['name'];
    email = data['email'];
  }
}
