class CommentModel {
  String? name;
  String? image;
  String? text;
  String? dateTime;
  String? commentId;

  // Constructor with optional fields
  CommentModel({
    this.name,
    this.image,
    this.text,
    this.dateTime,
    this.commentId,
  });

  // Named constructor to create an object from JSON with null-safety checks
 factory CommentModel.fromJson(Map<String, dynamic> json)
      {
        return CommentModel(
          name: json['name'],
          image: json['image'],
          text: json['text'],
          dateTime: json['dateTime'],
          commentId: json['commentId'],
        );
      }

  // Method to convert the object to a Map (for storing data)
  Map<String, dynamic> toMap() {
    return {
      'name': name ?? '',
      'image': image ?? '',
      'text': text ?? '',
      'dateTime': dateTime ?? '',
      'commentId': commentId ?? '',
    };
  }
}
