import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

class MockPersonRepository extends Mock implements PersonRepository {}

class FakePerson extends Fake implements Person {}

void main() {

  group('AuthBloc', (){
    
    late PersonRepository personRepository;
    Person person = Person(personId: "Some personId", name: "Some name", email: "Some email");

    setUp((){
       personRepository = MockPersonRepository();
    });

    setUpAll((){
       registerFallbackValue(FakePerson());
    });

    blocTest<AuthBloc, AuthState>(
      'Test that AuthLogin emits AuthSuccess',
      setUp: (){
        when(() => personRepository.readByEmail(any()))
          .thenAnswer((_) async => person);
      },
      build: () => AuthBloc(repository: personRepository),
      act: (bloc) => bloc.add(AuthLogin(email: person.email)),
      expect: () => [
        AuthInProgess(),
        AuthSuccess(user:person)
      ],
      verify: (_) {
        verify(() => personRepository.readByEmail(any())).called(1);
      }
    );

    blocTest<AuthBloc, AuthState>(
      'Test that AuthLogin emits AuthError when null is returned',
      setUp: (){
        when(() => personRepository.readByEmail(any()))
          .thenAnswer((_) async => null);
      },
      build: () => AuthBloc(repository: personRepository),
      act: (bloc) => bloc.add(AuthLogin(email: person.email)),
      expect: () => [
        AuthInProgess(),
        AuthError()
      ],
      verify: (_) {
        verify(() => personRepository.readByEmail(any())).called(1);
      }
    );

  });

}