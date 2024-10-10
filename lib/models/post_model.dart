class PostModel {
  String postId; // postId is now required and non-nullable
  String name; // name is now required and non-nullable
  String? uId;
  String? image;
  String? dataTime;
  String? text;
  String? postImage;

  PostModel({
    required this.postId, // postId is required
    required this.name, // name is required
    this.uId,
    this.image,
    this.dataTime,
    this.text,
    this.postImage = '',
  });

  // Factory method to create a PostModel from Firestore document data
  factory PostModel.fromJson(Map<String, dynamic> json, String id) {
    return PostModel(
      postId: id, // Assign Firestore document ID to postId
      name: json['name'] as String,
      uId: json['uId'],
      image: json['image'],
      dataTime: json['dataTime'],
      text: json['text'],
      postImage: json['postImage'] ?? '',
    );
  }

  // Method to convert PostModel to a Map to save it in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name, // name is required and not nullable
      'uId': uId ?? '',
      'image': image ?? '',
      'dataTime': dataTime ?? '',
      'text': text ?? '',
      'postImage': postImage ?? '',
    };
  }
}
