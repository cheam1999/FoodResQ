import 'dart:convert';
import 'dart:io';

//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/env.dart';
import 'package:foodresq/main_common.dart';
import 'package:foodresq/models/custom_exception.dart';
import 'package:foodresq/screen/home.dart';
import 'package:foodresq/screen/ingredient_listing_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';
import 'package:get/get.dart';

final ingredientListingRepositoryProvider =
    Provider<IngredientRepository>((ref) => IngredientRepository(ref.read));

class AddIngredientPage extends StatefulWidget {
  static String routeName = "/addIngredient";
  const AddIngredientPage({Key? key, required this.title}) : super(key: key);

  final String title;

  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

List? _outputs;
File? _image;
bool _loading = false;

//_AddIngredientPageState(this._read);

TextEditingController ingredientController = TextEditingController();
TextEditingController dateController = TextEditingController();
DateTime _selectedDate = DateTime.now();

class _AddIngredientPageState extends State<AddIngredientPage> {
  @override
  void initState() {
    super.initState();
    _loading = true;
    _outputs = null;
    _image = null;

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
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColourConstant.kButtonColor),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: Icon(Icons.image),
                      label: Text("Gallery"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColourConstant.kButtonColor),
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
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text(
                                    'Add Ingredient Manually',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
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
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormField(
                                            controller: dateController,
                                            onTap: () async {
                                              // Below line stops keyboard from appearing
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());

                                              dateController.text =
                                                  "${_selectedDate.toLocal()}"
                                                      .split(' ')[0];

                                              // Show Date Picker Here
                                              await _selectDate(context);
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
                                  actions: [addIngredient2()],
                                );
                              },
                            );
                          },
                        ).then((value) {
                          dateController.clear();
                          ingredientController.clear();
                        });
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Add Ingredient Manually"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColourConstant.kButtonColor),
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
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColourConstant.kButtonColor),
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
      backgroundColor: ColourConstant.kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColourConstant.kHeaderColor,
        title: Text(
          widget.title,
          style: TextStyle(
            color: ColourConstant.kTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/graphics/background.png"),
              colorFilter: new ColorFilter.mode(
                  Colors.white.withOpacity(0.2), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraint) {
              return SizedBox(
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
                                  "Image Placeholder",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
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
                                    Text("${_selectedDate.toLocal()}"
                                        .split(' ')[0]),
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
                                  child: addIngredient(),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            }),
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
        backgroundColor: ColourConstant.kButtonColor,
      ),
    );
  }
}

class addIngredient extends HookConsumerWidget {
  const addIngredient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: () async {
        bool success = false;

        success = await ref
            .read(ingredientListingRepositoryProvider)
            .saveIngredient(_outputs![0]["label"], _selectedDate);

        if (success) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, ModalRoute.withName('/'));
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: const Text('Fail to save!')));
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
            MaterialStateProperty.all<Color>(ColourConstant.kButtonColor),
      ),
    );
  }
}

class addIngredient2 extends HookConsumerWidget {
  const addIngredient2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(ColourConstant.kButtonColor),
      ),
      child: Text("Save"),
      onPressed: () async {
        var ingredient = ingredientController.text;

        bool success = false;

        if (dateController.text != '') {
          success = await ref
              .read(ingredientListingRepositoryProvider)
              .saveIngredient(ingredient, _selectedDate);
        } else {
          success = false;
        }

        if (success) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, ModalRoute.withName('/'));
          dateController.clear();
          ingredientController.clear();
        } else {
          Get.back();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: const Text('Fail to save!')));
        }
      },
    );
  }
}
