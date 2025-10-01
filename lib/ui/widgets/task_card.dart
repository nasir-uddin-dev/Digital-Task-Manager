import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white,
      title: Text(
       taskModel.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(taskModel.description),
          Text(
            'Date: ${taskModel.createdDate}',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Chip(
                label: Text(taskModel.status),
                backgroundColor: Colors.blue,
                labelStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Colors.redAccent,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  )),
            ],
          )
        ],
      ),
    );
  }
}