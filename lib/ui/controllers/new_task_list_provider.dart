import 'package:flutter/foundation.dart';
import 'package:task_management_app/data/models/task_model.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';

class NewTaskListProvider extends ChangeNotifier {
  bool _getNewTaskInProgress = false;

  String? _errorMessage;

  List<TaskModel> _newTaskList = [];

  bool get getNewTaskInProgress => _getNewTaskInProgress;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get newTaskList => _newTaskList;

  Future<bool> getNewTasks() async {
    bool isSuccess = false;

    _getNewTaskInProgress = true;
    notifyListeners();

    //Fetching data from the internet
    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.newTaskListUrl);

    if(response.isSuccess){
      List<TaskModel> list =[];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData)); //JSON Data convert Object
      }
      _newTaskList = list;
      isSuccess = true;
    }else{
       _errorMessage = response.errorMessage;
    }

    _getNewTaskInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
