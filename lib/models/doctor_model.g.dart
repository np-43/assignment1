// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorModelAdapter extends TypeAdapter<DoctorModel> {
  @override
  final int typeId = 1;

  @override
  DoctorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorModel(
      id: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      profilePic: fields[3] as String?,
      profilePicLocal: fields[4] as String?,
      favorite: fields[5] as bool?,
      primaryContactNo: fields[6] as String?,
      rating: fields[7] as String?,
      emailAddress: fields[8] as String?,
      qualification: fields[9] as String?,
      description: fields[10] as String?,
      specialization: fields[11] as String?,
      languagesKnown: fields[12] as String?,
      dob: fields[13] as DateTime?,
      bloodGroup: fields[14] as String?,
      height: fields[15] as String?,
      weight: fields[16] as String?,
      isEdited: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.profilePic)
      ..writeByte(4)
      ..write(obj.profilePicLocal)
      ..writeByte(5)
      ..write(obj.favorite)
      ..writeByte(6)
      ..write(obj.primaryContactNo)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.emailAddress)
      ..writeByte(9)
      ..write(obj.qualification)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.specialization)
      ..writeByte(12)
      ..write(obj.languagesKnown)
      ..writeByte(13)
      ..write(obj.dob)
      ..writeByte(14)
      ..write(obj.bloodGroup)
      ..writeByte(15)
      ..write(obj.height)
      ..writeByte(16)
      ..write(obj.weight)
      ..writeByte(17)
      ..write(obj.isEdited);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
