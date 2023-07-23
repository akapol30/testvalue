// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_list_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCard _$MyCardFromJson(Map<String, dynamic> json) => MyCard(
      foodname: json['foodname'] as String?,
      foodtype: json['foodtype'] as String?,
      ingredient: json['ingredient'] as List<dynamic>?,
      quantity: json['quantity'] as List<dynamic>?,
      uom: json['uom'] as List<dynamic>?,
      step: json['step'] as List<dynamic>?,
      pic: json['pic'] as List<dynamic>?,
      region: json['region'] as String?,
      recipetype: json['recipetype'] as String?,
    );

Map<String, dynamic> _$MyCardToJson(MyCard instance) => <String, dynamic>{
      'foodname': instance.foodname,
      'foodtype': instance.foodtype,
      'region': instance.region,
      'recipetype': instance.recipetype,
      'ingredient': instance.ingredient,
      'quantity': instance.quantity,
      'uom': instance.uom,
      'step': instance.step,
      'pic': instance.pic,
    };

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      foodname: json['foodname'] as String?,
      foodtype: json['foodtype'] as String?,
      ingredient: json['ingredient'] as List<dynamic>?,
      quantity: json['quantity'] as List<dynamic>?,
      uom: json['uom'] as List<dynamic>?,
      step: json['step'] as List<dynamic>?,
      pic: json['pic'] as List<dynamic>?,
      region: json['region'] as String?,
      recipetype: json['recipetype'] as String?,
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'foodname': instance.foodname,
      'foodtype': instance.foodtype,
      'region': instance.region,
      'recipetype': instance.recipetype,
      'ingredient': instance.ingredient,
      'quantity': instance.quantity,
      'uom': instance.uom,
      'step': instance.step,
      'pic': instance.pic,
    };
