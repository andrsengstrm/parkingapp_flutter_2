import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/blocs/persons_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

class Login extends StatefulWidget {
  const Login({super.key, this.message});

  final String? message;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginMode loginMode = LoginMode.login;
  String? message;
  late PersonRepository repository;

  @override
  void initState() {
    super.initState();
    message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonsBloc(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(32),
          //color: Colors.white,
          child: Center(
            child: Wrap(
              children: [
                loginMode == LoginMode.create
                ? _CreateUserForm(
                    alternateLoginMode: LoginMode.login,
                    onLoginModeChanged: (value) => _onLoginModeChanged(value)
                  )
                : _LoginUserForm(
                    alternateLoginMode: LoginMode.create,
                    onLoginModeChanged: (value) => _onLoginModeChanged(value)
                  ),
                message != null 
                ? Text(message!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                : const SizedBox.shrink()
      
              ],
            )
          ),
        ),
      ),
    );
  }

  void _onLoginModeChanged(LoginMode newLoginMode) {
    setState(() {
      loginMode = newLoginMode;
      message = "";
    });
  }
}


class _CreateUserForm extends StatelessWidget {

  final LoginMode alternateLoginMode;
  final ValueChanged<LoginMode> onLoginModeChanged;

  const _CreateUserForm({
    required this.alternateLoginMode,
    required this.onLoginModeChanged
  });

  @override
  Widget build(BuildContext context) {
    final loginFormKey = GlobalKey<FormState>();
    String? email;
    String? name;
    String? personId;
    return Form(
      key: loginFormKey,
      child: Wrap(
        runSpacing: 16,                  
        children: [
          const Text(
            "Parkeringsappen",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold
            )
          ),
          const Text("Fyll i dina uppgifter för att skapa ett konto"),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
              hintText: "Email",
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Du måste fylla i din email för att skapa ett konto";
              }
              return null;
            },
            onSaved: (value) => email = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Namn",
              hintText: "Namn",
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Du måste fylla i ditt namn för att skapa ett konto";
              }
              return null;
            },
            onSaved: (value) => name = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Personnummer",
              hintText: "Personummer",
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Du måste fylla i ditt personnummer för att skapa ett konto";
              }
              return null;
            },
            onSaved: (value) => personId = value,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(320, 50), // Set minimum width and height
            ),
            onPressed: () async {
              if(loginFormKey.currentState!.validate()) {
                loginFormKey.currentState!.save();
                if(email != null && personId != null && name != null) {
                  var userToAdd = Person(email: email!, personId: personId!, name: name!);
                  context.read<PersonsBloc>().add(CreatePerson(person: userToAdd));
                  context.read<AuthBloc>().add(AuthLogin(email: userToAdd.email));
                }
              } 
            },
            child: const Text("Skapa konto")
          ),
          const Text("Har du redan ett konto? "),
          GestureDetector(
            onTap: () {
              onLoginModeChanged(alternateLoginMode);
            },
            child: const Text("Klicka här för att logga in"),
          ),
        ]
      ),
    );
  }
}


class _LoginUserForm extends StatelessWidget {
  const _LoginUserForm({
    required this.alternateLoginMode,
    required this.onLoginModeChanged
  });
  final LoginMode alternateLoginMode;
  final ValueChanged<LoginMode> onLoginModeChanged;

  @override
  Widget build(BuildContext context) {
    final loginFormKey = GlobalKey<FormState>();
    String? email;
    String? pwd;
    return Form(
      key: loginFormKey,
      child: Wrap(
        runSpacing: 16,
        children: [
          const Text(
            "Parkeringsappen",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold
            )
          ),
          const Text("Fyll i dina uppgifter för att logga in"),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
              hintText: "Email",
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Du måste fylla i din email för att logga in";
              }
              return null;
            },
            onSaved: (value) => email = value,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
              hintText: "Password",
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Du måste fylla i ditt lösenord för att logga in";
              }
              return null;
            },
            onSaved: (value) => pwd = value,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), // Set minimum width and height
            ),
            onPressed: () async {
              if(loginFormKey.currentState!.validate()) {
                loginFormKey.currentState!.save();
                context.read<AuthBloc>().add(AuthLogin(email: email!));
              } 
            },
            child: const Text("Logga in")
          ),
          const Text("Har du inget konto? "),
          GestureDetector(
            onTap: () {
              onLoginModeChanged(alternateLoginMode);
            },
            child: const Text("Klicka här för att skapa ett konto"),
          ),
        ]
      ),
    );
  }
}

enum LoginMode {
  create,
  login
}
