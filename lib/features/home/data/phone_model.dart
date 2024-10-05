import 'dart:io';

class PhoneModel {
  final String name;
  final File image;
  final int? price;
  final DateTime dateTime;
  final String? description;

  PhoneModel(
      {required this.name,
      required this.image,
      required this.dateTime,
      this.price,
      this.description});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': image.path,
      'price': price,
      'dateTime': dateTime.toIso8601String(),
      'description': description
    };
  }

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
        name: json['name'],
        image: File(json['imagePath']),
        price: json['price'],
        dateTime: DateTime.parse(json['dateTime']),
        description: json['description']);
  }
}
