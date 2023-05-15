import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  AuthenticationPageState createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationPage> {
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('본인인증', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 30.0),
            Column(
              children: <Widget>[
                const Text('본인인증을 위해 아래 정보를 입력해주세요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 60.0),
                TextFormField(
                  controller: _nameController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '이름',
                  ),
                ),
                TextFormField(
                  controller: _birthController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '생년월일 (YYYYMMDD)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _idNumberController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '주민번호(  - 없이 13자리 입력하세요)',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: '휴대폰 번호(01012345678)',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 60.0),
                ElevatedButton(
                  onPressed: () {
                    // 본인인증 로직 추가
                    // 모든 필드가 채워졌는지 확인
                    if (_nameController.text.isEmpty ||
                        _birthController.text.isEmpty ||
                        _idNumberController.text.isEmpty ||
                        _phoneNumberController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("알림"),
                              content: const Text("모든 필드를 채워주세요."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("확인"),
                                )
                              ],
                            );
                          });
                    } else {
                      // 본인인증 로직 추가
                      // 예: 본인인증 API 호출
                    }
                  },
                  child: const Text('본인인증 진행'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
