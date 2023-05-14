import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  final Function addEvent;
  AddSchedulePage({required this.addEvent});

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String medication = '';
  int dosagePerOnce = 0;
  int dailyDose = 0;
  int totalDosingDays = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('복약 일정 추가')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: '약품명'),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return '약품명을 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  medication = value!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '1회 투약량'),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return '1회 투약량을 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  dosagePerOnce = int.parse(value!);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '1일 투약횟수'),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return '1일 투약횟수를 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  dailyDose = int.parse(value!);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '총 투약일수'),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return '총 투약일수를 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  totalDosingDays = int.parse(value!);
                });
              },
            ),
            ElevatedButton(
              child: Text('복약 시작 날짜 선택'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                );
                if(picked != null && picked != startDate){
                  setState(() {
                    startDate = DateTime(picked.year, picked.month, picked.day);
                  });
                }
              },
            ),
            ElevatedButton(
              child: Text('복약 종료 날짜 선택'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: endDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days:30)),
                );
                if(picked != null && picked != endDate){
                  setState(() {
                    endDate = DateTime(picked.year, picked.month, picked. day);
                  });
                }
              },
            ),

            ElevatedButton(
              child: Text('추가'),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  widget.addEvent(
                    medication,
                    dosagePerOnce,
                    dailyDose,
                    totalDosingDays,
                    startDate,
                    endDate,
                  );
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}