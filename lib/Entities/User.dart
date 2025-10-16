class User {
  final String username;
  final String email;
  final String fullName;
  User({required this.email,required this.fullName,required this.username});
  Map<String,dynamic> toMap(){
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
    };
  }
  
  factory User.fromMap(Map<String,dynamic> map){
    return User(
      username: map['username'],
      email: map['email'],
      fullName: map['fullName'],
    );
  }
}