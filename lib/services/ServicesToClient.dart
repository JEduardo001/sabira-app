import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesToclient {

  Future<bool> updateDataUser({required idUser,required data}) async {
    String url = "http://10.0.2.2:3000/api/updateDataUser";
    bool exito = false;
    try{
      final jsonData = jsonEncode(data);

      final response = await http.put(
        Uri.parse("$url/$idUser"),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonData
      );
      if(response.statusCode == 200){
        print("datos actualizados");
        exito = true;
      }else{
        print("error al actualizar los datos del ususario ${response.body}"); 
      }
    }catch(e){
      print("Error al actualizar los datos del usuario $e");
    }
    return exito;

  }

   Future<List<dynamic>> loadSmilesSend({required idUser}) async {
    List<dynamic> data = [];
    String url = "http://10.0.2.2:3000/api/getSmilesSend";
    try{
      final response = await http.get(Uri.parse("$url/$idUser"));
      if(response.statusCode == 200){
        data = jsonDecode(response.body);
      }else{
        print("Error al traer las sonrisas enviadas del  usuarioo ${response.statusCode}");
      }
    }catch(e){
      print("Error al traer las sonrisas enviadas del usuario error: $e");
    }
    
    return data;
  }

  Future<List<dynamic>> loadSmilesReceived({required idUser}) async {
    List<dynamic> data = [];
    String url = "http://10.0.2.2:3000/api/getSmilesReceived";
    try{
      final response = await http.get(Uri.parse("$url/$idUser"));
      if(response.statusCode == 200){
        data = jsonDecode(response.body);
      }else{
        print("Error al traer las sonrisas recibidas del  usuarioo codigo de error${response.statusCode} Error: ${response.body}");
      }
    }catch(e){
      print("Error al traer las sonrisas recibidas del usuario error: $e");
    }

    return data;
  }

  Future<List<dynamic>> loadListMatches({required idUser}) async {
    List<dynamic> data = [];
    String url = "http://10.0.2.2:3000/api/getListMatchs";
    try{
      final response = await http.get(Uri.parse("$url/$idUser"));
      if(response.statusCode == 200){
        data = jsonDecode(response.body);
      }else{
        print("Error al traer la lista de matches del usuarioo codigo de error${response.statusCode} Error: ${response.body}");
      }
    }catch(e){
      print("Error al traer la lista de matches del usuario error: $e");
    }

    return data;
  }

  Future<List<dynamic>> loadChats({required idUser}) async {
    List<dynamic> data = [];
    String url = "http://10.0.2.2:3000/api/getListChats";
    try{
      final response = await http.get(Uri.parse("$url/$idUser"));
      if(response.statusCode == 200){
        data = jsonDecode(response.body);
      }else{
        print("Error al traer la lista de chats del usuarioo codigo de error${response.statusCode} Error: ${response.body}");
      }
    }catch(e){
      print("Error al traer la lista de chats del usuario error: $e");
    }

    return data;
  }

  Future<Map<String,dynamic>> loadChatData({required idChat}) async {
    Map<String,dynamic> data = {};
    String url = "http://10.0.2.2:3000/api/loadChatData";
    try{
      final response = await http.get(Uri.parse("$url/$idChat"));
      if(response.statusCode == 200){
        data = jsonDecode(response.body);
      }else{
        print("Error al traer el contenido del chat. error${response.statusCode} Error: ${response.body}");
      }
    }catch(e){
      print("Error al traer el contenido del chat. $e");
    }

    return data;
  }


  Future<void> insertMessage({required dataMessage, required idChat}) async {
    String url = "http://10.0.2.2:3000/api/insertMessage";
    try{
      final dataMessageJson = jsonEncode(dataMessage);

      final response = await http.post(Uri.parse("$url/$idChat"),
         headers: {
          'Content-type': 'application/json',
          },
          body: dataMessageJson
      );
      if(response.statusCode == 200){
        print("Mensaje insertado correctamente en la base de datos");
      }else{
        print("Error al insertar el mensaje del chat. error${response.statusCode} Error: ${response.body}");
      }
    }catch(e){
      print("Error al insertar el mensaje del chat. $e");
    }
  }
    

   Future<bool> deletePreviousImages({required listImagesToDelete, required idUser}) async {
    bool codeStatus = false; 
    String url = "http://10.0.2.2:3000/api/deleteImage";
    try{
      final imagesToDelete = jsonEncode(listImagesToDelete);

      final response = await http.delete(Uri.parse("$url/$idUser"),
         headers: {
          'Content-type': 'application/json',
          },
          body: imagesToDelete
      );
      if(response.statusCode == 200){
        print("Imagenes a eliminar eliminadas con exito");
        codeStatus = true;
      }else{
        print("Error al eliminar las imagenes. error${response.statusCode} Error: ${response.body}");
      }
     
    }catch(e){
      print("Error al eliminar las imagenes. $e");
    }

    return codeStatus;
  }

}