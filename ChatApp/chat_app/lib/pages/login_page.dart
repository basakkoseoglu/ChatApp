// ignore_for_file: must_be_immutable

import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //şifre ve email kontrolleri
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //kayıt ol sayfasına gitme
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  //giriş metodu
  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();
    //giriş methodu
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
    //hata mesajı
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              color: Theme.of(context).colorScheme.primary,
              size: 60,
            ),
            const SizedBox(
              height: 50,
            ),
            //hoşgeldiniz mesajı
            Text(
              'Tekrar Hoşgeldinn! Sizi görmeyi özledik 💖',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            //email kısmı
            const SizedBox(
              height: 50,
            ),
            MyTextField(
              hintText: "E-mail",
              obscureText: false,
              controller: _emailController,
            ),
            //şifre kısmı
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Şifre",
              obscureText: true,
              controller: _passwordController,
            ),
            //giriş butonu
            const SizedBox(
              height: 25,
            ),
            MyButton(
              text: "Giriş Yap",
              onTap: () => login(context),
            ),
            //kayıt olma
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hesabın yok mu? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Kayıt ol',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
