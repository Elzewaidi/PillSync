// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userIdField: fields[0] as String,
      emailAddressField: fields[1] as String,
      fullNameField: fields[2] as String,
      imageUrlField: fields[3] as String?,
      isVerifiedField: fields[4] as bool,
      tokenField: fields[5] as String,
      phoneNumberField: fields[6] as String?,
      ageField: (fields[7] as num?)?.toInt(),
      birthDateField: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userIdField)
      ..writeByte(1)
      ..write(obj.emailAddressField)
      ..writeByte(2)
      ..write(obj.fullNameField)
      ..writeByte(3)
      ..write(obj.imageUrlField)
      ..writeByte(4)
      ..write(obj.isVerifiedField)
      ..writeByte(5)
      ..write(obj.tokenField)
      ..writeByte(6)
      ..write(obj.phoneNumberField)
      ..writeByte(7)
      ..write(obj.ageField)
      ..writeByte(8)
      ..write(obj.birthDateField);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
