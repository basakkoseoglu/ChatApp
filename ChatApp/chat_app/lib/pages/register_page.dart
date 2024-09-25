// ignore_for_file: must_be_immutable

import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  //şifre ve email kontrolleri
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirimPasswordController = TextEditingController();
  //giriş sayfasına gitme
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  void register(BuildContext context) {
    final _auth = AuthService();

    //şifre kontrolü
    if (_passwordController.text == _confirimPasswordController.text) {
      try {
        _auth.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //şifreler eşleşmiyorsa
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Şifreler eşleşmiyor!'),
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
              'Senin içn bir hesap oluşturalım ❤️',
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
            //şifre onay kısmı
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Şifreyi tekrar gir",
              obscureText: true,
              controller: _confirimPasswordController,
            ),
            //giriş butonu
            const SizedBox(
              height: 25,
            ),
            MyButton(
              text: "Kayıt Ol",
              onTap: () => register(context),
            ),
            //kayıt olma
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Zaten bir hesabım var? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Giriş Yap',
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
