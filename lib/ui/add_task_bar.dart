import 'package:calendar_events/controllers/task_controller.dart';
import 'package:calendar_events/models/task.dart';
import 'package:calendar_events/services/theme.dart';
import 'package:calendar_events/ui/widgets/button.dart';
import 'package:calendar_events/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectDateTime = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5,10,15,20];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily","Weekly","Monthly"];

  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15,top: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your Title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your Note", controller:  _noteController,),
              MyInputField(title: "Date Time", hint: DateFormat.yMd().format(_selectDateTime),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  iconSize: 20,
                  color: Colors.grey,
                  onPressed: () {
                    _getDateFormUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: (){
                          _getTimeFormUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: (){
                          _getTimeFormUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }
                  ).toList(),
                ),
              ),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  ).toList(),
                ),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  _validateDate(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      //add to database
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !!",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        icon: Icon(Icons.warning_amber_rounded,color: Colors.yellow,),
        backgroundColor: Colors.red,
      );
    }
  }

  _addTaskToDb() async{
    int value = await _taskController.addTask(
        task:Task(
          note:_noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectDateTime),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print('My id is ' + '$value');
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap(
          children: List<Widget>.generate(
              3, (index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                  child: _selectedColor == index?Icon(Icons.done,
                    color: Colors.white,
                    size: 16,
                  ):Container(),
                ),
              ),
            );
          }
          ),
        ),
      ],
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.deepOrangeAccent,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.close_outlined,
          size: 25,
          color: Colors.white,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: ()=>_validateDate(),
          child: Container(
            margin: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.done,
              size: 25,
              color: Colors.white,),
          ),
        )
      ],
    );
  }

  _getDateFormUser() async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2222)
    );
    if(_pickerDate != null){
      setState(() {
        _selectDateTime = _pickerDate;
      });
    }
    else{
      print("it's null or something is wrong !!!");
    }
  }

  _getTimeFormUser({required bool isStartTime}) async{
    var pickedTime = await _showTimePicked();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      print("Time canceld");
    }else if (isStartTime == true){
      setState(() {
        _startTime = _formatedTime;
      });
    }else if (isStartTime == false){
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }
  _showTimePicked(){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),)
    );
  }
}
