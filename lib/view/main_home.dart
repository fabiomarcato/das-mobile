import 'package:flutter/material.dart';
import '../components/student_tile.dart';
import '../data/student_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final students = {...STUDENTS};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alunos"),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, i) => StudentTile(students.values.elementAt(i)),
      ),
    );
  }
}
