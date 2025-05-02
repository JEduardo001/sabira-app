import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesToUsers {

  Future<bool> createUser({required idUser}) async {
    String url = "http://10.0.2.2:3000/api/createUser";
    bool exito = false;
    String tokenDevice;

     Map<String,dynamic> dataUser = {
      "id": idUser,
      "tokenDevice": "null",
      
    };

    try{
      final jsonData = jsonEncode(dataUser);

      final response = await http.post(
        Uri.parse("$url"),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonData
      );
      if(response.statusCode == 200){
        print("Usuario creado");
        exito = true;
      }else{
        print("Error al crear el usuario ususario ${response.body}"); 
      }
    }catch(e){
      print("Error al intentar crear el usuario $e");
    } 
    return exito;

  }
}