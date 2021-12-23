import 'dart:convert';
import 'dart:io';

//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/screens/ingredient_listing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';
import 'package:get/get.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  List? _outputs;
  File? _image;
  bool _loading = false;

  TextEditingController ingredientController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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

  pickImage(ImageSource imageType) async {
    var image = await ImagePicker().pickImage(source: imageType);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image!);
    Get.back();
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

  //options for getting image
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Image Taken From",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Camera"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.brown),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: Icon(Icons.image),
                      label: Text("Gallery"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.brown),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Manually add",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        //do something here
                        Get.back();
                        //dialog pop up
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Add Ingredient Manually'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: ingredientController,
                                          decoration: InputDecoration(
                                            labelText: 'Ingredient',
                                            icon: Icon(Icons.fastfood),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: dateController,
                                          onTap: () {
                                            // Below line stops keyboard from appearing
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());

                                            // Show Date Picker Here
                                            _selectDate(context);

                                            dateController.text =
                                                "${_selectedDate.toLocal()}"
                                                    .split(' ')[0];
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Expiry Date',
                                            icon: Icon(
                                                Icons.calendar_today_rounded),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Save"),
                                    onPressed: () async {
                                      var ingredient =
                                          ingredientController.text;

                                      bool success = false;

                                      //userID hard code
                                      success = await saveIngredient(
                                          1, ingredient, _selectedDate);

                                      if (success) {
                                        //Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IngredientListingPage()),
                                        );
                                      } else
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: const Text(
                                                    'Fail to save!')));
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Add Ingredient Manually"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.brown),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                      label: Text("Cancel"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.brown),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Your Ingredient',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _image == null
                    ? Container(
                        child: Center(
                          child: Text(
                            "Image shown here",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        width: 200,
                        height: 200,
                        color: Colors.black38,
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        color: Colors.white,
                        child: FittedBox(
                          child: Image.file(_image!),
                          fit: BoxFit.fill,
                        ),
                      ),
                SizedBox(height: 50),
                _outputs != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Ingredient Name:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 0,
                                width: 10,
                              ),
                              Text(
                                _outputs![0]["label"],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Expiry Date:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 0,
                                width: 10,
                              ),
                              Text("${_selectedDate.toLocal()}".split(' ')[0]),
                              SizedBox(
                                height: 0,
                                width: 10,
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_today_rounded),
                                iconSize: 20,
                                onPressed: () => _selectDate(context),
                                color: Colors.orange.shade800,
                              ),
                            ],
                          ),
                          Text(
                            "Note: For things without expiry date, select an estimated expiry date.",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                bool success = false;

                                //userID hard code
                                success = await saveIngredient(
                                    1, _outputs![0]["label"], _selectedDate);

                                if (success) {
                                  //Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IngredientListingPage()),
                                  );
                                } else
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              const Text('Fail to save!')));
                              },
                              child: Text(
                                "Confirm & Save",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange.shade800),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Pick Image",
        onPressed: imagePickerOption,
        child: Icon(
          Icons.add_a_photo,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

// save ingredient api
@override
Future<bool> saveIngredient(
    int userId, String ingredientName, DateTime expiryDate) async {
  final String apiRoute = 'save_ingredient';

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String expiryDateString = dateFormat.format(expiryDate);

  print(expiryDateString);

  var url = Uri.parse('http://192.168.0.122:8000/api/' + apiRoute);
  //var url = Uri.parse('http://127.0.0.1:8000/api/' + apiRoute);

  print('Requesting to $url');

  var response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      'user_id': userId,
      'ingredient_name': ingredientName,
      'expiry_date': expiryDateString
    }),
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
