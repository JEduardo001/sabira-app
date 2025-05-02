import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sabira/services/servicesToFunctionsGenerals.dart';

class ClientProvider with ChangeNotifier {
  ServicesToFunctionsGenerals functionsGenerals = ServicesToFunctionsGenerals();
  
  ClientData? clientData; 
  Map<String, dynamic> responseDataClient = {};
  
  Future<void> getDataClient() async {
    User? user = FirebaseAuth.instance.currentUser;
    var idClient = user?.uid;
    
    responseDataClient = await functionsGenerals.getDataUserOrClientById(idUser: idClient);

    if (responseDataClient.isNotEmpty) {
      clientData = ClientData.fromMap(responseDataClient); 
    }
    notifyListeners(); 
    
   
  }
  Future<bool> existClient() async {
    User? user = FirebaseAuth.instance.currentUser;
    print("Usuario UID: ${user?.uid}");
    if(user?.uid != null){
     return true;
    }else{
      return false;
    }
   
  }
}


class ClientData{
  
  String age;
  String descriptionIAm;
  String id;
  ImgProfile? imgProfile;
  List<MorePhotos> listMorePhotos;
  List<Matches> listMatches;
  String name;
  List<SmilesReceived> listSmilesReceived;
  List<SmilesSend> listSmilesSent;
  List<String> listThingsLike;
  String tokenDevice;
  String whatISearch;

  ClientData({
    required this.age,
    required this.descriptionIAm,
    required this.id,
    required this.imgProfile,
    required this.listMorePhotos,
    required this.listMatches,
    required this.name,
    required this.listSmilesReceived,
    required this.listSmilesSent,
    required this.listThingsLike,
    required this.tokenDevice,
    required this.whatISearch
  });

   factory ClientData.fromMap(Map<String, dynamic> map) {
  
    List<Matches> listMatches = [];
    List<MorePhotos> listMorePhotos = [];
    List<SmilesReceived> listSmilesReceived = [];
    List<SmilesSend> listSmilesSend = [];
    List<String> listThingsILike = [];
    ImgProfile? imgProfile = null;

    if(map['matches'] != null){
      listMatches = (map['matches'] as List).map((orderMap) => Matches.fromMap(orderMap)).toList();
    }

    if(map['listMorePhotos'] != null){
      listMorePhotos = (map['listMorePhotos'] as List).map((orderMap) => MorePhotos.fromMap(orderMap)).toList();

    }

    if(map['smilesReceived'] != null){
      listSmilesReceived = (map['smilesReceived'] as List).map((orderMap) => SmilesReceived.fromMap(orderMap)).toList();
    }
    
    if(map['smilesSent'] != null){
      listSmilesSend = (map['smilesSent'] as List).map((orderMap) => SmilesSend.fromMap(orderMap)).toList();
    }

    if(map['thingsILike'] != null){
      listThingsILike = (map['thingsILike'] as List).cast<String>();

     
    }

    if(map['imgProfile']["urlImage"] != "null"){
      imgProfile = ImgProfile.fromMap(map['imgProfile']);
    }

    return ClientData(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      descriptionIAm: map['descriptionIAm'],
      imgProfile: imgProfile,
      listMatches: listMatches,
      listMorePhotos: listMorePhotos,
      listSmilesReceived: listSmilesReceived,
      listSmilesSent: listSmilesSend,
      listThingsLike: listThingsILike,
      tokenDevice: map['tokenDevice'],
      whatISearch: map['whatISearch'],
    );
  } 

}



class ImgProfile{
  String nameFile;
  String urlImage;

  ImgProfile({
    required this.nameFile,
    required this.urlImage
  });

  factory ImgProfile.fromMap(Map<String, dynamic> map) {
    return ImgProfile(
      nameFile: map['nameFile'],
      urlImage: map['urlImage'],
    );
  }
}

class MorePhotos{
  String nameFile;
  String urlImage;

  MorePhotos({
    required this.nameFile,
    required this.urlImage
  });

  factory MorePhotos.fromMap(Map<String, dynamic> map) {
    return MorePhotos(
      nameFile: map['nameFile'],
      urlImage: map['urlImage'],
    );
  }
}


class Matches{
  String idUser;
  String matchDate;
 // String imgProfile;
 // String name;

  Matches({
    required this.idUser,
    required this.matchDate,
    // required this.imgProfile,
    //required this.name
  });

  factory Matches.fromMap(Map<String, dynamic> map) {
    return Matches(
      idUser: map['idUser'],
      matchDate: map['matchDate'],
     // imgProfile: map['imgProfile'],     
     // name: map['name'],
    );
  }
}

class SmilesReceived{
  String idUser;
  String smileDate;
 // String imgProfile;
 // String name;

  SmilesReceived({
    required this.idUser,
    required this.smileDate,
   // required this.imgProfile,
   // required this.name
  });

  factory SmilesReceived.fromMap(Map<String, dynamic> map) {
    return SmilesReceived(
      idUser: map['idUser'],
      smileDate: map['smileDate'],
    //  imgProfile: map['imgProfile'],
    //  name: map['name'],

    );
  }
}

class SmilesSend{
  String idUser;
  String smileDate;
 // String imgProfile;
 // String name;

  SmilesSend({
    required this.idUser,
    required this.smileDate,
  //  required this.imgProfile,
  //  required this.name
  });

  factory SmilesSend.fromMap(Map<String, dynamic> map) {
    return SmilesSend(
      idUser: map['idUser'],
      smileDate: map['smileDate'],
     // imgProfile: map['imgProfile'],
     // name: map['name'],

    );
  }
}




  