import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcador_laranja_app/service/UsuarioService.dart';
import 'estilos.dart';
import 'textos_legais.dart'; // Importa os textos dos termos

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeCriancaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _nomeResponsavelController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _aceitouTermos = false;
  String? _dataConfirmacao;

  bool get _formularioValido {
    return _nomeCriancaController.text.isNotEmpty &&
        _idadeController.text.isNotEmpty &&
        _nomeResponsavelController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty &&
        _aceitouTermos;
  }

  void _mostrarTermo(String titulo, String conteudo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(child: Text(conteudo)),
        actions: [
          TextButton(
            child: Text("Fechar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastre-se'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
                  children: [
                    TextField(
                      controller: _nomeCriancaController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome da criança',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _idadeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Idade',
                      ),
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
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _nomeResponsavelController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome do responsável',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _aceitouTermos,
                          onChanged: (bool? valor) {
                            setState(() {
                              _aceitouTermos = valor ?? false;
                              _dataConfirmacao = valor == true
                                  ? DateFormat(
                                      'dd/MM/yyyy – HH:mm',
                                    ).format(DateTime.now())
                                  : null;
                            });
                          },
                        ),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Li e aceito o "),
                              GestureDetector(
                                onTap: () =>
                                    _mostrarTermo('Termo de Uso', termoUso),
                                child: Text(
                                  "Termo de Uso",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                              Text(" e a "),
                              GestureDetector(
                                onTap: () => _mostrarTermo(
                                  'Política de Privacidade',
                                  politicaPrivacidade,
                                ),
                                child: Text(
                                  "Política de Privacidade",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                              Text("."),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _formularioValido
                          ? () async {
                              var idade = int.parse(_idadeController.text);

                              // Mostrar loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    Center(child: CircularProgressIndicator()),
                              );

                              try {
                                var resp = await CadastraUsuario(
                                    _nomeCriancaController.text,
                                    idade,
                                    _nomeResponsavelController.text,
                                    _emailController.text,
                                    _senhaController.text,
                                    "S",
                                    _aceitouTermos ? "S" : "N");

                                Navigator.pop(context); // Fechar loading

                                if (resp) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Cadastro realizado em $_dataConfirmacao',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro ao cadastrar usuário!',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                _nomeCriancaController.clear();
                                _idadeController.clear();
                                _nomeResponsavelController.clear();
                                _emailController.clear();
                                _senhaController.clear();
                                _aceitouTermos = false;
                                _dataConfirmacao = null;
                              } catch (e) {
                                Navigator.pop(context); // Fechar loading
                                print("Erro ao cadastrar usuário: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao cadastrar usuário!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                                _nomeCriancaController.clear();
                                _idadeController.clear();
                                _nomeResponsavelController.clear();
                                _emailController.clear();
                                _senhaController.clear();
                                _aceitouTermos = false;
                                _dataConfirmacao = null;
                              }
                            }

                          // Aqui você pode salvar os dados no banco

                          : null,
                      style: estiloBotaoPadraoForm,
                      child: Text('CADASTRAR'),
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
}
