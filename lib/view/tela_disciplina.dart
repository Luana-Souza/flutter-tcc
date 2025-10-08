

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/disciplinas/atividade.dart';
import '../models/disciplinas/avaliacao.dart';
import '../models/disciplinas/disciplina.dart';

class TelaDisciplina extends StatelessWidget {
  final Disciplina disciplina;

  TelaDisciplina({super.key, required this.disciplina});

  final List<String> alunosIds = [
    '001',
    '002',
    '003',
    '004',
  ];

  final List<Atividade> listaAtividades = [
    //faça pelo menos duas atividades
    Atividade(
      id: '00',
      nome: 'Atividade 01',
      descricao: 'Entregar o trabalho de matemática',
      prazoDeEntrega: Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      prazoEntregada: null,
      creditoMinimo: 10,
      creditoMaximo: 20,
      credito: 15,
    ),
    Atividade(
      id: '01',
      nome: 'Atividade 02',
      descricao: 'Entregar o trabalho de português',
      prazoDeEntrega: Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      prazoEntregada: null,
      creditoMinimo: 10,
      creditoMaximo: 20,
      credito: 15,
    )

  ];
  final List<Avaliacao> listAvaliacoes = [
    Avaliacao(
      id: '001',
      nome: 'Prova 01',
      sigla: 'P01',
      data: Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      pontuacao: null,
    ),
    Avaliacao(
      id: '002',
      nome: 'Prova 02',
      sigla: 'P02',
      data: Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      pontuacao: null,
    )

  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Column(children: [
            Text(disciplina.nome,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
            Text(" Turma - ${disciplina.turma.toString()}",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
          ),
          backgroundColor: Color(0xFF0A6D92),
          centerTitle: true,
          toolbarHeight: 65,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ListView(
              children:[
                ElevatedButton(
                  onPressed: () {},
                  child:  Text("Meus alunos"),
                ),
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Divider(color: Colors.black),
                ),
                Center(
                  child: Text(
                    "Atividades",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(listaAtividades.length, (index){
                    Atividade atividade = listaAtividades[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.assignment),
                      title: Text(atividade.nome) ,
                      subtitle: Text('${atividade.descricao} \n'
                          'Data de Entrega: ${atividade.prazoDeEntrega.toDate().toLocal().toString().split(' ')[0]}'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print('Atividade excluída: ${atividade.nome}');
                        },
                      ),
                      onTap: () {
                        print('Atividade selecionada: ${atividade.nome}');
                      },
                    );
                  }),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print("CRIAR ATIVIDADE");

                  },
                  icon: Icon(Icons.add),
                  label: Text("Nova Atividade"),
                ),
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Divider(color: Colors.black),
                ),
                Center(
                  child: Text(
                    "Avaliações",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(listAvaliacoes.length, (index){
                    Avaliacao avaliacao  = listAvaliacoes[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.description),
                      title: Text(avaliacao.nome) ,
                      subtitle: Text('${avaliacao.data.toDate().toLocal().toString().split(' ')[0]}'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print('Atividade excluída: ${avaliacao.nome}');
                        },
                      ),
                      onTap: () {
                        print('Atividade selecionada: ${avaliacao.nome}');
                      },
                    );
                  }),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print("CRIAR AVALIAÇÃO");

                  },
                  icon: Icon(Icons.add),
                  label: Text("Nova Avaliação"),
                ),
              ]
          ),
        ));

  }
}