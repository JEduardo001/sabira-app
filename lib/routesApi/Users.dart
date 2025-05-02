import 'package:http/http.dart' as http;
import 'dart:convert';

class Users {
  List<dynamic>? listUsers;
  List<dynamic>? get users => listUsers;

  Future<bool> getUsers() async {
    final http.Response response;
    bool resultState = false;
    try{
      response = await http.get(Uri.parse('http://10.0.2.2:3000/api/users'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        listUsers = data;
        resultState = true;
      }else{
        print("Error al obtener los usuarios error code ${response.statusCode}");
      }
    }catch(e){
      print("Error al obtener los usuarios. $e");
    }

    return resultState;
  }
}