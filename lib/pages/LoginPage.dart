import 'package:flutter/material.dart';
import 'package:my_app/pages/SignUpPage.dart';

import '../home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Text('나만을 위한 꼼꼼한 복약관리,', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                Text('시작해볼까요?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 60.0),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '아이디',
                  ),
                    obscureText: false,
              ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '비밀번호',
                  ),
                    obscureText: true,
              ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: Text('취소'),
                      onPressed: () {
                        _usernameController.clear();
                        _passwordController.clear();
                      },
                    ),
                    ElevatedButton(
                      child: Text('로그인'),
                      onPressed: () {
                        bool loginSuccess = true;

                        if(loginSuccess){
                          setState(() {
                            isLoggedIn = true;
                          });
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Center(
                  child: InkWell(
                    child: Text(
                      '계정이 없으신가요? 회원가입',
                      style: TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
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