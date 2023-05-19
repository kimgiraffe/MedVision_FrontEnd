import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> authenticateUser(String name, String birth, String idNumber, String phoneNumber) async {
  String url = 'https://tilko.net/api/v1.0/HiraSimpleAuth';
  String apiKey = 'a379ba7545364b1a8e5b4c4ee040aef7';
  var body = {
    'Name': name,
    'BirthDate': birth,
    'PhoneNumber': phoneNumber,
    'IdNumber': idNumber,
  };

  http.Response response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'API-Key': apiKey,
    },
    body: jsonEncode(body),
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
