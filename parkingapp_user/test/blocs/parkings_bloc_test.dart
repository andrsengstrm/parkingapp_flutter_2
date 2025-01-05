import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkingapp_user/blocs/parkings_bloc.dart';
import 'package:parkingapp_user/repositories/parking_repository.dart';
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
      'Test that CreateParking emits ParkingsSuccess',
      setUp: (){
        when(() => parkingRepository.create(any()))
          .thenAnswer((_) async => newParking);
        when(() => parkingRepository.readByVehicleOwnerEmail(any()))
          .thenAnswer((_) async => [newParking]);
      },
      build: () => ParkingsBloc(repository: parkingRepository),
      act: (bloc) => bloc.add(CreateParking(parking: newParking)),
      expect: () => [
        ParkingsSuccess(parkingsList: [newParking])
      ],
      verify: (_) {
        verify(() => parkingRepository.create(any())).called(1);
      }
    );

  });

}