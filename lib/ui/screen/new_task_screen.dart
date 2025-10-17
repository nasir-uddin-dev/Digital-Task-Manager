import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_management_app/data/models/task_status_count_model.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/controllers/new_task_list_provider.dart';
import 'package:task_management_app/ui/screen/add_new_task_screen.dart';
import 'package:task_management_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_management_app/ui/widgets/snack_bar_message.dart';
import 'package:task_management_app/ui/widgets/task_card.dart';

import '../widgets/task_count_by_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTaskStatusCountInProgress = false;

  List<TaskStatusCountModel> _taskStatusCountlist = [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllTaskStatusCount();
    context.read<NewTaskListProvider>().getNewTasks();
    });

    super.initState();
  }

  Future<void> _getAllTaskStatusCount() async {
    _getTaskStatusCountInProgress = true;
    setState(() {});

    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountlist = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

    _getTaskStatusCountInProgress = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 90,
              child: Visibility(
                visible: _getTaskStatusCountInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: ListView.separated(
                  itemCount: _taskStatusCountlist.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountByStatusCard(
                        title: _taskStatusCountlist[index].status,
                        count: _taskStatusCountlist[index].count);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 4,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child: Consumer<NewTaskListProvider>(
                  builder: (context, newTaskListProvider, _) {
                    return Visibility(
                                  visible: newTaskListProvider.getNewTaskInProgress == false,
                                  replacement: CenteredProgressIndicator(),
                                  child: ListView.separated(
                    itemCount: newTaskListProvider.newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: newTaskListProvider.newTaskList[index], refreshParent: () { context.read<NewTaskListProvider>().getNewTasks();},
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                                  ),
                                );
                  }
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewTaskScreen()));
  }
}
