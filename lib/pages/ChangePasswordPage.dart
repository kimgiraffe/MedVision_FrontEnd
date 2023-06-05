import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final response = await http.post(
      'http://localhost:8000/changepassword/' as Uri,
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호 변경에 실패하였습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('비밀번호 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: '현재 비밀번호',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: '새 비밀번호',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              child: const Text('비밀번호 변경'),
              onPressed: () {
                changePassword(
                  _currentPasswordController.text,
                  _newPasswordController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
