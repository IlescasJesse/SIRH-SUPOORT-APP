import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/constants.dart';
import '../models/user_model.dart';
import '../models/dashboard_model.dart';
import '../models/agenda_log_model.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  String? _token;
  String _baseUrl = AppConstants.baseUrl;

  // Getters
  String get baseUrl => _baseUrl;
  bool get isAuthenticated => _token != null;

  // Setters
  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  // Headers comunes
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // Inicializar token desde storage
  Future<void> loadToken() async {
    _token = await storage.read(key: AppConstants.tokenKey);
    print(
        'Token cargado: ${_token != null ? "Sí (${_token?.substring(0, 20)}...)" : "No"}');
  }

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Intentando login a: $_baseUrl/login');
      print('Usuario: $username');

      final response = await http
          .post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'deviceId': 'flutter_mobile_app',
        }),
      )
          .timeout(
        AppConstants.apiTimeout,
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
        },
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          _token = data['token'];
          await storage.write(key: AppConstants.tokenKey, value: _token);
          await storage.write(
              key: AppConstants.userKey, value: jsonEncode(data['user']));

          return {
            'success': true,
            'user': UserModel.fromJson(data['user']),
            'message': 'Login exitoso',
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Credenciales inválidas',
          };
        }
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              data['message'] ?? 'Error del servidor (${response.statusCode})',
        };
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Verifica:\n'
            '1. Que el servidor esté encendido\n'
            '2. Que la IP sea correcta ($_baseUrl)\n'
            '3. Que estés en la misma red',
      };
    } on FormatException catch (e) {
      print('FormatException: $e');
      return {
        'success': false,
        'message':
            'Error en la respuesta del servidor. Puede que el backend tenga un problema.',
      };
    } catch (e) {
      print('Error general login: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    _token = null;
    await storage.delete(key: AppConstants.tokenKey);
    await storage.delete(key: AppConstants.userKey);
  }

  // Obtener Dashboard
  Future<DashboardModel?> getDashboard() async {
    try {
      print('Llamando a getDashboard con token: ${_token != null}');
      final response = await http
          .get(
            Uri.parse('$_baseUrl/dashboard'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      print('Dashboard response status: ${response.statusCode}');
      if (response.statusCode == 401) {
        print('Error 401: Token inválido o expirado');
        throw Exception(
            'Sesión expirada. Por favor, inicia sesión nuevamente.');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DashboardModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getDashboard: $e');
      rethrow;
    }
  }

  // Obtener logs de Agenda
  Future<List<AgendaLogModel>> getAgendaLogs({int limit = 50}) async {
    try {
      print('Llamando a getAgendaLogs con token: ${_token != null}');
      final response = await http
          .get(
            Uri.parse('$_baseUrl/agenda/logs?limit=$limit'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      print('AgendaLogs response status: ${response.statusCode}');
      if (response.statusCode == 401) {
        print('Error 401: Token inválido o expirado');
        throw Exception(
            'Sesión expirada. Por favor, inicia sesión nuevamente.');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final logs = data['logs'] as List;
        return logs.map((log) => AgendaLogModel.fromJson(log)).toList();
      }
      return [];
    } catch (e) {
      print('Error getAgendaLogs: $e');
      rethrow;
    }
  }

  // Obtener estadísticas de Agenda
  Future<Map<String, dynamic>?> getAgendaStats() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/agenda/stats'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getAgendaStats: $e');
      return null;
    }
  }

  // Ejecutar tarea de Agenda
  Future<Map<String, dynamic>> runAgendaTask(String taskName) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/agenda/run/$taskName'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Tarea ejecutada correctamente',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al ejecutar tarea',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // Estado del servidor
  Future<Map<String, dynamic>?> getServerHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/server/health'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getServerHealth: $e');
      return null;
    }
  }

  // Obtener logs recientes
  Future<List<dynamic>> getRecentLogs({int limit = 20}) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/logs/recent?limit=$limit'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['logs'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getRecentLogs: $e');
      return [];
    }
  }

  // Resetear servidor (requiere autenticación)
  Future<Map<String, dynamic>> resetServer() async {
    try {
      print('Intentando resetear servidor...');
      final response = await http
          .post(
            Uri.parse('$_baseUrl/admin/reset'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      print('Reset server response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Servidor reseteado exitosamente',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'No tienes permisos para resetear el servidor',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Error al resetear el servidor',
        };
      }
    } on SocketException catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor',
      };
    } catch (e) {
      print('Error resetServer: $e');
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Obtener bajas pendientes
  Future<List<dynamic>> getBajasPendientes() async {
    try {
      await loadToken();
      print('Llamando a getBajasPendientes');
      final response = await http
          .get(
            Uri.parse('$_baseUrl/bajas/pendientes'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      print('Bajas pendientes response status: ${response.statusCode}');

      if (response.statusCode == 401) {
        throw Exception(
            'Sesión expirada. Por favor, inicia sesión nuevamente.');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['bajas'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getBajasPendientes: $e');
      rethrow;
    }
  }

  // Ejecutar baja extemporánea
  Future<Map<String, dynamic>> ejecutarBaja(String bajaId) async {
    try {
      await loadToken();
      print('Ejecutando baja ID: $bajaId');
      final response = await http
          .post(
            Uri.parse('$_baseUrl/bajas/ejecutar/$bajaId'),
            headers: _headers,
          )
          .timeout(AppConstants.apiTimeout);

      print('Ejecutar baja response status: ${response.statusCode}');
      print('Ejecutar baja response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Baja procesada exitosamente',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'No tienes permisos para procesar bajas',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Baja no encontrada o ya fue procesada',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Error al procesar la baja',
        };
      }
    } on SocketException catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor',
      };
    } catch (e) {
      print('Error ejecutarBaja: $e');
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }
}
