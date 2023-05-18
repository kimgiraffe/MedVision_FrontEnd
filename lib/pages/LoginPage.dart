import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/pages/SignUpPage.dart';

import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoggedIn = false;

  void navigateToHome(BuildContext context) {
    if(isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()),);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                const Text('나만을 위한 꼼꼼한 복약관리,', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                const Text('시작해볼까요?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 60.0),
                TextField(
                  controller: _usernameController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '아이디',
                  ),
                    obscureText: false,
              ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '비밀번호',
                  ),
                    obscureText: true,
              ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: const Text('취소'),
                      onPressed: () {
                        _usernameController.clear();
                        _passwordController.clear();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('로그인'),
                      onPressed: () {
                        bool loginSuccess = true;

                        if(loginSuccess){
                          setState(() {
                            isLoggedIn = true;
                          });
                        }
                        navigateToHome(context);
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                      '계정이 없으신가요? ',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    InkWell(
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 14.0,
                          decoration: TextDecoration.underline,
                        ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                  ),
                ])

            ),
          ],
        ),
      ])),
    );
  }
}