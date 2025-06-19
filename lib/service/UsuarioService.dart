import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:marcador_laranja_app/service/Contexto.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      return true;
    } else {
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
      var resposta = jsonDecode(jsonToken.body);
      var tokenMap = resposta['token'];
      var dadosUsuario = resposta['usuario'];
      Contexto.token = tokenMap;

      // Salvar dados do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', tokenMap);
      await prefs.setString('dadosUsuario', jsonEncode(dadosUsuario));

      var token = tokenMap.toString().isNotEmpty;
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

Future<bool> AtualizarUsuario(String nomeCrianca, int idade,
    String nomeResponsavel, String email, String senha) async {
  try {
    // Buscar token do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Token não encontrado");
      return false;
    }

    var dadosAtualizados = <String, dynamic>{};

    // Adicionar apenas os campos que foram fornecidos
    if (nomeCrianca.isNotEmpty) dadosAtualizados['nomeCrianca'] = nomeCrianca;
    if (idade > 0) dadosAtualizados['idade'] = idade;
    if (nomeResponsavel.isNotEmpty)
      dadosAtualizados['nomeResponsavel'] = nomeResponsavel;
    if (email.isNotEmpty) dadosAtualizados['email'] = email;
    if (senha.isNotEmpty) dadosAtualizados['senha'] = senha;

    var resposta = await http.put(
      Uri.parse(
          "https://api-projeto-marcador-laranja.onrender.com/usuarios/atualizar"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(dadosAtualizados),
    );

    if (resposta.statusCode == 200) {
      // Atualizar dados no SharedPreferences se a resposta incluir dados atualizados

      await prefs.setString('dadosUsuario', jsonEncode(dadosAtualizados));

      return true;
    } else {
      print("Erro ao atualizar usuário: ${resposta.statusCode}");
      print("Resposta: ${resposta.body}");
      return false;
    }
  } catch (e) {
    print("Erro ao atualizar usuário: $e");
    return false;
  }
}
