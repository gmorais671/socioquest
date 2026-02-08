class Pesquisa {
  int? id;
  String? pesquisador;
  String? dataPesquisa;

  // Campos originais
  int? p1QtdPessoas;
  int? p2QtdCriancas;
  int? p3QtdIdosos;
  String? p4RendaFamiliar;
  String? p5RecebeBeneficio;
  String? p6QualBeneficio;
  String? p7AcessoAguaTratada;
  String? p8BeneficiosEsperados;
  String? p9FonteAgua;
  String? p10ProblemasSaude;
  String? p11QuaisProblemas;
  double? p12GastoMensalAgua;
  String? p13TemReservatorio;
  int? p14CapacidadeReservatorio;
  String? p15TipoMoradia;
  String? p16MoradiaPropria;
  int? p17TempoResidencia;
  String? p18Observacoes;
  double? p19Latitude;
  double? p20Longitude;

  // Novos campos (endereço / contato / perfil / moradia detalhada / participação)
  String? logradouro;
  String? endereco;
  String? numero;
  String? complemento;
  String? bairro;
  String? cep;
  String? municipio;
  String? email;
  String? telefone;
  String? estadoCivil;
  String? corRaca;
  String? materialParedes;
  String? condicaoMoradia;
  int? qtdComodos;
  String? eletricidade; // Sim / Regular / Irregular / Não
  String? coletaLixo; // Sim / Não
  String? coletaFreq; // ex: "2 vezes", "3 vezes"
  String? contribuinteRenda;
  String? escolaridadeChefe;
  String? participaGrupos; // Sim/Não
  String? conheceLider; // Sim/Não
  String? liderNome;
  String? liderTelefone;
  String? nomeEntrevistado;

  Pesquisa({
    this.id,
    this.pesquisador,
    this.dataPesquisa,
    this.p1QtdPessoas,
    this.p2QtdCriancas,
    this.p3QtdIdosos,
    this.p4RendaFamiliar,
    this.p5RecebeBeneficio,
    this.p6QualBeneficio,
    this.p7AcessoAguaTratada,
    this.p8BeneficiosEsperados,
    this.p9FonteAgua,
    this.p10ProblemasSaude,
    this.p11QuaisProblemas,
    this.p12GastoMensalAgua,
    this.p13TemReservatorio,
    this.p14CapacidadeReservatorio,
    this.p15TipoMoradia,
    this.p16MoradiaPropria,
    this.p17TempoResidencia,
    this.p18Observacoes,
    this.p19Latitude,
    this.p20Longitude,
    // novos
    this.logradouro,
    this.endereco,
    this.numero,
    this.complemento,
    this.bairro,
    this.cep,
    this.municipio,
    this.email,
    this.telefone,
    this.estadoCivil,
    this.corRaca,
    this.materialParedes,
    this.condicaoMoradia,
    this.qtdComodos,
    this.eletricidade,
    this.coletaLixo,
    this.coletaFreq,
    this.contribuinteRenda,
    this.escolaridadeChefe,
    this.participaGrupos,
    this.conheceLider,
    this.liderNome,
    this.liderTelefone,
    this.nomeEntrevistado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pesquisador': pesquisador,
      'data_pesquisa': dataPesquisa,
      'p1_qtd_pessoas': p1QtdPessoas,
      'p2_qtd_criancas': p2QtdCriancas,
      'p3_qtd_idosos': p3QtdIdosos,
      'p4_renda_familiar': p4RendaFamiliar,
      'p5_recebe_beneficio': p5RecebeBeneficio,
      'p6_qual_beneficio': p6QualBeneficio,
      'p7_acesso_agua_tratada': p7AcessoAguaTratada,
      'p8_beneficios_esperados': p8BeneficiosEsperados,
      'p9_fonte_agua': p9FonteAgua,
      'p10_problemas_saude': p10ProblemasSaude,
      'p11_quais_problemas': p11QuaisProblemas,
      'p12_gasto_mensal_agua': p12GastoMensalAgua,
      'p13_tem_reservatorio': p13TemReservatorio,
      'p14_capacidade_reservatorio': p14CapacidadeReservatorio,
      'p15_tipo_moradia': p15TipoMoradia,
      'p16_moradia_propria': p16MoradiaPropria,
      'p17_tempo_residencia': p17TempoResidencia,
      'p18_observacoes': p18Observacoes,
      'p19_latitude': p19Latitude,
      'p20_longitude': p20Longitude,
      // novos
      'logradouro': logradouro,
      'endereco': endereco,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cep': cep,
      'municipio': municipio,
      'email': email,
      'telefone': telefone,
      'estado_civil': estadoCivil,
      'cor_raca': corRaca,
      'material_paredes': materialParedes,
      'condicao_moradia': condicaoMoradia,
      'qtd_comodos': qtdComodos,
      'eletricidade': eletricidade,
      'coleta_lixo': coletaLixo,
      'coleta_freq': coletaFreq,
      'contribuinte_renda': contribuinteRenda,
      'escolaridade_chefe': escolaridadeChefe,
      'participa_grupos': participaGrupos,
      'conhece_lider': conheceLider,
      'lider_nome': liderNome,
      'lider_telefone': liderTelefone,
      'nome_entrevistado': nomeEntrevistado,
    };
  }

  factory Pesquisa.fromMap(Map<String, dynamic> map) {
    return Pesquisa(
      id: map['id'] as int?,
      pesquisador: map['pesquisador'] as String?,
      dataPesquisa: map['data_pesquisa'] as String?,
      p1QtdPessoas: map['p1_qtd_pessoas'] as int?,
      p2QtdCriancas: map['p2_qtd_criancas'] as int?,
      p3QtdIdosos: map['p3_qtd_idosos'] as int?,
      p4RendaFamiliar: map['p4_renda_familiar'] as String?,
      p5RecebeBeneficio: map['p5_recebe_beneficio'] as String?,
      p6QualBeneficio: map['p6_qual_beneficio'] as String?,
      p7AcessoAguaTratada: map['p7_acesso_agua_tratada'] as String?,
      p8BeneficiosEsperados: map['p8_beneficios_esperados'] as String?,
      p9FonteAgua: map['p9_fonte_agua'] as String?,
      p10ProblemasSaude: map['p10_problemas_saude'] as String?,
      p11QuaisProblemas: map['p11_quais_problemas'] as String?,
      p12GastoMensalAgua: map['p12_gasto_mensal_agua'] != null
          ? (map['p12_gasto_mensal_agua'] as num).toDouble()
          : null,
      p13TemReservatorio: map['p13_tem_reservatorio'] as String?,
      p14CapacidadeReservatorio: map['p14_capacidade_reservatorio'] as int?,
      p15TipoMoradia: map['p15_tipo_moradia'] as String?,
      p16MoradiaPropria: map['p16_moradia_propria'] as String?,
      p17TempoResidencia: map['p17_tempo_residencia'] as int?,
      p18Observacoes: map['p18_observacoes'] as String?,
      p19Latitude: map['p19_latitude'] != null
          ? (map['p19_latitude'] as num).toDouble()
          : null,
      p20Longitude: map['p20_longitude'] != null
          ? (map['p20_longitude'] as num).toDouble()
          : null,
      // novos
      logradouro: map['logradouro'] as String?,
      endereco: map['endereco'] as String?,
      numero: map['numero'] as String?,
      complemento: map['complemento'] as String?,
      bairro: map['bairro'] as String?,
      cep: map['cep'] as String?,
      municipio: map['municipio'] as String?,
      email: map['email'] as String?,
      telefone: map['telefone'] as String?,
      estadoCivil: map['estado_civil'] as String?,
      corRaca: map['cor_raca'] as String?,
      materialParedes: map['material_paredes'] as String?,
      condicaoMoradia: map['condicao_moradia'] as String?,
      qtdComodos: map['qtd_comodos'] as int?,
      eletricidade: map['eletricidade'] as String?,
      coletaLixo: map['coleta_lixo'] as String?,
      coletaFreq: map['coleta_freq'] as String?,
      contribuinteRenda: map['contribuinte_renda'] as String?,
      escolaridadeChefe: map['escolaridade_chefe'] as String?,
      participaGrupos: map['participa_grupos'] as String?,
      conheceLider: map['conhece_lider'] as String?,
      liderNome: map['lider_nome'] as String?,
      liderTelefone: map['lider_telefone'] as String?,
      nomeEntrevistado: map['nome_entrevistado'] as String?,
    );
  }
}