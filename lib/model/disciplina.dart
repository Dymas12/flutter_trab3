class Disciplina {
  final int codigo;
  final String descricao;
  final int cargaHoraria;

  Disciplina(this.codigo, this.descricao, this.cargaHoraria);

  int calcularCargaHorariaRelogio() {
    return cargaHoraria * 60;
  }

  factory Disciplina.fromJson(Map<String, dynamic> json) {
    return Disciplina(
      json['codigo'],
      json['descricao'],
      json['cargaHoraria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'cargaHoraria': cargaHoraria,
    };
  }
}
