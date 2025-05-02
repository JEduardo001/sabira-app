import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/provider/ProviderHome.dart';
import 'package:sabira/screens/Home.dart';
import 'package:sabira/screens/ListSmiles-Matches-Chats.dart';

import 'package:sabira/screens/Login.dart';
import 'package:sabira/screens/Perfil.dart';
import 'package:sabira/screens/chat.dart';

class Menuscreens extends StatefulWidget {

  const Menuscreens({super.key});

  @override
  State<Menuscreens> createState() => _MenuscreensState();
}

class _MenuscreensState extends State<Menuscreens> {
    final FirebaseAuth _auth = FirebaseAuth.instance;


   Future<void> signOut() async {
     try{
      await _auth.signOut();
      
     }catch(e){
      print("Error al cerrar sesión $e");
     }

    }


  @override
  Widget build(BuildContext context) {
    var providerHome = Provider.of<ProviderHome>(context); 
    var providerClient= Provider.of<ClientProvider>(context); 
    ClientData? dataClient = providerClient.clientData;
    String idClient = dataClient!.id;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(onPressed: 
              () => {
                Navigator.push(context, MaterialPageRoute(builder:  (context) => Home(idUserSearch: providerHome.idUserSearch,itUser: providerHome.itUser, itUserLast: providerHome.itUserLast,searchById: providerHome.searchById,)))
              }
            ,
            icon: const Icon(Icons.arrow_back,size: 50,))),   
         const Padding(
          padding: EdgeInsets.only(left: 20,top: 40),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "¿buscas algo?",
                style: TextStyle(
                  fontSize: 40
                ),            
              ),
            ),
          ),
         const SizedBox(height: 50,),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil(idClient: idClient)));
              }, 
              child: const Row(
                children: [
                  Icon(Icons.person,color: Color.fromARGB(255, 72, 206, 188),),
                  SizedBox(width: 15,),
                  Text("Mi perfil",style: TextStyle(fontSize: 20),)    
                ],
              )         
            ),
          ),
          const SizedBox(height: 20,),
         Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListGustadosRecibidos(typeList: 0, idClient: idClient,)));
              }, 
              child: const Row(
                children: [
                   Icon(Icons.message_outlined,color: Color.fromARGB(255, 75, 189, 179),),
                   SizedBox(width: 15,),
                   Text("Mis chats",style: TextStyle(fontSize: 20),)    
                ],
              )         
            ),
          ),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListGustadosRecibidos(typeList: 1, idClient: idClient)));
              }, 
              child: const Row(
                children: [
                   Icon(Icons.heat_pump_sharp,color: Color.fromARGB(193, 89, 192, 49),),
                   SizedBox(width: 15,),
                   Text("Sonrisas enviadas",style: TextStyle(fontSize: 20),)    
                ],
              )         
            ),
          ),
          const SizedBox(height: 20,),
         Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListGustadosRecibidos(typeList: 2, idClient: idClient)));
              }, 
              child: const Row(
                children: [
                   Icon(Icons.sentiment_very_satisfied_sharp,color: Color.fromARGB(255, 108, 231, 37),),
                   SizedBox(width: 15,),
                   Text("Sonrisas recibidas",style: TextStyle(fontSize: 20),)    
                ],
              )         
            ),
          ),
          const SizedBox(height: 20,),
         Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListGustadosRecibidos(typeList: 3, idClient: idClient)));
              }, 
              child: const Row(
                children: [
                   Icon(Icons.join_inner,color: Color.fromARGB(255, 235, 81, 255),),
                   SizedBox(width: 15,),
                   Text("Mis matchs",style: TextStyle(fontSize: 20),)    
                ],
              )         
            ),
          ),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
               
               await signOut();
               Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

              }, 
              child: const Row(
                children: [
                   Icon(Icons.login,color: Color.fromARGB(255, 83, 86, 255),),
                   SizedBox(width: 15,),
                   Text("Cerrar sesión",style: TextStyle(fontSize: 20),)    
                ],
              )         
            ),
          ),
          const SizedBox(height: 50,),
          Align(
            alignment: Alignment.center,
            child:  ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll( Color.fromARGB(255, 255, 115, 105))
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListGustadosRecibidos(typeList: 1, idClient: idClient)));

                }, 
                child: const Text("Eliminar cuenta", style: TextStyle(color: Colors.white),)
              ),
          )  
        ],
      ),
    );
  }
}