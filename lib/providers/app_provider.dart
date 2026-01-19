import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/dashboard_model.dart';
import '../models/agenda_log_model.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  DashboardModel? _dashboard;
  List<AgendaLogModel> _agendaLogs = [];
  Map<String, dynamic>? _agendaStats;
  Map<String, dynamic>? _serverHealth;

  bool _isLoading = false;
  String? _error;
  bool _isDarkMode = false;
  Timer? _autoRefreshTimer;
  Function()? _onSessionExpired;

  // Getters
  UserModel? get currentUser => _currentUser;
  DashboardModel? get dashboard => _dashboard;
  List<AgendaLogModel> get agendaLogs => _agendaLogs;
  Map<String, dynamic>? get agendaStats => _agendaStats;
  Map<String, dynamic>? get serverHealth => _serverHealth;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ApiService get apiService => _apiService;
  bool get isDarkMode => _isDarkMode;

  // Setter para callback de sesión expirada
  void setSessionExpiredCallback(Function() callback) {
    _onSessionExpired = callback;
  }

  // Cambiar tema
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Iniciar actualización en tiempo real (cada 5 segundos)
  void startAutoRefresh() {
    stopAutoRefresh(); // Detener cualquier timer existente
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      refreshAll();
    });
  }

  // Detener actualización automática
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }

  // Inicializar
  Future<void> initialize() async {
    await _apiService.loadToken();
    _currentUser = await _authService.getCurrentUser();

    // Verificar si realmente hay sesión válida
    final hasValidSession = await _authService.isLoggedIn();
    if (!hasValidSession) {
      _currentUser = null;
      _onSessionExpired?.call();
      return;
    }

    if (_currentUser != null) {
      startAutoRefresh();
    }
    notifyListeners();
  }

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _apiService.login(username, password);

    _isLoading = false;

    if (result['success'] == true) {
      _currentUser = result['user'];
      _error = null;
      startAutoRefresh();
      notifyListeners();
      return true;
    } else {
      _error = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    stopAutoRefresh();
    await _apiService.logout();
    await _authService.logout();
    _currentUser = null;
    _dashboard = null;
    _agendaLogs = [];
    _agendaStats = null;
    _serverHealth = null;
    notifyListeners();
  }

  // Cargar Dashboard
  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboard = await _apiService.getDashboard();
      _error = null;
    } catch (e) {
      if (e.toString().contains('401') ||
          e.toString().contains('Sesión expirada')) {
        print('Sesión expirada detectada en loadDashboard');
        await logout();
        _onSessionExpired?.call();
        _error = 'Sesión expirada';
      } else {
        _error = 'Error al cargar dashboard: ${e.toString()}';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Cargar logs de Agenda
  Future<void> loadAgendaLogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _agendaLogs = await _apiService.getAgendaLogs();
      _error = null;
    } catch (e) {
      if (e.toString().contains('401') ||
          e.toString().contains('Sesión expirada')) {
        print('Sesión expirada detectada en loadAgendaLogs');
        await logout();
        _onSessionExpired?.call();
        _error = 'Sesión expirada';
      } else {
        _error = 'Error al cargar logs: ${e.toString()}';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Cargar estadísticas de Agenda
  Future<void> loadAgendaStats() async {
    try {
      _agendaStats = await _apiService.getAgendaStats();
      notifyListeners();
    } catch (e) {
      print('Error al cargar stats: $e');
    }
  }

  // Cargar salud del servidor
  Future<void> loadServerHealth() async {
    try {
      _serverHealth = await _apiService.getServerHealth();
      notifyListeners();
    } catch (e) {
      print('Error al cargar server health: $e');
    }
  }

  // Ejecutar tarea de Agenda
  Future<Map<String, dynamic>> runAgendaTask(String taskName) async {
    return await _apiService.runAgendaTask(taskName);
  }

  // Resetear servidor
  Future<Map<String, dynamic>> resetServer() async {
    return await _apiService.resetServer();
  }

  // Refresh todo
  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboard(),
      loadAgendaLogs(),
      loadAgendaStats(),
      loadServerHealth(),
    ]);
  }
}
