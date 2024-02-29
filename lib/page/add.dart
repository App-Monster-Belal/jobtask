import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobtask/custom/route.dart';

import '../custom/Custom.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _project_name = TextEditingController();
  final TextEditingController _project_update = TextEditingController();
  final TextEditingController _assigned_engineer = TextEditingController();
  final TextEditingController _assigned_technician = TextEditingController();
  final TextEditingController _start_date = TextEditingController();
  final TextEditingController _end_date = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar( backgroundColor: Colors.teal,
        title: Text('Add Information', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back,
              color: Colors.white
          ),
          iconSize: 28,
          onPressed: ()=> Get.toNamed(home),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    Text("Please Add Information", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),),
                    SizedBox(height: 20),
                    customText("Project Name", TextInputType.text, _project_name, (val) {
                      if (val!.isEmpty) {
                        return "can't be empty";
                      }
                    }),
                    SizedBox(height: 10),
                    customText("Project Update", TextInputType.text, _project_update, (val) {
                      if (val!.isEmpty) {
                        return "can't be empty";
                      }
                    }),
                    SizedBox(height: 10),
                    customText("Assigned Engineer", TextInputType.text, _assigned_engineer, (val) {
                      if (val!.isEmpty) {
                        return "can't be empty";
                      }
                    }),
                    SizedBox(height: 10),
                    customText("Assigned Tech", TextInputType.text, _assigned_technician, (val) {
                      if (val!.isEmpty) {
                        return "can't be empty";
                      }
                    }),
                    SizedBox(height: 10),
                    customDate(_start_date, () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _start_date.text = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                        });
                      }
                    }, "Start Date"),
                    SizedBox(height: 10),
                    customDate(_end_date, () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _end_date.text = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                        });
                      }
                    }, "End Date"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      height: 40, width: 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal), // Change Colors.blue to your desired color
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> requestBody = {
                              "start_date": _start_date.text,
                              "end_date": _end_date.text,
                              "project_name": _project_name.text,
                              "project_update": _project_update.text,
                              "assigned_engineer": _assigned_engineer.text,
                              "assigned_technician": _assigned_technician.text
                            };

                            final response = await http.post(
                              Uri.parse('https://scubetech.xyz/projects/dashboard/add-project-elements/'),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(requestBody),
                            );

                            if (response.statusCode == 200 || response.statusCode == 201) {
                              Fluttertoast.showToast(
                                msg: 'Added Successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                              debugPrint('ok: ${response.body}');
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Something Wrong',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              debugPrint('Failed to add : ${response.body}');
                            }
                          }
                        },
                        child:Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18), ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
