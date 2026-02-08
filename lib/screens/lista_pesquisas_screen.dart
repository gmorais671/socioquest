import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/pesquisa.dart';
import '../utils/export_helper.dart';
import 'detalhe_pesquisa_screen.dart';

/// Tela de listagem de pesquisas salvas
class ListaPesquisasScreen extends StatefulWidget {
  const ListaPesquisasScreen({super.key});

  @override
  State<ListaPesquisasScreen> createState() => _ListaPesquisasScreenState();
}

class _ListaPesquisasScreenState extends State<ListaPesquisasScreen> {
  List<Pesquisa> _pesquisas = [];
  bool _carregando = true;
  bool _exportando = false;

  @override
  void initState() {
    super.initState();
    _carregarPesquisas();
  }

  /// Carrega todas as pesquisas do banco de dados
  Future<void> _carregarPesquisas() async {
    setState(() {
      _carregando = true;
    });

    try {
      final pesquisas = await DatabaseHelper.instance.getAll();
      setState(() {
        _pesquisas = pesquisas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar pesquisas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Exporta todas as pesquisas para XLSX
  Future<void> _exportarTudo() async {
    if (_pesquisas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há pesquisas para exportar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _exportando = true;
    });

    try {
      await ExportHelper.exportarParaXlsx(_pesquisas, context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _exportando = false;
      });
    }
  }

  /// Abre a tela de detalhes da pesquisa
  Future<void> _abrirDetalhe(Pesquisa pesquisa) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhePesquisaScreen(pesquisa: pesquisa),
      ),
    );

    // Se houve alteração, recarrega a lista
    if (resultado == true) {
      _carregarPesquisas();
    }
  }

  /// Exclui uma pesquisa com confirmação
  Future<void> _excluirPesquisa(Pesquisa pesquisa) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Deseja realmente excluir a pesquisa #${pesquisa.id}?\n\nEsta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true && pesquisa.id != null) {
      try {
        await DatabaseHelper.instance.delete(pesquisa.id!);
        _carregarPesquisas();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pesquisa excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir pesquisa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Formata a data para exibição
  String _formatarData(String? dataString) {
    if (dataString == null || dataString.isEmpty) {
      return 'Data não informada';
    }
    try {
      final data = DateTime.parse(dataString);
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    } catch (e) {
      return dataString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de ações
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade100,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_pesquisas.length} pesquisa${_pesquisas.length != 1 ? 's' : ''} salva${_pesquisas.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _exportando || _pesquisas.isEmpty ? null : _exportarTudo,
                icon: _exportando 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.file_download),
                label: Text(_exportando ? 'Exportando...' : 'Exportar Tudo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Lista de pesquisas
        Expanded(
          child: _carregando
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                )
              : _pesquisas.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _carregarPesquisas,
                      color: Colors.red,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _pesquisas.length,
                        itemBuilder: (context, index) {
                          final pesquisa = _pesquisas[index];
                          return _buildPesquisaCard(pesquisa);
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  /// Widget para estado vazio
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma pesquisa cadastrada',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use a aba "Nova Pesquisa" para\nadicionar uma pesquisa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// Card para exibir uma pesquisa
  Widget _buildPesquisaCard(Pesquisa pesquisa) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _abrirDetalhe(pesquisa),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${pesquisa.id}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pesquisa.pesquisador ?? 'Pesquisador não informado',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatarData(pesquisa.dataPesquisa),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu de ações
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'editar') {
                        _abrirDetalhe(pesquisa);
                      } else if (value == 'excluir') {
                        _excluirPesquisa(pesquisa);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Colors.blue),
                          title: Text('Editar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'excluir',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Excluir'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              // Informações resumidas
              Row(
                children: [
                  _buildInfoChip(
                    Icons.people,
                    '${pesquisa.p1QtdPessoas ?? '-'} pessoas',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.water_drop,
                    pesquisa.p7AcessoAguaTratada == 'Sim' 
                        ? 'Com água tratada' 
                        : pesquisa.p7AcessoAguaTratada == 'Não'
                            ? 'Sem água tratada'
                            : 'Água: -',
                  ),
                ],
              ),
              if (pesquisa.p19Latitude != null && pesquisa.p20Longitude != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'GPS: ${pesquisa.p19Latitude!.toStringAsFixed(4)}, ${pesquisa.p20Longitude!.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Chip de informação
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
