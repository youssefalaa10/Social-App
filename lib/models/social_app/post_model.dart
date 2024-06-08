class PostModel
{
  late String name;
  late String uId;
  late String image;
  late String dataTime;
  late String text;
  late String postImage;


  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    required this.dataTime,
    required this.text,
    required this.postImage,


  });

  PostModel.fromJson(Map<String,dynamic>json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dataTime = json['dataTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dataTime':dataTime,
      'text':text,
      'postImage':postImage,
    };
  }
}