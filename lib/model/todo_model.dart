import 'package:flutter/material.dart';

class Autogenerated {
  List<Todos>? todos;
  int? total;
  int? skip;
  int? limit;

  Autogenerated({this.todos, this.total, this.skip, this.limit});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = <Todos>[];
      json['todos'].forEach((v) {
        todos!.add(Todos.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todos != null) {
      data['todos'] = todos!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class Todos {
  String? id;
  String? todo;
  bool? completed;
  int? userId;
  DateTime? dueDate;
  TimeOfDay? dueTime;

  Todos({this.id, this.todo, this.completed, this.userId, this.dueDate, this.dueTime});

  Todos.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    todo = json['todo'];
    completed = json['completed'];
    userId = json['userId'];
    dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null;
    dueTime = json['dueTime'] != null ? TimeOfDay.fromDateTime(DateTime.parse(json['dueTime'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['todo'] = todo;
    data['completed'] = completed;
    data['userId'] = userId;
    data['dueDate'] = dueDate?.toIso8601String();
    data['dueTime'] = dueTime != null ? '${dueTime!.hour}:${dueTime!.minute}' : null;

    return data;
  }
}
