import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pesquisa.dart';

/// Helper para gerenciar o banco de dados SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Obtém a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pesquisa_agua_legal.db');
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const realType = 'REAL';

    await db.execute('''
      CREATE TABLE pesquisas (
        id $idType,
        pesquisador $textType,
        data_pesquisa $textType,
        p1_qtd_pessoas $intType,
        p2_qtd_criancas $intType,
        p3_qtd_idosos $intType,
        p4_renda_familiar $textType,
        p5_recebe_beneficio $textType,
        p6_qual_beneficio $textType,
        p7_acesso_agua_tratada $textType,
        p8_beneficios_esperados $textType,
        p9_fonte_agua $textType,
        p10_problemas_saude $textType,
        p11_quais_problemas $textType,
        p12_gasto_mensal_agua $realType,
        p13_tem_reservatorio $textType,
        p14_capacidade_reservatorio $intType,
        p15_tipo_moradia $textType,
        p16_moradia_propria $textType,
        p17_tempo_residencia $intType,
        p18_observacoes $textType,
        p19_latitude $realType,
        p20_longitude $realType,
        -- novos campos
        logradouro $textType,
        endereco $textType,
        numero $textType,
        complemento $textType,
        bairro $textType,
        cep $textType,
        municipio $textType,
        email $textType,
        telefone $textType,
        estado_civil $textType,
        cor_raca $textType,
        material_paredes $textType,
        condicao_moradia $textType,
        qtd_comodos $intType,
        eletricidade $textType,
        coleta_lixo $textType,
        coleta_freq $textType,
        contribuinte_renda $textType,
        escolaridade_chefe $textType,
        participa_grupos $textType,
        conhece_lider $textType,
        lider_nome $textType,
        lider_telefone $textType,
        nome_entrevistado $textType
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adiciona as colunas novas ao banco existente
      final alterStatements = [
        "ALTER TABLE pesquisas ADD COLUMN logradouro TEXT",
        "ALTER TABLE pesquisas ADD COLUMN endereco TEXT",
        "ALTER TABLE pesquisas ADD COLUMN numero TEXT",
        "ALTER TABLE pesquisas ADD COLUMN complemento TEXT",
        "ALTER TABLE pesquisas ADD COLUMN bairro TEXT",
        "ALTER TABLE pesquisas ADD COLUMN cep TEXT",
        "ALTER TABLE pesquisas ADD COLUMN municipio TEXT",
        "ALTER TABLE pesquisas ADD COLUMN email TEXT",
        "ALTER TABLE pesquisas ADD COLUMN telefone TEXT",
        "ALTER TABLE pesquisas ADD COLUMN estado_civil TEXT",
        "ALTER TABLE pesquisas ADD COLUMN cor_raca TEXT",
        "ALTER TABLE pesquisas ADD COLUMN material_paredes TEXT",
        "ALTER TABLE pesquisas ADD COLUMN condicao_moradia TEXT",
        "ALTER TABLE pesquisas ADD COLUMN qtd_comodos INTEGER",
        "ALTER TABLE pesquisas ADD COLUMN eletricidade TEXT",
        "ALTER TABLE pesquisas ADD COLUMN coleta_lixo TEXT",
        "ALTER TABLE pesquisas ADD COLUMN coleta_freq TEXT",
        "ALTER TABLE pesquisas ADD COLUMN contribuinte_renda TEXT",
        "ALTER TABLE pesquisas ADD COLUMN escolaridade_chefe TEXT",
        "ALTER TABLE pesquisas ADD COLUMN participa_grupos TEXT",
        "ALTER TABLE pesquisas ADD COLUMN conhece_lider TEXT",
        "ALTER TABLE pesquisas ADD COLUMN lider_nome TEXT",
        "ALTER TABLE pesquisas ADD COLUMN lider_telefone TEXT"
      ];

      for (final stmt in alterStatements) {
        try {
          await db.execute(stmt);
        } catch (e) {
          // ignora se já existir ou erro; mas log útil em dev
          // print('Alter table error: $e');
        }
      }
    }
    if (oldVersion < 3) { // assumindo que a versão agora será 3
      await db.execute("ALTER TABLE pesquisas ADD COLUMN nome_entrevistado TEXT");
    }
  }

  /// Insere uma nova pesquisa no banco de dados
  Future<int> insert(Pesquisa pesquisa) async {
    final db = await instance.database;
    final map = pesquisa.toMap();
    map.remove('id'); // Remove ID para autoincrement
    return await db.insert('pesquisas', map);
  }

  /// Obtém todas as pesquisas ordenadas por data (mais recente primeiro)
  Future<List<Pesquisa>> getAll() async {
    final db = await instance.database;
    final result = await db.query(
      'pesquisas',
      orderBy: 'data_pesquisa DESC',
    );
    return result.map((map) => Pesquisa.fromMap(map)).toList();
  }

  /// Obtém uma pesquisa pelo ID
  Future<Pesquisa?> getById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'pesquisas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Pesquisa.fromMap(maps.first);
    }
    return null;
  }

  /// Atualiza uma pesquisa existente
  Future<int> update(Pesquisa pesquisa) async {
    final db = await instance.database;
    return await db.update(
      'pesquisas',
      pesquisa.toMap(),
      where: 'id = ?',
      whereArgs: [pesquisa.id],
    );
  }

  /// Exclui uma pesquisa pelo ID
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'pesquisas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Exclui todas as pesquisas
  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete('pesquisas');
  }

  /// Obtém o número total de pesquisas
  Future<int> getCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM pesquisas');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Fecha a conexão com o banco de dados
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
