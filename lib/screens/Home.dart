
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/provider/ProviderHome.dart';
import 'package:sabira/screens/menuScreens.dart';
import 'dart:math';
import 'package:sabira/services/servicesToClient.dart';
import 'package:sabira/services/servicesToFunctionsGenerals.dart';
import 'package:sabira/services/servicesToUsers.dart';


class Home extends StatefulWidget {
  String idUserSearch;
  bool searchById;
  int itUser;
  int itUserLast; 

  Home({super.key, required this.idUserSearch, required this.searchById, required this.itUser, required this.itUserLast});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ServicesToFunctionsGenerals servicesGenerals = ServicesToFunctionsGenerals();
  ServicesToclient servicesToClient = ServicesToclient();

 /*  String idUserSearch;
  bool searchById;
  int itUser;
  int itUserLast;  */

  //_HomeState({required this.idUserSearch, required this.searchById, required this.itUser, required this.itUserLast});
    User? user = FirebaseAuth.instance.currentUser;
    bool getMoreUser = false;
  @override
  void initState()   {
    // TODO: implement initState
    super.initState();
  }
 
  void setAlert(String nameUser){
    String message = "Anónimo";
    if(nameUser != "null"){
      message = "Hiciste match con $nameUser !"; 
    }

    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  String validateIfDataIsNull({required data}){
    if(data != "null"){
      return data;
    }else{
      return "No especificado";
    }
  }

  void reload(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var providerHome = Provider.of<ProviderHome>(context); 
    var clientProvider = Provider.of<ClientProvider>(context); 
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    Random random = Random();


    List<Color> colors = [
      const Color.fromARGB(255, 54, 216, 244),
      const Color.fromARGB(255, 124, 244, 54),
      const Color.fromARGB(255, 158, 54, 244),
      Colors.red
    ];

    Color getColor(){
      return colors[random.nextInt(4)];
    }

    void getMoreUsers() async{
     await providerHome.getMoreUsers();
     setState(() {
       
     });
    }

    void changeIteratorUsers(){
        providerHome.setStartItUserIndex(providerHome.itStartGetUserIndex+1);
        if(providerHome.itUser+1 >= providerHome.dataUsers.length-5){
           getMoreUsers();
        }else{
          if(providerHome.dataUsers[providerHome.itUser+1]["id"] == clientProvider.clientData!.id){
            print("Es gial");
            providerHome.setStartItUserIndex(providerHome.itStartGetUserIndex+1);
            if(providerHome.itUser+2 >= providerHome.dataUsers.length){
              getMoreUsers();
            }else{
              providerHome.setItUser(providerHome.itUser + 2);
            }    
          }else{
           providerHome.setItUser(providerHome.itUser +1);
          }
        }
    }
   
    return Scaffold(
      body: 
        (providerHome.loadingDataUsers)
        ?  Center(child: Column(
          children: [
            const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () => reload(),  
              child: const Text("Recargar"),
            )

          ],
        ))

        :  (providerHome.dataUsers.isEmpty)
          ? const Center(child: Text("No hay usuarios para mostrar, esto no deberia pasar :(" ,style: TextStyle(fontSize: 30),),)
          :

      Stack(
        children: [
              Positioned(
                top: 0,
                left: 0,
                width: screenWidth,
                height: screenHeight,
                child: 
                  SingleChildScrollView(
                    child: Column(
                      children: [

                      
                        Stack(
                          children: [                              
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.5,                       
                              child: (!providerHome.loadingDataUsers)
                                        ? 
                                          (providerHome.dataUsers![providerHome.itUser]["imgProfile"]["urlImage"] != "null")

                                          ? Image.network(providerHome.dataUsers![providerHome.itUser]["imgProfile"]["urlImage"],width: 200, height: 200, fit: BoxFit.cover,)
                                          : Image.asset("assets/images/perfil2.png",width: 200, height: 200, fit: BoxFit.cover,)

                                        : const CircularProgressIndicator()
                            ),

                            Positioned(
                              top: screenHeight * 0.08,
                              left: screenWidth * 0.85,
                              child: FloatingActionButton(
                                backgroundColor:const Color.fromARGB(255, 173, 243, 255),
                                onPressed: ()  {
                                  if(providerHome.searchById){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  Menuscreens()));
                                  }else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  Menuscreens()));

                                  }
                                },     
                                child: const Icon(Icons.home_sharp),
                              ),
                            ),
                          ],
                        ),
                  
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child:  Text( 
                                      (!providerHome.loadingDataUsers)
                                      ? validateIfDataIsNull(data: providerHome.dataUsers![providerHome.itUser]["name"])
                                      : "Cargando",
                                      style:  TextStyle(
                                        fontSize: screenWidth * 0.09
                                      ),
                                    ),
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset(
                                    'assets/images/ageIcon2.png', 
                                      width: 50.0, 
                                      height: 50.0, 
                                      fit: BoxFit.cover, 
                                    ),
                                  ),
                                  const SizedBox(width: 10,),

                                  Align(
                                  alignment: Alignment.centerLeft,
                                  child:  Text( 
                                        (!providerHome.loadingDataUsers)
                                        ? validateIfDataIsNull(data: providerHome.dataUsers![providerHome.itUser]["age"])
                                        : "Cargando",
                                        style:  TextStyle(
                                          fontSize: screenWidth * 0.05
                                        ),
                                      ),
                                  ),
                                ],
                              ),
                    
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0), 
                                    child: Image.asset(
                                    'assets/images/soy.jpg', 
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover, 
                                    ),
                                  ),
                                  const SizedBox(width: 10,),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:  Text( 
                                          "Soy",
                                          style:  TextStyle(
                                            fontSize: screenWidth * 0.05
                                          ),
                                        ),
                                  ),
                                
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child:  Text( 
                                      (!providerHome.loadingDataUsers)
                                      ? validateIfDataIsNull(data: providerHome.dataUsers![providerHome.itUser]["iAm"])
                                      : "Cargando",                            
                                      style:  TextStyle(
                                        fontSize: screenWidth * 0.05
                                      ),
                                    ),
                              ),
                 
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0), 
                                    child: Image.asset(
                                    'assets/images/corazon.png',
                                      width: 50.0, 
                                      height: 50.0, 
                                      fit: BoxFit.cover, 
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:  Text( 
                                          "Me gusta",
                                          style:  TextStyle(
                                            fontSize: screenWidth * 0.05
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                
                              const SizedBox(height: 20,),
                              Wrap(
                                  spacing: 5,
                                  runSpacing: 15,
                                  children: [               
                                    if(!providerHome.loadingDataUsers)
                                      if(providerHome.dataUsers![providerHome.itUser]['thingsILiked'].isNotEmpty)
                                        ...List.generate(
                                          providerHome.dataUsers![providerHome.itUser]['thingsILiked'].length,
                                        (i2){
                                          return    Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: getColor(),
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Text(providerHome.dataUsers![providerHome.itUser]['thingsILiked'][i2]),
                                          );

                                        }
                                      )
                                      else const Text("Aún no hay gustos", style: TextStyle(fontSize: 20),)
                                    else const Text("Cargando"),                            
                                
                                  ],
                                ),
                  
                                const SizedBox(height: 15,), 
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0), 
                                      child: Image.asset(
                                      'assets/images/lupa.jpg',
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover, 
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:  Text( 
                                            '¿Qué busco?',
                                            style:  TextStyle(
                                              fontSize: screenWidth * 0.05
                                            ),
                                          ),
                                    ),
                                  
                                  ],
                                  
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:  Text( 
                                          (!providerHome.loadingDataUsers)
                                        ? validateIfDataIsNull(data: providerHome.dataUsers![providerHome.itUser]["whatISearch"])
                                        : "Cargando",
                                        style:  TextStyle(
                                          fontSize: screenWidth * 0.05
                                        ),
                                      ),
                                ),
                    
                                const SizedBox(height: 50,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Más fotos de sabira",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.06
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),
                          
                    
                                if(!providerHome.loadingDataUsers)

                                 if(providerHome.dataUsers![providerHome.itUser]['listMorePhotos'].isNotEmpty)
                            
                                    ...List.generate(
                                      providerHome.dataUsers![providerHome.itUser]['listMorePhotos'].length,
                                      (i2) {
                                          return Column(
                                            children: [
                                              ClipRRect(
                              
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image.network(
                                                  providerHome.dataUsers![providerHome.itUser]['listMorePhotos'][i2]["urlImage"],
                                                  width: screenWidth,  
                                                    height: screenHeight * 0.4,  
                                                    fit: BoxFit.cover,  
                                                  
                                                ),
                                              ),
                                              const SizedBox(height: 40,)
                                            ],
                                          );
                                      }
                                    )
                                  else const Text("Sin más fotos", style: TextStyle(fontSize: 20),)
                               else const Text("Cargando"),
                                       
                               const SizedBox(height: 200,),
                            ],
                          )                         
                        )
                      ],
                    ),
                  )
              ),


              Positioned(
                top: screenHeight * 0.85,
                left: screenWidth * 0.2,
                //width: screenWidth * 0.2,
                height: screenHeight * 0.09,
                child:  ElevatedButton(
                    onPressed: () {
                      
                     if(providerHome.dataUsers.isNotEmpty){
                      changeIteratorUsers();
                     }
                     
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color.fromARGB(183, 33, 149, 243), 
                      shadowColor: Colors.black,
                      elevation: 10, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                      ),
                    ),
                    child: const Icon(
                      Icons.find_replace,  
                      size: 45,             
                    ),
                  ),
              ),

              Positioned(
                  top: screenHeight * 0.85,
                  left: screenWidth * 0.6,
                  //width: screenWidth * 0.2,
                  height: screenHeight * 0.09,
                  child: ElevatedButton(
                    onPressed: () async {

                      if(providerHome.dataUsers.isNotEmpty){
                        if((await servicesGenerals.checkMatch(idUserDestinationSmile: providerHome.dataUsers![providerHome.itUser]['id'],idUserSendSmile: clientProvider.clientData!.id))) {
                          setAlert(providerHome.dataUsers![providerHome.itUser]['name']);
                        }
                        changeIteratorUsers();     
                      }                                               
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(181, 33, 243, 103),
                      shadowColor: Colors.black, 
                      elevation: 10, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                      ),
                    ),
                    child: const Icon(
                      Icons.sentiment_satisfied_alt,  
                      size: 45,            
                    ),
                  ),
              ),  
        ],
      )
    );
  }
}