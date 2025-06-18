import 'dart:math';
import 'package:flutter/material.dart';
import 'package:marcador_laranja_app/app_controller.dart';
import 'estilos.dart';

class JogodaMemoria extends StatefulWidget {
  const JogodaMemoria({super.key});

  @override
  State<JogodaMemoria> createState() => _JogodaMemoriaState();
}

class _JogodaMemoriaState extends State<JogodaMemoria> {
  final List<String> todasVogais = ['a', 'e', 'i', 'o', 'u'];
  final List<String> todasConsoantes = [
    'b',
    'c',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'm',
    'n',
    'p',
    'q',
    'r',
    's',
    't',
    'v',
    'w',
    'x',
    'z',
  ];

  List<String> cartas = [];
  List<bool> reveladas = [];
  List<int> selecionadas = [];
  bool jogoIniciado = false;
  int pontuacao = 0;
  bool usandoVogais = true;

  void iniciarJogo(bool vogais) {
    usandoVogais = vogais;
    List<String> base = vogais ? todasVogais : todasConsoantes;
    base.shuffle();
    int quantidade = vogais ? 5 : 10;
    cartas = base.take(quantidade).toList();
    cartas = [...cartas, ...cartas];
    cartas.shuffle();
    reveladas = List.generate(cartas.length, (_) => false);
    selecionadas.clear();

    setState(() {
      jogoIniciado = true;
    });
  }

  void selecionarCarta(int index) {
    if (reveladas[index] || selecionadas.length == 2) return;

    setState(() {
      reveladas[index] = true;
      selecionadas.add(index);
    });

    if (selecionadas.length == 2) {
      Future.delayed(const Duration(seconds: 1), () {
        int i = selecionadas[0];
        int j = selecionadas[1];
        if (cartas[i] == cartas[j]) {
          pontuacao += 10;
          if (!reveladas.contains(false)) {
            mostrarResultado("Parabéns! Você completou o jogo!");
          }
        } else {
          setState(() {
            reveladas[i] = false;
            reveladas[j] = false;
          });
        }
        selecionadas.clear();
      });
    }
  }

  void mostrarResultado(String msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(msg, style: estiloMensagemVitoria),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    jogoIniciado = false;
                  });
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
    int colunas = usandoVogais ? 4 : 5;
    int linhas = usandoVogais ? 2 : 5;
    double larguraCarta = 63;
    double alturaCarta = 90;
    double espacamento = 8;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: estiloBordaAppBar,
          child: AppBar(
            title: const Text('Jogo da Memória'),
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
              padding: const EdgeInsets.all(20),
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
              onTap: () => Navigator.of(context).pushReplacementNamed('/home'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tema Escuro',
                    style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                  ),
                  const CustomSwitch(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: estiloContainerBody,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!jogoIniciado)
                Column(
                  children: [
                    Text('Escolha uma categoria:', style: estiloNomeCrianca),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => iniciarJogo(true),
                      style: estiloBotaoPadrao,
                      child: const Text('VOGAIS'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => iniciarJogo(false),
                      style: estiloBotaoPadrao,
                      child: const Text('CONSOANTES'),
                    ),
                  ],
                )
              else
                Expanded(
                  child: GridView.count(
                    crossAxisCount: colunas,
                    crossAxisSpacing: espacamento,
                    mainAxisSpacing: espacamento,
                    shrinkWrap: true,
                    childAspectRatio: larguraCarta / alturaCarta,
                    children: List.generate(cartas.length, (index) {
                      bool estaRevelada = reveladas[index];
                      String letra = cartas[index];
                      return GestureDetector(
                        onTap: () => selecionarCarta(index),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            final rotate = Tween(
                              begin: pi,
                              end: 0.0,
                            ).animate(animation);
                            return AnimatedBuilder(
                              animation: rotate,
                              child: child,
                              builder: (context, child) {
                                final isUnder =
                                    (ValueKey(estaRevelada) != child!.key);
                                final rotation =
                                    isUnder
                                        ? min(rotate.value, pi / 2)
                                        : rotate.value;
                                return Transform(
                                  transform: Matrix4.rotationY(rotation),
                                  alignment: Alignment.center,
                                  child: child,
                                );
                              },
                            );
                          },
                          child: Container(
                            key: ValueKey(estaRevelada),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              estaRevelada
                                  ? 'assets/cartas/$letra.png'
                                  : 'assets/cartas/fundo_carta.png',
                              width: larguraCarta,
                              height: alturaCarta,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
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
