import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/core/helper.dart';
import 'package:digitolk_test/core/storage.dart';
import 'package:digitolk_test/core/toastr.dart';
import 'package:digitolk_test/models/task.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:digitolk_test/services/auth_service.dart';
import 'package:digitolk_test/services/task_service.dart';
import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pusher_client/pusher_client.dart';

class TasksPage extends StatefulWidget {
  static const String name = "Tasks";
  final ValueChanged<int> onCreateClick;

  const TasksPage({Key? key, required this.onCreateClick}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tomorrow = today.add(const Duration(days: 1));

    TaskService.fetch().then((tasks) {
      setTasks(tasks);
    });
  }

  List<Task> uncompletedTasks = <Task>[];
  List<Task> completedTasks = <Task>[];
  bool loading = true;
  DateTime today = DateTime.now();
  late DateTime tomorrow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Task",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextButton(
                      onPressed: () => widget.onCreateClick(1),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          Text(
                            "Add Task",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Incomplete Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Expanded(child: _build_uncompleted_task_list()),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(height: 200, child: _build_uncompleted_task_list()),
                  SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Complete Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 200, child: _build_completed_task_list()),
                ],
              ),
            ),
    );
  }

  ListView _build_uncompleted_task_list() {
    return ListView(
      children: uncompletedTasks.map(
        (task) {
          return taskRow(task, forCompletedTask: false);
        },
      ).toList(),
    );
  }

  Slidable taskRow(Task task, {bool forCompletedTask = false}) {
    String time = prepareTime(task.dueAt);
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) async {
              List<Task> tasks = await TaskService.deleteTask(task.id);
              setTasks(tasks);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
          ),
        ],
      ),
      // component is not dragged.
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 25),
        leading: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: task.completed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox(
                height: task.completed ? 0 : 7,
              ),
              GestureDetector(
                onTap: () => toggleComplete(task),
                child: Icon(task.completed
                    ? CupertinoIcons.checkmark_square
                    : CupertinoIcons.square),
              ),
            ],
          ),
        ),
        minLeadingWidth: 15,
        title: task.completed
            ? Text(task.summary)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.summary),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.alarm,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.black45, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  String prepareTime(String dueAtString) {
    DateTime dueAt = DateTime.parse(dueAtString);
    List<String> months =
        ",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(",");

    String day = dueAt.day.toString();

    String month = months[dueAt.month];

    if (dueAt.day == today.day) {
      day = "Today";
    }
    if (dueAt.day == tomorrow.day) {
      day = "Tomorrow";
    }
    if (day != 'Today' && day != 'Tomorrow') {
      day = "$day $month";
    }

    day =
        '$day, ${dueAt.hour.toString().padLeft(2, '0')}.${dueAt.minute.toString().padLeft(2, '0')}';
    return day;
  }

  ListView _build_completed_task_list() {
    return ListView(
      children: completedTasks.map(
        (task) {
          return taskRow(task, forCompletedTask: true);
        },
      ).toList(),
    );
  }

  toggleComplete(Task task) async {
    loading = true;
    List<Task> tasks = await TaskService.toggleComplete(task.id);
    setTasks(tasks);
  }

  void setTasks(List<Task> tasks) {
    completedTasks = tasks.where((t) => t.completed).toList();
    uncompletedTasks = tasks.where((t) => !t.completed).toList();
    setState(() {
      loading = false;
    });
  }
}
