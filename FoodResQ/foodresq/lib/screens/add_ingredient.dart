import 'dart:convert';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  DateTime _selectedDate = DateTime.now();

  late File pickedImage;
  var imageFile;
  var result = '';

  bool isImageLoaded = false;

  getImageFromGallery() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
    });
  }

  //Text Recognition
  readTextFromImage() async {
    result = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            result = result + ' ' + word.text;
          });
        }
      }
    }
  }

  //select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });

    //print(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () {
              getImageFromGallery();
            },
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            // dragStartBehavior: DragStartBehavior.down
            physics: ClampingScrollPhysics(),
            // padding: EdgeInsets.symmetric(
            //     horizontal: getProportionateScreenWidth(20)),
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 30.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Snap a picture on your ingredients here!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                isImageLoaded
                    ? Center(
                        child: Container(
                          height: 250.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(pickedImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                Text(result),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Milk"),
                            Text("Accuracy: 95%"),
                            Text("${_selectedDate.toLocal()}".split(' ')[0]),
                            OutlinedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select Date'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          readTextFromImage();
        },
        child: Icon(
          Icons.check,
        ),
      ),
    );
  }
}

// save ingredient api
@override
Future<bool> saveIngredient(int userId, String ingredientName) async {
  final String apiRoute = 'save_ingredient';

  var url = Uri.parse('http://192.168.0.122:8000/api/' + apiRoute);
  //var url = Uri.parse('http://127.0.0.1:8000/api/' + apiRoute);

  print('Requesting to $url');

  var response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: jsonEncode({'user_id': userId, 'ingredient_name': ingredientName}),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseBody = response.body;

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 422) {
    throw CustomException.fromJson(
        jsonDecode(responseBody) as Map<String, dynamic>);
  } else {
    throw CustomException(message: 'Failed to save ingredient!');
  }
}

// Future labelsread() async {
  //   result = '';
  //   FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
  //   ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  //   List labels = await labeler.processImage(myImage);

  //   for (ImageLabel label in labels) {
  //     final String text = label.text;
  //     final double confidence = label.confidence;
  //     setState(() {
  //       result = result + ' ' + '$text    $confidence' + '\n';
  //     });
  //   }
  // }