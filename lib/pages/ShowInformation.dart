import 'package:flutter/material.dart';

class Prescription {
  final DateTime prescriptionDate;
  final String medication;
  final int dosagePerOnce;
  final int dailyDose;
  final int totalDosingDays;

  Prescription({
    required this.prescriptionDate,
    required this.medication,
    required this.dosagePerOnce,
    required this.dailyDose,
    required this.totalDosingDays,
  });
}

class ShowInformation extends StatelessWidget {
  // 이 함수는 서버에서 prescription 정보를 가져옵니다.
  Future<List<Prescription>> getPrescriptionData() async {
    // 더미 데이터
    List<Prescription> prescriptions = [
      Prescription(
        prescriptionDate: DateTime.now(),
        medication: '약품1',
        dosagePerOnce: 1,
        dailyDose: 3,
        totalDosingDays: 7,
      ),
      Prescription(
        prescriptionDate: DateTime.now(),
        medication: '약품2',
        dosagePerOnce: 2,
        dailyDose: 2,
        totalDosingDays: 14,
      ),
    ];
    return prescriptions;
  }

  // 이 함수는 알약의 효능을 가져오는 함수입니다.
  Future<String> getMedicationEffect(String medication) async {
    return '$medication의 효능은 ... 입니다.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알약 정보'),
      ),
      body: FutureBuilder<List<Prescription>>(
        future: getPrescriptionData(),
        builder: (BuildContext context, AsyncSnapshot<List<Prescription>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Prescription prescription = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('약품명: ${prescription.medication}'),
                    subtitle: Text('제조 일자: ${prescription.prescriptionDate}\n1회 투약량: ${prescription.dosagePerOnce}\n1일 투여 횟수: ${prescription.dailyDose}\n총 투약 일수: ${prescription.totalDosingDays}'),
                    onTap: () async {
                      String effect = await getMedicationEffect(prescription.medication);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알약의 효능'),
                            content: Text(effect),
                            actions: [
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
