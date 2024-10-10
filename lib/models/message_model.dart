class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.text,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      dateTime: json['dateTime'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
