import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/blocs/persons_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:parkingapp_user/login.dart';
import 'package:shared/models/person.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonsState state = context.watch<PersonsBloc>().state;
    return switch(state) {
      //AuthIsAuth(user: Person loggedInUser) => accountMainView(context, loggedInUser),
      //_ => const Login()
      PersonsSuccess(user: Person user) => accountMainView(context, user),
      // TODO: Handle this case.
      _ => const Text("Ett fel har uppstått")

    };
  }

  Widget accountMainView(BuildContext context, user) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Container(
      color: Colors.amber,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mitt konto", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Namn",
                hintText: "Namn",
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return "Du måste fylla i ett namn";
                }
                return null;
              },
              onSaved: (value) => user.name = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.personId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Personnummer",
                hintText: "Personnummer",
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return "Du måste fylla i ett personnummer";
                }
                return null;
              },
              onSaved: (value) => user.personId = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
                hintText: "Email",
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return "Du måste fylla i email";
                }
                return null;
              },
              onSaved: (value) => user.email = value!,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  var updatedPerson = Person(id: user.id, name: user.name, personId: user.personId, email: user.email);
                  //var personReturned = await PersonRepository().update(updatedPerson.id, updatedPerson);    
                  context.read<PersonsBloc>().add(UpdatePerson(person: updatedPerson));
                  //if(personReturned != null) {
                    /*
                    setState(() {
                      editMode = false;
                    });
                    */
                  //}
                } 
              },
              child: const Text("Spara"),
            ),
          ],
        )
      )
    );
  }

}