import 'dart:convert';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/environment.dart';

class AuthService with ChangeNotifier {
  Usuario _usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  Usuario get usuario => this._usuario;

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Get TOKEN de forma estatica para que pueda acceder al token sin la necesidad
  //de instanciar al Provider entonces seria directo la clase (.)punto el get =
  // AuthService.getToken

  static Future<String> getToken() async {
    final storage = new FlutterSecureStorage();
    final token = storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final storage = new FlutterSecureStorage();
    storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(
      '${Environment.apiUrl}/login',
      body: jsonEncode(data),
      //esto no es necesario
      headers: {'Content-Type': 'application/json'},
    );

    print(resp.body);
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this._usuario = loginResponse.usuario;
      await this._guardarToke(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
      'online': true
    };

    final resp = await http.post(
      '${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      //esto no es necesario
      headers: {'Content-Type': 'application/json'},
    );

    this.autenticando = false;

    print(resp.statusCode);
    print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this._usuario = loginResponse.usuario;
      await _guardarToke(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      print(respBody['msg']);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    print(token);

    final resp = await http.get('${Environment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});

    print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this._usuario = loginResponse.usuario;
      await this._guardarToke(loginResponse.token);
      return true;
    } else {
      await this.logout();
      return false;
    }
  }

  Future _guardarToke(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
