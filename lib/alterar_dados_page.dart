import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcador_laranja_app/service/UsuarioService.dart';
import 'dart:convert';
import 'estilos.dart';
import 'textos_legais.dart'; // <-- Importa os textos dos termos e política

class AlterarDadosPage extends StatefulWidget {
  const AlterarDadosPage({super.key});

  @override
  State<AlterarDadosPage> createState() => _AlterarDadosPageState();
}

class _AlterarDadosPageState extends State<AlterarDadosPage> {
  final TextEditingController _nomeCriancaController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _nomeResponsavelController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  Map<String, dynamic>? _dadosUsuario;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? dadosUsuarioString = prefs.getString('dadosUsuario');

      if (dadosUsuarioString != null) {
        _dadosUsuario = jsonDecode(dadosUsuarioString);

        setState(() {
          _nomeCriancaController.text = _dadosUsuario!['nomeCrianca'] ?? '';
          _idadeController.text = (_dadosUsuario!['idade'] ?? '').toString();
          _nomeResponsavelController.text =
              _dadosUsuario!['nomeResponsavel'] ?? '';
          _emailController.text = _dadosUsuario!['email'] ?? '';
          _carregando = false;
        });
      } else {
        setState(() {
          _carregando = false;
        });
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
      setState(() {
        _carregando = false;
      });
    }
  }

  void _atualizarDados() async {
    // Validar se as senhas coincidem
    if (_senhaController.text.isNotEmpty &&
        _senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'As senhas não coincidem!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar nome da criança
    if (_nomeCriancaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nome da criança é obrigatório!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar nome do responsável
    if (_nomeResponsavelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nome do responsável é obrigatório!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar idade
    int? idade;
    if (_idadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Idade é obrigatória!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    idade = int.tryParse(_idadeController.text);
    if (idade == null || idade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Idade deve ser um número válido!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      bool sucesso = await AtualizarUsuario(
        _nomeCriancaController.text,
        idade,
        _nomeResponsavelController.text,
        _emailController.text,
        _senhaController.text,
      );

      Navigator.pop(context); // Fechar loading

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Dados atualizados com sucesso!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Limpar campos de senha
        _senhaController.clear();
        _confirmarSenhaController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao atualizar dados!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Fechar loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao atualizar dados: $e',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _carregarDadosUsuario();
    }
  }

  void _mostrarDialogoTexto(BuildContext context, String titulo, String texto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(child: Text(texto)),
        actions: [
          TextButton(
            child: Text('Fechar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Atualizar'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: estiloBodyTransparente,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nomeCriancaController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome da criança',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z\s]")),
                        LengthLimitingTextInputFormatter(50),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _idadeController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Permite apenas números inteiros
                        if (value.isNotEmpty &&
                            !RegExp(r'^[0-9]+$').hasMatch(value)) {
                          _idadeController.text =
                              value.replaceAll(RegExp(r'[^0-9]'), '');
                          _idadeController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _idadeController.text.length),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Idade',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _nomeResponsavelController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome do responsável',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z\s]")),
                        LengthLimitingTextInputFormatter(50),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Novo e-mail',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-Z0-9@._\-]"),
                        ),
                        LengthLimitingTextInputFormatter(60),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nova senha (opcional)',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'''[;'"\\\s]'''),
                        ),
                        LengthLimitingTextInputFormatter(20),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _confirmarSenhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Repita a nova senha',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'''[;'"\\\s]'''),
                        ),
                        LengthLimitingTextInputFormatter(20),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _atualizarDados,
                      child: Text('ATUALIZAR'),
                      style: estiloBotaoPadraoForm,
                    ),
                    Divider(height: 30, color: Colors.grey),
                    ListTile(
                      title: Text('Termos de Uso'),
                      trailing: Icon(Icons.description),
                      onTap: () => _mostrarDialogoTexto(
                        context,
                        'Termos de Uso',
                        termoUso,
                      ),
                    ),
                    ListTile(
                      title: Text('Política de Privacidade'),
                      trailing: Icon(Icons.privacy_tip),
                      onTap: () => _mostrarDialogoTexto(
                        context,
                        'Política de Privacidade',
                        politicaPrivacidade,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeCriancaController.dispose();
    _idadeController.dispose();
    _nomeResponsavelController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}
