import 'package:flutter/material.dart';
import 'package:task_management_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_management_app/ui/widgets/task_card.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllCompletedTasks();
    });
    super.initState();
  }

  Future<void> _getAllCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.completedTaskListUrl);

    _getCompletedTaskInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
          child: Visibility(
        visible: _getCompletedTaskInProgress == false,
        replacement: CenteredProgressIndicator(),
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          itemBuilder: (context, int index) {
            return TaskCard(
                taskModel: _completedTaskList[index],
                refreshParent: () {
                  _getAllCompletedTasks();
                });
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 5,
            );
          },
        ),
      )),
    ));
  }
}
