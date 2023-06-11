import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_app/pages/ChangePasswordPage.dart';
import 'package:my_app/pages/LoginPage.dart';
import 'package:my_app/pages/SearchPillPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_app/pages/AuthenticationPage.dart';

//import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final List<MedicationSchedule> medicationSchedules;
  const Home({Key? key, this.medicationSchedules = const []}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    Container(),
    SearchPillPage(),
    ChangePasswordPage(),
  ];

  List<MedicationSchedule> _medicationSchedules = [];
  List<MedicationSchedule> selectedSchedules = [];
  final Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState(){
    super.initState();
    _medicationSchedules = widget.medicationSchedules;
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  CalendarFormat format = CalendarFormat.week;

  final dateFormat = DateFormat('yyyy.MM.dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '복용 일정 관리',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
      children: <Widget> [

      TableCalendar(

      eventLoader: (day) {
        return _events[day] ?? [];
      },
      calendarStyle: const CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        markerSize: 5.0,
      ),


      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2023, 12, 31),
      focusedDay: focusedDay,
      locale: 'ko-KR',
      daysOfWeekHeight: 30.0,

      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false
      ),



      calendarFormat: format,
      onFormatChanged: (CalendarFormat format){
        setState(() {
          this.format = format;
        });
      },

      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        this.selectedDay = selectedDay;
        this.focusedDay = focusedDay;

        setState(() {
          selectedSchedules = _events[selectedDay] ?.map((e) => e as MedicationSchedule).toList() ?? [];
        });
      },

      selectedDayPredicate: (DateTime day) {
        return isSameDay(selectedDay, day);
        },
      ),
        const SizedBox(height: 10.0),
        Center(
          child:
        ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  String medication = ' ';
                  int dosagePerOnce = 0;
                  int dailyDose = 0;
                  int totalDosingDays = 0;
                  DateTime startDate = DateTime.now();
                  DateTime endDate = DateTime.now();
                  List<TimeOfDay> dosingTimes = [];
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text('복약 일정 추가'),
                      content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (value) {
                              medication = value;
                            },
                            decoration: const InputDecoration(hintText: '약품명'),
                          ),
                          TextField(
                            onChanged: (value) {
                              dosagePerOnce = int.parse(value);
                            },
                            decoration: const InputDecoration(
                                hintText: '1회 투약량'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            onChanged: (value) {
                              totalDosingDays = int.parse(value);
                            },
                            decoration: const InputDecoration(
                                hintText: '1일 투여횟수'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            onChanged: (value) {
                              totalDosingDays = int.parse(value);
                            },
                            decoration: const InputDecoration(
                                hintText: '총 투약일수'),
                            keyboardType: TextInputType.number,
                          ),
                          InkWell(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                      Duration(days: 30)));
                              if (pickedDate != null) {
                                setState(() {
                                  startDate = pickedDate;
                                });
                              }
                            },
                            child: Text(
                              "시작 날짜: ${DateFormat('yyyy.MM.dd').format(
                                  startDate)}",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: endDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                      Duration(days: 30)));
                              if (pickedDate != null) {
                                setState(() {
                                  endDate = pickedDate;
                                });
                              }
                            },
                            child: Text(
                              "종료 날짜: ${DateFormat('yyyy.MM.dd').format(
                                  endDate)}",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (pickedTime != null &&
                                  !dosingTimes.contains(pickedTime)) {
                                setState(() {
                                  dosingTimes.add(pickedTime);
                                });
                              }
                            },
                            child: const Text(
                              "투약 시간 추가",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          ...dosingTimes.map(
                                  (time) =>
                                  ListTile(
                                    title: Text("투약 시간: ${time.format(context)}"
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          dosingTimes.remove(time);
                                        });
                                      },
                                    ),
                                  )
                          ).toList(),
                        ],
                      ),),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('추가'),
                          onPressed: () {
                            MedicationSchedule newSchedule = addEvent(
                                medication,
                                dosagePerOnce,
                                dailyDose,
                                totalDosingDays,
                                startDate,
                                endDate,
                                dosingTimes);
                            final DateTime scheduleDay = DateTime(
                              newSchedule.startDate.year,
                              newSchedule.startDate.month,
                              newSchedule.startDate.day,
                            );
                            if(_events[scheduleDay] != null){
                              _events[scheduleDay]!.add(newSchedule);
                            }else{
                              _events[scheduleDay] = [newSchedule];
                            }
                            setState((){
                              _medicationSchedules = List.from(_medicationSchedules)..add(newSchedule);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: const Text('취소')),
                      ],
                    );
                  }
                  );
                },
              );
            },
          child: const Text('복약 일정 추가'),
        ),
        ),
        Column(
          children: _medicationSchedules.map((_medicationSchedules) {
            return ListTile(
              title: Text(_medicationSchedules.medication),
              subtitle: Text(
                '1회 투약량: ${_medicationSchedules.dosagePerOnce}\n'
                    '1일 투여횟수: ${_medicationSchedules.dailyDose}\n'
                    '총 투약일수: ${_medicationSchedules.totalDosingDays}\n'
                    '복용 시작일: ${dateFormat.format(_medicationSchedules.startDate)}\n'
                    '복용 종료일: ${dateFormat.format(_medicationSchedules.endDate)}\n'
                    '복용 시각: ${_medicationSchedules.dosingTimes.map((time) => time.format(context)).join(', ')}'
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 50.0),
        const Text('  최근 처방을 받으셨나요?'),
        const Text("  심평원 '내가 먹는 약' 서비스로 조회해보세요"),
        Column(
          children: <Widget> [
        Center(
          child:
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const AuthenticationPage())
              );
            },
            child: const Text('조회하러 가기'),
          ),
        ),
        const SizedBox(height: 50.0),
        const Text('  최근 나의 처방 이력', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
          child: DataTable(
            border: TableBorder.symmetric(),
            columns: const <DataColumn>[
              DataColumn(label: Text('제조일자', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              DataColumn(label: Text('약품명', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              DataColumn(label: Text('1회 투약량', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              DataColumn(label: Text('1일 투여횟수', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              DataColumn(label: Text('총 투약일수', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            ],
            rows:
              prescriptionList.map((prescription) => DataRow(
                cells: <DataCell> [
                    DataCell(Text(dateFormat.format(prescription.prescriptionDate), textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                    DataCell(Text(prescription.medication, textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                    DataCell(Text('${prescription.DosagePerOnce}회', textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                    DataCell(Text('${prescription.DailyDose}회', textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                    DataCell(Text('${prescription.TotalDosingDays}일', textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                  ],
              )).toList(),
            ),
          ),
        )])
      ])),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              label: 'Back'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Camera'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings'
          ),
        ],
        onTap: (index) {
          setState(() {
            if(index == 0){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
            else if(index == 1){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPillPage()),
              );
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            }
          });
        },
        currentIndex: _selectedIndex,
      ),
    );
  }

  MedicationSchedule addEvent(
      String medication,
      int dosagePerOnce,
      int dailyDose,
      int totalDosingDays,
      DateTime startDate,
      DateTime endDate,
      List<TimeOfDay> dosingTimes,
      ) {

    MedicationSchedule newSchedule = MedicationSchedule(
      medication: medication,
      dosagePerOnce: dosagePerOnce,
      dailyDose: dailyDose,
      totalDosingDays: totalDosingDays,
      startDate: startDate,
      endDate: endDate,
      dosingTimes: dosingTimes,
    );

    return newSchedule;
  }
}

class Event {
  String title;
  Event(this.title);
}

class Prescription{
  final DateTime prescriptionDate;
  final String medication;
  final int DosagePerOnce;
  final int DailyDose;
  final int TotalDosingDays;

  Prescription({
    required this.prescriptionDate,
    required this.medication,
    required this.DosagePerOnce,
    required this.DailyDose,
    required this.TotalDosingDays,
  });
}

List<Prescription> prescriptionList = [
  Prescription(
    prescriptionDate: DateTime(2023, 6, 2),
    medication: '뉴토리드정',
    DosagePerOnce: 1,
    DailyDose: 3,
    TotalDosingDays: 3,
  ),
  Prescription(
    prescriptionDate: DateTime(2023, 6, 2),
    medication: '뉴파클러캡슐',
    DosagePerOnce: 1,
    DailyDose: 3,
    TotalDosingDays: 3,
  ),
  Prescription(
    prescriptionDate: DateTime(2023, 6, 2),
    medication: '베포탄서방정',
    DosagePerOnce: 1,
    DailyDose: 1,
    TotalDosingDays: 3,
  ),
  Prescription(
    prescriptionDate: DateTime(2023, 6, 2),
    medication: '모니필정350밀리그램',
    DosagePerOnce: 1,
    DailyDose: 3,
    TotalDosingDays: 2,
  ),
];

class MedicationSchedule {
  String medication;
  int dosagePerOnce;
  int dailyDose;
  int totalDosingDays;
  DateTime startDate;
  DateTime endDate;
  List<TimeOfDay> dosingTimes;

  MedicationSchedule({
    required this.medication,
    required this.dosagePerOnce,
    required this.dailyDose,
    required this.totalDosingDays,
    required this.startDate,
    required this.endDate,
    required this.dosingTimes,
  });
}
