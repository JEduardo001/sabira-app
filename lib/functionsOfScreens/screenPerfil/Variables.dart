import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Variables {

  List<Color> listColorsTasted = [ 
     const Color.fromARGB(255, 54, 216, 244), 
     const Color.fromARGB(255, 124, 244, 54),
    const Color.fromARGB(255, 158, 54, 244),
  ];
  int itListColorsTasted = -1;

  //controladores textinput
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAge = TextEditingController();
  TextEditingController controllerIAm = TextEditingController();
  TextEditingController controllerTasted = TextEditingController();
  TextEditingController controllerWhatISearch = TextEditingController();

  bool dataUploaded = false;
  bool existImageProfile = true;

  ImagePicker picker = ImagePicker();
  bool isPickingImage = false;
  XFile? newImageProfileSelectedByFile = null;
  XFile? newImageSectionMoreImgSelectedByFile = null;

  List<XFile> newImagesUserSelectedByFile = [];
  Map<String,dynamic> imageProfileByUrl = {};
  List<Map<String,dynamic>> listMorePhotosByUrl = [];
  Map<String,dynamic> urlImageProfile = {};
  List<Map<String,dynamic>> imagesToDelete = [];
  List<Map<String,dynamic>> urlsNewImagesToUpdate = [];
  List<String> listThingsLike = [];

}