import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabira/screens/Login.dart';
import 'package:sabira/widgets/SetAlertMessage.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPassword();
}

class _RecoverPassword extends State<RecoverPassword> {

  final TextEditingController controllerEmail = TextEditingController();


  Future<void> sendPasswordResetEmail() async {
    String email = controllerEmail.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Correo de restablecimiento enviado a $email");

     
    } catch (e) {
      print("Ocurrió un error al enviar el correo de restablecimeineto de contraseña: $e");
      setAlertMessage(typeMessage: e.toString(), context: context);

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
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text("Recuperar contraseña",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05,),
          
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              children: [
                const Text("Porfavor ingrese el correo electrónico que ingresó en la cuenta, se le enviará un correo donde podrá restablecer su contraseña y deberá volver a inciar sesión con su nueva contraseña.",
                  style:  TextStyle(
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: controllerEmail,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.email),
                    hintText: "Ingresa tu email"
                    
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () => {
                    sendPasswordResetEmail(),

                    
                  },
                  child: const Text("Recuperar contraseña")
                )
              ],
            ),
          )
        ],
      ),
    );
  
  }

}