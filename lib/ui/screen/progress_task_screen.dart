import 'package:flutter/material.dart';
import 'package:task_management_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_management_app/ui/widgets/task_card.dart';
import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllProgressTasks();
    });
    super.initState();
  }

  Future<void> _getAllProgressTasks() async {
    _getProgressTaskInProgress = true;
    setState(() {});

    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.progressTaskListUrl);

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

    _getProgressTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: _getProgressTaskInProgress,
        replacement: CenteredProgressIndicator(),
        child: ListView.separated(
          itemCount: _progressTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
                taskModel: _progressTaskList[index],
                refreshParent: (){
                  _getAllProgressTasks();
                });
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 5,
            );
          },
        ),
      ),
    ));
  }
}
