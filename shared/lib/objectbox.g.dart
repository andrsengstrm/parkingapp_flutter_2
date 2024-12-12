// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;

import 'models/parking.dart';
import 'models/parking_space.dart';
import 'models/person.dart';
import 'models/vehicle.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 2827233230222059718),
      name: 'Parking',
      lastPropertyId: const obx_int.IdUid(7, 7752874878956729229),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 9162117939563496558),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6654514823008871065),
            name: 'startTime',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7862163815216777840),
            name: 'endTime',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 5623470963209636989),
            name: 'vehicleDb',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 7752874878956729229),
            name: 'parkingSpaceDb',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 7971679284233146659),
      name: 'ParkingSpace',
      lastPropertyId: const obx_int.IdUid(3, 4926862837850440094),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4235565167012212242),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3388345047582911590),
            name: 'address',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 4926862837850440094),
            name: 'pricePerHour',
            type: 8,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 6204732547452475028),
      name: 'Person',
      lastPropertyId: const obx_int.IdUid(4, 5753084926534769011),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7262708376117770237),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6002183484536268670),
            name: 'personId',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 8269673697602762211),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5753084926534769011),
            name: 'email',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 2852842459744921116),
      name: 'Vehicle',
      lastPropertyId: const obx_int.IdUid(8, 2627394452066168480),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 3521521379886025542),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 2651199704286083081),
            name: 'regId',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 167106927899938160),
            name: 'personOwner',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 2627394452066168480),
            name: 'vehicleType',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
obx.Store openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) {
  return obx.Store(getObjectBoxModel(),
      directory: directory,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(5, 2852842459744921116),
      lastIndexId: const obx_int.IdUid(1, 3143467106540658847),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [2873583754072079135],
      retiredIndexUids: const [3143467106540658847],
      retiredPropertyUids: const [
        2467096810797741914,
        5592838161900795093,
        2034654012159923427,
        5478732290347115486,
        7255081794660306940,
        2431658961351374028,
        579306653700035187,
        8153576999914725724
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Parking: obx_int.EntityDefinition<Parking>(
        model: _entities[0],
        toOneRelations: (Parking object) => [],
        toManyRelations: (Parking object) => {},
        getId: (Parking object) => object.id,
        setId: (Parking object, int id) {
          object.id = id;
        },
        objectToFB: (Parking object, fb.Builder fbb) {
          final startTimeOffset = fbb.writeString(object.startTime);
          final endTimeOffset =
              object.endTime == null ? null : fbb.writeString(object.endTime!);
          final vehicleDbOffset = fbb.writeString(object.vehicleDb);
          final parkingSpaceDbOffset = fbb.writeString(object.parkingSpaceDb);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, startTimeOffset);
          fbb.addOffset(2, endTimeOffset);
          fbb.addOffset(5, vehicleDbOffset);
          fbb.addOffset(6, parkingSpaceDbOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final startTimeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final endTimeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final object = Parking(
              id: idParam, startTime: startTimeParam, endTime: endTimeParam)
            ..vehicleDb = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 14, '')
            ..parkingSpaceDb = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 16, '');

          return object;
        }),
    ParkingSpace: obx_int.EntityDefinition<ParkingSpace>(
        model: _entities[1],
        toOneRelations: (ParkingSpace object) => [],
        toManyRelations: (ParkingSpace object) => {},
        getId: (ParkingSpace object) => object.id,
        setId: (ParkingSpace object, int id) {
          object.id = id;
        },
        objectToFB: (ParkingSpace object, fb.Builder fbb) {
          final addressOffset = fbb.writeString(object.address);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, addressOffset);
          fbb.addFloat64(2, object.pricePerHour);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final addressParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final pricePerHourParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final object = ParkingSpace(
              id: idParam,
              address: addressParam,
              pricePerHour: pricePerHourParam);

          return object;
        }),
    Person: obx_int.EntityDefinition<Person>(
        model: _entities[2],
        toOneRelations: (Person object) => [],
        toManyRelations: (Person object) => {},
        getId: (Person object) => object.id,
        setId: (Person object, int id) {
          object.id = id;
        },
        objectToFB: (Person object, fb.Builder fbb) {
          final personIdOffset = fbb.writeString(object.personId);
          final nameOffset = fbb.writeString(object.name);
          final emailOffset =
              object.email == null ? null : fbb.writeString(object.email!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, personIdOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, emailOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final personIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final emailParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 10);
          final object = Person(
              id: idParam,
              personId: personIdParam,
              name: nameParam,
              email: emailParam);

          return object;
        }),
    Vehicle: obx_int.EntityDefinition<Vehicle>(
        model: _entities[3],
        toOneRelations: (Vehicle object) => [],
        toManyRelations: (Vehicle object) => {},
        getId: (Vehicle object) => object.id,
        setId: (Vehicle object, int id) {
          object.id = id;
        },
        objectToFB: (Vehicle object, fb.Builder fbb) {
          final regIdOffset = fbb.writeString(object.regId);
          final personOwnerOffset = fbb.writeString(object.personOwner);
          final vehicleTypeOffset = fbb.writeString(object.vehicleType);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, regIdOffset);
          fbb.addOffset(6, personOwnerOffset);
          fbb.addOffset(7, vehicleTypeOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final regIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final vehicleTypeParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 18, '');
          final object = Vehicle(
              id: idParam, regId: regIdParam, vehicleType: vehicleTypeParam)
            ..personOwner = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 16, '');

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Parking] entity fields to define ObjectBox queries.
class Parking_ {
  /// See [Parking.id].
  static final id =
      obx.QueryIntegerProperty<Parking>(_entities[0].properties[0]);

  /// See [Parking.startTime].
  static final startTime =
      obx.QueryStringProperty<Parking>(_entities[0].properties[1]);

  /// See [Parking.endTime].
  static final endTime =
      obx.QueryStringProperty<Parking>(_entities[0].properties[2]);

  /// See [Parking.vehicleDb].
  static final vehicleDb =
      obx.QueryStringProperty<Parking>(_entities[0].properties[3]);

  /// See [Parking.parkingSpaceDb].
  static final parkingSpaceDb =
      obx.QueryStringProperty<Parking>(_entities[0].properties[4]);
}

/// [ParkingSpace] entity fields to define ObjectBox queries.
class ParkingSpace_ {
  /// See [ParkingSpace.id].
  static final id =
      obx.QueryIntegerProperty<ParkingSpace>(_entities[1].properties[0]);

  /// See [ParkingSpace.address].
  static final address =
      obx.QueryStringProperty<ParkingSpace>(_entities[1].properties[1]);

  /// See [ParkingSpace.pricePerHour].
  static final pricePerHour =
      obx.QueryDoubleProperty<ParkingSpace>(_entities[1].properties[2]);
}

/// [Person] entity fields to define ObjectBox queries.
class Person_ {
  /// See [Person.id].
  static final id =
      obx.QueryIntegerProperty<Person>(_entities[2].properties[0]);

  /// See [Person.personId].
  static final personId =
      obx.QueryStringProperty<Person>(_entities[2].properties[1]);

  /// See [Person.name].
  static final name =
      obx.QueryStringProperty<Person>(_entities[2].properties[2]);

  /// See [Person.email].
  static final email =
      obx.QueryStringProperty<Person>(_entities[2].properties[3]);
}

/// [Vehicle] entity fields to define ObjectBox queries.
class Vehicle_ {
  /// See [Vehicle.id].
  static final id =
      obx.QueryIntegerProperty<Vehicle>(_entities[3].properties[0]);

  /// See [Vehicle.regId].
  static final regId =
      obx.QueryStringProperty<Vehicle>(_entities[3].properties[1]);

  /// See [Vehicle.personOwner].
  static final personOwner =
      obx.QueryStringProperty<Vehicle>(_entities[3].properties[2]);

  /// See [Vehicle.vehicleType].
  static final vehicleType =
      obx.QueryStringProperty<Vehicle>(_entities[3].properties[3]);
}
