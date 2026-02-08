import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/database_helper.dart';
import '../models/pesquisa.dart';

/// Tela do formulário de pesquisa
class FormularioScreen extends StatefulWidget {
  final String nomePesquisador;
  final Pesquisa? pesquisaParaEditar;

  const FormularioScreen({
    super.key,
    required this.nomePesquisador,
    this.pesquisaParaEditar,
  });

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _salvando = false;
  bool _capturandoLocalizacao = false;

  // Controladores para campos de texto
  final _p1Controller = TextEditingController();
  final _p2Controller = TextEditingController();
  final _p3Controller = TextEditingController();
  final _p6Controller = TextEditingController();
  final _p9Controller = TextEditingController();
  final _p11Controller = TextEditingController();
  final _p12Controller = TextEditingController();
  final _p14Controller = TextEditingController();
  final _p15Controller = TextEditingController();
  final _p17Controller = TextEditingController();
  final _p18Controller = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  // Novos controladores para campos de texto
  final _logradouroController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cepController = TextEditingController();
  final _municipioController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _estadoCivilController = TextEditingController();
  final _corRacaController = TextEditingController();
  final _materialParedesController = TextEditingController();
  final _condicaoMoradiaController = TextEditingController();
  final _qtdComodosController = TextEditingController();
  final _eletricidadeController = TextEditingController();
  final _coletaLixoController = TextEditingController();
  final _coletaFreqController = TextEditingController();
  final _contribuinteRendaController = TextEditingController();
  final _escolaridadeChefeController = TextEditingController();
  final _participaGruposController = TextEditingController();
  final _conheceLiderController = TextEditingController();
  final _liderNomeController = TextEditingController();
  final _liderTelefoneController = TextEditingController();
  final _nomeEntrevistadoController = TextEditingController();

  // Valores para dropdowns e radios
  String? _p4RendaFamiliar;
  String? _p5RecebeBeneficio;
  String? _p7AcessoAguaTratada;
  String? _p10ProblemasSaude;
  String? _p13TemReservatorio;
  String? _p16MoradiaPropria;

  // Valores para checkboxes (P8 - Benefícios esperados)
  final Map<String, bool> _p8Beneficios = {
    'Água de qualidade': false,
    'Economia financeira': false,
    'Melhoria na saúde': false,
    'Regularização do abastecimento': false,
    'Valorização do imóvel': false,
    'Mais tempo disponível': false,
    'Outros': false,
  };

  // Opções de renda familiar
  final List<String> _opcoesRendaFamiliar = [
    'Até 1 salário mínimo',
    'De 1 a 2 salários mínimos',
    'De 2 a 3 salários mínimos',
    'De 3 a 5 salários mínimos',
    'Acima de 5 salários mínimos',
  ];

  @override
  void initState() {
    super.initState();
    // Se está editando, preenche os campos
    if (widget.pesquisaParaEditar != null) {
      _preencherCampos(widget.pesquisaParaEditar!);
    }
  }

  /// Preenche os campos com dados existentes para edição
  void _preencherCampos(Pesquisa pesquisa) {
    _p1Controller.text = pesquisa.p1QtdPessoas?.toString() ?? '';
    _p2Controller.text = pesquisa.p2QtdCriancas?.toString() ?? '';
    _p3Controller.text = pesquisa.p3QtdIdosos?.toString() ?? '';
    _p4RendaFamiliar = pesquisa.p4RendaFamiliar;
    _p5RecebeBeneficio = pesquisa.p5RecebeBeneficio;
    _p6Controller.text = pesquisa.p6QualBeneficio ?? '';
    _p7AcessoAguaTratada = pesquisa.p7AcessoAguaTratada;
    
    // Preencher checkboxes P8
    if (pesquisa.p8BeneficiosEsperados != null && pesquisa.p8BeneficiosEsperados!.isNotEmpty) {
      final beneficios = pesquisa.p8BeneficiosEsperados!.split(';');
      for (var beneficio in beneficios) {
        if (_p8Beneficios.containsKey(beneficio.trim())) {
          _p8Beneficios[beneficio.trim()] = true;
        }
      }
    }
    
    _p9Controller.text = pesquisa.p9FonteAgua ?? '';
    _p10ProblemasSaude = pesquisa.p10ProblemasSaude;
    _p11Controller.text = pesquisa.p11QuaisProblemas ?? '';
    _p12Controller.text = pesquisa.p12GastoMensalAgua?.toString() ?? '';
    _p13TemReservatorio = pesquisa.p13TemReservatorio;
    _p14Controller.text = pesquisa.p14CapacidadeReservatorio?.toString() ?? '';
    _p15Controller.text = pesquisa.p15TipoMoradia ?? '';
    _p16MoradiaPropria = pesquisa.p16MoradiaPropria;
    _p17Controller.text = pesquisa.p17TempoResidencia?.toString() ?? '';
    _p18Controller.text = pesquisa.p18Observacoes ?? '';
    _latitudeController.text = pesquisa.p19Latitude?.toString() ?? '';
    _longitudeController.text = pesquisa.p20Longitude?.toString() ?? '';

    _logradouroController.text = pesquisa.logradouro ?? '';
    _enderecoController.text = pesquisa.endereco ?? '';
    _numeroController.text = pesquisa.numero ?? '';
    _complementoController.text = pesquisa.complemento ?? '';
    _bairroController.text = pesquisa.bairro ?? '';
    _cepController.text = pesquisa.cep ?? '';
    _municipioController.text = pesquisa.municipio ?? '';
    _emailController.text = pesquisa.email ?? '';
    _telefoneController.text = pesquisa.telefone ?? '';
    _estadoCivilController.text = pesquisa.estadoCivil ?? '';
    _corRacaController.text = pesquisa.corRaca ?? '';
    _materialParedesController.text = pesquisa.materialParedes ?? '';
    _condicaoMoradiaController.text = pesquisa.condicaoMoradia ?? '';
    _qtdComodosController.text = pesquisa.qtdComodos?.toString() ?? '';
    _eletricidadeController.text = pesquisa.eletricidade ?? '';
    _coletaLixoController.text = pesquisa.coletaLixo ?? '';
    _coletaFreqController.text = pesquisa.coletaFreq ?? '';
    _contribuinteRendaController.text = pesquisa.contribuinteRenda ?? '';
    _escolaridadeChefeController.text = pesquisa.escolaridadeChefe ?? '';
    _participaGruposController.text = pesquisa.participaGrupos ?? '';
    _conheceLiderController.text = pesquisa.conheceLider ?? '';
    _liderNomeController.text = pesquisa.liderNome ?? '';
    _liderTelefoneController.text = pesquisa.liderTelefone ?? '';
    _nomeEntrevistadoController.text = pesquisa.nomeEntrevistado ?? ''; 
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _p1Controller.dispose();
    _p2Controller.dispose();
    _p3Controller.dispose();
    _p6Controller.dispose();
    _p9Controller.dispose();
    _p11Controller.dispose();
    _p12Controller.dispose();
    _p14Controller.dispose();
    _p15Controller.dispose();
    _p17Controller.dispose();
    _p18Controller.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _logradouroController.dispose();
    _enderecoController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _municipioController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _estadoCivilController.dispose();
    _corRacaController.dispose();
    _materialParedesController.dispose();
    _condicaoMoradiaController.dispose();
    _qtdComodosController.dispose();
    _eletricidadeController.dispose();
    _coletaLixoController.dispose();
    _coletaFreqController.dispose();
    _contribuinteRendaController.dispose();
    _escolaridadeChefeController.dispose();
    _participaGruposController.dispose();
    _conheceLiderController.dispose();
    _liderNomeController.dispose();
    _liderTelefoneController.dispose();
    _nomeEntrevistadoController.dispose();
    super.dispose();
  }

  /// Captura a localização atual via GPS
  Future<void> _capturarLocalizacao() async {
    setState(() {
      _capturandoLocalizacao = true;
    });

    try {
      // Verificar permissão de localização
      var status = await Permission.location.status;
      
      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permissão negada permanentemente. Ative nas configurações.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Abrir',
                textColor: Colors.white,
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      if (status.isGranted) {
        // Verificar se o serviço de localização está ativo
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Serviço de localização desativado. Por favor, ative o GPS.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        // Obter posição atual
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 30),
        );

        setState(() {
          _latitudeController.text = position.latitude.toStringAsFixed(8);
          _longitudeController.text = position.longitude.toStringAsFixed(8);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Localização capturada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permissão de localização negada.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar localização: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _capturandoLocalizacao = false;
      });
    }
  }

  /// Salva a pesquisa no banco de dados
  Future<void> _salvarPesquisa() async {
    setState(() {
      _salvando = true;
    });

    try {
      // Monta a string de benefícios selecionados
      List<String> beneficiosSelecionados = [];
      _p8Beneficios.forEach((key, value) {
        if (value) {
          beneficiosSelecionados.add(key);
        }
      });

      // Cria o objeto Pesquisa
      final pesquisa = Pesquisa(
        id: widget.pesquisaParaEditar?.id,
        pesquisador: widget.nomePesquisador,
        dataPesquisa: widget.pesquisaParaEditar?.dataPesquisa ?? 
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        p1QtdPessoas: int.tryParse(_p1Controller.text),
        p2QtdCriancas: int.tryParse(_p2Controller.text),
        p3QtdIdosos: int.tryParse(_p3Controller.text),
        p4RendaFamiliar: _p4RendaFamiliar,
        p5RecebeBeneficio: _p5RecebeBeneficio,
        p6QualBeneficio: _p6Controller.text.isEmpty ? null : _p6Controller.text,
        p7AcessoAguaTratada: _p7AcessoAguaTratada,
        p8BeneficiosEsperados: beneficiosSelecionados.isEmpty 
            ? null 
            : beneficiosSelecionados.join(';'),
        p9FonteAgua: _p9Controller.text.isEmpty ? null : _p9Controller.text,
        p10ProblemasSaude: _p10ProblemasSaude,
        p11QuaisProblemas: _p11Controller.text.isEmpty ? null : _p11Controller.text,
        p12GastoMensalAgua: double.tryParse(_p12Controller.text.replaceAll(',', '.')),
        p13TemReservatorio: _p13TemReservatorio,
        p14CapacidadeReservatorio: int.tryParse(_p14Controller.text),
        p15TipoMoradia: _p15Controller.text.isEmpty ? null : _p15Controller.text,
        p16MoradiaPropria: _p16MoradiaPropria,
        p17TempoResidencia: int.tryParse(_p17Controller.text),
        p18Observacoes: _p18Controller.text.isEmpty ? null : _p18Controller.text,
        p19Latitude: double.tryParse(_latitudeController.text),
        p20Longitude: double.tryParse(_longitudeController.text),

        // novos campos
        logradouro: _logradouroController.text.isEmpty ? null : _logradouroController.text,
        endereco: _enderecoController.text.isEmpty ? null : _enderecoController.text,
        numero: _numeroController.text.isEmpty ? null : _numeroController.text,
        complemento: _complementoController.text.isEmpty ? null : _complementoController.text,
        bairro: _bairroController.text.isEmpty ? null : _bairroController.text,
        cep: _cepController.text.isEmpty ? null : _cepController.text,
        municipio: _municipioController.text.isEmpty ? null : _municipioController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
        estadoCivil: _estadoCivilController.text.isEmpty ? null : _estadoCivilController.text,
        corRaca: _corRacaController.text.isEmpty ? null : _corRacaController.text,
        materialParedes: _materialParedesController.text.isEmpty ? null : _materialParedesController.text,
        condicaoMoradia: _condicaoMoradiaController.text.isEmpty ? null : _condicaoMoradiaController.text,
        qtdComodos: int.tryParse(_qtdComodosController.text),
        eletricidade: _eletricidadeController.text.isEmpty ? null : _eletricidadeController.text,
        coletaLixo: _coletaLixoController.text.isEmpty ? null : _coletaLixoController.text,
        coletaFreq: _coletaFreqController.text.isEmpty ? null : _coletaFreqController.text,
        contribuinteRenda: _contribuinteRendaController.text.isEmpty ? null : _contribuinteRendaController.text,
        escolaridadeChefe: _escolaridadeChefeController.text.isEmpty ? null : _escolaridadeChefeController.text,
        participaGrupos: _participaGruposController.text.isEmpty ? null : _participaGruposController.text,
        conheceLider: _conheceLiderController.text.isEmpty ? null : _conheceLiderController.text,
        liderNome: _liderNomeController.text.isEmpty ? null : _liderNomeController.text,
        liderTelefone: _liderTelefoneController.text.isEmpty ? null : _liderTelefoneController.text,
        nomeEntrevistado: _nomeEntrevistadoController.text.isEmpty ? null : _nomeEntrevistadoController.text,
      );

      // Salva ou atualiza no banco
      if (widget.pesquisaParaEditar != null) {
        await DatabaseHelper.instance.update(pesquisa);
      } else {
        await DatabaseHelper.instance.insert(pesquisa);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.pesquisaParaEditar != null 
                ? 'Pesquisa atualizada com sucesso!' 
                : 'Pesquisa salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Se for nova pesquisa, limpa o formulário
        if (widget.pesquisaParaEditar == null) {
          _limparFormulario();
        } else {
          // Se for edição, volta para a tela anterior
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar pesquisa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _salvando = false;
      });
    }
  }

  /// Limpa todos os campos do formulário
  void _limparFormulario() {
    _p1Controller.clear();
    _p2Controller.clear();
    _p3Controller.clear();
    _p6Controller.clear();
    _p9Controller.clear();
    _p11Controller.clear();
    _p12Controller.clear();
    _p14Controller.clear();
    _p15Controller.clear();
    _p17Controller.clear();
    _p18Controller.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    _logradouroController.clear();
    _enderecoController.clear();
    _numeroController.clear();
    _complementoController.clear();
    _bairroController.clear();
    _cepController.clear();
    _municipioController.clear();
    _emailController.clear();
    _telefoneController.clear();
    _estadoCivilController.clear();
    _corRacaController.clear();
    _materialParedesController.clear();
    _condicaoMoradiaController.clear();
    _qtdComodosController.clear();
    _eletricidadeController.clear();
    _coletaLixoController.clear();
    _coletaFreqController.clear();
    _contribuinteRendaController.clear();
    _escolaridadeChefeController.clear();
    _participaGruposController.clear();
    _conheceLiderController.clear();
    _liderNomeController.clear();
    _liderTelefoneController.clear();
    _nomeEntrevistadoController.clear();

    setState(() {
      _p4RendaFamiliar = null;
      _p5RecebeBeneficio = null;
      _p7AcessoAguaTratada = null;
      _p10ProblemasSaude = null;
      _p13TemReservatorio = null;
      _p16MoradiaPropria = null;
      _p8Beneficios.updateAll((key, value) => false);
    });

    // Volta ao topo do formulário
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget sectionCard({
      required IconData icon,
      required String title,
      required List<Widget> children,
    }) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho
              Card(
                color: Colors.red.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.pesquisaParaEditar != null ? 'Editando Pesquisa' : 'Nova Pesquisa',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pesquisador: ${widget.nomePesquisador}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Text(
                        'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // --- Novas seções com uma coluna só ---

              sectionCard(
                icon: Icons.person,
                title: 'Dados da localidade',
                children: [
                  _buildTextField(controller: _logradouroController, hintText: 'Logradouro'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _enderecoController, hintText: 'Endereço'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _numeroController, hintText: 'Número'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _complementoController, hintText: 'Complemento'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _bairroController, hintText: 'Bairro'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _cepController, hintText: 'CEP'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _municipioController, hintText: 'Município'),
                ],
              ),

              sectionCard(
                icon: Icons.contact_mail,
                title: 'Contato do Entrevistado',
                children: [
                  _buildTextField(controller: _nomeEntrevistadoController, hintText: 'Nome completo do entrevistado'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _emailController, hintText: 'E-mail'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _telefoneController, hintText: 'Telefone'),
                ],
              ),

              sectionCard(
                icon: Icons.account_circle,
                title: 'Perfil',
                children: [
                  _buildTextField(controller: _estadoCivilController, hintText: 'Estado Civil'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _corRacaController, hintText: 'Cor/Raça'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _escolaridadeChefeController, hintText: 'Escolaridade do chefe da família'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _contribuinteRendaController, hintText: 'Quem contribui mais para a renda'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _participaGruposController, hintText: 'Participa de grupos comunitários?'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _conheceLiderController, hintText: 'Conhece o líder comunitário?'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _liderNomeController, hintText: 'Nome do líder comunitário'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _liderTelefoneController, hintText: 'Telefone do líder comunitário'),
                ],
              ),

              sectionCard(
                icon: Icons.home,
                title: 'Moradia',
                children: [
                  _buildTextField(controller: _materialParedesController, hintText: 'Material das paredes'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _condicaoMoradiaController, hintText: 'Condição da moradia'),
                  const SizedBox(height: 12),
                  _buildNumericField(controller: _qtdComodosController, hintText: 'Quantidade de cômodos'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _eletricidadeController, hintText: 'Eletricidade (Sim / Regular / Irregular / Não)'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _coletaLixoController, hintText: 'Coleta de lixo (Sim/Não)'),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _coletaFreqController, hintText: 'Frequência da coleta de lixo'),
                ],
              ),

              const SizedBox(height: 8),

              // --- Campos originais P1 a P18 ---
              _buildSectionTitle('1. Quantas pessoas moram na residência?'),
              _buildNumericField(controller: _p1Controller, hintText: 'Ex: 4'),
              const SizedBox(height: 14),

              _buildSectionTitle('2. Quantas crianças (0-12 anos)?'),
              _buildNumericField(controller: _p2Controller, hintText: 'Ex: 2'),
              const SizedBox(height: 14),

              _buildSectionTitle('3. Quantos idosos (60+ anos)?'),
              _buildNumericField(controller: _p3Controller, hintText: 'Ex: 1'),
              const SizedBox(height: 14),

              _buildSectionTitle('4. Qual a renda familiar mensal?'),
              _buildDropdownField(
                value: _p4RendaFamiliar,
                items: _opcoesRendaFamiliar,
                hintText: 'Selecione a faixa de renda',
                onChanged: (value) => setState(() => _p4RendaFamiliar = value),
              ),
              const SizedBox(height: 14),

              _buildSectionTitle('5. Recebe algum benefício social?'),
              _buildRadioSimNao(
                value: _p5RecebeBeneficio,
                onChanged: (value) => setState(() => _p5RecebeBeneficio = value),
              ),
              const SizedBox(height: 14),

              _buildSectionTitle('6. Qual benefício recebe?'),
              _buildTextField(controller: _p6Controller, hintText: 'Ex: Bolsa Família, BPC, etc.'),
              const SizedBox(height: 14),

              _buildSectionTitle('7. Tem acesso à água tratada?'),
              _buildRadioSimNao(
                value: _p7AcessoAguaTratada,
                onChanged: (value) => setState(() => _p7AcessoAguaTratada = value),
              ),
              const SizedBox(height: 14),

              _buildSectionTitle('8. Quais benefícios espera do programa? (múltipla escolha)'),
              _buildCheckboxList(),
              const SizedBox(height: 14),

              _buildSectionTitle('9. Qual a principal fonte de água atual?'),
              _buildTextField(controller: _p9Controller, hintText: 'Ex: Poço, cisterna, rio, carro-pipa...'),
              const SizedBox(height: 14),

              _buildSectionTitle('10. Já teve problemas de saúde relacionados à água?'),
              _buildRadioSimNao(
                value: _p10ProblemasSaude,
                onChanged: (value) => setState(() => _p10ProblemasSaude = value),
              ),
              const SizedBox(height: 14),

              _buildSectionTitle('11. Quais problemas de saúde?'),
              _buildTextField(controller: _p11Controller, hintText: 'Ex: Diarreia, vômito, problemas de pele...', maxLines: 2),
              const SizedBox(height: 14),

              _buildSectionTitle('12. Quanto gasta mensalmente com água? (R\$)'),
              _buildNumericField(controller: _p12Controller, hintText: 'Ex: 50.00', decimal: true),
              const SizedBox(height: 14),

              _buildSectionTitle('13. Tem reservatório de água?'),
              _buildRadioSimNao(
                value: _p13TemReservatorio,
                onChanged: (value) => setState(() => _p13TemReservatorio = value),
              ),
              const SizedBox(height: 14),

              _buildSectionTitle('14. Capacidade do reservatório (litros)?'),
              _buildNumericField(controller: _p14Controller, hintText: 'Ex: 1000'),
              const SizedBox(height: 14),

              _buildSectionTitle('15. Qual o tipo de moradia?'),
              _buildTextField(controller: _p15Controller, hintText: 'Ex: Casa de alvenaria, madeira, mista...'),
              const SizedBox(height: 14),

              _buildSectionTitle('16. A moradia é própria?'),
              _buildRadioSimNao(
                value: _p16MoradiaPropria,
                onChanged: (value) => setState(() => _p16MoradiaPropria = value),
              ),
              const SizedBox(height: 14),

              _buildSectionTitle('17. Há quanto tempo reside no local? (anos)'),
              _buildNumericField(controller: _p17Controller, hintText: 'Ex: 5'),
              const SizedBox(height: 14),

              _buildSectionTitle('18. Observações adicionais'),
              _buildTextField(controller: _p18Controller, hintText: 'Informações complementares...', maxLines: 4),
              const SizedBox(height: 18),

              // Localização GPS
              _buildSectionTitle('19-20. Localização (GPS)'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latitudeController,
                              decoration: const InputDecoration(
                                labelText: 'Latitude',
                                hintText: '-23.12345678',
                                prefixIcon: Icon(Icons.location_on, color: Colors.red),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _longitudeController,
                              decoration: const InputDecoration(
                                labelText: 'Longitude',
                                hintText: '-46.12345678',
                                prefixIcon: Icon(Icons.location_on, color: Colors.red),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _capturandoLocalizacao ? null : _capturarLocalizacao,
                          icon: _capturandoLocalizacao
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.my_location),
                          label: Text(_capturandoLocalizacao ? 'Capturando...' : 'Capturar Localização'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _salvarPesquisa,
                  icon: _salvando
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save, size: 28),
                  label: Text(
                    _salvando ? 'Salvando...' : (widget.pesquisaParaEditar != null ? 'Atualizar Pesquisa' : 'Salvar Pesquisa'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                ),
              ),

              // Botão Limpar (apenas para nova pesquisa)
              if (widget.pesquisaParaEditar == null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _limparFormulario,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Limpar Formulário'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o título de uma seção
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        // Exemplo simples: campo obrigatório se hintText não for nulo
        if (value == null || value.trim().isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    String? hintText,
    bool decimal = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: decimal,
        signed: false,
      ),
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Campo obrigatório';
        }
        final number = decimal ? double.tryParse(value.replaceAll(',', '.')) : int.tryParse(value);
        if (number == null) {
          return 'Número inválido';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hintText,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione uma opção';
        }
        return null;
      },
    );
  }

  Widget _buildRadioSimNao({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Sim'),
            value: 'Sim',
            groupValue: value,
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Não'),
            value: 'Não',
            groupValue: value,
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxList() {
    return Column(
      children: _p8Beneficios.entries.map((entry) {
        return CheckboxListTile(
          title: Text(entry.key),
          value: entry.value,
          onChanged: (bool? checked) {
            setState(() {
              _p8Beneficios[entry.key] = checked ?? false;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
