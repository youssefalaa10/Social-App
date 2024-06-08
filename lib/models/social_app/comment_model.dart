class CommentModel {
  late String name;
  late String image;
  late String text;
  late String dateTime;
  late String commentId;

  CommentModel({
    required this.name,
    required this.image,
    required this.text,
    required this.dateTime,
    required this.commentId,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    text = json['text'];
    dateTime = json['dateTime'];
    commentId = json['commentId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'text': text,
      'dateTime': dateTime,
      'commentId': commentId,
    };
  }
}
