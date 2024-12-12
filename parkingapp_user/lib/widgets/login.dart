import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  
  get loginFormKey => null;

  @override
  Widget build(BuildContext context) {
    
      String loginMode = "create";
      String? email;
      String? name;
      String? personId;
      String? pwd;
      
      return Container(
        color: Colors.white,
        child: Center(
          widthFactor: 300,
          child: 
          loginMode == "create"
          ? Form(
              key: loginFormKey,
              child: SizedBox(
                width: 300,
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
                          minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                        ),
                        onPressed: () async {
                          if(loginFormKey.currentState!.validate()) {
                            loginFormKey.currentState!.save();
                              
                            
                          } 
                        },
                        child: const Text("Skapa konto")
                      ),
                      const Text("Har de redan ett konto?"),
                      GestureDetector(
                        onTap: () {
                            //var loginModeCreate = false;
                        },
                        child: const Text("Klicka här för att logga in"),
                      ),
                  ]
                ),
              ),
            )
        
          : Form(
              key: loginFormKey,
              child: SizedBox(
                width: 300,
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
                            
                            
                          } 
                        },
                        child: const Text("Logga in")
                      ),
                      const Text("Har du inget konto?"),
                      GestureDetector(
                        onTap: () {
                          //setState(() {
                            //loginModeCreate = true;
                          //});
                        },
                        child: const Text("Klicka här för att skapa ett konto"),
                      ),
                  ]
                ),
              ),
            )
        
        ),
      );
    }
  }
