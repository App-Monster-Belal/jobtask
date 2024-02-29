import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jobtask/page/home.dart';

import '../custom/Custom.dart';
import '../custom/route.dart';

class UpdatePage extends StatefulWidget {
  final Project project;
  UpdatePage({required this.project});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _project_name;
  late TextEditingController _project_update;
  late TextEditingController _assigned_engineer;
  late TextEditingController _assigned_technician;
  late TextEditingController _start_date;
  late TextEditingController _end_date;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _project_name = TextEditingController(text: widget.project.projectName);
    _project_update =
        TextEditingController(text: widget.project.projectUpdate);
    _assigned_engineer =
        TextEditingController(text: widget.project.assignedEngineer);
    _assigned_technician =
        TextEditingController(text: widget.project.assignedTechnician);
    _start_date = TextEditingController(text: widget.project.startDate);
    _end_date = TextEditingController(text: widget.project.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Update Page',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          iconSize: 28,
          onPressed: () => Get.toNamed(home),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      Text(
                        "Please Update Information",
                        style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _project_name,
                        hint: 'Project Name',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      _buildTextField(
                        controller: _project_update,
                        hint: 'Project Update',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      _buildTextField(
                        controller: _assigned_engineer,
                        hint: 'Assigned Engineer',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      _buildTextField(
                        controller: _assigned_technician,
                        hint: 'Assigned Technician',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
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
                      SizedBox(height: 20),
                      Container(
                        height: 40,
                        width: 250,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                          ),
                          onPressed: () async {
                            _updateProjectDetails();
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        labelStyle: TextStyle(color: Colors.blueGrey), // Change label color
        filled: true,
        fillColor: Colors.grey[200], // Background color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue), // Focused border color
        ),
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (val) {
        if (val!.isEmpty) {
          return "can't be empty";
        }
        return null;
      },
    );
  }

  void _updateProjectDetails() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> requestBody = {
        "start_date": _start_date.text,
        "end_date": _end_date.text,
        "project_name": _project_name.text,
        "project_update": _project_update.text,
        "assigned_engineer": _assigned_engineer.text,
        "assigned_technician": _assigned_technician.text
      };

      final response = await http.put(
        Uri.parse(
            'https://scubetech.xyz/projects/dashboard/update-project-elements/${widget.project.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Updated Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        debugPrint('Failed to update : ${response.body}');
      }
    }
  }
}
