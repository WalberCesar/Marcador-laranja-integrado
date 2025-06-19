import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'estilos.dart';

class SenhaEsquecidaPage extends StatelessWidget {
  const SenhaEsquecidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esqueceu sua senha?'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retorna para a página anterior
          },
        ),
        backgroundColor: Colors.deepOrange, // Cor de fundo do AppBar
      ),
      body: Container(
        decoration: estiloBodyTransparente, // Fundo com transparência
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z0-9@._\-]"),
                      ),
                      LengthLimitingTextInputFormatter(60),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica de recuperação de senha
                    },
                    child: Text('ENVIAR'),
                    style: estiloBotaoPadraoForm, // Estilo do botão
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
