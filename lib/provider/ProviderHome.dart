import 'package:flutter/material.dart';
import 'package:sabira/services/ServicesToFunctionsGenerals.dart';
import 'package:sabira/services/ServicesToUsers.dart';

class ProviderHome with ChangeNotifier {
  ServicesToUsers servicesToUsers = ServicesToUsers();
  ServicesToFunctionsGenerals servicesGenerals = ServicesToFunctionsGenerals();

  String idUserSearch = "";
  bool searchById = false;
  int itUser = 0;
  int itUserLast = 0;
  int itStartGetUserIndex = 0;
  List<dynamic> dataUsers = [];
  bool loadingDataUsers= true;


  void setIdUserSearch(String newIdUserSearch) {
    idUserSearch = newIdUserSearch;
    notifyListeners();  
  }

  void setSearchById(bool newSearchById) {
    searchById = newSearchById;
    notifyListeners();
  }

  void setItUser(int newItUser) {
    itUser = newItUser;
    notifyListeners();
  }

  void setItUserLast(int newItUserLast) {
    itUserLast = newItUserLast;
    notifyListeners();
  }

  void setStartItUserIndex(int newItStartUserIndex) {
    itStartGetUserIndex = newItStartUserIndex;
    notifyListeners();
  }
   void setLoadingDataUsers(bool newValue) {
    loadingDataUsers = newValue;
    notifyListeners();
  }

  Future<void> getMoreUsers() async{
    List<dynamic> usersData = await servicesGenerals.getUsers(itStartUser: itStartGetUserIndex);
    print("tomare usuarios de la bd desde la posicion:: $itStartGetUserIndex");
    print("la cantidad de nuevos usuarios son: ${usersData.length}");
    print("xxxxxxxxxx $usersData");

    if(usersData.isNotEmpty){
      // Validamos si aun hay usuarios por ver de la antigua lista, si es asi los unimos con los nuevos
      if(itUser < dataUsers.length-1){
        for(var user in usersData){
          dataUsers.add(user);
        }
      }else{
        dataUsers = usersData;
        itUser = 0;
      }
     
      if(searchById){
        Map<String,dynamic> dataUserSearch = await servicesGenerals.getDataUserOrClientById(idUser: idUserSearch);
        itUserLast = itUser;
        dataUsers.add(dataUserSearch);
        itUser = dataUsers.length -1; 
      }
      loadingDataUsers = false;
    }else{
      print("No hay mas usuarios nuevos que tomar");
      //validamos si aun hay usuarios por ver en la lista
      if(itUser >= dataUsers.length-1){
        itUser = 0;
        itStartGetUserIndex = 0;
      }
    }
  }
}