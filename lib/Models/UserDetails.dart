class UserDetails {
  String firstName;
  String lastName;
  String nickName;
  String email;
  String authDocId;

  UserDetails({this.authDocId, this.email,this.firstName,this.lastName,this.nickName});

  Map<String, dynamic> toJson() =>
    {
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'email': email,
      'authDocId': authDocId,
    };
}