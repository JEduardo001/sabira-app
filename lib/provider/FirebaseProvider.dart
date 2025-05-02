
import 'dart:io';
import 'package:sabira/main.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sabira/services/ServicesToFunctionsGenerals.dart';

class FirebaseProvider with ChangeNotifier{
  ServicesToFunctionsGenerals functionsGenerals = ServicesToFunctionsGenerals();
  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference storageRef;
   // Esta función sube las fotos al servicio storage
  Future<List<Map<String,String>>> uploadPhotosSectionMoreImages({required variablesScreenPerfil, required idUser}) async {
    File file;
    String fileName;
    List<Map<String,String>> urlImages = [];

    try {

      for(int i=0;i<variablesScreenPerfil.newImagesUserSelectedByFile.length;i++){
        file = File(variablesScreenPerfil.newImagesUserSelectedByFile[i].path);  
        fileName = 'imagesUsers/moreImgUsers/${DateTime.now().millisecondsSinceEpoch}_extraPhoto_idUser_$idUser.png';
        //lo anadimos al servicio storage
        await FirebaseStorage.instance
            .ref(fileName) 
            .putFile(file); 

        urlImages.add(
          { 
            "urlImage": await getUrlImage(fileName,file),
            "nameFile": fileName
          }
        );
      }
    
      
    } catch (e) {
      print('Error al subir las imagenes seccion mas imagenes a storage: $e');
    }
    return urlImages;
  }

  Future<Map<String,String>> uploadPhotoImageProfile({required variablesScreenPerfil, required idUser}) async {
    File file;
    String fileName;
    Map<String,String> urlImage = {};

    try {

      file = File(variablesScreenPerfil.newImageProfileSelectedByFile.path);  
      fileName = 'imagesUsers/imgProfilesUsers/${DateTime.now().millisecondsSinceEpoch}_profilePhoto_idUser_$idUser.png'; 
      //lo anadimos al servicio storage
      await FirebaseStorage.instance
          .ref(fileName) 
          .putFile(file);  

      urlImage["nameFile"] = fileName;
      urlImage["urlImage"] = await getUrlImage(fileName,file);
        
  
    } catch (e) {
      print('Error al subir la imagen del perfil a storage: $e');
    }
    return urlImage;
  }

  //eliminar fotos de storage
 Future<bool> deletePreviousImages({required listImagesToDelete}) async {
 
  try {
    for(int i=0;i<listImagesToDelete.length;i++){
      print("image a borrar desde el controlador de firebase ${listImagesToDelete[i]["nameFile"]}");
      storageRef = storage.ref().child(listImagesToDelete[i]["nameFile"]);
      await storageRef.delete();
    }
    
    print("Archivos eliminados de storage con exito.");
  } catch (e) {
    print("Error al eliminar el archivo de storage: $e");
  }

  return true;
}

Future<String> getUrlImage(fileName,file) async{
    // Crear una referencia para el archivo
      storageRef = storage.ref().child(fileName);
      // Subir el archivo
      UploadTask uploadTask = storageRef.putFile(file);
      
      // Esperar a que la subida termine
      await uploadTask;
      
      // Obtener la URL de descarga despues de que el archivo haya sido subido
      String downloadURL = await storageRef.getDownloadURL();

      return downloadURL;
  }

  void initStateFirebase({required idClient}) async {
      // Asegúrate de inicializar Firebase antes de ejecutar la aplicación
    /*   WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(); */


    // Escuchar cambios en el token cuando la app se inicie
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Token renovado: $newToken");
      // Enviar el nuevo token al servidor
      functionsGenerals.sendTokenToServer(newToken,idClient);
    });

    // Obtener el token al iniciar la app (si es necesario)
    FirebaseMessaging.instance.getToken().then((token) {
      print("Token inicial: $token");
      // Enviar el token al servidor
      functionsGenerals.sendTokenToServer(token,idClient);
    }); 

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Mensaje recibido en primer plano: ${message.notification?.title}');
    print('Cuerpo: ${message.notification?.body}');
    
    // Puedes mostrar la notificación o actualizar la UI aquí
    // Si prefieres mostrarla de manera personalizada en la app, usa algo como:
    /* showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.notification?.title ?? 'Nuevo mensaje'),
          content: Text(message.notification?.body ?? 'Contenido del mensaje'),
        );
      },
    ); */
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('La notificación fue abierta desde segundo plano o cerrado.');
    print('Mensaje: ${message.notification?.title}');
    //esto se dispara solo cuando se recibe una noti y la app esta en segundo plano en multitarea y cuando la app esta completamente cerrada
      navigatorKey.currentState?.pushNamed('/', arguments: message.data);
    // Puedes navegar a una pantalla específica de chat o lo que necesites
    //Navigator.pushNamed(context, '/chat', arguments: message.data);
  });
  }
}

