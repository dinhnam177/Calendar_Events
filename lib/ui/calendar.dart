import 'package:calendar_events/controllers/task_controller.dart';
import 'package:calendar_events/models/task.dart';
import 'package:calendar_events/ui/add_task_bar.dart';
import 'package:calendar_events/services/theme.dart';
import 'package:calendar_events/ui/widgets/button.dart';
import 'package:calendar_events/ui/widgets/task_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final _taskController = Get.put(TaskController());
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  TextStyle dayStyle (FontWeight fontWeight){
    return TextStyle(color: Colors.white,fontWeight: fontWeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _calendar(),
          SizedBox(height: 10,),
          _showTask(),
        ],
      ),
      backgroundColor: Colors.black,
      floatingActionButton: button(),
    );
  }
  Widget button() => MyButton(
      onTap: () async{
        await Get.to(AddTaskPage());
        _taskController.getTask();
      }
  );
  _showTask(){
    return Expanded(
        child: Obx((){
          return ListView.builder(
              itemCount: _taskController.taskList.length,
              itemBuilder: (_, index){
                Task task = _taskController.taskList[index];
                if(task.repeat == 'Daily'){
                  return  AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if(task.date == DateFormat.yMd().format(selectedDay)){
                  return  AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }else{
                  return Container();
                }

          });
        }),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1?
          MediaQuery.of(context).size.height*0.24:
          MediaQuery.of(context).size.height*0.32,
        color: Colors.black,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
            ),
            Spacer(),
            task.isCompleted==1?Container()
                : _boottomSheetButton(
                label: "Task Completed",
                onTap: (){
                  _taskController.markTaskCompeleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
                context: context,
            ),
            _boottomSheetButton(
              label: "Delete Task",
              onTap: (){
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            SizedBox(height: 20,),
            _boottomSheetButton(
              label: "Close",
              onTap: (){
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  _boottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Colors.grey[600]!:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.deepOrangeAccent,
      title: Text("Calendar Event App"),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      leading: Container(
        margin: EdgeInsets.only(left: 60),
        child: Icon(Icons.calendar_today_rounded,),
      ),
    );
  }

  _calendar() {
    return Container(
      child: TableCalendar(
        firstDay: DateTime.utc(2010,10,20),
        lastDay: DateTime.utc(2040,10,20),
        focusedDay: selectedDay,
        calendarFormat: format,

        // Switch 2 weeks, week, month
        onFormatChanged: (CalendarFormat _format){
          setState(() {
            format = _format;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekVisible: true,

        //Day Changed
        onDaySelected: (DateTime selectDay, DateTime focusDay){
          setState(() {
            selectedDay = selectDay;
            focusedDay = focusDay;
          });
        },
        selectedDayPredicate: (DateTime date){
          return isSameDay(selectedDay,date);
        },

        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
          ),
          formatButtonShowsNext: true,
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white,),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white,),
        ),
        //To style the Calendar
        calendarStyle: CalendarStyle(
          defaultTextStyle: dayStyle(FontWeight.normal),
          weekendTextStyle: dayStyle(FontWeight.normal),
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: Color(0xff30384c),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          weekdayStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
