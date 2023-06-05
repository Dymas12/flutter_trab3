import 'package:flutter/material.dart';
import '../../model/disciplina.dart';
import '../../persistence/disciplina_arquivo.dart';

class HomePage extends StatefulWidget {
  final DisciplinaArquivo disciplinaArquivo;

  const HomePage({Key? key, required this.disciplinaArquivo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController cargaHorariaController = TextEditingController();
  final List<Disciplina> disciplinas = [];

  @override
  void initState() {
    super.initState();
    widget.disciplinaArquivo.criarArquivo();
    _carregarDisciplinas();
  }

  Future<void> _carregarDisciplinas() async {
    final disciplinas = await widget.disciplinaArquivo.lerDisciplinas();
    setState(() {
      this.disciplinas.clear();
      this.disciplinas.addAll(disciplinas);
    });

    // Log das disciplinas lidas
    print('Disciplinas carregadas: $disciplinas');
  }

  Future<void> _gravarDisciplina() async {
    final codigo = int.tryParse(codigoController.text);
    final descricao = descricaoController.text;
    final cargaHoraria = int.tryParse(cargaHorariaController.text);

    if (codigo != null && descricao.isNotEmpty && cargaHoraria != null) {
      final disciplina = Disciplina(codigo, descricao, cargaHoraria);
      await widget.disciplinaArquivo.gravarDisciplina(disciplina);

      setState(() {
        disciplinas.add(disciplina);
      });

      codigoController.clear();
      descricaoController.clear();
      cargaHorariaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disciplina cadastrada com sucesso'),
        ),
      );

      print('Payload: ${disciplina.toJson()}');
    }
  }

  Future<void> _excluirDisciplina(Disciplina disciplina) async {
    await widget.disciplinaArquivo.excluirDisciplina(disciplina);
    setState(() {
      disciplinas.remove(disciplina);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Disciplina excluída com sucesso'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disciplinas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: disciplinas.length,
              itemBuilder: (context, index) {
                final disciplina = disciplinas[index];

                // Formatação da carga horária
                final cargaHorariaRelogio = (disciplina.cargaHoraria / 60).toStringAsFixed(0);
                final cargaHorariaFormatada = '${disciplina.cargaHoraria} h/a - $cargaHorariaRelogio h';

                return ListTile(
                  title: Text(disciplina.descricao),
                  subtitle: Text(cargaHorariaFormatada),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _excluirDisciplina(disciplina),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: codigoController,
                  decoration: InputDecoration(labelText: 'Código'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: cargaHorariaController,
                  decoration: InputDecoration(labelText: 'Carga Horária'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _gravarDisciplina,
                  child: Text('Cadastrar Disciplina'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
