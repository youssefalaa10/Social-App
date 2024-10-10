class SocialUserModel {
  String name;
  String email;
  String phone;
  String uId;
  String image;
  String cover;
  String bio;
  bool isEmailVerified;

  // Constructor with required and optional fields
  SocialUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    this.image = '',
    this.cover = '',
    this.bio = '',
    this.isEmailVerified = false,
  });

  // Named constructor to create an object from JSON, with validation
  factory SocialUserModel.fromJson(Map<String, dynamic> json) {
    return SocialUserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uId: json['uId'],
      image: json['image'] ?? '',
      cover: json['cover'] ?? '',
      bio: json['bio'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }

  // Method to convert object to a Map (to be used when saving data)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
