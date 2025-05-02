import 'package:sabira/functionsOfScreens/screenPerfil/Variables.dart';

class FunctionsToPrepareDataToUpdateDataUser {
  Variables variablesScreenPerfil = Variables();

  final Function() updateUI;


  FunctionsToPrepareDataToUpdateDataUser({required this.variablesScreenPerfil,required this.updateUI});

   List<Map<String,String>> prepareNewListMorePhotos()
    {
    List<Map<String, String>> listMorePhotos = [];

      for (int i = 0; i < variablesScreenPerfil.listMorePhotosByUrl.length; i++) {
        listMorePhotos.add({
          "nameFile": variablesScreenPerfil.listMorePhotosByUrl[i]["nameFile"],
          "urlImage": variablesScreenPerfil.listMorePhotosByUrl[i]["urlImage"]
        });
      }

      if (variablesScreenPerfil.urlsNewImagesToUpdate.isNotEmpty) {
        for (int i = 0; i < variablesScreenPerfil.urlsNewImagesToUpdate.length; i++) {
          listMorePhotos.add({
            "nameFile": variablesScreenPerfil.urlsNewImagesToUpdate[i]["nameFile"],
            "urlImage": variablesScreenPerfil.urlsNewImagesToUpdate[i]["urlImage"]
          });
        }
      }

    return listMorePhotos;

       
  }


  Map<String, dynamic?>? prepareNewImageProfile(){
      
       var resultImageProfile = (!variablesScreenPerfil!.existImageProfile)
        ? {
            
              "nameFile": "null",
              "urlImage": "null",
            
          }
        : (variablesScreenPerfil.urlImageProfile.isNotEmpty)
            ? {
                "nameFile": variablesScreenPerfil.urlImageProfile["nameFile"],
                "urlImage": variablesScreenPerfil.urlImageProfile["urlImage"],
                  
                
              }
            : null; 
      return resultImageProfile;
  }

  Map<String,dynamic>  prepareResultNewDataUser({required resultImageProfile, required listMorePhotos})
  {
     var newDataUser = {
            "name": (variablesScreenPerfil.controllerName.text == "No especificado" || variablesScreenPerfil.controllerName.text == "") ? "null" : variablesScreenPerfil.controllerName.text,
            "age": (variablesScreenPerfil.controllerAge.text == "") ? "null" : variablesScreenPerfil.controllerAge.text,
            "iAm": (variablesScreenPerfil.controllerIAm.text == "No especificado" || variablesScreenPerfil.controllerIAm.text == "") ? "null" : variablesScreenPerfil.controllerIAm.text,

            "thingsILiked": [
              for(int i = 0; i<variablesScreenPerfil.listThingsLike.length;i++)
                variablesScreenPerfil.listThingsLike[i]
              
            ],
            "whatISearch":(variablesScreenPerfil.controllerWhatISearch.text == "No especificado" || variablesScreenPerfil.controllerWhatISearch.text == "") ? "null" : variablesScreenPerfil.controllerWhatISearch.text,
            "listMorePhotos": listMorePhotos,

                      
            
            if(resultImageProfile != null)
              "imgProfile": {
                "nameFile": resultImageProfile["nameFile"],
                "urlImage": resultImageProfile["urlImage"],
              }
      
                                
          };
    return newDataUser;

  }
}