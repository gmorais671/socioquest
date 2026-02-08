import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/pesquisa.dart';

/// Helper para exportação de dados para XLSX
class ExportHelper {
  /// Exporta a lista de pesquisas para um arquivo XLSX e compartilha
  static Future<void> exportarParaXlsx(
    List<Pesquisa> pesquisas,
    BuildContext context,
  ) async {
    try {
      // Criar planilha Excel
      var excel = Excel.createExcel();
      
      // Renomear a planilha padrão
      excel.rename('Sheet1', 'Pesquisas');
      var sheet = excel['Pesquisas'];

      // Definir cabeçalhos
      List<String> cabecalhos = [
        'ID',
        'Pesquisador',
        'Data da Pesquisa',
        'P1 - Qtd Pessoas',
        'P2 - Qtd Crianças',
        'P3 - Qtd Idosos',
        'P4 - Renda Familiar',
        'P5 - Recebe Benefício',
        'P6 - Qual Benefício',
        'P7 - Acesso Água Tratada',
        'P8 - Benefícios Esperados',
        'P9 - Fonte de Água',
        'P10 - Problemas Saúde',
        'P11 - Quais Problemas',
        'P12 - Gasto Mensal Água',
        'P13 - Tem Reservatório',
        'P14 - Capacidade Reservatório',
        'P15 - Tipo Moradia',
        'P16 - Moradia Própria',
        'P17 - Tempo Residência',
        'P18 - Observações',
        'P19 - Latitude',
        'P20 - Longitude',
        // Novos campos
        'Logradouro',
        'Endereço',
        'Número',
        'Complemento',
        'Bairro',
        'CEP',
        'Município',
        'E-mail',
        'Telefone',
        'Estado Civil',
        'Cor/Raça',
        'Material das Paredes',
        'Condição da Moradia',
        'Qtd Cômodos',
        'Eletricidade',
        'Coleta de Lixo',
        'Frequência da Coleta',
        'Contribuinte da Renda',
        'Escolaridade do Chefe',
        'Participa de Grupos',
        'Conhece Líder',
        'Nome do Líder',
        'Telefone do Líder',
        'Nome do Entrevistado',
      ];

      // Estilo para o cabeçalho
      CellStyle headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#cd9494'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        horizontalAlign: HorizontalAlign.Center,
      );

      // Adicionar cabeçalhos
      for (int i = 0; i < cabecalhos.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(cabecalhos[i]);
        cell.cellStyle = headerStyle;
      }

      // Adicionar dados
      for (int rowIndex = 0; rowIndex < pesquisas.length; rowIndex++) {
        final pesquisa = pesquisas[rowIndex];
        final row = rowIndex + 1; // +1 porque a linha 0 é o cabeçalho

        List<dynamic> valores = [
          pesquisa.id?.toString() ?? '',
          pesquisa.pesquisador ?? '',
          _formatarData(pesquisa.dataPesquisa),
          pesquisa.p1QtdPessoas?.toString() ?? '',
          pesquisa.p2QtdCriancas?.toString() ?? '',
          pesquisa.p3QtdIdosos?.toString() ?? '',
          pesquisa.p4RendaFamiliar ?? '',
          pesquisa.p5RecebeBeneficio ?? '',
          pesquisa.p6QualBeneficio ?? '',
          pesquisa.p7AcessoAguaTratada ?? '',
          pesquisa.p8BeneficiosEsperados?.replaceAll(';', ', ') ?? '',
          pesquisa.p9FonteAgua ?? '',
          pesquisa.p10ProblemasSaude ?? '',
          pesquisa.p11QuaisProblemas ?? '',
          pesquisa.p12GastoMensalAgua?.toStringAsFixed(2) ?? '',
          pesquisa.p13TemReservatorio ?? '',
          pesquisa.p14CapacidadeReservatorio?.toString() ?? '',
          pesquisa.p15TipoMoradia ?? '',
          pesquisa.p16MoradiaPropria ?? '',
          pesquisa.p17TempoResidencia?.toString() ?? '',
          pesquisa.p18Observacoes ?? '',
          pesquisa.p19Latitude?.toString() ?? '',
          pesquisa.p20Longitude?.toString() ?? '',
          // Novos campos
          pesquisa.logradouro ?? '',
          pesquisa.endereco ?? '',
          pesquisa.numero ?? '',
          pesquisa.complemento ?? '',
          pesquisa.bairro ?? '',
          pesquisa.cep ?? '',
          pesquisa.municipio ?? '',
          pesquisa.email ?? '',
          pesquisa.telefone ?? '',
          pesquisa.estadoCivil ?? '',
          pesquisa.corRaca ?? '',
          pesquisa.materialParedes ?? '',
          pesquisa.condicaoMoradia ?? '',
          pesquisa.qtdComodos?.toString() ?? '',
          pesquisa.eletricidade ?? '',
          pesquisa.coletaLixo ?? '',
          pesquisa.coletaFreq ?? '',
          pesquisa.contribuinteRenda ?? '',
          pesquisa.escolaridadeChefe ?? '',
          pesquisa.participaGrupos ?? '',
          pesquisa.conheceLider ?? '',
          pesquisa.liderNome ?? '',
          pesquisa.liderTelefone ?? '',
          pesquisa.nomeEntrevistado ?? '',
        ];

        for (int colIndex = 0; colIndex < valores.length; colIndex++) {
          var cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: row),
          );
          cell.value = TextCellValue(valores[colIndex].toString());
        }
      }

      // Ajustar largura das colunas (aproximado)
      for (int i = 0; i < cabecalhos.length; i++) {
        sheet.setColumnWidth(i, 20);
      }

      // Gerar bytes do arquivo
      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Erro ao gerar arquivo Excel');
      }

      // Obter diretório para salvar o arquivo
      final directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/socioquest_$timestamp.xlsx';

      // Salvar arquivo
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Compartilhar arquivo
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Pesquisas - Programa Água Legal',
        text: 'Exportação de ${pesquisas.length} pesquisa(s) do Programa Água Legal.',
      );

      // Mostrar mensagem de sucesso
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pesquisas.length} pesquisa(s) exportada(s) com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Mostrar mensagem de erro
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }

  /// Formata a data para exibição
  static String _formatarData(String? dataString) {
    if (dataString == null || dataString.isEmpty) {
      return '';
    }
    try {
      final data = DateTime.parse(dataString);
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    } catch (e) {
      return dataString;
    }
  }

  /// Exporta uma única pesquisa para XLSX
  static Future<void> exportarPesquisaIndividual(
    Pesquisa pesquisa,
    BuildContext context,
  ) async {
    await exportarParaXlsx([pesquisa], context);
  }
}
