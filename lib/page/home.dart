import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobtask/custom/Custom.dart';

import '../custom/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Project>> _futureProjects;

  @override
  void initState() {
    super.initState();
    _futureProjects = fetchProjects();
  }

  Future<List<Project>> fetchProjects() async {
    final response =
    await http.get(Uri.parse('https://scubetech.xyz/projects/dashboard/all-project-elements/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Project> projects = [];
      data.forEach((project) {
        projects.add(Project.fromJson(project));
      });
      return projects;
    } else {
      throw Exception('Failed to load projects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAECEE),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
            'Home Details Page',
            style: TextStyle(color: Colors.white),
          ),
        centerTitle: true,

      ),
      body: Column(
        children: [

          SizedBox(
            height: 647,
            width: double.maxFinite,
            child: FutureBuilder<List<Project>>(
              future: _futureProjects,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(update_page, arguments: snapshot.data![index]),
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Project Name: ${snapshot.data![index].projectName}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
                                ),
                                SizedBox(height: 5),
                                Text('Update: ${snapshot.data![index].projectUpdate}', style: TextStyle(fontSize: 14)),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.10,
                                      width: MediaQuery.of(context).size.width*0.38,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Assigned Engineer: ${snapshot.data![index].assignedEngineer}',
                                            style: TextStyle(fontSize: 14, ),
                                            softWrap: true,
                                            maxLines: 2,
                                          ),

                                          Text(
                                            'Assigned Technician: ${snapshot.data![index].assignedTechnician}',
                                            style: TextStyle(fontSize: 14),
                                            softWrap: true,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 30,),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.10,
                                      width: MediaQuery.of(context).size.width*0.32,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Start Date: ${snapshot.data![index].startDate}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'End Date: ${snapshot.data![index].endDate}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
            width: double.maxFinite,
            child: Container(
              child: customButton(()=>Get.toNamed(add_page), 40, "Add new Data"),
              decoration: BoxDecoration(

                  color: Colors.teal
              ),
            ),

          ),
        ],
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //         child: FloatingActionButton(
      //           backgroundColor: Colors.teal,
      //           onPressed: () {
      //             Get.toNamed(add_page);
      //           },
      //           child: Icon(Icons.add),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),


    );
  }
}

class Project {
  final int id;
  final String startDate;
  final String endDate;
  final String projectName;
  final String projectUpdate;
  final String assignedEngineer;
  final String assignedTechnician;
  final int duration;

  Project({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.projectName,
    required this.projectUpdate,
    required this.assignedEngineer,
    required this.assignedTechnician,
    required this.duration,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      projectName: json['project_name'],
      projectUpdate: json['project_update'],
      assignedEngineer: json['assigned_engineer'],
      assignedTechnician: json['assigned_technician'],
      duration: json['duration'],
    );
  }
}
