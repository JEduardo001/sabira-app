import 'dart:ui';

import 'package:sabira/functionsOfScreens/screenPerfil/Variables.dart';

class FunctionsGeneralsPerfil {
  Variables variablesScreenPerfil = Variables();

  final Function() updateUI;
  FunctionsGeneralsPerfil({required this.variablesScreenPerfil,required this.updateUI});

  Color setListColors(){
        variablesScreenPerfil.itListColorsTasted++;
        if(variablesScreenPerfil.itListColorsTasted==variablesScreenPerfil.listColorsTasted.length){
          variablesScreenPerfil.itListColorsTasted = 0;
        }
        return variablesScreenPerfil.listColorsTasted[variablesScreenPerfil.itListColorsTasted];

  }

  void addTaste(){
      if(variablesScreenPerfil.controllerTasted.text != "" && variablesScreenPerfil.listThingsLike.length < 12){
          variablesScreenPerfil.listThingsLike.add(variablesScreenPerfil.controllerTasted.text);
          variablesScreenPerfil.controllerTasted.text = "";
        updateUI();
      }
     
    }

    void deleteTaste(it){
     variablesScreenPerfil.listThingsLike.removeAt(it);
     updateUI();
    }
}