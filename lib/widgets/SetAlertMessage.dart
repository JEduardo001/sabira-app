

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabira/utils/UtilsForRegisterAndLogin.dart';


void setAlertMessage({required String typeMessage, required context}){ 
    String message = "";

    switch(typeMessage){
      case "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.":
        message = "Contraseña incorrecta";
      break;
      case "[firebase_auth/invalid-email] The email address is badly formatted.":
        message = "Correo electrónico no valido";
      break;
      case "incorrectFields":
        message = "Todos los campos deben estar completos";
      break;
      case "passwordDoesNotMatch":
        message = "Las contraseñas no coinciden";
      break;
      case "[firebase_auth/weak-password] Password should be at least 6 characters":
        message = "La contraseña debe tener como mínimo 6 caracteres";
      break;
      case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
        message = "El correo elctrónico ingresado, ya esta en uso";
      break;
      default:
        message = "Ocurrio un error vuelve a intentarlo, si el problema persiste intentalo más tarde";
      break;
    }
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
}

void setAlertWaitingForAccountVerification({required context, required message}) async{

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
            AlertDialog(
              title: const Text('Alerta'),
              content: Column(
                children: [
                  Text(message),
                  const SizedBox(height: 30,),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async => { 
                      sendEmailVerification(context: context)
                    },
                     child: const Text("Volver a enviar correo de verificación")
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                ),
                
              ],
            );
      },
    );
}