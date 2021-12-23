import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Tensorflow extends StatefulWidget {
  const Tensorflow({Key? key}) : super(key: key);

  @override
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Tensorflow> {
  List? _outputs;
  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/image_model/model_unquant.tflite",
      labels: "assets/image_model/labels.txt",
      numThreads: 1,
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tensorflow Lite",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loading ? Container(
              height: 300,
              width: 300,
            ):
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null ? Container() : Image.file(_image!),
                  SizedBox(
                    height: 20,
                  ),
                  _image == null ? Container() : _outputs != null ?
                  Text(
                    _outputs![0]["label"], 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ): Container(child: Text(""),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  FloatingActionButton(
                    tooltip: "Pick Image",
                    onPressed: pickImage,
                    child: Icon(
                      Icons.add_a_photo,
                      size: 20,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.amber,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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

  
// class _AddIngredientPageState extends State<AddIngredientPage> {
//   DateTime _selectedDate = DateTime.now();

//   late File pickedImage;
//   var imageFile;
//   var result = '';

//   bool isImageLoaded = false;

//   getImageFromGallery() async {
//     var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

//     setState(() {
//       pickedImage = File(tempStore!.path);
//       isImageLoaded = true;
//     });
//   }

//   //Text Recognition
//   readTextFromImage() async {
//     result = '';
//     FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
//     TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
//     VisionText readText = await recognizeText.processImage(myImage);

//     for (TextBlock block in readText.blocks) {
//       for (TextLine line in block.lines) {
//         for (TextElement word in line.elements) {
//           setState(() {
//             result = result + ' ' + word.text;
//           });
//         }
//       }
//     }
//   }

//   //select date
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2015, 8),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != _selectedDate)
//       setState(() {
//         _selectedDate = picked;
//       });

//     //print(_selectedDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               getImageFromGallery();
//             },
//             child: Icon(
//               Icons.add_a_photo,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           child: SingleChildScrollView(
//             // dragStartBehavior: DragStartBehavior.down
//             physics: ClampingScrollPhysics(),
//             // padding: EdgeInsets.symmetric(
//             //     horizontal: getProportionateScreenWidth(20)),
//             padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 30.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   'Snap a picture on your ingredients here!',
//                   style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 isImageLoaded
//                     ? Center(
//                         child: Container(
//                           height: 250.0,
//                           width: 250.0,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: FileImage(pickedImage),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       )
//                     : Container(),
//                 SizedBox(height: 20),
//                 Text(result),
//                 SizedBox(height: 20),
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Milk"),
//                             Text("Accuracy: 95%"),
//                             Text("${_selectedDate.toLocal()}".split(' ')[0]),
//                             OutlinedButton(
//                               onPressed: () => _selectDate(context),
//                               child: Text('Select Date'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           readTextFromImage();
//         },
//         child: Icon(
//           Icons.check,
//         ),
//       ),
//     );
//   }
// }

// // save ingredient api
// @override
// Future<bool> saveIngredient(int userId, String ingredientName) async {
//   final String apiRoute = 'save_ingredient';

//   var url = Uri.parse('http://192.168.0.122:8000/api/' + apiRoute);
//   //var url = Uri.parse('http://127.0.0.1:8000/api/' + apiRoute);

//   print('Requesting to $url');

//   var response = await http.post(
//     url,
//     headers: {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({'user_id': userId, 'ingredient_name': ingredientName}),
//   );

//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');

//   var responseBody = response.body;

//   if (response.statusCode == 200) {
//     return true;
//   } else if (response.statusCode == 422) {
//     throw CustomException.fromJson(
//         jsonDecode(responseBody) as Map<String, dynamic>);
//   } else {
//     throw CustomException(message: 'Failed to save ingredient!');
//   }
// }