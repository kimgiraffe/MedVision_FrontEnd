import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimpleAuthentication extends StatefulWidget {
  final String authType;

  const SimpleAuthentication({Key? key, required this.authType}) : super(key: key);

  @override
  _SimpleAuthenticationState createState() => _SimpleAuthenticationState();
}

class _SimpleAuthenticationState extends State<SimpleAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Authentication'),
      ),
      body: Center(
        child: Text('Selected auth type: ${widget.authType}'), // 표시된 인증 유형
      ),
    );
  }
}
