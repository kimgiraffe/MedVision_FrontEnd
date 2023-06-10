import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:my_app/pages/ShowInformation.dart';  // my_app 으로 수정


class SearchPillPage extends StatefulWidget {
  @override
  _SearchPillPageState createState() => _SearchPillPageState();
}

class _SearchPillPageState extends State<SearchPillPage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path);
    });
  }

  Widget showImage() {
    return Container(
      color: const Color(0xffd0cece),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Center(
          child: _image == null? Text("No image selected.") : Image.file(File(_image!.path))
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('알약 검색')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.0),
          showImage(),
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(child: Icon(Icons.add_a_photo),tooltip: 'pick image',onPressed: (){getImage(ImageSource.camera);}),
              FloatingActionButton(child: Icon(Icons.wallpaper), tooltip: 'pick image', onPressed: (){getImage(ImageSource.gallery);})
            ],
          ),
          SizedBox(height: 50.0),
          ElevatedButton(  // RaisedButton을 ElevatedButton으로 수정
            child: Text('검색하러 가기'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowInformation()),  // ShowInformation을 생성자 없이 호출
              );
            },
          ),
        ],
      ),
    );
  }
}
