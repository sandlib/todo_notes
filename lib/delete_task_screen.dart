import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_todo/database_helper.dart';
import 'package:personal_todo/models/task_model.dart';
import 'package:personal_todo/todo_list_screen.dart';

class DeleteTask extends StatefulWidget {
  final Function updateTask;
  final Task task;
  DeleteTask({this.task, this.updateTask});

  @override
  _DeleteTaskState createState() => _DeleteTaskState();
}

class _DeleteTaskState extends State<DeleteTask> {
  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTask();
    Navigator.popAndPushNamed(context, TODOListScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      direction: Axis.vertical,
      spacing: -5,
      runAlignment: WrapAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            size: 30.0,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            buildShowModalBottomSheet(context);
          },
        ),
        Text(
          'Delete',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
        )
      ],
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Color(0xFF353535),
      context: context,
      builder: (context) {
        return Container(
          height: 200.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            direction: Axis.vertical,
            children: [
              Text(
                'Delete ${widget.task.status == 1 ? "completed" : "incomplete"} tasks',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
              ),
              Text(
                  'Delete this task "${widget.task.title.split(' ').length > 5 ? '${widget.task.title.split(' ').sublist(0, 6).join(" ")}...' : widget.task.title}"?'),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10.0,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    width: MediaQuery.of(context).size.width / 3.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    width: MediaQuery.of(context).size.width / 3.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: FlatButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () => _delete(),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
