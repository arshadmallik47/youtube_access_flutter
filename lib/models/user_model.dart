class UserModel {
  // constructor
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.createdAt,
    this.profileImage,
  });

  final String uid;
  final String userName;
  final String email;
  final String? profileImage;

  final DateTime createdAt;

  // from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      userName: json['userName'],
      email: json['email'],
      profileImage: json['profileImage'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['createdAt'].millisecondsSinceEpoch),
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userName': userName,
        'email': email,
        'profileImage': profileImage,
        'createdAt': createdAt,
      };
}
