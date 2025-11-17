import '../../util/validar.dart';
import '../firestore_model.dart';
import 'atividade.dart';
import 'avaliacao.dart';

class Disciplina extends FirestoreModel{
  final String professorId;
  final List<String> alunosIds;
  final String nome;
  final String turma;
  final String instituicaoId;

  Disciplina( {
    String? id,
    required this.professorId,
    List<String>? alunosIds,
    required String nome,
    required  String turma,
    required this.instituicaoId,
  })  : nome = Validar.nomeDisciplina(nome),
        turma = Validar.turma(turma),
        alunosIds = alunosIds ?? [], super(id: id);
  @override
  Map<String, dynamic> toMap(){
    return {
      'professorId': professorId,
      'alunosIds': alunosIds,
      'nome': nome,
      'turma': turma,
      'instituicao': instituicaoId,
    };
  }
  factory Disciplina.fromMap(String id, Map<String, dynamic> map){
    return Disciplina(
      id: id,
      professorId: map['professorId'] ?? '',
      alunosIds: List<String>.from(map['alunosIds'] ?? []),
      nome: map['nome'] ?? '',
      turma: map['turma'] ?? 0,
      instituicaoId: map['instituicao'] ?? '',
    );
  }
}