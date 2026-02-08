import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/pesquisador_dialog.dart';
import 'formulario_screen.dart';
import 'lista_pesquisas_screen.dart';

/// Tela principal com navegação por abas
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _nomePesquisador;
  bool _carregouPesquisador = false;

  @override
  void initState() {
    super.initState();
    _carregarPesquisador();
  }

  /// Carrega o nome do pesquisador salvo nas preferências
  Future<void> _carregarPesquisador() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('nome_pesquisador');
    
    setState(() {
      _nomePesquisador = nome;
      _carregouPesquisador = true;
    });

    // Se não há pesquisador cadastrado, mostra o dialog
    if (nome == null || nome.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarDialogPesquisador(dismissible: false);
      });
    }
  }

  /// Mostra o dialog para definir/alterar o pesquisador
  void _mostrarDialogPesquisador({bool dismissible = true}) {
    mostrarDialogPesquisador(
      context,
      nomePesquisadorAtual: _nomePesquisador,
      dismissible: dismissible,
      onNomeSalvo: (nome) {
        setState(() {
          _nomePesquisador = nome;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesquisador definido: $nome'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  /// Lista de telas para navegação
  List<Widget> get _screens => [
    FormularioScreen(nomePesquisador: _nomePesquisador ?? ''),
    const ListaPesquisasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Mostra loading enquanto carrega o pesquisador
    if (!_carregouPesquisador) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programa Água Legal'),
        actions: [
          // Botão para alterar pesquisador
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Alterar Pesquisador',
            onPressed: () => _mostrarDialogPesquisador(),
          ),
          // Menu popup com informações
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'pesquisador') {
                _mostrarDialogPesquisador();
              } else if (value == 'sobre') {
                _mostrarSobre();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pesquisador',
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.red),
                  title: const Text('Alterar Pesquisador'),
                  subtitle: Text(_nomePesquisador ?? 'Não definido'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'sobre',
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.red),
                  title: Text('Sobre o App'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            activeIcon: Icon(Icons.edit_note, size: 28),
            label: 'Nova Pesquisa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            activeIcon: Icon(Icons.list_alt, size: 28),
            label: 'Pesquisas Salvas',
          ),
        ],
      ),
    );
  }

  /// Mostra informações sobre o aplicativo
  void _mostrarSobre() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.water_drop, color: Colors.blue),
            SizedBox(width: 8),
            Text('Programa Água Legal'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aplicativo de coleta de dados socioeconômicos para o Programa Água Legal.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Versão: 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
