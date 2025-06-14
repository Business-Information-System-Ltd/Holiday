//import 'package:flutter/material.dart';

class Holiday{
  final int id;
  final String date;
  final String name;
  final String type;
  final bool recurring;
  final String countryCode;
  final String region;
  final String createdAt;
  final String updatedAt;

  Holiday({
    required this.id,
    required this.date,
    required this.name,
    required this.type,
    required this.recurring,
    required this.countryCode,
    required this.region,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Holiday.fromJson(Map<String, dynamic> json){
    return Holiday(
        id: json['id'], 
        date:json['date'], 
        name: json['name'],
        type: json['type'],
        recurring:json['recurring'], 
        countryCode: json['country_code'], 
        region:json['region'], 
        createdAt: json['created_at'], 
        updatedAt:json['updated_at'],
        );
  }

  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'date':date,
      'name':name,
      'type':type,
      'recurring':recurring,
      'country_code':countryCode,
      'region':region,
      'created_at':createdAt,
      'updated_at':updatedAt,
    };
  }
}
