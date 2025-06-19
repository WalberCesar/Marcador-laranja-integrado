import 'package:flutter/material.dart';

// home_page

final ButtonStyle estiloBotaoPadrao = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepOrange,
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide(color: Colors.deepOrange.shade700),
  ),
  fixedSize: Size.fromHeight(60),
  padding: EdgeInsets.symmetric(horizontal: 20),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  foregroundColor: Colors.white,
);

final ButtonStyle estiloBotaoUltimo = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepOrange,
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide(color: Colors.deepOrange.shade700),
  ),
  fixedSize: Size.fromHeight(90),
  padding: EdgeInsets.all(20),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  foregroundColor: Colors.white,
);

// drawer listview e appbar

final AppBarTheme estiloAppBar = AppBarTheme(
  backgroundColor: Colors.deepOrange,
  elevation: 5,
  titleTextStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  ),
  iconTheme: IconThemeData(color: Colors.white),
);

final BoxDecoration estiloBordaAppBar = BoxDecoration(
  border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
);

// header do Drawer

final BoxDecoration estiloDrawerHeader = BoxDecoration(
  color: Colors.deepOrange,
);

final TextStyle estiloNomeCrianca = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Colors.white,
);

final TextStyle estiloPontuacao = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

// ListTile

final TextStyle estiloListTileTexto = TextStyle(
  fontSize: 16,
  color: Colors.deepOrange,
);

final TextStyle estiloListTileSubtitulo = TextStyle(
  fontSize: 14,
  color: Colors.deepOrange,
);

final Color estiloListTileIcone = Colors.deepOrange;

// Body dos jogos

final BoxDecoration estiloContainerBody = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.black, width: 2),
);

// Formulários

final BoxDecoration estiloBodyTransparente = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
);

final ButtonStyle estiloBotaoPadraoForm = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepOrange,
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
    side: BorderSide(color: Colors.deepOrange.shade700),
  ),
  minimumSize: Size(double.infinity, 60),
  padding: EdgeInsets.symmetric(horizontal: 20),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  foregroundColor: Colors.white,
);

// Jogo da Velha

final BoxDecoration estiloCelulaVelha = BoxDecoration(
  border: Border.all(color: Colors.black, width: 2),
);

final TextStyle estiloTextoCelula = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.deepOrange,
);

final TextStyle estiloMensagemVitoria = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.green,
);

final ButtonStyle estiloBotaoReiniciar = ElevatedButton.styleFrom(
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
);

// Jogo da Memória

// Largura máxima da área centralizada
const double larguraMaximaMemoria = 400;

// Espaçamento entre cartas
const double espacoEntreCartas = 6;

// Borda arredondada das cartas
final BorderRadius bordaCartasMemoria = BorderRadius.circular(12);

// Tema específico para o jogo da memória (opcional)
final ThemeData temaMemoria = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  useMaterial3: true,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange,
    ),
  ),
);

final ButtonStyle estiloBotaoDesabilitado = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey[300],
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
    side: BorderSide(color: Colors.grey[400]!),
  ),
  minimumSize: Size(double.infinity, 60),
  padding: EdgeInsets.symmetric(horizontal: 20),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.grey[600],
  ),
  foregroundColor: Colors.grey[600],
);
