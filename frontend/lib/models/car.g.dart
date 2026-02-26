// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 0;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      id: fields[0] as String,
      make: fields[1] as String,
      model: fields[2] as String,
      year: fields[3] as String,
      licensePlate: fields[4] as String,
      imagePath: fields[5] as String,
      isSelected: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.make)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.licensePlate)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
