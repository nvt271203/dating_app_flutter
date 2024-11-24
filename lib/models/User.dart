class User {
  String userId;
  String userName;
  String avatar;
  String email;

  User({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.email,
  });



  // Getter for userId
  String get getUserId => userId;

  // Getter for userName
  String get getUserName => userName;

  // Getter for imgUser
  String get getImgUser => avatar;

  // Getter for email
  String get getEmail => email;

  // Setter for userId
  set setUserId(String id) {
    userId = id;
  }

  // Setter for userName
  set setUserName(String name) {
    userName = name;
  }

  // Setter for imgUser
  set setImgUser(String image) {
    avatar = image;
  }

  // Setter for email
  set setEmail(String emailValue) {
    email = emailValue;
  }

  // Phương thức fromMap để tạo đối tượng User từ Map
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      avatar: data['avatar'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
