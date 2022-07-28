// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      year: json['year'] as int,
      address: json['address'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      tel: json['tel'] as String,
      rating: (json['rating'] as num).toDouble(),
      logo: json['logo'] as String?,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'lat': instance.lat,
      'lon': instance.lon,
      'year': instance.year,
      'address': instance.address,
      'district': instance.district,
      'city': instance.city,
      'country': instance.country,
      'tel': instance.tel,
      'rating': instance.rating,
      'logo': instance.logo,
      'distance': instance.distance,
    };
