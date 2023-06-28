// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

School _$SchoolFromJson(Map<String, dynamic> json) => School(
      json['name'] as String,
      $enumDecode(_$SchoolTypeEnumMap, json['type']),
      json['phone_num'] as String,
      json['email'] as String,
      json['address'] as String,
      json['website'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$SchoolTypeEnumMap[instance.type]!,
      'phone_num': instance.phoneNum,
      'email': instance.email,
      'address': instance.address,
      'website': instance.website,
      'id': instance.id,
    };

const _$SchoolTypeEnumMap = {
  SchoolType.directSubsidy: 'direct_subsidy',
  SchoolType.government: 'government',
  SchoolType.aided: 'aided',
};

Slp _$SlpFromJson(Map<String, dynamic> json) => Slp(
      json['name'] as String,
      json['email'] as String,
      json['password'] as String,
      $enumDecode(_$GenderEnumMap, json['gender']),
      json['id'] as String,
    );

Map<String, dynamic> _$SlpToJson(Slp instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'gender': _$GenderEnumMap[instance.gender]!,
      'id': instance.id,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      json['name'] as String,
      $enumDecode(_$GenderEnumMap, json['gender']),
      DateTime.parse(json['dob'] as String),
      json['diagnosis'] as String,
      $enumDecode(_$StudentFormEnumMap, json['form']),
      json['id'] as String,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender]!,
      'dob': instance.dob.toIso8601String(),
      'diagnosis': instance.diagnosis,
      'form': _$StudentFormEnumMap[instance.form]!,
      'id': instance.id,
    };

const _$StudentFormEnumMap = {
  StudentForm.f1: 'f1',
  StudentForm.f2: 'f2',
  StudentForm.f3: 'f3',
  StudentForm.f4: 'f4',
  StudentForm.f5: 'f5',
  StudentForm.f6: 'f6',
};
