import 'package:sabira/functionsOfScreens/screenPerfil/Variables.dart';
import 'package:sabira/provider/FirebaseProvider.dart';
import 'package:sabira/services/ServicesToFunctionsGenerals.dart';
import 'package:sabira/services/servicesToClient.dart';


class FunctionsControllerUser {
  ServicesToFunctionsGenerals functionsGenerals =ServicesToFunctionsGenerals();
  FirebaseProvider firebaseProvider = FirebaseProvider();
  Variables variablesScreenPerfil = Variables();
  ServicesToclient servicesToclient = ServicesToclient();

  final Function() updateUI;


  FunctionsControllerUser({required this.variablesScreenPerfil,required this.updateUI});
  
  Future<void> loadDataUser({required idClient}) async{
    Map<String,dynamic> dataUser = {};
    String noData = "No especificado";

    dataUser = await functionsGenerals.getDataUserOrClientById(idUser: idClient);
    if(dataUser.isNotEmpty){
      
      variablesScreenPerfil.imageProfileByUrl = dataUser["imgProfile"];
      variablesScreenPerfil.controllerName.text = (dataUser["name"] == "null") ? noData : dataUser["name"] ;
      variablesScreenPerfil.controllerAge.text = (dataUser["age"] == "null") ? "" : dataUser["age"] ;
      variablesScreenPerfil.controllerIAm.text =(dataUser["iAm"] == "null") ? noData : dataUser["iAm"];
      variablesScreenPerfil.controllerWhatISearch.text = (dataUser["whatISearch"] == "null") ? noData : dataUser["whatISearch"] ;

      dataUser["thingsILiked"].forEach((taste) => {
        variablesScreenPerfil.listThingsLike.add(taste)
      });
      dataUser["listMorePhotos"].forEach((photo) => {
        variablesScreenPerfil.listMorePhotosByUrl.add(photo)
      });

      if(variablesScreenPerfil.imageProfileByUrl["urlImage"] == "null"){
       variablesScreenPerfil.existImageProfile = false;
      }

     variablesScreenPerfil.dataUploaded = true;
    }else{
      print("No hay datos del usuario");
    }


  } 

  Future<bool> updateDataUser({required newDataUser, required idClient}) async{
    bool exito = await servicesToclient.updateDataUser(idUser: idClient,data: newDataUser);
    return exito;
  } 

  Future<bool> operationsToUpdateDataUser({required idClient, required functionsToPrepareDataToUpdateDataUser, required functionsImages}) async{
    bool succesUpdateDataUser = false;
    Map<String,dynamic> resultNewDataUser;

    await uploadNewImages(idClient: idClient);
    resultNewDataUser = prepareNewDataUser(functionsToPrepareDataToUpdateDataUser); 
  
    //subir los nuevos datos
    succesUpdateDataUser = await updateDataUser(newDataUser: resultNewDataUser, idClient: idClient);

    if(succesUpdateDataUser){
      //eliminamos la foto de perfil de storage
      await functionsImages!.deleteImagesFromStorageAndDataBase(idClient: idClient);
    }         

    return  succesUpdateDataUser;
  }

  Map<String,dynamic> prepareNewDataUser(functionsToPrepareDataToUpdateDataUser){
    //preparar los las nuevas imagenes seccion mas imagenes
    List<Map<String,String>> listMorePhotos = functionsToPrepareDataToUpdateDataUser!.prepareNewListMorePhotos();    
    // preparar la nueva imagen de perfil   
    var resultImageProfile = functionsToPrepareDataToUpdateDataUser!.prepareNewImageProfile();
    //obtenemos el resultado final de los nuevos datos
    var resultNewDataUser = functionsToPrepareDataToUpdateDataUser!.prepareResultNewDataUser(listMorePhotos: listMorePhotos, resultImageProfile: resultImageProfile );   

    return resultNewDataUser;
  }

  Future<void> uploadNewImages({required idClient}) async{
    //subir la imagen nueva de perfil de usuario a storage y regresar la url 
    if(variablesScreenPerfil.newImageProfileSelectedByFile != null){    
      variablesScreenPerfil.urlImageProfile  = await firebaseProvider.uploadPhotoImageProfile(idUser: idClient, variablesScreenPerfil: variablesScreenPerfil);
    }
    //subir las imagenes nuevas seccion more imagenes y regresar las url
    if(variablesScreenPerfil.newImagesUserSelectedByFile.isNotEmpty){             
      variablesScreenPerfil.urlsNewImagesToUpdate = await firebaseProvider.uploadPhotosSectionMoreImages(idUser: idClient, variablesScreenPerfil: variablesScreenPerfil);
    }

  }
}