
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:jobtask/page/home.dart';
import 'package:jobtask/page/update.dart';

import '../page/add.dart';

const String home='/home';
const String add_page= '/add_page';
const String update_page= '/update_page';

List <GetPage> getPages=[


  GetPage(name: home, page: ()=>HomePage()),
  GetPage(name: add_page, page: ()=>AddPage()),
  GetPage(name: update_page, page: ()=>UpdatePage(
    project: Get.arguments,
  ))
];