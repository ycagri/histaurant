import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant extends Equatable {
  final String id;
  final String name;
  final String desc;
  final double lat;
  final double lon;
  final int year;
  final String address;
  final String district;
  final String city;
  final String country;
  final String tel;
  final double? rating;
  final String? logo;

  const Restaurant(
      {required this.id,
      required this.name,
      required this.desc,
      required this.lat,
      required this.lon,
      required this.year,
      required this.address,
      required this.district,
      required this.city,
      required this.country,
      required this.tel,
      required this.rating,
      required this.logo});

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toMap() => _$RestaurantToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        desc,
        lat,
        lon,
        year,
        address,
        district,
        city,
        country,
        tel,
        rating,
        logo
      ];

  @override
  String toString() => "$name ($year)";
}
