import 'package:flutter/material.dart';
import 'estilos.dart';
import 'textos_legais.dart'; // <-- Importa os textos dos termos e política

class AlterarDadosPage extends StatelessWidget {
  const AlterarDadosPage({super.key});

  void _mostrarDialogoTexto(BuildContext context, String titulo, String texto) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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

  void _mostrarDialogoExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Deseja excluir a conta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha este diálogo
                  _mostrarConfirmacaoSenha(context);
                },
                child: Text('Sim'),
              ),
            ],
          ),
    );
  }

  void _mostrarConfirmacaoSenha(BuildContext context) {
    final TextEditingController senhaController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Confirme sua senha para finalizar a exclusão'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Aqui pode validar a senha se necessário
                  Navigator.pop(context); // Fecha diálogo da senha
                  _mostrarContaExcluida(context);
                },
                child: Text('Confirmar Exclusão'),
              ),
            ],
          ),
    );
  }

  void _mostrarContaExcluida(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Conta Excluída com Sucesso'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome da criança',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Idade',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome do responsável',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Novo e-mail',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nova senha',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Repita a nova senha',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para atualizar os dados
                      },
                      child: Text('ATUALIZAR'),
                      style: estiloBotaoPadraoForm,
                    ),
                    Divider(height: 30, color: Colors.grey),
                    ListTile(
                      title: Text('Termos de Uso'),
                      trailing: Icon(Icons.description),
                      onTap:
                          () => _mostrarDialogoTexto(
                            context,
                            'Termos de Uso',
                            termoUso,
                          ),
                    ),
                    ListTile(
                      title: Text('Política de Privacidade'),
                      trailing: Icon(Icons.privacy_tip),
                      onTap:
                          () => _mostrarDialogoTexto(
                            context,
                            'Política de Privacidade',
                            politicaPrivacidade,
                          ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _mostrarDialogoExclusao(context),
                      child: Text(
                        'Excluir Conta',
                        style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
}
