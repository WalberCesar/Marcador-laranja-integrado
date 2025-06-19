import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marcador_laranja_app/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'estilos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var _dadosUsuario;
  String _nomeCrianca = '';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carregarDadosUsuario();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _carregarDadosUsuario();
    }
  }

  Future<void> _carregarDadosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? dadosUsuarioString = prefs.getString('dadosUsuario');

      if (dadosUsuarioString != null) {
        _dadosUsuario = jsonDecode(dadosUsuarioString);
        setState(() {
          _nomeCrianca =
              (_dadosUsuario['nomeCrianca'] ?? '').toString().toUpperCase();
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

  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: estiloBordaAppBar,
            child: AppBar(
              title: Text('Menu Principal'),
              iconTheme: estiloAppBar.iconTheme,
              backgroundColor: estiloAppBar.backgroundColor,
              elevation: estiloAppBar.elevation,
              titleTextStyle: estiloAppBar.titleTextStyle,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 20), // Padding de 20
              decoration: estiloDrawerHeader, // Fundo darkorange
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Espaço entre os textos

                children: [
                  Text(
                    _nomeCrianca, // Nome da criança em uppercase
                    style: estiloNomeCrianca, // Estilo do nome
                  ),
                  Text(
                    'Pontuação: 0', // Pontuação
                    style: estiloPontuacao, // Estilo da pontuação
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0), // Espaço ao redor do switch
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tema Escuro',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                    ), // Estilo do texto
                  ),
                  CustomSwitch(), // Usa o switch para alternar o tema
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: estiloListTileIcone,
              ),
              title: Text(
                'Alterar Dados',
                style: estiloListTileTexto,
              ),
              onTap: () async {
                await Navigator.of(context).pushNamed('/alterardados');
                // Recarregar dados quando retornar da página de alterar dados
                _carregarDadosUsuario();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: estiloListTileIcone,
              ),
              title: Text(
                'Sair',
                style: estiloListTileTexto,
              ),
              subtitle: Text(
                'Finalizar sessão',
                style: estiloListTileSubtitulo,
              ),
              onTap: () async {
                // Remover token do SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');

                Navigator.of(context).pushReplacementNamed('/');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Você foi desconectado!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: estiloBordaAppBar, // Aplica a borda preta
          child: AppBar(
            title: Text('Menu Principal'),
            iconTheme: estiloAppBar.iconTheme, // Estilo dos ícones
            backgroundColor: estiloAppBar.backgroundColor, // Fundo darkorange
            elevation: estiloAppBar.elevation, // Efeito de relevo
            titleTextStyle: estiloAppBar.titleTextStyle, // Estilo do título
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30), // Adiciona padding de 12 em todos os lados
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/jogodamemoria');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Jogo da Memória'),
                    ),
                    style: estiloBotaoPadrao,
                  ),
                ),
                SizedBox(width: 12), // Espaço entre os botões
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/jogodavelha');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Jogo da Velha'),
                    ),
                    style: estiloBotaoPadrao,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12), // Espaço entre as linhas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/nomedaimagem');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Nome da Imagem'),
                    ),
                    style: estiloBotaoPadrao,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/jogodaforca');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Forca'),
                    ),
                    style: estiloBotaoPadrao,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/contorno');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Contorne a Letra'),
                    ),
                    style: estiloBotaoPadrao,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/cruzadinha');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Cruzadinha'),
                    ),
                    style: estiloBotaoPadrao,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/areacriativa');
                    },
                    child: Text(
                      'Área Criativa',
                      textAlign: TextAlign.center, // Centraliza o texto
                    ),
                    style: estiloBotaoUltimo, // Aplica o estilo do último botão
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDarkTheme,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}
