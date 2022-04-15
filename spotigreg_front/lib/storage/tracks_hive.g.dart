// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TracksHiveAdapter extends TypeAdapter<TracksHive> {
  @override
  final int typeId = 1;

  @override
  TracksHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TracksHive(
      id: fields[0] as String,
      title: fields[1] as String,
      artiste: fields[2] as String,
      duration: fields[3] as String,
      url: fields[4] as String,
      cover: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TracksHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artiste)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.cover);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TracksHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
