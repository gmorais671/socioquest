import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/pesquisa.dart';
import 'formulario_screen.dart';

/// Tela de detalhes e edição de uma pesquisa
class DetalhePesquisaScreen extends StatefulWidget {
  final Pesquisa pesquisa;

  const DetalhePesquisaScreen({
    super.key,
    required this.pesquisa,
  });

  @override
  State<DetalhePesquisaScreen> createState() => _DetalhePesquisaScreenState();
}

class _DetalhePesquisaScreenState extends State<DetalhePesquisaScreen> {
  late Pesquisa _pesquisa;

  @override
  void initState() {
    super.initState();
    _pesquisa = widget.pesquisa;
  }

  /// Formata a data para exibição
  String _formatarData(String? dataString) {
    if (dataString == null || dataString.isEmpty) {
      return 'Não informada';
    }
    try {
      final data = DateTime.parse(dataString);
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    } catch (e) {
      return dataString;
    }
  }

  /// Abre a tela de edição
  Future<void> _editarPesquisa() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Editar Pesquisa'),
          ),
          body: FormularioScreen(
            nomePesquisador: _pesquisa.pesquisador ?? '',
            pesquisaParaEditar: _pesquisa,
          ),
        ),
      ),
    );

    if (resultado == true) {
      // Recarrega a pesquisa atualizada
      final pesquisaAtualizada = await DatabaseHelper.instance.getById(_pesquisa.id!);
      if (pesquisaAtualizada != null) {
        setState(() {
          _pesquisa = pesquisaAtualizada;
        });
      }
      // Retorna true para a lista atualizar
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  /// Exclui a pesquisa com confirmação
  Future<void> _excluirPesquisa() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text(
          'Deseja realmente excluir esta pesquisa?\n\nEsta ação não pode ser desfeita.',
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

    if (confirmar == true && _pesquisa.id != null) {
      try {
        await DatabaseHelper.instance.delete(_pesquisa.id!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pesquisa excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisa #${_pesquisa.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: _editarPesquisa,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Excluir',
            onPressed: _excluirPesquisa,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cabeçalho
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#${_pesquisa.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pesquisador',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _pesquisa.pesquisador ?? 'Não informado',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Data: ${_formatarData(_pesquisa.dataPesquisa)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dados da Família
          _buildSection(
            'Dados da Família',
            Icons.family_restroom,
            [
              _buildInfoRow('1. Pessoas na residência', _pesquisa.p1QtdPessoas?.toString()),
              _buildInfoRow('2. Crianças (0-12 anos)', _pesquisa.p2QtdCriancas?.toString()),
              _buildInfoRow('3. Idosos (60+ anos)', _pesquisa.p3QtdIdosos?.toString()),
              _buildInfoRow('4. Renda familiar mensal', _pesquisa.p4RendaFamiliar),
              _buildInfoRow('5. Recebe benefício social', _pesquisa.p5RecebeBeneficio),
              _buildInfoRow('6. Qual benefício', _pesquisa.p6QualBeneficio),
            ],
          ),

          // Acesso à Água
          _buildSection(
            'Acesso à Água',
            Icons.water_drop,
            [
              _buildInfoRow('7. Acesso à água tratada', _pesquisa.p7AcessoAguaTratada),
              _buildInfoRow('8. Benefícios esperados', _pesquisa.p8BeneficiosEsperados?.replaceAll(';', ', ')),
              _buildInfoRow('9. Fonte de água atual', _pesquisa.p9FonteAgua),
              _buildInfoRow('10. Problemas de saúde relacionados', _pesquisa.p10ProblemasSaude),
              _buildInfoRow('11. Quais problemas', _pesquisa.p11QuaisProblemas),
              _buildInfoRow(
                '12. Gasto mensal com água',
                _pesquisa.p12GastoMensalAgua != null
                    ? 'R\$ ${_pesquisa.p12GastoMensalAgua!.toStringAsFixed(2)}'
                    : null,
              ),
              _buildInfoRow('13. Tem reservatório', _pesquisa.p13TemReservatorio),
              _buildInfoRow(
                '14. Capacidade do reservatório',
                _pesquisa.p14CapacidadeReservatorio != null
                    ? '${_pesquisa.p14CapacidadeReservatorio} litros'
                    : null,
              ),
            ],
          ),

          // Moradia
          _buildSection(
            'Moradia',
            Icons.home,
            [
              _buildInfoRow('15. Tipo de moradia', _pesquisa.p15TipoMoradia),
              _buildInfoRow('16. Moradia própria', _pesquisa.p16MoradiaPropria),
              _buildInfoRow(
                '17. Tempo de residência',
                _pesquisa.p17TempoResidencia != null
                    ? '${_pesquisa.p17TempoResidencia} anos'
                    : null,
              ),
            ],
          ),

          // Observações
          _buildSection(
            'Observações',
            Icons.notes,
            [
              _buildInfoRow('18. Observações adicionais', _pesquisa.p18Observacoes),
            ],
          ),

          // Dados do Entrevistado (novos campos)
          _buildSection(
            'Dados do Entrevistado',
            Icons.person,
            [
              _buildInfoRow('Logradouro', _pesquisa.logradouro),
              _buildInfoRow('Endereço', _pesquisa.endereco),
              _buildInfoRow('Número', _pesquisa.numero),
              _buildInfoRow('Complemento', _pesquisa.complemento),
              _buildInfoRow('Bairro', _pesquisa.bairro),
              _buildInfoRow('CEP', _pesquisa.cep),
              _buildInfoRow('Município', _pesquisa.municipio),
            ],
          ),

          // Contato (novos campos)
          _buildSection(
            'Contato',
            Icons.contact_mail,
            [
              _buildInfoRow('E-mail', _pesquisa.email),
              _buildInfoRow('Telefone', _pesquisa.telefone),
            ],
          ),

          // Perfil (novos campos)
          _buildSection(
            'Perfil',
            Icons.account_circle,
            [
              _buildInfoRow('Estado Civil', _pesquisa.estadoCivil),
              _buildInfoRow('Cor/Raça', _pesquisa.corRaca),
              _buildInfoRow('Escolaridade do chefe da família', _pesquisa.escolaridadeChefe),
              _buildInfoRow('Quem contribui mais para a renda', _pesquisa.contribuinteRenda),
              _buildInfoRow('Participa de grupos comunitários?', _pesquisa.participaGrupos),
              _buildInfoRow('Conhece o líder comunitário?', _pesquisa.conheceLider),
              _buildInfoRow('Nome do líder comunitário', _pesquisa.liderNome),
              _buildInfoRow('Telefone do líder comunitário', _pesquisa.liderTelefone),
            ],
          ),

          // Moradia (novos campos)
          _buildSection(
            'Moradia (detalhes)',
            Icons.home,
            [
              _buildInfoRow('Material das paredes', _pesquisa.materialParedes),
              _buildInfoRow('Condição da moradia', _pesquisa.condicaoMoradia),
              _buildInfoRow('Quantidade de cômodos', _pesquisa.qtdComodos?.toString()),
              _buildInfoRow('Eletricidade', _pesquisa.eletricidade),
              _buildInfoRow('Coleta de lixo', _pesquisa.coletaLixo),
              _buildInfoRow('Frequência da coleta de lixo', _pesquisa.coletaFreq),
            ],
          ),

          // Localização
          _buildSection(
            'Localização GPS',
            Icons.location_on,
            [
              _buildInfoRow('Latitude', _pesquisa.p19Latitude?.toString()),
              _buildInfoRow('Longitude', _pesquisa.p20Longitude?.toString()),
            ],
          ),

          const SizedBox(height: 24),

          // Botões de ação
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _excluirPesquisa,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Excluir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _editarPesquisa,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Constrói uma seção de informações
  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  /// Constrói uma linha de informação
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value ?? '-',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: value != null ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}