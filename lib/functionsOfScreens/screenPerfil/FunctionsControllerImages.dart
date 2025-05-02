import 'package:image_picker/image_picker.dart';
import 'package:sabira/functionsOfScreens/screenPerfil/Variables.dart';
import 'package:sabira/provider/FirebaseProvider.dart';
import 'package:sabira/services/servicesToClient.dart';

class FunctionsControllerImages {
  Variables variablesScreenPerfil = Variables();
  ServicesToclient servicesToclient = ServicesToclient();
  FirebaseProvider firebaseProvider = FirebaseProvider();

  final Function() updateUI;

  FunctionsControllerImages({required this.variablesScreenPerfil,required this.updateUI});



  Future<void> pickImage(String destinationRoute) async {
  if (variablesScreenPerfil.isPickingImage) {
    return; 
  }

  variablesScreenPerfil.isPickingImage = true;

  updateUI();

  XFile? selectedImage;
  
  selectedImage = await variablesScreenPerfil.picker.pickImage(source: ImageSource.gallery);
  
  if (selectedImage != null) {
    if (destinationRoute == "changeImageProfile") {
      variablesScreenPerfil.newImageProfileSelectedByFile = selectedImage;
        variablesScreenPerfil.existImageProfile = true;
        updateUI();

    }

    if (destinationRoute == "changeImageToSectionMoreImg") {
      variablesScreenPerfil.newImageSectionMoreImgSelectedByFile = selectedImage;
      variablesScreenPerfil.newImagesUserSelectedByFile.add(variablesScreenPerfil.newImageSectionMoreImgSelectedByFile!);
    } 
  }

  variablesScreenPerfil.isPickingImage = false;
  updateUI();

}


void deleteImageProfile(){

      if(variablesScreenPerfil.newImageProfileSelectedByFile != null){
        variablesScreenPerfil.existImageProfile = false;
        variablesScreenPerfil.newImageProfileSelectedByFile = null;
        updateUI();

      }

      if(variablesScreenPerfil.imageProfileByUrl["urlImage"] != "null"){
          variablesScreenPerfil.existImageProfile = false;
          variablesScreenPerfil.imagesToDelete.add({
            "urlImage": variablesScreenPerfil.imageProfileByUrl["urlImage"],
            "nameFile": variablesScreenPerfil.imageProfileByUrl["nameFile"]
          });
          variablesScreenPerfil.imageProfileByUrl["urlImage"] = "null";
          variablesScreenPerfil.imageProfileByUrl["nameFile"] = "null"; 

        updateUI();
      }   
    }


     void deleteImageExtra({required itPositionImage, typeImage}){
      if(typeImage == "imagesSelectedByDevice"){
          variablesScreenPerfil.newImagesUserSelectedByFile.removeAt(itPositionImage);
      
        updateUI();

      }else{
          variablesScreenPerfil.imagesToDelete.add({
            "nameFile": variablesScreenPerfil.listMorePhotosByUrl[itPositionImage]["nameFile"],
            "urlImage": variablesScreenPerfil.listMorePhotosByUrl[itPositionImage]["urlImage"]
          });
          variablesScreenPerfil.listMorePhotosByUrl.removeAt(itPositionImage);
        updateUI();
       
      }
     
    }

    Future<bool> deleteImagesFromStorageAndDataBase({required idClient}) async{
      if(variablesScreenPerfil.imagesToDelete.isNotEmpty){
        await servicesToclient.deletePreviousImages(listImagesToDelete: variablesScreenPerfil.imagesToDelete, idUser: idClient);// eliminar foto de database 
        await firebaseProvider.deletePreviousImages(listImagesToDelete: variablesScreenPerfil.imagesToDelete);// eliminar foto de storage 
      }
      return true;
   
    } 
}