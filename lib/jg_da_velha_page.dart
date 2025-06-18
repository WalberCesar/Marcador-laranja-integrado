import 'package:flutter/material.dart';
import 'package:marcador_laranja_app/app_controller.dart';
import 'estilos.dart';

class JogodaVelha extends StatefulWidget {
  const JogodaVelha({super.key});

  @override
  State<JogodaVelha> createState() {
    return JogodaVelhaState();
  }
}

class JogodaVelhaState extends State<JogodaVelha> {
  List<String> tabuleiro = List.generate(9, (_) => '');
  String jogador = '';
  String maquina = '';
  bool vezDoJogador = true;
  int pontuacao = 0;
  bool jogoIniciado = false;

  void escolherSimbolo(String simbolo) {
    setState(() {
      jogador = simbolo;
      maquina = simbolo == 'X' ? 'O' : 'X';
      jogoIniciado = true;
    });
  }

  void reiniciarJogo() {
    setState(() {
      tabuleiro = List.generate(9, (_) => '');
      vezDoJogador = true;
      jogoIniciado = false;
    });
  }

  void jogar(int index) {
    if (tabuleiro[index] == '' && vezDoJogador) {
      setState(() {
        tabuleiro[index] = jogador;
        vezDoJogador = false;
      });

      if (verificarVitoria(jogador)) {
        pontuacao += 50;
        mostrarResultado('Você venceu!', estiloMensagemVitoria);
      } else if (!tabuleiro.contains('')) {
        mostrarResultado('Empate!', estiloTextoCelula);
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            jogarMaquina();
            vezDoJogador = true;

            if (verificarVitoria(maquina)) {
              mostrarResultado('Você perdeu!', estiloTextoCelula);
            } else if (!tabuleiro.contains('')) {
              mostrarResultado('Empate!', estiloTextoCelula);
            }
          });
        });
      }
    }
  }

  void jogarMaquina() {
    int? melhorJogada;

    melhorJogada = encontrarMelhorJogada(maquina);
    if (melhorJogada != null) {
      tabuleiro[melhorJogada] = maquina;
      return;
    }

    melhorJogada = encontrarMelhorJogada(jogador);
    if (melhorJogada != null) {
      tabuleiro[melhorJogada] = maquina;
      return;
    }

    if (tabuleiro[4] == '') {
      tabuleiro[4] = maquina;
      return;
    }

    for (int i in [0, 2, 6, 8]) {
      if (tabuleiro[i] == '') {
        tabuleiro[i] = maquina;
        return;
      }
    }

    for (int i in [1, 3, 5, 7]) {
      if (tabuleiro[i] == '') {
        tabuleiro[i] = maquina;
        return;
      }
    }
  }

  int? encontrarMelhorJogada(String simbolo) {
    for (int i = 0; i < 9; i++) {
      if (tabuleiro[i] == '') {
        tabuleiro[i] = simbolo;
        bool venceu = verificarVitoria(simbolo);
        tabuleiro[i] = '';
        if (venceu) return i;
      }
    }
    return null;
  }

  bool verificarVitoria(String simbolo) {
    List<List<int>> combinacoes = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var c in combinacoes) {
      if (tabuleiro[c[0]] == simbolo &&
          tabuleiro[c[1]] == simbolo &&
          tabuleiro[c[2]] == simbolo) {
        return true;
      }
    }
    return false;
  }

  void mostrarResultado(String resultado, TextStyle estiloTexto) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(resultado, style: estiloTexto),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  reiniciarJogo();
                },
                style: estiloBotaoReiniciar,
                child: const Text('Jogar novamente'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                style: estiloBotaoPadrao,
                child: const Text('Sair do jogo'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: estiloBordaAppBar,
          child: AppBar(
            title: Text('Jogo da Velha'),
            iconTheme: estiloAppBar.iconTheme,
            backgroundColor: estiloAppBar.backgroundColor,
            elevation: estiloAppBar.elevation,
            titleTextStyle: estiloAppBar.titleTextStyle,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: estiloDrawerHeader,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nome da Criança', style: estiloNomeCrianca),
                  Text('Pontuação: $pontuacao', style: estiloPontuacao),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.arrow_left_rounded,
                color: estiloListTileIcone,
              ),
              title: Text('Voltar', style: estiloListTileTexto),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tema Escuro',
                    style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                  ),
                  CustomSwitch(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: estiloContainerBody,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!jogoIniciado)
              Column(
                children: [
                  Text('Escolha X ou O:', style: estiloNomeCrianca),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => escolherSimbolo('X'),
                        style: estiloBotaoPadrao,
                        child: const Text('X'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => escolherSimbolo('O'),
                        style: estiloBotaoPadrao,
                        child: const Text('O'),
                      ),
                    ],
                  ),
                ],
              )
            else
              GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => jogar(index),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: estiloCelulaVelha,
                      child: Center(
                        child: Text(tabuleiro[index], style: estiloTextoCelula),
                      ),
                    ),
                  );
                },
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
