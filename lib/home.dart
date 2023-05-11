import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
  ];

  Map<DateTime, List<dynamic>> _events = {};

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  CalendarFormat format = CalendarFormat.week;


  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '복용 일정 관리',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
        ),

      ),
      body: Container(
        child: ListView(
        children: <Widget> [

      TableCalendar(
        //events: _events;
        // eventLoader: _getEvents,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2023, 12, 31),
        focusedDay: focusedDay,
        locale: 'ko-KR',
        daysOfWeekHeight: 30.0,

        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false
        ),

        calendarStyle: CalendarStyle(
          markerSize: 10.0,
          markerDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
          ),
        ),

        calendarFormat: format,
        onFormatChanged: (CalendarFormat format){
          setState(() {
            this.format = format;
          });
        },

        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });
        },
        selectedDayPredicate: (DateTime day) {
          return isSameDay(selectedDay, day);
        },
      ),

          SizedBox(height: 10.0),
          Center(
            child:
          ElevatedButton(
              onPressed: (){},
              child: Text('복약 일정 추가')
            ),
          ),
          SizedBox(height: 50.0),
          Text('  최근 처방을 받으셨나요?'),
          Text("  심평원 '내가 먹는 약' 서비스로 조회해보세요"),
          Column(
            children: <Widget> [
          Center(
            child:
            ElevatedButton(
              onPressed: (){},
              child: Text('조회하러 가기'),
            ),
          ),
          SizedBox(height: 50.0),
          Text('  최근 나의 처방 이력', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 15.0),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.symmetric(),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
                4: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: const [
                    TableCell(child: Text('제조일자', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))),
                    TableCell(child: Text('약품명', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))),
                    TableCell(child: Text('1회 투약량', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))),
                    TableCell(child: Text('1일 투여횟수', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))),
                    TableCell(child: Text('총 투약일수', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))),
                  ],
                ),

              ],
            ),
          )
          ])]
      )),


      //body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Camera'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
          ),
        ],
      ),
    );
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