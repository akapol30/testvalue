import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databasetest/class_book.dart';
import 'package:databasetest/class_getingtext.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:min_id/min_id.dart';

class AddNorth extends StatefulWidget {
  const AddNorth({super.key});

  @override
  State<AddNorth> createState() => _AddNorthState();
}

class _AddNorthState extends State<AddNorth> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  int currentStep = 0;
  List<File> images = [];

  PlatformFile? files;
  Foodsql myFoodbook = Foodsql(
    foodname: '',
    foodtype: '',
    region: '',
    recipetype: '',
    ingredient: [],
    quantity: [],
    uom: [],
    step: [],
    pic: [],
  );

  final CollectionReference _tableFoodbook =
      FirebaseFirestore.instance.collection("ListRecipesNorth");
  //final user = FirebaseAuth.instance.currentUser!;
  static int countIng = 0, countStep = 0;
  bool flatimage = false;
  final formKey = GlobalKey<FormState>();

  var date = DateTime.now();
  var formattedDate = DateFormat('dd - MM - yyyy');
  String foodname = '';
  List<Ingdata> foodsIng = List.generate(countIng, (index) => Ingdata());
  List<Stepdata> foodsStep = List.generate(countStep, (index) => Stepdata());

  void _saveIngToDataBase() {
    for (int i = 0; i < foodsIng.length; i++) {
      myFoodbook.ingredient!.add(foodsIng[i].ingname!);
      myFoodbook.quantity!.add(foodsIng[i].quantity!);
      myFoodbook.uom!.add(foodsIng[i].uom!);
    }
  }

  void _saveStepToDataBase() {
    for (int i = 0; i < foodsStep.length; i++) {
      myFoodbook.step!.add(foodsStep[i].step!);
    }
  }

  void _onListCountChangeIng(int value) {
    setState(() {
      countIng = value;
      foodsIng = List.generate(
          countIng, (index) => Ingdata(ingname: '', quantity: '', uom: ''));
    });
  }

  void _onListCountChangeStep(int value) {
    setState(() {
      countStep = value;
      foodsStep = List.generate(countStep, (index) => Stepdata(step: ''));
    });
  }

  String? selectedValueRg, selectedValueRp, selectedValuefood;
  List? categoryItemList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: firebase,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      "${snapshot.error}",
                      style: const TextStyle(
                          fontSize: 20.0, fontFamily: 'MitrLight'),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text("แบบฟอร์มรายละเอียดอาหาร",
                          style: TextStyle(fontFamily: 'Mitr')),
                    ),
                    body: SingleChildScrollView(
                        child: Stepper(
                      currentStep: currentStep,
                      onStepContinue: () async {
                        if (currentStep != 3) {
                          setState(() {
                            currentStep++;
                          });
                        } else {
                          final uploadTasks = images.map((file) async {
                            String uniqueFilename = '${MinId.getId()}+book';
                            Reference refRoot = FirebaseStorage.instance.ref();
                            Reference refDirImages =
                                refRoot.child('imagesbook');
                            Reference refImageToUpload =
                                refDirImages.child(uniqueFilename);
                            await refImageToUpload.putFile(File(file.path));
                            return await refImageToUpload.getDownloadURL();
                          });

                          final urls = await Future.wait(uploadTasks);
                          for (int i = 0; i < urls.length; i++) {
                            myFoodbook.pic!.add(urls[i]);
                          }
                          if (formKey.currentState!.validate()) {
                            myFoodbook.foodtype = selectedValuefood!;

                            myFoodbook.region = selectedValueRg!;

                            myFoodbook.recipetype = selectedValueRp!;

                            //myFoodbook.namepro = user.displayName!;

                            //myFoodbook.picpro = user.photoURL!;

                            _saveIngToDataBase();
                            _saveStepToDataBase();
                            formKey.currentState?.save();

                            await _tableFoodbook.add({
                              "Bfoodtype": myFoodbook.foodtype,
                              "Bfoodname": myFoodbook.foodname,
                              "Bingredient": myFoodbook.ingredient,
                              "Bquantity": myFoodbook.quantity,
                              "Buom": myFoodbook.uom,
                              "Bstep": myFoodbook.step,
                              "Bpicfood": myFoodbook.pic,
                              "Bregion": myFoodbook.region,
                              "Brecipetype": myFoodbook.recipetype,
                            });
                            formKey.currentState?.reset();
                          }
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        }
                      },
                      onStepCancel: () {
                        if (currentStep != 0) {
                          setState(() {
                            currentStep--;
                          });
                        }
                      },
                      onStepTapped: (index) {
                        setState(() {
                          currentStep = index;
                        });
                      },
                      steps: [
                        Step(
                            isActive: currentStep >= 0,
                            title: const Text("รูปภาพ"),
                            content: files == null
                                ? defaultImg(context)
                                : multiImg(context)),
                        Step(
                          isActive: currentStep >= 1,
                          title: const Text("รายละเอียด"),
                          content: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: const InputDecoration(
                                        labelText: 'ชื่ออาหาร',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: RequiredValidator(
                                          errorText: "กรุณาป้อนชื่ออาหาร ^^"),
                                      onSaved: (value) {
                                        myFoodbook.foodname = value!.trim();
                                        foodname = value.trim();
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: DropdownButton<String>(
                                      value: selectedValueRg,
                                      isExpanded: true,
                                      hint: const Text("ภูมิภาค"),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValueRg = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'ภาคเหนือ',
                                        'ภาคอีสาน',
                                        'ภาคตะวันตก',
                                        'ภาคกลาง',
                                        'ภาคตะวันออก',
                                        'ภาคใต้',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: DropdownButton<String>(
                                      value: selectedValueRp,
                                      isExpanded: true,
                                      hint: const Text("ประเภทสูตร"),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValueRp = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'Food',
                                        'Beverage',
                                        'Dessert',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: DropdownButton<String>(
                                      value: selectedValuefood,
                                      isExpanded: true,
                                      hint: const Text("ประเภทอาหาร"),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValuefood = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'อาหารตามสั่ง',
                                        'อาหารเช้า',
                                        'อาหารป่า',
                                        'อาหารจานเดียว',
                                        'อาหารทะเล',
                                        'อาหารเจ',
                                        'ติ่มซำ',
                                        'น้ำพริก',
                                        'อาหารคลีน/สลัด',
                                        'ก๋วยเตี๋ยว',
                                        'น้ำผลไม้',
                                        'ชานมไข่มุก',
                                        'กาแฟ',
                                        'เครื่องดื่มแอลกอฮอล์',
                                        'เบเกอรี/เค้ก',
                                        'ของหวาน',
                                        'คุ๊กกี้',
                                        'ไอศกรีม',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                        Step(
                            isActive: currentStep >= 2,
                            title: const Text("วัตถุดิบ"),
                            content: Column(children: [
                              Row(
                                children: [
                                  const Text("จำนวนวัตถุดิบทั้งหมด",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Mitr')),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: const InputDecoration(
                                        labelText: 'จำนวน',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: ((value) {
                                        if (countIng > 30) {
                                          return 'ใส่ได้ <= 30';
                                        }
                                        return null;
                                      }),
                                      onChanged: (value) {
                                        try {
                                          _onListCountChangeIng(
                                              int.parse(value));
                                        } catch (e) {
                                          _onListCountChangeIng(0);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                      child: Container(
                                          color: Colors.yellow.shade100,
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          child: ListView.builder(
                                              itemCount: countIng,
                                              itemBuilder: (context, index) {
                                                return _multiIng(index);
                                              }))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ])),
                        Step(
                          isActive: currentStep >= 3,
                          title: const Text("ขั้นตอน"),
                          content: Column(
                            children: [
                              Row(children: [
                                const Text("จำนวนขั้นตอนทั้งหมด",
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Mitr')),
                                const SizedBox(width: 15),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: const InputDecoration(
                                        labelText: 'จำนวน',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: ((value) {
                                        if (countStep > 20) {
                                          return 'ใส่ได้ <= 20';
                                        }
                                        return null;
                                      }),
                                      onChanged: (value) {
                                        try {
                                          _onListCountChangeStep(
                                              int.parse(value));
                                        } catch (e) {
                                          _onListCountChangeStep(0);
                                        }
                                      },
                                    )),
                                const SizedBox(width: 20),
                              ]),
                              const SizedBox(height: 16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                      child: Container(
                                          color: Colors.orange.shade100,
                                          height: 130,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          child: ListView.builder(
                                              itemCount: countStep,
                                              itemBuilder: (context, index) {
                                                return _multiStep(index);
                                              }))),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    )));
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }));
  }

  Widget defaultImg(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 5)),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.3,
        child: InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png', 'jpeg'],
            );

            if (result != null) {
              images = result.paths.map((path) => File(path!)).toList();
              setState(() {
                files = result.files.first;
              });
            }
          },
          child: Ink.image(image: const AssetImage('assets/images/pic2.png')),
        ));
  }

  Widget multiImg(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 5)),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.3,
        child: InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png', 'jpeg'],
            );

            if (result != null) {
              images = result.paths.map((path) => File(path!)).toList();
              setState(() {
                files = result.files.first;
              });
            }
          },
          child: SizedBox(
              height: 200,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GridView.builder(
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Stack(children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                left: 40,
                                bottom: 40,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    dltImage(images[index]);
                                  },
                                ))
                          ]),
                        );
                      }))),
        ));
  }

  void dltImage(data) {
    setState(() {
      images.remove(data);
    });
  }

  _multiIng(int index) {
    return Row(
      children: [
        Text(
          "${index + 1}",
          style: const TextStyle(fontSize: 18),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: const EdgeInsets.only(left: 12),
                width: MediaQuery.of(context).size.width * 0.25,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'วัตถุดิบ',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: foodsIng[index].ingname,
                  //validator:
                  //    RequiredValidator(errorText: "กรุณาป้อนชื่อวัตถุดิบ ^^"),
                  onChanged: (v) {
                    foodsIng[index].ingname = v;
                  },
                ))),
        const SizedBox(width: 10),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'จำนวน',
                border: OutlineInputBorder(),
              ),
              initialValue: foodsIng[index].quantity,
              //validator:
              //    RequiredValidator(errorText: "กรุณาป้อนจำนวนวัตถุดิบ ^^"),
              onChanged: (c) {
                foodsIng[index].quantity = c;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            )),
        const SizedBox(width: 10),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                padding: const EdgeInsets.only(right: 20),
                width: MediaQuery.of(context).size.width * 0.26,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'หน่วย',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: foodsIng[index].uom,
                  //validator:
                  //    RequiredValidator(errorText: "กรุณาป้อนหน่วยวัตถุดิบ ^^"),
                  onChanged: (v) {
                    foodsIng[index].uom = v;
                  },
                ))),
      ],
    );
  }

  _multiStep(int index) {
    return Row(children: [
      Text("${index + 1}", style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'ขั้นตอน',
              border: OutlineInputBorder(),
            ),
            initialValue: foodsStep[index].step,
            //validator: RequiredValidator(errorText: "กรุณาป้อนขั้นตอนการทำ ^^"),
            onChanged: (v) {
              foodsStep[index].step = v;
            },
          ))
    ]);
  }
}
