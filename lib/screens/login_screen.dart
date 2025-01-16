import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Giriş başarılı!')));
        Navigator.pushReplacementNamed(context, '/home'); // Ana sayfaya yönlendirme
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Giriş hatası: $e')));
      }
    }
  }

  void _openSignUpDialog() {
    final _signUpEmailController = TextEditingController();
    final _signUpPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Kayıt Ol", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _signUpEmailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _signUpPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _signUpEmailController.text,
                    password: _signUpPasswordController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kayıt başarılı!')));
                  Navigator.pushReplacementNamed(context, '/home'); // Ana sayfaya yönlendirme
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kayıt hatası: $e')));
                }
              },
              child: Text("Kayıt Ol"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Geçerli bir e-posta adresi girin!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre boş olamaz!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Giriş Yap'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _openSignUpDialog,
                        child: Text('Kayıt Ol'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
