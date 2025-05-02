
import 'dart:convert';
import 'package:http/http.dart' as http;
class ServicesToFunctionsGenerals {

  Future<bool> checkMatch({required idUserSendSmile, required idUserDestinationSmile}) async {
    bool match = false;
    String urlValidateLastMatch = "http://10.0.2.2:3000/api/validateLastMatch";

    try{
      final lastMatchResponse =  await http.get(Uri.parse("$urlValidateLastMatch/$idUserSendSmile/$idUserDestinationSmile"));
      if (lastMatchResponse.statusCode == 200) {
        var decodedResponse = jsonDecode(lastMatchResponse.body);
        var lastMatch = decodedResponse['data'];
        if(!lastMatch){
          await insertSmile(idUserSendSmile: idUserSendSmile, idUserDestinationSmile: idUserDestinationSmile);      

          if(await existMatch(idUserSendSmile: idUserSendSmile, idUserDestinationSmile: idUserDestinationSmile)){
            //insertamos el usuario con el que hizo match en su lista de matches, lo mismo para el otro usuario
            await insertListMatches(idUserSendSmile: idUserSendSmile, idUserDestinationSmile: idUserDestinationSmile);
            await createChat(idUserSendSmile: idUserSendSmile, idUserDestinationSmile: idUserDestinationSmile);
          }
        } 
      } else {
        print('Error al obtener si hubo un anterior match: ${lastMatchResponse.statusCode}');
      }      
    }catch(e){
      print("Error al tener validar si ya hubo match anteriormente");
    }  
    return match;
  }

  Future<Map<String,dynamic>> getDataUserOrClientById({required idUser}) async {
    Map<String,dynamic> dataUser = {};
    String url = "http://10.0.2.2:3000/api/getDataUser";
    try{
      final response = await http.get(Uri.parse("$url/$idUser"));
      if(response.statusCode == 200){
        dataUser = jsonDecode(response.body);
      }else{
        print("Error al traer los datos del  usuarioo ${response.statusCode}");
      }
    }catch(e){
      print("Error al traer los datos del usuario error: $e");
    }

    return dataUser;
  }

  Future<void> sendTokenToServer(String? token, String idClient) async {
    if (token != null) {
      print("Enviando token al servidor: $token");
      var tokenDevice = {
        "token": token
      };

      var jsonToken = jsonEncode(tokenDevice);

      //var idClient = idClientToken;
      String url = "http://10.0.2.2:3000/api/setTokenDispositivoClient";
      try{
        final response = await http.put(Uri.parse("$url/$idClient"),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonToken
          
        );
        if(response.statusCode == 200){
          print("Token insertado correctamente");
        }else{
          print("Error al insertar el token. error${response.statusCode} Error: ${response.body}");
        }
      }catch(e){
        print("Error al insertar el token. $e");
      }


    }
  }

  Future<void> createChat({required idUserSendSmile, required idUserDestinationSmile}) async {
    String urlCreateChat = "http://10.0.2.2:3000/api/createChat";
    DateTime now = DateTime.now();

    try{
        final response = await http.get(Uri.parse("$urlCreateChat/$idUserDestinationSmile/$idUserSendSmile/$now"));
        if(response.statusCode == 200){
          print("Chat creado para ambos usuarios");
        }else{
          print("Error al crear el chat${response.body}"); 
        }
      }catch(e){
        print("Error al hacer la llamada a la api para crear el chat. $e");
    }
  }

  Future<void> insertListMatches({required idUserSendSmile, required idUserDestinationSmile}) async{
      DateTime now = DateTime.now();
      String urlInsertMatch = "http://10.0.2.2:3000/api/insertMatch";
      //insertamos el usuario con el que hizo match en ambas listas de sus maches de ambos usuarios
      try{
        final response = await http.get(Uri.parse("$urlInsertMatch/$idUserDestinationSmile/$idUserSendSmile/$now"));
        if(response.statusCode == 200){
          print("usuarios que hicieron match insertados en sus lisas de match");
        }else{
          print("Error al insertar en sus listas de match los usuarios que hicieron match${response.body}"); 
        }
      }catch(e){
        print("Error al insertar en sus listas de match los usuarios que hicieron match :  $e");
      }
  }

  Future<bool> existMatch({required idUserSendSmile, required idUserDestinationSmile}) async {
    bool match = false;
    String urlValidateMatch = "http://10.0.2.2:3000/api/validateMatch";
    //validar match
    try{
      final response = await http.get(Uri.parse("$urlValidateMatch/$idUserDestinationSmile/$idUserSendSmile"));
      if(response.body == "true"){
        match = true;
      }else{
        print("match falso${response.body}"); 
      }
    }catch(e){
      print("Error al insertar la sonrisa en la lista de sonrisas enviadas del usuario:  $e");
    }
    return match;
  }

  Future<void> insertSmile({required idUserSendSmile, required idUserDestinationSmile}) async{
    String urlInsertSmile = "http://10.0.2.2:3000/api/insertSmile";
    DateTime now = DateTime.now();

    //insertar sonrisa
    try{
      final response = await http.put(Uri.parse("$urlInsertSmile/$idUserSendSmile/$idUserDestinationSmile/$now"));
      if(response.statusCode == 200){
        print("Sonrisa insertada con exito");
      } 
    }catch(e){
      print("Error al insertar la sonrisa en la lista de sonrisas enviadas del usuario:  $e");
    } 
  }

  Future<List<dynamic>> getUsers({required itStartUser}) async {    
    List<dynamic> dataUsers = [];
    try{
      // - itStartUser -  iterador que sirve para indicar desde que posicion de la lista de usuarios empezar a tomar los datos

      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/users/$itStartUser'));
      if (response.statusCode == 200) {
         dataUsers = json.decode(response.body);
      }else{
        print("Error al obtener los usuarios error  ${response}");
      }
    }catch(e){
      print("Error al obtener los usuarios. $e");
    }
    return dataUsers;
  }
}

