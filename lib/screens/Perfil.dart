import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sabira/functionsOfScreens/screenPerfil/FunctionsControllerImages.dart';
import 'package:sabira/functionsOfScreens/screenPerfil/FunctionsControllerUser.dart';
import 'package:sabira/functionsOfScreens/screenPerfil/FunctionsGenerals.dart';
import 'package:sabira/functionsOfScreens/screenPerfil/FunctionsToPrepareDataToUpdateUser.dart';
import 'package:sabira/functionsOfScreens/screenPerfil/Variables.dart';
import 'package:sabira/provider/FirebaseProvider.dart';
import 'package:sabira/screens/MenuScreens.dart';
import 'package:sabira/services/servicesToClient.dart';
import 'package:sabira/services/servicesToFunctionsGenerals.dart';


class Perfil extends StatefulWidget {
  String idClient;
  Perfil({super.key,required this.idClient});

  @override
  State<Perfil> createState() => _PerfilState(idClient: idClient);
}

class _PerfilState extends State<Perfil> {
  String idClient;

  _PerfilState({required this.idClient});

  ServicesToclient servicesToClient = ServicesToclient();
  ServicesToFunctionsGenerals functionsGenerals = ServicesToFunctionsGenerals();


  Variables variablesScreenPerfil = Variables();
  FunctionsControllerImages? functionsImages;
  FunctionsControllerUser? functionsUser;
  FunctionsGeneralsPerfil? functionsGeneralsPerfil;
  FunctionsToPrepareDataToUpdateDataUser? functionsToPrepareDataToUpdateDataUser;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    functionsImages = FunctionsControllerImages(variablesScreenPerfil: variablesScreenPerfil, updateUI: updateUI);
    functionsUser = FunctionsControllerUser(variablesScreenPerfil: variablesScreenPerfil, updateUI: updateUI);
    functionsGeneralsPerfil = FunctionsGeneralsPerfil(variablesScreenPerfil: variablesScreenPerfil, updateUI: updateUI);
    functionsToPrepareDataToUpdateDataUser = FunctionsToPrepareDataToUpdateDataUser(variablesScreenPerfil: variablesScreenPerfil, updateUI: updateUI);

    loadUserData();
   
  }


  void loadUserData() async {
    await functionsUser!.loadDataUser(idClient: idClient);
    updateUI();
  }

  void updateUI(){
    setState(() {
      
    });
  }

  void setAlert(bool typeMessage){
    String message;
    (typeMessage) ? message = "Informacion Actualizada" : message = "Ocurrio un error, intenta mas tarde"; 

    
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    Widget setWidgetImageProfile(){
      return (
          Stack(
            children: [          
               Padding(
                padding: const EdgeInsets.all(40),      
                child: 
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SizedBox(
                    height: screenHeight * 0.5,
                    width: screenWidth * 0.6,
                  
                    child:  (variablesScreenPerfil.newImageProfileSelectedByFile != null)
                      ? Image.file(
                          File(variablesScreenPerfil.newImageProfileSelectedByFile!.path),
                          fit: BoxFit.cover,
                        )
                      : 
                        Image.network(
                          variablesScreenPerfil.imageProfileByUrl["urlImage"],
                          fit: BoxFit.cover,
                        ),
                  )                       
                ),
              ),
              Positioned(
                right: 0,
                child: ClipRRect(                 
                  borderRadius: BorderRadius.circular(80.0),
                  child:                                                               
                      ElevatedButton(                        
                        onPressed: () => {
                          functionsImages!.deleteImageProfile(),
                          setState(() {
                            
                          })                                               
                        },                         
                        child:                        
                        Image.asset(
                          "assets/images/tacheRojo.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                ),
              )       
            ],
          )
      );
    }

    return Scaffold(
      body: 
      
        SingleChildScrollView(
        child: Column(
        
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
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child:  Align(
              alignment: Alignment.bottomLeft,
              child: Text(
            "Sobre ti",
            style: TextStyle(
              fontSize: screenWidth * 0.15
            ),
          ),
            )
          ),
          const SizedBox(height: 30,),
         Align(
          alignment: Alignment.bottomCenter,
          child: (variablesScreenPerfil.dataUploaded)
            ? 
              (variablesScreenPerfil.existImageProfile)
                ? setWidgetImageProfile()
                :  ClipRRect(
                  borderRadius: BorderRadius.circular(70.0),
                  child:   Image.asset(
                    "assets/images/perfil2.png",
                    fit: BoxFit.cover,
                  ),
                ) 
                        
            : const Text("Cargando")
         ),  
          
           const SizedBox(
                height: 30,
                width: 30,
              ),

            Container(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: ElevatedButton(
                onPressed: ( ) {
                  functionsImages!.pickImage("changeImageProfile");
                            
                  
                }, 
                child: const Text("cambiar foto principal")

                ),
            ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () async {

                  bool succesUpdateDataUser = await functionsUser!.operationsToUpdateDataUser(idClient: idClient, functionsImages: functionsImages, functionsToPrepareDataToUpdateDataUser: functionsToPrepareDataToUpdateDataUser);
                  setAlert(succesUpdateDataUser);
                  setState(() {
                    variablesScreenPerfil.listThingsLike = [];
                    variablesScreenPerfil.listMorePhotosByUrl = [];     
                    variablesScreenPerfil.imagesToDelete = []; 
                    variablesScreenPerfil.newImagesUserSelectedByFile = [];
                    variablesScreenPerfil.urlsNewImagesToUpdate = [];          
                  }); 
                  loadUserData();

               
                }, 
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.asset("assets/images/saveIcon.png",width: 50,height: 50,),
                    ),
                    const Text("Guardar")

                  ],
                )
              )

            ),

              
              Container(
                padding: const EdgeInsets.all( 15),
                child:  Column(
              children: [
                SizedBox(height: screenHeight * 0.01),
                   Align(
                      alignment: Alignment.centerLeft,
                      child:  TextField(
                        controller: variablesScreenPerfil.controllerName,
                        maxLength: 150,
                        
                        style: TextStyle(
                          fontSize: screenWidth * 0.09
                        ),
                    ),
                    ),
                   
                    const SizedBox(height: 40,),
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
                              "Edad",
                              style:  TextStyle(
                                fontSize: screenWidth * 0.05
                              ),
                            ),
                            
                        ),
                      
                      ],
                    ),

                   Align(
                    alignment: Alignment.centerLeft,
                    child:  SizedBox(
                      width: 100,
                      child: TextField(
                        controller: variablesScreenPerfil.controllerAge,
                        maxLines: 1, 
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[ FilteringTextInputFormatter.digitsOnly ],
                        maxLength: 3,
                         
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          
                        ),
                      ),
                    ),
                   ),

                    
                    const SizedBox(height: 40,),
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
                    
                    TextField(
                        controller: variablesScreenPerfil.controllerIAm,
                        maxLines: null,
                        keyboardType: TextInputType.multiline, 
                        style: TextStyle(
                          fontSize: screenWidth * 0.05
                        ),
                    ),                  
                    const SizedBox(height: 50,),
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Agrega hasta 12 cosas que te gustan"),

                    ),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: variablesScreenPerfil.controllerTasted,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05
                            ),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll( Color.fromARGB(255, 82, 255, 232))
                          ),
                          onPressed: () => {
                            functionsGeneralsPerfil!.addTaste()
                          },
                          child:  const Text("Agregar", style: TextStyle(color:  Color.fromARGB(255, 132, 0, 194)),)
                        )                       
                      ],
                    ),
                    ),                                        
                    const SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                          spacing: screenWidth * 0.01,
                          runSpacing: 15, 
                          children: [
                            
                            if(variablesScreenPerfil.listThingsLike.isNotEmpty)
                              ...List.generate(
                                variablesScreenPerfil.listThingsLike.length,
                                (int it) =>  Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                      child:   Container(
                                        padding: const  EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: functionsGeneralsPerfil!.setListColors(),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))
                                        ),
                                        child:  Text(variablesScreenPerfil.listThingsLike[it]),
                                      ),
                                    ),
                                  
                                  Positioned(
                                    right: 0,
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          functionsGeneralsPerfil!.deleteTaste(it);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,                                  
                                        ),
                                        child: ClipOval( 
                                          child: Image.asset(
                                            'assets/images/tacheRojo.png',
                                            width: 40, 
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                  ],
                               ),
                              )
                            else
                             const Center(
                                child: Text("Parece que aún no hay gustos"),
                              )
                          ],
                        ),
                    ),
                    
                    const SizedBox(height: 50,), 
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
                                "¿Que busco?",
                                style:  TextStyle(
                                  fontSize: screenWidth * 0.05
                                ),
                              ),
                        ),
                       
                      ],
                      
                    ),
                    TextField(
                        controller: variablesScreenPerfil.controllerWhatISearch,
                        maxLines: null,
                        keyboardType: TextInputType.multiline, 
                        style: TextStyle(
                          fontSize: screenWidth * 0.05
                        ),
                    ),
                    
                    const SizedBox(height: 60,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "Puedes agregar más fotos",
                            style: TextStyle(
                              fontSize: screenWidth * 0.06
                            ),
                          ),
                          const SizedBox(width: 20,),
                          IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(146, 189, 137, 242)), // Color de fondo
                            ),
                            onPressed: 
                              () => {
                                functionsImages!.pickImage("changeImageToSectionMoreImg")
                              }
                            ,
                            icon: const Icon(Icons.add,size: 30,
                            )
                          ),
                    
                        ],
                      )
                    ),
                    const SizedBox(height: 20,),

                    if(variablesScreenPerfil.listMorePhotosByUrl.isNotEmpty)
                    
                      ...List.generate(
                        variablesScreenPerfil.listMorePhotosByUrl.length,
                        (int itPositionImage) => 
                          Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                          width: screenWidth,  
                                          height: screenHeight * 0.4,  
                                          child: 
                                            variablesScreenPerfil.listMorePhotosByUrl[itPositionImage] != null
                                            ? 
                                              Image.network(variablesScreenPerfil.listMorePhotosByUrl[itPositionImage]["urlImage"]!,fit: BoxFit.cover)
                                            : 
                                              Image.asset("assets/images/sinFoto.jpg",fit: BoxFit.cover)
                                        ),
                                  ),

                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: ElevatedButton(
                                      onPressed: () => {
                                        functionsImages!.deleteImageExtra(itPositionImage: itPositionImage, typeImage: "previousImagesByUrl")
                                      },
                                      child: Image.asset("assets/images/tacheRojo.png", width: 30, height: 30,),
                                    )
                                  
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20,)
                            ],
                          )

                      ), 
                    if(variablesScreenPerfil.newImagesUserSelectedByFile.isNotEmpty)
                       ...List.generate(
                        variablesScreenPerfil.newImagesUserSelectedByFile.length,
                        (int itPositionImage) => 
                          Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                          width: screenWidth,  
                                          height: screenHeight * 0.4,  
                                          child: 
                                            variablesScreenPerfil.newImagesUserSelectedByFile[itPositionImage] != ""
                                            ? 
                                              Image.file(File(variablesScreenPerfil.newImagesUserSelectedByFile[itPositionImage].path),fit: BoxFit.cover)
                                            : 
                                              Image.asset("assets/images/sinFoto.jpg",fit: BoxFit.cover)
                                        ),
                                  ),

                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: ElevatedButton(
                                      onPressed: () => {
                                        functionsImages!.deleteImageExtra(itPositionImage: itPositionImage, typeImage: "imagesSelectedByDevice")
                                      },
                                      child: Image.asset("assets/images/tacheRojo.png", width: 30, height: 30,),
                                    )
                                  
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20,)
                            ],
                          )
                      )  
              ],  
              ),
              ),   
        ],
      ),
      ) 
    );
  }
}