


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> sendEmailVerification({required context}) async {
    User? user = FirebaseAuth.instance.currentUser;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Se ha enviado un correo de verificación a ${user!.email}.'),
    ));
    return  await user?.sendEmailVerification();
  }
