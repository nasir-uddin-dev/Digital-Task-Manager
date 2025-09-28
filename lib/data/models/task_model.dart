// {
// "_id": "65b4a19c279fb0f60f610bb0",
// "title": "A",
// "description": "v",
// "status": "New",
// "email": "softenghasan25@gmail.com",
// "createdDate": "2024-01-27T06:24:25.316Z"
// },

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String email;
  final String createdDate;

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.email,
      required this.createdDate});

  factory TaskModel.fromJson(Map<String,dynamic> jsonData){
    return TaskModel(
        id: jsonData['_id'],
        title: jsonData['title'],
        description: jsonData['description'],
        status: jsonData['status'],
        email: jsonData['email'],
        createdDate: jsonData['createdData'],
    );
  }
}
