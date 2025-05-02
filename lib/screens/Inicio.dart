import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/provider/FirebaseProvider.dart';
import 'package:sabira/provider/ProviderHome.dart';
import 'package:sabira/screens/Home.dart';
import 'package:sabira/screens/Login.dart';
import 'package:sabira/services/ServicesToFunctionsGenerals.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var clientProvider = Provider.of<ClientProvider>(context);
    var firebaseProvider = Provider.of<FirebaseProvider>(context);
    var providerHome = Provider.of<ProviderHome>(context); 

    Future<void> getDataClient() async {
      if(await clientProvider.existClient()){
        await clientProvider.getDataClient();
        firebaseProvider.initStateFirebase(idClient: clientProvider.clientData!.id);
      }
    }
    getDataClient();

    Future<void> getUsers() async {
      await providerHome.getMoreUsers();
    }
    getUsers();



    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ClipOval(child: Image.asset("assets/images/m1.avif")),
            StreamBuilder<User?>(
              stream: _auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  // verificamos si el usuario esta autenticado
                  if (snapshot.hasData) {

                    clientProvider.getDataClient();
                    // Usamos `addPostFrameCallback` para realizar la navegación después de construir la UI
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            idUserSearch: "",
                            itUser: 0,
                            itUserLast: 0,
                            searchById: false,
                          ),
                        ),
                      );
                    });
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    });
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
