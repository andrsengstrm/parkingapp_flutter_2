import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkingapp_user/blocs/vehicles_bloc.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/vehicle.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class FakeVehicle extends Fake implements Vehicle {}

void main() {

  group('VehiclesBloc', (){
    
    late VehicleRepository vehicleRepository;
    Vehicle newVehicle = Vehicle(regId: "some regId", vehicleType: "some vehicleType");

    setUpAll((){
       vehicleRepository = MockVehicleRepository();
       registerFallbackValue(FakeVehicle());
    });

    blocTest<VehiclesBloc, VehiclesState>(
      'Test that CreateVehicle emits VehiclesSuccess',
      setUp: (){
        when(() => vehicleRepository.create(any()))
          .thenAnswer((_) async => newVehicle);
        when(() => vehicleRepository.readByOwnerEmail(any()))
          .thenAnswer((_) async => [newVehicle]);
      },
      build: () => VehiclesBloc(repository: vehicleRepository),
      act: (bloc) => bloc.add(CreateVehicle(vehicle: newVehicle)),
      expect: () => [
        VehiclesSuccess(vehiclesList: [newVehicle])
      ],
      verify: (_) {
        verify(() => vehicleRepository.create(any())).called(1);
      }
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'Test that CreateVehicle emits VehiclesError when null is returned',
      setUp: (){
        when(() => vehicleRepository.create(any()))
          .thenAnswer((_) async => null);
      },
      build: () => VehiclesBloc(repository: vehicleRepository),
      act: (bloc) => bloc.add(CreateVehicle(vehicle: newVehicle)),
      expect: () => [
        VehiclesError()
      ],
      verify: (_) {
        verify(() => vehicleRepository.create(any())).called(1);
      }
    );

  });

}