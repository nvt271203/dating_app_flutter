class Chat {
  String idSender;
  String idReceiver;
  String timeCreated;
  String message;

  // Constructor
  Chat({
    required this.idSender,
    required this.idReceiver,
    required this.timeCreated,
    required this.message,
  });
  // Getter và Setter cho idSender
  String get getIdSender => idSender;
  set setIdSender(String value) {
    idSender = value;
  }

  // Getter và Setter cho idReceiver
  String get getIdReceiver => idReceiver;
  set setIdReceiver(String value) {
    idReceiver = value;
  }

  // Getter và Setter cho timeCreated
  String get getTimeCreated => timeCreated;
  set setTimeCreated(String value) {
    timeCreated = value;
  }

  // Getter và Setter cho message
  String get getMessage => message;
  set setMessage(String value) {
    message = value;
  }

  // Phương thức fromMap để tạo đối tượng Chat từ Map
  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      idSender: data['idSender'] ?? '',
      idReceiver: data['idReceiver'] ?? '',
      timeCreated: data['timeCreated'] ?? '',
      message: data['message'] ?? '',
    );
  }
  // // Phương thức fromMap để tạo đối tượng User từ Map
  // factory User.fromMap(Map<String, dynamic> data) {
  //   return User(
  //     userId: data['userId'] ?? '',
  //     userName: data['userName'] ?? '',
  //     avatar: data['avatar'] ?? '',
  //     email: data['email'] ?? '',
  //   );
  // }
}
