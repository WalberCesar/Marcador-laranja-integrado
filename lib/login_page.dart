import 'package:flutter/material.dart';
import 'package:marcador_laranja_app/service/UsuarioService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcador_laranja_app/service/Contexto.dart';
import 'estilos.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email_controler = TextEditingController();
  var senha_controler = TextEditingController();
  bool _loginInvalido = false;
  bool _formularioValido = false;

  void _validarFormulario() {
    setState(() {
      _formularioValido =
          email_controler.text.isNotEmpty && senha_controler.text.isNotEmpty;
    });
  }

  Widget _body() {
    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: estiloBodyTransparente, // Fundo com transparência
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/Marcador_laranja_logo_1.png',
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: email_controler,
                            onChanged: (value) {
                              _validarFormulario();
                              if (_loginInvalido) {
                                setState(() {
                                  _loginInvalido = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            obscureText: true,
                            controller: senha_controler,
                            onChanged: (value) {
                              _validarFormulario();
                              if (_loginInvalido) {
                                setState(() {
                                  _loginInvalido = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Senha',
                            ),
                          ),
                          if (_loginInvalido)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Dados inválidos!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _formularioValido
                                ? () async {
                                    var resp = await LoginUsuario(
                                        email_controler.text,
                                        senha_controler.text);
                                    if (resp) {
                                      // Salvar token no SharedPreferences
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'token', Contexto.token);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Login realizado com sucesso!',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      Future.delayed(Duration(seconds: 1), () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');
                                      });
                                    } else {
                                      setState(() {
                                        _loginInvalido = true;
                                      });
                                    }
                                  }
                                : null,
                            child: Text('ENTRAR'),
                            style: _formularioValido
                                ? estiloBotaoPadraoForm
                                : estiloBotaoDesabilitado,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/cadastro');
                            },
                            child: Text('CADASTRAR'),
                            style: estiloBotaoPadraoForm, // Estilo do botão
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.help_outline),
                              color: Colors.deepOrange,
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed('/senhaesquecida');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Stack(children: [_body()]),
    );
  }
}
