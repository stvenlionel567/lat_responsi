// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lat_responsi/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    cek_login();
  }

  void cek_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome to Ngeyangin!",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
                child: Text("Silahkan login untuk menggunakan fitur kami")),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 330,
              child: TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 330,
              child: TextFormField(
                  controller: password,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  String _username = username.text;
                  String _password = password.text;
                  if (_formKey.currentState?.validate() ?? false) {
                    print('Succesfull');
                    logindata.setBool('login', false);
                    logindata.setString('username', _username);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                  } else {}
                },
                child: Text('login'))
          ],
        ),
      ),
    ));
  }
}
