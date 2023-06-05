import 'package:flutter/material.dart';
import 'persistence/disciplina_arquivo.dart';
import 'view/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DisciplinaArquivo disciplinaArquivo = DisciplinaArquivo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disciplinas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(disciplinaArquivo: disciplinaArquivo),
    );
  }
}
