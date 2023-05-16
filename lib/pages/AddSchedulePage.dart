import 'package:flutter/material.dart';
import 'package:my_app/home.dart';

typedef AddEventFunction = MedicationSchedule Function(
  String medication,
  int dosagePerOnce,
  int dailyDose,
  int totalDosingDays,
  DateTime startDate,
  DateTime endDate,
  List<TimeOfDay> dosingTimes
    );

class AddSchedulePage extends StatefulWidget {
  final AddEventFunction addEvent;
  const AddSchedulePage({Key? key, required this.addEvent}) : super(key: key);

  @override
  AddSchedulePageState createState() => AddSchedulePageState();
}

class AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String medication = '';
  int dosagePerOnce = 0;
  int dailyDose = 0;
  int totalDosingDays = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<TimeOfDay> dosingTimes = [];
  final dailyDoseController = TextEditingController();

  @override
  void dispose() {
    dailyDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true, title: const Text('복약 일정 추가')),
      body: SingleChildScrollView(child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: '약품명'),
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '1회 투약량'),
              validator: (value) {
                if(value == null || value.isEmpty || int.tryParse(value) == null) {
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
              controller: dailyDoseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '1일 투약횟수'),
              validator: (value) {
                if(value == null || value.isEmpty || int.tryParse(value) == null) {
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '총 투약일수'),
              validator: (value) {
                if(value == null || value.isEmpty || int.tryParse(value) == null) {
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
              child: const Text('복약 시작 날짜 선택'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if(picked != null && picked != startDate){
                  setState(() {
                    startDate = DateTime(picked.year, picked.month, picked.day);
                  });
                }
              },
            ),
            ElevatedButton(
              child: const Text('복약 종료 날짜 선택'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: endDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days:30)),
                );
                if(picked != null && picked != endDate){
                  setState(() {
                    endDate = DateTime(picked.year, picked.month, picked. day);
                  });
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  //print('Button pressed, dailyDose: $dailyDose');
                  dosingTimes.clear();
                  for(int i = 1; i <= dailyDose; i++){
                    await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('복용 시간 선택 ($i 회)'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: const Text('복용 시간을 선택하세요.'),
                                onTap: () async {
                                  final TimeOfDay ? picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      dosingTimes.add(picked);
                                    });
                                  }
                                  Navigator.of(context).pop();

                                  }

                              )
                            ],
                          ),
                        ),
                      );
                      },
                    );
                    //await Future.delayed(Duration(microseconds: 200));
                    //await showTime(i);
                  }
                },
                child: const Text('복용 시간 선택')
            ),

            ElevatedButton(
              child: const Text('추가'),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  //print('Event to add: $medication, $dosagePerOnce, $dailyDose, $totalDosingDays, $startDate, $endDate');
                  MedicationSchedule newSchedule = widget.addEvent(
                    medication,
                    dosagePerOnce,
                    dailyDose,
                    totalDosingDays,
                    startDate,
                    endDate,
                    dosingTimes,
                  );
                  _formKey.currentState!.reset();
                  setState(() {
                    medication = '';
                    dosagePerOnce = 0;
                    dailyDose = 0;
                    totalDosingDays = 0;
                    startDate = DateTime.now();
                    endDate = DateTime.now();
                  });
                  Navigator.pop(context, newSchedule);
                }
              },
            ),
          ],
        ),
      ),
      ),
    ),
    );
  }

  Future<void> showTime(int doseNumber) async {
    final TimeOfDay ? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        dosingTimes.add(picked);
      });
    }
  }
}