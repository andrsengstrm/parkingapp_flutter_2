import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkingapp_admin/blocs/parkingspaces_bloc.dart';
import 'package:parkingapp_admin/repositories/parking_space_repository.dart';
import 'package:shared/models/parking_space.dart';

class MockParkingSpacesRepository extends Mock implements ParkingSpaceRepository {}

class FakeParkingSpace extends Fake implements ParkingSpace {}

void main() {

  group('ParkingSpacesBloc', (){
    
    late ParkingSpaceRepository parkingSpaceRepository;
    ParkingSpace parkingSpace = ParkingSpace(address: "Some address", pricePerHour: 10);

    setUpAll((){
       parkingSpaceRepository = MockParkingSpacesRepository();
       registerFallbackValue(FakeParkingSpace());
    });

    blocTest<ParkingSpacesBloc, ParkingSpacesState>(
      'Test that ReadAllParkingSpaces emits ParkingSpacesSuccess',
      setUp: (){
        when(() => parkingSpaceRepository.read())
          .thenAnswer((_) async => [parkingSpace]);
      },
      build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
      act: (bloc) => bloc.add(ReadAllParkingSpaces()),
      expect: () => [
        ParkingSpacesSuccess(parkingSpacesList: [parkingSpace])
      ],
      verify: (_) {
        verify(() => parkingSpaceRepository.read()).called(1);
      }
    );

    blocTest<ParkingSpacesBloc, ParkingSpacesState>(
      'Test that CreateParkingSpace emits ParkingSpacesError when null is returned',
      setUp: (){
        when(() => parkingSpaceRepository.create(any()))
          .thenAnswer((_) async => null);
      },
      build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
      act: (bloc) => bloc.add(CreateParkingSpace(parkingSpace: parkingSpace)),
      expect: () => [
        ParkingSpacesError()
      ],
      verify: (_) {
        verify(() => parkingSpaceRepository.create(any())).called(1);
      }
    );

  });

}