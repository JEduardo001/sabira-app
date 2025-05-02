import 'package:flutter/material.dart';
import 'package:sabira/screens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabira/screens/Perfil.dart';
import 'package:sabira/services/ServicesToUsers.dart';

import 'package:sabira/widgets/SetAlertMessage.dart';


class CrearCuenta extends StatefulWidget {
  const CrearCuenta({super.key});

  @override
  State<CrearCuenta> createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {

  bool ocultarPassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordControllerRepeat = TextEditingController();
  ServicesToUsers servicesToUsers  = ServicesToUsers();




  // Registro de usuario
  Future<String> register() async {
    String typeError = "null";
    try {
      // Crear usuario con correo y contraseña
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

     if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        servicesToUsers.createUser(idUser: uid);
      } else {
        print("Error al crear el documento del usuario, su UID es null");
      }
      // Enviar correo de verificación
      await userCredential.user?.sendEmailVerification();

      // Notificar al usuario que el correo de verificación ha sido enviado
      setAlertWaitingForAccountVerification(
        context: context,
        message: 'Se ha enviado un correo de verificación a ${emailController.text}. Por favor, confirmalo para poder crear tu cuenta.  Esperando confirmación'
      );

     
      // Esperar a que el usuario verifique su correo
      bool emailVerified = false;
      while (!emailVerified) {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.reload();  // Recargar el usuario para obtener el estado actualizado
        emailVerified = user?.emailVerified ?? false;

        if (!emailVerified) {
          // Si no está verificado, esperar un momento antes de volver a comprobar
          await Future.delayed(Duration(seconds: 3));
        }

       
      }

      User? user = FirebaseAuth.instance.currentUser;

      // Si el correo está verificado, se manda a la nueva pantalla
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Perfil(idClient: user!.uid,)),
      );
      print("Correo verificado y redirigiendo...");

    } catch (e) {
      typeError = e.toString();
      print('Error al registrarse: $e');
    }
    return typeError;
  }




  void setAlert(String typeMessage){  
    setAlertMessage(typeMessage: typeMessage, context: context);
  }

  void validationsForRegister() async {
    String responseRegister;
    
    if(emailController.text == "" || passwordController.text == "" || passwordControllerRepeat.text == ""){
      setAlert("incorrectFields");
    }else{
      if(passwordController.text != passwordControllerRepeat.text){
        setAlert("passwordDoesNotMatch");

      }else{
        responseRegister = await register();
        if(responseRegister != "null"){
          setAlert(responseRegister);
        }
      }
    }
   
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(89, 158, 248, 0.992),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.09,),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(onPressed: 
              () => {
                Navigator.push(context, MaterialPageRoute(builder:  (context) => const Login()))
              }
            ,
            icon: const Icon(Icons.arrow_back,size: 50,color: Color.fromARGB(255, 255, 255, 255),))),          
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Text("Crea tu cuenta",
               style: TextStyle(fontSize: 70,color: Colors.white),
               ),
            )
          ),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(30),
              width: screenWidth * 0.6,
              height: screenHeight * 0.50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 5,
                  color: const Color.fromARGB(255, 233, 230, 230)
                ),
                 boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      offset: const Offset(-5.0, -5.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ],
              ),
              child: Column(
                children: [
                 const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 20,
                        
                      ),
                    ),
                  ),
                   TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.email_outlined)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Contraseña",
                      style: TextStyle(
                        fontSize: 20,
                        
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: ocultarPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(
                            (ocultarPassword)
                            ? 
                              Icons.visibility
                            :
                              Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              ocultarPassword = !ocultarPassword;
                            });
                          },
                        ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirmar contraseña",
                      style: TextStyle(
                        fontSize: 20,
                        
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordControllerRepeat,
                    obscureText: ocultarPassword,
                  ),
                  const SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: () async => { 
                      validationsForRegister()
                    },
                     child: const Text("Crear cuenta")
                  )
               


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}