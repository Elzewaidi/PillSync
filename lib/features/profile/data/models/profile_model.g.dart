// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final typeId = 2;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      userIdField: fields[0] as String,
      fullNameField: fields[1] as String,
      emailAddressField: fields[2] as String,
      phoneNumberField: fields[3] as String?,
      imageUrlField: fields[4] as String?,
      ageField: (fields[5] as num?)?.toInt(),
      birthDateField: fields[6] as String?,
      createdAtField: fields[7] as DateTime?,
      updatedAtField: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userIdField)
      ..writeByte(1)
      ..write(obj.fullNameField)
      ..writeByte(2)
      ..write(obj.emailAddressField)
      ..writeByte(3)
      ..write(obj.phoneNumberField)
      ..writeByte(4)
      ..write(obj.imageUrlField)
      ..writeByte(5)
      ..write(obj.ageField)
      ..writeByte(6)
      ..write(obj.birthDateField)
      ..writeByte(7)
      ..write(obj.createdAtField)
      ..writeByte(8)
      ..write(obj.updatedAtField);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
