class ChildModel {
  final String childName;
  final String securtiyCode;
  final String imageUrl;
  final List<String> videos;
  final List<String> channels;

  String? uid;

  ChildModel({
    required this.childName,
    required this.securtiyCode,
    required this.imageUrl,
    required this.videos,
    required this.channels,
  });
  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      childName: json['childname'],
      securtiyCode: json['securityCode'],
      imageUrl: json['imageUrl'],
      videos: List<String>.from(json['videos']),
      channels: List<String>.from(json['channels']),
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'childname': childName,
        'securityCode': securtiyCode,
        'imageUrl': imageUrl,
        'videos': videos,
        'channels': channels,
      };
}
