import 'package:flutter/foundation.dart';
import 'package:task_management_app/data/models/user_model.dart';
import 'package:task_management_app/data/services/api_caller.dart';
import 'package:task_management_app/data/utils/urls.dart';
import 'package:task_management_app/ui/controllers/auth_controller.dart';

class LoginProvider extends ChangeNotifier {
  bool _loginInprogress = false;

  String? _errorMessage;

  bool get loginInProgress => _loginInprogress; //getter method access private-variable
  String? get errorMessage => _errorMessage;


  Future<bool> login(String email, String password) async {
    bool isSuccess = false;

    _loginInprogress =
        true; //when api will be called , then loading will be started
    notifyListeners(); //showing for loading to UI, In that case, notifyListeners is used

    //Making data prepare to key-value pair for sending request body to Api server
    Map<String, dynamic> requestBody = {"email": email, "password": password};

    //To send data server. This is a post type request
    final ApiResponse response =
        await ApiCaller.postRequest(url: Urls.loginUrl, body: requestBody);

    //Here , There is a if-else condition. If condition is true, Then it is executed
    //Otherwise , else part is executed
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel model = UserModel.fromJson(response.responseData['data']);  //we will collect data from server and covert it Json to objcet
      String token = response.responseData['token'];  //Token is being taken from sever

      await AuthController.saveUserData(model, token);  //SharedPreference is saved data

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _loginInprogress = false;
    notifyListeners();

    return isSuccess;
  }
}
