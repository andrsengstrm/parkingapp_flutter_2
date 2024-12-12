import 'package:flutter/material.dart';
import 'package:parkingapp_user/widgets/login.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  

  @override
  Widget build(BuildContext context) {

    late bool isLoggedIn = false;
    
    return Scaffold(
      body: 
      isLoggedIn
      ? const Center(
         child: Text("Inloggad!")
        )
      : const Login()
     );
  }
} 