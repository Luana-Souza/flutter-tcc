import 'package:flutter/material.dart';

void mostrarDetalhesDialog(BuildContext context, {required String titulo, required Map<String, String> dados}) {
  showDialog(
    context: context,
    builder: (context) => DetalhesDialog(titulo: titulo, dados: dados),
  );
}

class DetalhesDialog extends StatelessWidget {
  final String titulo;
  final Map<String, String> dados;

  const DetalhesDialog({
    super.key,
    required this.titulo,
    required this.dados,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: SingleChildScrollView(
        child: ListBody(
          children: dados.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '${entry.key}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: entry.value,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
