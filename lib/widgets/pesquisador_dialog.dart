import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dialog para definir ou alterar o nome do pesquisador
class PesquisadorDialog extends StatefulWidget {
  final String? nomePesquisadorAtual;
  final Function(String) onNomeSalvo;

  const PesquisadorDialog({
    super.key,
    this.nomePesquisadorAtual,
    required this.onNomeSalvo,
  });

  @override
  State<PesquisadorDialog> createState() => _PesquisadorDialogState();
}

class _PesquisadorDialogState extends State<PesquisadorDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nomePesquisadorAtual ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _salvarNome() async {
    if (_formKey.currentState!.validate()) {
      final nome = _controller.text.trim();
      
      // Salvar no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nome_pesquisador', nome);
      
      widget.onNomeSalvo(nome);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Identificação do Pesquisador',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quem está realizando a pesquisa?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome do Pesquisador',
                hintText: 'Digite seu nome completo',
                prefixIcon: Icon(Icons.person, color: Colors.red),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, informe o nome do pesquisador';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        if (widget.nomePesquisadorAtual != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ElevatedButton.icon(
          onPressed: _salvarNome,
          icon: const Icon(Icons.check),
          label: const Text('Confirmar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Função utilitária para mostrar o dialog do pesquisador
Future<void> mostrarDialogPesquisador(
  BuildContext context, {
  String? nomePesquisadorAtual,
  required Function(String) onNomeSalvo,
  bool dismissible = true,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) => WillPopScope(
      onWillPop: () async => dismissible,
      child: PesquisadorDialog(
        nomePesquisadorAtual: nomePesquisadorAtual,
        onNomeSalvo: onNomeSalvo,
      ),
    ),
  );
}
