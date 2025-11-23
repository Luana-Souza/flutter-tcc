import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/models/transacao.dart';

class TransacaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarCreditos({
    required String disciplinaId,
    required String alunoId,
    required int quantidade,
    required String descricao,
  }) async {
    try {
      final disciplinaRef = _firestore.collection('disciplinas').doc(disciplinaId);
      final matriculaRef = disciplinaRef.collection('matriculas').doc(alunoId);
      final transacoesRef = disciplinaRef.collection('transacoes');

      final novaTransacao = Transacao(
        alunoId: alunoId,
        disciplinaId: disciplinaId,
        descricao: descricao,
        valor: quantidade,
        tipo: TipoTransacao.ganho,
        data: DateTime.now(),
      );

      final batch = _firestore.batch();

      final docTransacao = transacoesRef.doc();
      batch.set(docTransacao, novaTransacao.toMap());

      batch.set(
        matriculaRef,
        {'saldo': FieldValue.increment(quantidade)},
        SetOptions(merge: true)
      );

      await batch.commit();
      print("Créditos adicionados com sucesso!");

    } catch (e) {
      print("Erro ao adicionar créditos: $e");
      rethrow;
    }
  }

  Future<void> adicionarCreditosEmLote({
    required String disciplinaId,
    required List<String> alunosIds,
    required int quantidade,
    required String descricao,
  }) async {
    try {
      final batch = _firestore.batch();
      final disciplinaRef = _firestore.collection('disciplinas').doc(disciplinaId);

      for (String alunoId in alunosIds) {
        final matriculaRef = disciplinaRef.collection('matriculas').doc(alunoId);
        final transacoesRef = disciplinaRef.collection('transacoes').doc();


        final novaTransacao = Transacao(
          alunoId: alunoId,
          disciplinaId: disciplinaId,
          descricao: descricao,
          valor: quantidade,
          tipo: TipoTransacao.ganho,
          data: DateTime.now(),
        );

        batch.set(transacoesRef, novaTransacao.toMap());
        batch.set(
            matriculaRef,
            {'saldo': FieldValue.increment(quantidade)},
            SetOptions(merge: true)
        );
      }

      await batch.commit();
      print("Lote processado com sucesso: ${alunosIds.length} alunos.");

    } catch (e) {
      print("Erro ao processar lote: $e");
      rethrow;
    }
  }

  Future<bool> gastarCreditos({
    required String disciplinaId,
    required String alunoId,
    required int quantidade,
    required String descricao,
  }) async {
    try {
      final disciplinaRef = _firestore.collection('disciplinas').doc(disciplinaId);
      final matriculaRef = disciplinaRef.collection('matriculas').doc(alunoId);

      return await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(matriculaRef);

        if (!snapshot.exists) return false;

        final dados = snapshot.data() as Map<String, dynamic>;
        final saldoAtual = dados['saldo'] as int? ?? 0;

        if (saldoAtual < quantidade) {
          return false;
        }

        final novaTransacao = Transacao(
          alunoId: alunoId,
          disciplinaId: disciplinaId,
          descricao: descricao,
          valor: quantidade,
          tipo: TipoTransacao.gasto,
          data: DateTime.now(),
        );

        final transacoesRef = disciplinaRef.collection('transacoes').doc();

        transaction.set(transacoesRef, novaTransacao.toMap());
        transaction.update(matriculaRef, {'saldo': FieldValue.increment(-quantidade)});

        return true;
      });

    } catch (e) {
      print("Erro ao gastar créditos: $e");
      return false;
    }
  }

  Future<int> consultarSaldo(String disciplinaId, String alunoId) async {
    try {
      final doc = await _firestore
          .collection('disciplinas')
          .doc(disciplinaId)
          .collection('matriculas')
          .doc(alunoId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['saldo'] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
  // Busca a data que o aluno recebeu o crédito por uma atividade específica
  Future<DateTime?> obterDataConclusaoAtividade({
    required String disciplinaId,
    required String alunoId,
    required String nomeAtividade,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('disciplinas')
          .doc(disciplinaId)
          .collection('transacoes')
          .where('alunoId', isEqualTo: alunoId)
          .orderBy('data', descending: true)
          .get();

      for (var doc in snapshot.docs) {
        final dados = doc.data();
        final descricao = dados['descricao'].toString();

        if (descricao.contains(nomeAtividade)) {
          return (dados['data'] as Timestamp).toDate();
        }
      }
      return null;
    } catch (e) {
      print("Erro ao buscar data da transação: $e");
      return null;
    }
  }


  Future<bool> verificarSeJaRecebeuCredito({
    required String disciplinaId,
    required String alunoId,
    required String nomeAtividade,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('disciplinas')
          .doc(disciplinaId)
          .collection('transacoes')
          .where('alunoId', isEqualTo: alunoId)
          .get();


      for (var doc in snapshot.docs) {
        final dados = doc.data();
        final descricao = dados['descricao'] as String;

        if (descricao.contains(nomeAtividade)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Erro ao verificar duplicidade: $e");
      return false;
    }
  }


  Future<List<Transacao>> buscarHistorico({
    required String disciplinaId,
    required String alunoId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('disciplinas')
          .doc(disciplinaId)
          .collection('transacoes')
          .where('alunoId', isEqualTo: alunoId)
          .orderBy('data', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Transacao.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Erro ao buscar histórico: $e");
      return [];
    }
  }
  Future<bool> verificarCompraExistente({
    required String disciplinaId,
    required String alunoId,
    required String avaliacaoNome,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('disciplinas')
          .doc(disciplinaId)
          .collection('transacoes')
          .where('alunoId', isEqualTo: alunoId)
          .where('tipo', isEqualTo: 1)
          .get();

      final jaComprou = snapshot.docs.any((doc) {
        final data = doc.data();
        final descricao = data['descricao'] as String;
        return descricao.contains(avaliacaoNome);
      });

      return jaComprou;

    } catch (e) {
      print("Erro ao verificar compra: $e");
      return false;
    }
  }
}
