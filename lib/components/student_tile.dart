import 'package:dasmobile/model/student.dart';
import 'package:flutter/material.dart';

class StudentTile extends StatelessWidget {
  final Student student;

  const StudentTile(this.student);

  @override
  Widget build(BuildContext context) {
    final avatar =
        CircleAvatar(backgroundImage: NetworkImage(student.avatarUrl));
    return ListTile(
      leading: avatar,
      title: Text(student.name),
      subtitle: Text(student.email),
    );
  }
}
