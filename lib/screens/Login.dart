import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/screens/CrearCuenta.dart';
import 'package:sabira/screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabira/screens/RecoverPassword.dart';
import 'package:sabira/utils/UtilsForRegisterAndLogin.dart';
import 'package:sabira/widgets/SetAlertMessage.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool ocultarPassword = true;
  bool logging = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> login() async {
    String typeError = "null";
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    
    } catch (e) {
      typeError = e.toString();
      print('Error al iniciar sesión: $typeError');
    }
   
    return typeError;
  }

  bool camposValidos(){
    if(emailController.text == "" || passwordController.text == ""){
      return false;
    }else{
      return true;
    }
  }

  void setAlert(String typeMessage){ 
    setAlertMessage(typeMessage: typeMessage,context: context);
  }

  Future<bool> verifyEmail() async {
    bool emailVerified = false;
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();  
     emailVerified = user?.emailVerified ?? false;
    return emailVerified;

    
  }

  void validationsForLogin() async{
    String responseLogin;
    bool emailVerified = false;

     if(camposValidos()){

      responseLogin = await login();
     
      if(responseLogin != "null"){
        setAlert(responseLogin);
      }else{
        emailVerified = await verifyEmail();
        if(!emailVerified){
          sendEmailVerification(context: context);
          setAlertWaitingForAccountVerification(message: "Correo no verificado porfavor verificalo para poder continuar. Le hemos enviado uno nuevo", context: context);
        }
        while (!emailVerified) {
          //si en el login no se verifica entonces cambia todo lo de dentro del while por lo mismo que esta en el mismo while en el archivo crear cuenta
          emailVerified = await verifyEmail();
          if (!emailVerified) {
            await Future.delayed(Duration(seconds: 3));
          }
        }  

        if(emailVerified){
          Provider.of<ClientProvider>(context, listen: false).getDataClient();
          goHome();

        }   
      }

  
      }else{
        setAlert("incorrectFields");
      }
      setState(() {
        logging = false;
      });
  }

  void goHome(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home(idUserSearch: "",itUser: 0, itUserLast: 0, searchById: false,)),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      
      body: Column(
      
        children: [
          Stack(
            children: [
            
              Image.asset("assets/images/m5.jpg", fit: BoxFit.cover,height: screenHeight /2,width: screenWidth,),
              
               Positioned(
                left: 10,
                top: 80,
                child: SizedBox(
                  width: 500,
                
                  child:  Column(
                  
                    children: [
                    
                     Align(
                      alignment: Alignment.centerLeft,
                      child:  Text(
                        "Conoce",
                        style: TextStyle(
                          fontSize: screenWidth * 0.15,
                          color: Colors.white
                        ),
                      
                      ),
                     ),
                     Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "diferentes vidas",
                        style: TextStyle(
                          fontSize:  screenWidth * 0.13,
                          color: Colors.white
                        ),
                      ))
                    ],
                  ),
                )
              )
            ],
            
          ),
          //SizedBox(height: screenHeight * 0.07,),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color:  Color.fromRGBO(89, 158, 248, 0.992),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color.fromARGB(255, 255, 251, 0),
                       
                      ),
                    ),
                  )

                ),
                Positioned(
                  left: 2,
                  child: ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(80),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color.fromARGB(255, 0, 89, 255)
                      ),
                    ),
                  )

                ),

                Positioned(
                 left: screenWidth * 0.15,
                 top: screenHeight * 0.02,
                  child:  Stack(
                    children: [
                      Container(
                        width: screenWidth * 0.7,
                        height: screenWidth ,
                        padding: const EdgeInsets.only(left: 40,right: 40,top: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(193, 235, 232, 232),
                            width: 5
                          )
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Email", style: TextStyle(fontSize: 20),),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.email),
                                hintText: "Ingresa tu email"
                                
                              ),
                            ),
                            const SizedBox(height: 30,),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Contraseña", style: TextStyle(fontSize: 20),),
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: ocultarPassword,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu contraseña",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    (ocultarPassword)
                                    ? 
                                      Icons.visibility_off
                                    :
                                      Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      ocultarPassword = !ocultarPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30,),
                            ElevatedButton(
                              onPressed: () async => {
                                setState(() {
                                  logging = true;
                                }),
                                validationsForLogin()
                              
                              },
                              child: const Text("Iniciar sesión")
                            ),
                            const SizedBox(height: 15,),
                            SizedBox(
                              width: 130,
                              height: 30,
                              child:  ElevatedButton(
                                onPressed: () => {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CrearCuenta()))
                                },
                                child: const Text("Crear cuenta")
                              )
                            ),
                           const SizedBox(height: 20,),
                           GestureDetector(   
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RecoverPassword()),
                                );
                              },
                              child: const Text("¿Olvidaste tu contraseña?"),
                            )

                          ],
                        ),
                      ),
                      if(logging)
                      
                       Positioned(child: Center(child: CircularProgressIndicator(),)) 
                      
                    ],
                  )
                ),
              ],
            )
          )         
        ],
      ),
    );
  }
}