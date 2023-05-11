import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordconfirmController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isCheckAgreementAll = false;
  bool _isCheckAgreement1 = false;
  bool _isCheckAgreement2 = false;
  bool _isCheckAgreement3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: new Form(

        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 10.0),
            Column(
              children: <Widget>[
                Text('나만을 위한 꼼꼼한 복약관리,', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                Text('시작해볼까요?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),

                SizedBox(height: 60.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '아이디',
                  ),
                  obscureText: false,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '비밀번호',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _passwordconfirmController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '비밀번호 재확인',

                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '이메일 주소',
                  ),
                  obscureText: false,
                ),
                SizedBox(height: 5.0),
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                    title: Text('전체 동의'),
                    checkColor: Colors.black,
                    value: _isCheckAgreementAll,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreementAll = value!;
                        _isCheckAgreement1 = true;
                        _isCheckAgreement2 = true;
                        _isCheckAgreement3 = true;
                      });
                    }
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.blue,
                  title: Text('서비스 이용 약관 동의 (필수)', style: TextStyle(fontSize: 14.0),),
                  checkColor: Colors.black,
                    value: _isCheckAgreement1,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreement1 = value!;
                      });
                    }
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                    title: Text('개인정보 수집 및 이용 동의 (필수)', style: TextStyle(fontSize: 14.0),),
                    checkColor: Colors.black,
                    value: _isCheckAgreement2,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreement2 = value!;
                      });
                    }
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('개인정보 제3자 정보제공 동의 (필수)', style: TextStyle(fontSize: 14.0),),
                    activeColor: Colors.blue,
                    checkColor: Colors.black,
                    value: _isCheckAgreement3,
                    onChanged: (value) {
                      setState(() {
                        _isCheckAgreement3 = value!;
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
                        child: Text('취소'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('회원가입'),
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
}