import 'package:flutter/material.dart';
import 'package:marcador_laranja_app/app_controller.dart';
import 'estilos.dart';

class Cruzadinha extends StatefulWidget {
  const Cruzadinha({super.key});

  @override
  State<Cruzadinha> createState() {
    return CruzadinhaState();
  }
}

class CruzadinhaState extends State<Cruzadinha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20), // Padding de 20
              decoration: estiloDrawerHeader, // Fundo darkorange
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Espaço entre os textos
                children: [
                  Text(
                    'Nome da Criança', // Nome da criança
                    style: estiloNomeCrianca, // Estilo do nome
                  ),
                  Text(
                    'Pontuação: 000', // Pontuação
                    style: estiloPontuacao, // Estilo da pontuação
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.arrow_left_rounded,
                color: estiloListTileIcone, // Ícone em darkorange
              ),
              title: Text(
                'Voltar',
                style: estiloListTileTexto, // Estilo do título
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
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
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: estiloBordaAppBar, // Aplica a borda preta
          child: AppBar(
            title: Text('Cruzadinha'),
            iconTheme: estiloAppBar.iconTheme, // Estilo dos ícones
            backgroundColor: estiloAppBar.backgroundColor, // Fundo darkorange
            elevation: estiloAppBar.elevation, // Efeito de relevo
            titleTextStyle: estiloAppBar.titleTextStyle, // Estilo do título
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20), // Margem de 20
        padding: EdgeInsets.all(20), // Padding de 20
        decoration: estiloContainerBody, // Estilo do Container
        child: Center(
          child:
          // O Jogo será montado aqui
          Text(
            'Aqui ficará o jogo', // Placeholder do jogo
            style: TextStyle(fontSize: 20),
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
