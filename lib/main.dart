import 'package:calendar_events/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'ui/calendar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState()=> _MyAppState();
}
  @override
class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calendar(),
    );
  }
}
