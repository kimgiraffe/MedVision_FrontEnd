import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PrivateAuthType {
  final String name;
  final int index;

  PrivateAuthType(this.name, this.index);
}



Future<http.Response> authenticateUser(String privateAuthType, String name, String birth, String phoneNumber, String idNumber) async {
  String url = 'https://tilko.net/api/v1.0/hirasimpleauth/simpleauthrequest';
  String apiKey = 'a379ba7545364b1a8e5b4c4ee040aef7';
  String encryptedKey = '<your-encrypted-key>'; // This should be the RSA-encrypted AES secret key

  Map<String, String> headers = {
    'API-KEY': apiKey,
    'ENC-KEY': encryptedKey,
    'Content-Type': 'application/json', // This line is added
  };

  Map<String, String> body = {
    'PrivateAuthType': privateAuthType,
    'UserName': name,
    'BirthDate': birth,
    'UserCellphoneNumber': phoneNumber,
    'IdentityNumber': idNumber,
  };

  http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(body),  // You need to convert the body to a json string
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to authenticate user. Status code: ${response.statusCode}');
  }

  return response;
}


class SimpleAuthentication extends StatefulWidget {
  const SimpleAuthentication({Key? key}) : super(key: key);

  @override
  SimpleAuthenticationState createState() => SimpleAuthenticationState();
}

class SimpleAuthenticationState extends State<SimpleAuthentication> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Authentication'),
      ),
      body: Center(
        child: Text('This is the SimpleAuthentication page'),
      ),
    );
  }
}

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

  List<PrivateAuthType> _authTypes = [
    PrivateAuthType('카카오톡', 0),
    PrivateAuthType('페이코', 1),
    PrivateAuthType('국민은행모바일', 2),
    PrivateAuthType('삼성패스', 3),
    PrivateAuthType('통신사Pass', 4),
    PrivateAuthType('신한', 5),
    PrivateAuthType('네이버', 6),
  ];
  PrivateAuthType? _selectedAuthType;

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
                const SizedBox(height: 60.0),
                DropdownButton<PrivateAuthType>(
                  hint: const Text("본인인증 방식을 선택해주세요"),
                  value: _selectedAuthType,
                  onChanged: (PrivateAuthType? newValue) {
                    setState(() {
                      _selectedAuthType = newValue;
                    });
                  },
                  items: _authTypes.map((PrivateAuthType authType) {
                    return DropdownMenuItem<PrivateAuthType>(
                      value: authType,
                      child: Text(authType.name),
                    );
                  }).toList(),
                ),
                // In the ElevatedButton onPressed method:
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _birthController.text.isEmpty ||
                        _idNumberController.text.isEmpty ||
                        _phoneNumberController.text.isEmpty
                    ) {
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
                      try {
                        var response = await authenticateUser(
                          _selectedAuthType!.index.toString(),
                          _nameController.text,
                          _birthController.text,
                          _phoneNumberController.text,
                          _idNumberController.text,
                        );

                        // If authentication is successful
                        if (response.statusCode == 200) {
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text("알림"),
                              content: const Text('본인인증 호출 성공'),
                              actions: <Widget>[
                                TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("확인"),)
                              ],
                            );
                          });
                        }else {
                          throw Exception('Unexpected status code: ${response.statusCode}');
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("본인인증 오류"),
                                content: Column(
                                  children: [
                                    Text("오류발생 : $e"),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              );
                            }
                        );

                      }
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

