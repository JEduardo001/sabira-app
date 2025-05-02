import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/routesApi/Users.dart';
import 'package:sabira/services/ServicesToClient.dart';

class Chat extends StatefulWidget {
  var idUserReceptor;
  var idChat;
  String urlImgProfileUserReceptor;
  String nameUserReceptor;

  Chat({super.key, required this.idUserReceptor, required this.idChat, required this.urlImgProfileUserReceptor, required this.nameUserReceptor});

  @override
  State<Chat> createState() => _ChatState(idUserReceptor: idUserReceptor, idChat: idChat, urlImgProfileUserReceptor: urlImgProfileUserReceptor, nameUserReceptor: nameUserReceptor);
}

class _ChatState extends State<Chat> {
  var idUserReceptor;
  var idChat;
  String urlImgProfileUserReceptor;
  String nameUserReceptor;
  
  bool chatLoaded = false;
  ScrollController scrollControllerChat = ScrollController();

  List<String> listMensajesEmisor = ["hola muy mal"];

  _ChatState({required this.idUserReceptor, required this.idChat,required this.urlImgProfileUserReceptor, required this.nameUserReceptor});

  Map<String,dynamic> dataChat = {};
  Map<String,dynamic> dataUserReceptor = {};


  ServicesToclient client = ServicesToclient();
  Users user = Users();


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    loadChatData(idChat: idChat);     
  }

  @override
  void dispose() {
    scrollControllerChat.dispose();
    super.dispose();
  }


  void loadChatData({required idChat}) async {
    dataChat = await client.loadChatData(idChat: idChat);

    setState(()  {
      chatLoaded = true;
    });
    // Mostramos el final de la lista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

   void _scrollToBottom() {
    if (scrollControllerChat.hasClients) {
      scrollControllerChat.jumpTo(scrollControllerChat.position.maxScrollExtent);
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    TextEditingController controllerMensaje = TextEditingController();
    DateTime nowDate = DateTime.now();
    var providerClient= Provider.of<ClientProvider>(context); 
    ClientData? dataClient = providerClient.clientData;
    String idClient = dataClient!.id;


    void setMensaje() async {
      var dataMessage = {
        "nameUserEmisor": dataClient.name,
        "idUserReceptor": idUserReceptor,
        "seenMessage": false,
        "idUserSendMessage":  idClient,
        "message": controllerMensaje.text,
        "dateMessage": DateFormat('dd-MM-yyyy HH:mm:ss').format(nowDate)
      };
      await client.insertMessage(dataMessage: dataMessage, idChat: idChat);

      loadChatData(idChat: idChat);
     
    }

    String setFecha(fechaMensaje){  
      DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
      
      DateTime fecha = format.parse(fechaMensaje);
      int horas = fecha.hour;
      int minutos = fecha.minute;
      return "$horas : $minutos";
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255)
            ),
            padding: const EdgeInsets.only(left: 20,top: 30,bottom: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                ClipOval(
                 child: (urlImgProfileUserReceptor != "null")
                                 ? Image.network(
                                  urlImgProfileUserReceptor,
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
                const SizedBox(width: 10,),
                Text(nameUserReceptor, style: const TextStyle(fontSize: 25),)
              ],
            ),
            
          ),
          Stack(
            children: [
                Container(
                  height: screenHeight * 0.80,
                   decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/mosaico2.jpg'), 
                        fit: BoxFit.cover, 
                         colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken, 
                          ),
                      ),
                  ),
                ),
                Positioned(
                  child: (chatLoaded) 
                   ?
                    Column(
                      children: [
                        if(dataChat["messages"].length == 0)
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 127, 241, 226),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: const Text("Aún no hay mensajes, envia alguno!"),
                          ),
                        SizedBox(
                          height:  screenHeight * 0.80,
                          child:  
                            ListView.builder(
                                  controller: scrollControllerChat,
                                  itemCount: dataChat["messages"].length,
                                  itemBuilder: (context, int it) {
                                    return Column(
                                      children: [
                                        (dataChat["messages"][it]["idUserSendMessage"] == idUserReceptor)
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  constraints: const BoxConstraints(
                                                    minWidth: 0,
                                                    maxWidth: 200,
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: const BoxDecoration(
                                                    color: Color.fromARGB(255, 255, 255, 255),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(dataChat[it]["message"] ?? ''),
                                                      const SizedBox(height: 7),
                                                      Container(
                                                        margin: const EdgeInsets.only(right: 30),
                                                        child: Text(setFecha(dataChat["messages"][it]["dateMessage"] ?? ''),) 
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  constraints: const BoxConstraints(
                                                    minWidth: 90,
                                                    maxWidth: 200,
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: const BoxDecoration(
                                                    color: Color.fromARGB(255, 127, 241, 226),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(dataChat["messages"][it]["message"] ?? ''),
                                                      const SizedBox(height: 7),
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 30),
                                                      child: Text(setFecha(dataChat["messages"][it]["dateMessage"] ?? ''),) 
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      const SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                )
                          
                        )
                      ],
                    )
                  
                    : const Center(child: CircularProgressIndicator()),
                )
              
            ],
          ),      
            Expanded(
                 child: Container(
                    //width: screenWidth,            
                    decoration: const BoxDecoration(
                      color:  Color.fromARGB(255, 255, 255, 255)
                    ),
                    child: Row(
                  
                      children: [
                        Container(
                            width: 300,
                            decoration: const BoxDecoration(
                              color:  Color.fromARGB(255, 231, 231, 231),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            margin: const EdgeInsets.all(10),
                            child:  TextField(                
                            decoration: const InputDecoration(
                              hintText: "Escribe un mensaje",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15)
                            ),
                            controller: controllerMensaje,
                            //style: TextStyle(),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton(onPressed: () {
                         
                          setMensaje();
                        }, child: const Icon(Icons.send),)
                      ],
                    )
                  ),
               )   
        ],
      ),
    );
  }
}

