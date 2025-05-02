import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/provider/ProviderHome.dart';
import 'package:sabira/routesApi/Users.dart';
import 'package:sabira/screens/MenuScreens.dart';
import 'package:sabira/screens/chat.dart';
import 'package:sabira/screens/home.dart';
import 'package:sabira/services/servicesToClient.dart';



class ListGustadosRecibidos extends StatefulWidget {
  int typeList;
  String idClient;
  ListGustadosRecibidos({super.key,required this.typeList, required this.idClient});

  @override
  State<ListGustadosRecibidos> createState() => _ListGustadosRecibidosState(typeList: typeList,idClient: idClient);
}

class _ListGustadosRecibidosState extends State<ListGustadosRecibidos> {
  int typeList;
  String idClient;


  _ListGustadosRecibidosState({required this.typeList, required this.idClient});
  ServicesToclient servicesToclient = ServicesToclient();
  Users controllerUser = Users();
  List<dynamic> data = [];
  bool dataUploaded = false;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTypeList(idUser: idClient);
  }

  void loadTypeList({required idUser}) async{
    switch(typeList){
      case 0:
        //title = "Mis Chats";
        data = await servicesToclient.loadChats(idUser: idUser);
      break;
      case 1:
        data = await servicesToclient.loadSmilesSend(idUser: idUser);
        
      break;
      case 2:
        data = await servicesToclient.loadSmilesReceived(idUser: idUser);
        //title = "Sonrisas recibidas";
      break;
      case 3:
        data = await servicesToclient.loadListMatches(idUser: idUser);
        print("los datons son $data");
        //title = "Mis Matchs";
      break;
      default:
        print("No hay funcion");
      break;
    }
    
    setState(() {
      dataUploaded = true;
    });


  }

  @override
  Widget build(BuildContext context) {
    var providerHome = Provider.of<ProviderHome>(context); 

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    String title;

    switch(typeList){
      case 0:
        title = "Mis Chats";
      break;
      case 1:
        title = "Sonrisas enviadas";
      break;
      case 2:
        title = "Sonrisas recibidas";
      break;
      case 3:
        title = "Mis Matchs";
      break;
      default:
       title = "Sin titulo";
      break;
    }

    return  Scaffold(
      body: Column(
        children: [
           const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(onPressed: 
              () => {
                Navigator.push(context, MaterialPageRoute(builder:  (context) => Menuscreens()))
              }
            ,
            icon: const Icon(Icons.arrow_back,size: 50,))),   
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 40
            ),
          ),
        ),

        (!dataUploaded)
          ? const Center(child: CircularProgressIndicator())
          : Expanded(
             
              child: 
                (data.isNotEmpty)
                ?        
                  ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, int it) {
                      return InkWell(
                        onTap: () {
                          if(typeList != 0) {
                            providerHome.setSearchById(true);
                            providerHome.setIdUserSearch(data[it]["idUser"]);
                          }
                          
            
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => (typeList == 0)
                                  ? Chat(
                                      idUserReceptor: data[it]["idUser2"],
                                      idChat: data[it]["idChat"],
                                      urlImgProfileUserReceptor: data[it]["imgProfile"]["urlImage"],
                                      nameUserReceptor: (data[it]["name"] == "null") ? "Anónimo" : data[it]["name"],
                                    )
                                  : 
                                
                                  Home(idUserSearch: providerHome.idUserSearch,itUser: providerHome.itUser, itUserLast: providerHome.itUserLast,searchById: providerHome.searchById,)
                                    
                                
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(225, 243, 230, 230),
                            borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: (data[it]["imgProfile"]["urlImage"] != "null")
                                ? Image.network(
                                  data[it]["imgProfile"]["urlImage"],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  )
                                :
                                Image.asset(
                                  "assets/images/perfil2.png",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                (data[it]["name"] == "null") ? "Anónimo" : data[it]["name"],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
              : const Text("Sin información", style: TextStyle(fontSize: 20),)
            )
        ],
      ),
    );
  }
}