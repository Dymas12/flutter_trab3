import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/disciplina.dart';

class DisciplinaArquivo {
  final String fileName = 'disciplina.json';

  Future<void> criarArquivo() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (!(await file.exists())) {
      await file.create();
      print('Arquivo $fileName criado.');
    }
  }

  Future<void> gravarDisciplina(Disciplina disciplina) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (!(await file.exists())) {
      await file.create();
    }

    final disciplinas = await lerDisciplinas();
    disciplinas.add(disciplina);

    final disciplinasJson = jsonEncode(disciplinas.map((d) => d.toJson()).toList());
    await file.writeAsString(disciplinasJson);

    final disciplinaJson = jsonEncode(disciplina.toJson());
    print('Disciplina gravada: $disciplinaJson');
  }

  Future<List<Disciplina>> lerDisciplinas() async {
    final file = File(fileName);
    if (await file.exists()) {
      final disciplinasJson = await file.readAsString();
      if (disciplinasJson.isNotEmpty) {
        final List<dynamic> disciplinasData = jsonDecode(disciplinasJson);

        final disciplinas = disciplinasData.map((data) {
          return Disciplina(
            data['codigo'],
            data['descricao'],
            data['cargaHoraria'],
          );
        }).toList();

        print('Disciplinas carregadas: $disciplinas');
        return disciplinas;
      }
    }
    print('Disciplinas carregadas: []');
    return [];
  }

  Future<void> excluirDisciplina(Disciplina disciplina) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    final disciplinas = await lerDisciplinas();
    disciplinas.remove(disciplina);

    final disciplinasJson = jsonEncode(disciplinas.map((d) => d.toJson()).toList());
    await file.writeAsString(disciplinasJson);

    print('Disciplina excluída: $disciplina');
  }
}
