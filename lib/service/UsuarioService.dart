import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:marcador_laranja_app/service/Contexto.dart';

Future CadastraUsuario(String nomeCrianca, int idade, String nomeResponsavel,
    String email, String senha, String leitura, String aceitacao) async {
  var usuario = {
    "nomeCrianca": nomeCrianca,
    "idade": idade,
    "nomeResponsavel": nomeResponsavel,
    "email": email,
    "senha": senha,
    "leitura": leitura,
    "aceitacao": aceitacao
  };

  try {
    var resposta = await http.post(
      Uri.parse(
          "https://api-projeto-marcador-laranja.onrender.com/usuarios/registrar"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(usuario), // <-- aqui, encode para JSON!
    );
    if (resposta.statusCode == 200 || resposta.statusCode == 201) {
      print("Resposta: ${resposta.body}");
      print("Resposta: ${resposta.statusCode}");
      return true;
    } else {
      print("Resposta: ${resposta.body}");
      print("Resposta: ${resposta.statusCode}");
      return false;
    }
  } catch (e) {
    print("Erro ao fazer cadastro: $e");
  }
}

Future<bool> LoginUsuario(String email, String senha) async {
  var usuario = {"email": email, "senha": senha};

  try {
    var jsonToken = await http.post(
      Uri.parse(
          "https://api-projeto-marcador-laranja.onrender.com/usuarios/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(usuario), // <-- aqui, encode para JSON!
    );

    if (jsonToken.statusCode == 200) {
      var tokenMap = jsonDecode(jsonToken.body);
      Contexto.token = tokenMap['token'];
      var token = tokenMap['token'].toString().isNotEmpty;
      print(" resposta token => $token");
      return token;
    } else {
      print("Erro ao fazer login: ${jsonToken.statusCode}");
      print("Resposta: ${jsonToken.body}");
      return false;
    }
  } catch (e) {
    print("Erro ao fazer login: $e");
    return false;
  }
}
