import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkingapp_user/blocs/persons_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

class MockPersonRepository extends Mock implements PersonRepository {}

class FakePerson extends Fake implements Person {}

void main() {

  group('PersonsBloc', (){
    
    late PersonRepository personRepository;
    Person newPerson = Person(personId: "Some personId", name: "Some name", email: "Some email");

    setUpAll((){
       personRepository = MockPersonRepository();
       registerFallbackValue(FakePerson());
    });

    blocTest<PersonsBloc, PersonsState>(
      'Test that CreatePerson emits PersonsSuccess',
      setUp: (){
        when(() => personRepository.create(any()))
          .thenAnswer((_) async => newPerson);
      },
      build: () => PersonsBloc(repository: personRepository),
      act: (bloc) => bloc.add(CreatePerson(person: newPerson)),
      expect: () => [
        PersonsSuccess(user:newPerson)
      ],
      verify: (_) {
        verify(() => personRepository.create(any())).called(1);
      }
    );

  });

}