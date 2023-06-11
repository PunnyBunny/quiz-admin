import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class School {
  String name;
  SchoolType type;
  String phoneNum;
  String email;
  String address;
  String website;

  School(
    this.name,
    this.type,
    this.phoneNum,
    this.email,
    this.address,
    this.website,
  );

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);
  Map<String, dynamic> toJson() => _$SchoolToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Slp {
  String name;
  String email;
  String password;
  Gender gender;

  Slp(this.name, this.email, this.password, this.gender);
  
  factory Slp.fromJson(Map<String, dynamic> json) => _$SlpFromJson(json);
  Map<String, dynamic> toJson() => _$SlpToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Student {
  String name;
  Gender gender;
  DateTime dob; // date of birth
  String diagnosis;
  StudentForm form;

  Student(this.name, this.gender, this.dob, this.diagnosis, this.form);
  
  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum SchoolType {
  directSubsidy,
  government,
  aided;

  String get chineseName {
    if (this == SchoolType.directSubsidy) return '直資';
    if (this == SchoolType.government) return '官立';
    return '資助';
  }


}

@JsonEnum(fieldRename: FieldRename.snake)
enum Gender {
  male,
  female;

  String get chineseName => this == Gender.male ? "男" : "女";
}

// the form (級別) of a student, not a literal form
@JsonEnum(fieldRename: FieldRename.snake)
enum StudentForm {
  f1,
  f2,
  f3,
  f4,
  f5,
  f6;

  String get chineseName {
    return "中${"一二三四五六"[StudentForm.values.indexOf(this)]}";
  }
}
