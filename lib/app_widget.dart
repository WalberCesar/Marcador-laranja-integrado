import 'package:flutter/material.dart';
import 'package:marcador_laranja_app/cadastro_page.dart';
import 'package:marcador_laranja_app/jg_cruzadinha_page.dart';
import 'package:marcador_laranja_app/login_page.dart';
import 'package:marcador_laranja_app/app_controller.dart';
import 'package:marcador_laranja_app/home_page.dart';
import 'package:marcador_laranja_app/area_criativa_page.dart';
import 'package:marcador_laranja_app/jg_contorno_page.dart';
import 'package:marcador_laranja_app/jg_da_memoria_page.dart';
import 'package:marcador_laranja_app/jg_da_velha_page.dart';
import 'package:marcador_laranja_app/jg_forca_page.dart';
import 'package:marcador_laranja_app/jg_nome_da_imagem_page.dart';
import 'package:marcador_laranja_app/senha_esquecida_page.dart';
import 'package:marcador_laranja_app/alterar_dados_page.dart';

class AppWidget extends StatelessWidget {
  final String title;

  const AppWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.red,
            brightness:
                AppController.instance.isDarkTheme
                    ? Brightness.dark
                    : Brightness.light,
          ),
          //Rotas
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(), //rota pricncipal
            '/home': (context) => HomePage(),
            '/jogodavelha': (context) => JogodaVelha(),
            '/areacriativa': (context) => AreaCriativa(),
            '/contorno': (context) => JogoContorno(),
            '/cruzadinha': (context) => Cruzadinha(),
            '/jogodamemoria': (context) => JogodaMemoria(),
            '/jogodaforca': (context) => JogodaForca(),
            '/nomedaimagem': (context) => JogoNomedaImagem(),
            '/alterardados': (context) => AlterarDadosPage(),
            '/cadastro': (context) => CadastroPage(),
            '/senhaesquecida': (context) => SenhaEsquecidaPage(),
          },
          //home: LoginPage(),
        );
      },
    );
  }
}
