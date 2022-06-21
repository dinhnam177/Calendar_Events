import 'package:calendar_events/db/db_helper.dart';
import 'package:calendar_events/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  void getTask() async{
    List<Map<String, dynamic>> task = await DBHelper.query();
    taskList.assignAll(task.map((data)=> new Task.fromJson(data)).toList());
  }

  void delete(Task task){
   DBHelper.delete(task);
   getTask();
  }

  void markTaskCompeleted(int id) async{
    await DBHelper.update(id);
    getTask();
  }
}