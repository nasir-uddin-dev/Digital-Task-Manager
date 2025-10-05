class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;

  String get fullName => '$firstName $lastName';

  UserModel(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.mobile});

  ///JSON -> OBJECT
  factory UserModel.fromJson(Map<String, dynamic> jsonData) => UserModel(
      id: jsonData['_id'],
      email: jsonData['email'],
      firstName: jsonData['firstName'],
      lastName: jsonData['lastName'],
      mobile: jsonData['mobile']);

  ///OBJECT -> JSON
  Map<String, dynamic> toJson() => {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
    };

}
