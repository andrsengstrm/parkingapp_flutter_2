import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkingapp_admin/blocs/parkings_bloc.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

class FakeParking extends Fake implements Parking {}

void main() {

  group('ParkingsBloc', (){
    
    late ParkingRepository parkingRepository;
    Person owner = Person(personId: "Some personId", name: "Some name", email: "Some email");
    Vehicle vehicle = Vehicle(regId: "Some regId", vehicleType: "Some vehicletype", owner: owner);
    ParkingSpace parkingSpace = ParkingSpace(address: "Some address", pricePerHour: 10);
    Parking newParking = Parking(vehicle: vehicle, parkingSpace: parkingSpace, startTime: "Some startTime");

    setUpAll((){
       parkingRepository = MockParkingRepository();
       registerFallbackValue(FakeParking());
    });

    blocTest<ParkingsBloc, ParkingsState>(
      'Test that ReadAllParkings emits ParkingsSuccess',
      setUp: (){
        when(() => parkingRepository.read())
          .thenAnswer((_) async => [newParking]);
      },
      build: () => ParkingsBloc(repository: parkingRepository),
      act: (bloc) => bloc.add(ReadAllParkings()),
      expect: () => [
        ParkingsSuccess(parkingsList: [newParking])
      ],
      verify: (_) {
        verify(() => parkingRepository.read()).called(1);
      }
    );

    blocTest<ParkingsBloc, ParkingsState>(
      'Test that ReadParkingById emits ParkingsError when null is returned',
      setUp: (){
        when(() => parkingRepository.readById(any()))
          .thenAnswer((_) async => null);
      },
      build: () => ParkingsBloc(repository: parkingRepository),
      act: (bloc) => bloc.add(ReadParkingById(id:1)),
      expect: () => [
        ParkingsError()
      ],
      verify: (_) {
        verify(() => parkingRepository.readById(any())).called(1);
      }
    );

  });

}