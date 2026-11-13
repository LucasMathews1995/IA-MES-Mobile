import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:suporte_mes_app/core/constant/api_constants.dart';

class AuthService {
  final String _tokenUrl =
      '${ApiConstants.keycloakUrl}/realms/mes-realm/protocol/openid-connect/token';
  final String _clientId = 'mes-app';

  static String?
  token; // Guarda o token em memória (ou use flutter_secure_storage)

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_tokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'grant_type': 'password',
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['access_token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void logout() {
    token = null;
  }
}
