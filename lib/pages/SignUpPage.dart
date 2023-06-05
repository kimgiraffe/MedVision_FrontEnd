import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../home.dart';

class SignUpFormData {
  String? username;
  String? password;
  String? passwordConfirm;
  String? email;

  SignUpFormData({
    this.username,
    this.password,
    this.passwordConfirm,
    this.email,
  });

  Map<String, dynamic> toJson() => {
    'username' : username,
    'password' : password,
    'passwordconfirm' : passwordConfirm,
    'email' : email
  };
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  SignUpFormData formData = SignUpFormData();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordconfirmController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isCheckAgreementAll = false;
  bool _isCheckAgreement1 = false;
  bool _isCheckAgreement2 = false;
  bool _isCheckAgreement3 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white)),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 10.0),
            Column(
              children: <Widget>[
                const Text('나만을 위한 꼼꼼한 복약관리,', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                const Text('시작해볼까요?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),

                const SizedBox(height: 60.0),
                TextFormField(
                  key: ValueKey(1),
                  keyboardType: TextInputType.text,
                  controller: _usernameController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z|0-9]'))
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '아이디',
                  ),
                  obscureText: false,
                  onChanged: (value){
                    formData.username = value;
                  },
                ),
                TextFormField(
                  key: ValueKey(2),
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '비밀번호',
                  ),
                  obscureText: true,
                  onChanged: (value){
                    formData.password = value;
                  },
                ),
                TextFormField(
                  key: ValueKey(3),
                  keyboardType: TextInputType.text,
                  controller: _passwordconfirmController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '비밀번호 재확인',
                  ),
                  obscureText: true,
                  onChanged: (value){
                    formData.passwordConfirm = value;
                  },
                ),
                TextFormField(
                  key: ValueKey(4),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '이메일 주소',
                  ),
                  obscureText: false,
                  onChanged: (value){
                    formData.email = value;
                  },
                ),
                const SizedBox(height: 5.0),
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                    title: const Text('전체 동의'),
                    checkColor: Colors.black,
                    value: _isCheckAgreementAll,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreementAll = value!;
                        _isCheckAgreement1 = _isCheckAgreementAll;
                        _isCheckAgreement2 = _isCheckAgreementAll;
                        _isCheckAgreement3 = _isCheckAgreementAll;
                      });
                    }
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.blue,
                  title: const Text('서비스 이용 약관 동의 (필수)', style: TextStyle(fontSize: 14.0),),
                  checkColor: Colors.black,
                    value: _isCheckAgreement1,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreement1 = value!;
                        _isCheckAgreementAll = _isCheckAgreement1 && _isCheckAgreement2 && _isCheckAgreement3;
                      });
                    }
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                    title: const Text('개인정보 수집 및 이용 동의 (필수)', style: TextStyle(fontSize: 14.0),),
                    checkColor: Colors.black,
                    value: _isCheckAgreement2,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreement2 = value!;
                        _isCheckAgreementAll = _isCheckAgreement1 && _isCheckAgreement2 && _isCheckAgreement3;
                      });
                    }
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('개인정보 제3자 정보제공 동의 (필수)', style: TextStyle(fontSize: 14.0),),
                    activeColor: Colors.blue,
                    checkColor: Colors.black,
                    value: _isCheckAgreement3,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreement3 = value!;
                        _isCheckAgreementAll = _isCheckAgreement1 && _isCheckAgreement2 && _isCheckAgreement3;
                      });
                    }
                ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          _usernameController.clear();
                          _passwordController.clear();
                          _passwordconfirmController.clear();
                          _emailController.clear();
                        },
                        child: const Text('취소'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if(!_isCheckAgreement1 || !_isCheckAgreement2 || !_isCheckAgreement3) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("알림"),
                                    content: const Text("모든 약관에 동의해야 합니다."),
                                    actions: <Widget>[
                                      TextButton(onPressed: () {
                                        Navigator.of(context).pop();
                                      }, child: const Text("확인"))
                                    ],
                                  );

                                },
                            );
                          }


                          else if(_passwordController.text != _passwordconfirmController.text){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("알림"),
                                    content: const Text("비밀번호가 일치하지 않습니다."),
                                    actions: <Widget>[
                                      TextButton(onPressed: (){
                                        Navigator.of(context).pop();
                                      }, child: const Text("확인"))
                                    ],
                                  );
                                }
                            );
                          }
                          else {
                            //TODO: 회원가입 로직 (서버에 정보 전송 등)
                            /*var response = await http.post(
                              Uri.parse('http://localhost:8000/signup/'),
                              body: json.encode(formData.toJson()),
                              headers: {'content-type' : 'application/json'}
                            );
                            if(response.statusCode == 201) {_showDialog('회원가입 성공');}
                            else {_showDialog('회원가입 실패');}*/
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
                            //Navigator.pop(context);
                          }
                        },
                        child: const Text('회원가입'),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(String message){
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        )
    );
  }
}
