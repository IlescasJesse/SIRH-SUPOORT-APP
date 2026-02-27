class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://172.31.246.60:3000/api/mobile/monitor';

  // Cambiar a tu IP del servidor en desarrollo
  // static const String baseUrl = 'http://192.168.1.100:3000/api/mobile/monitor';

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'your_secret_key';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String serverUrlKey = 'server_url';

  // Agenda Tasks
  static const List<String> agendaTasks = [
    'bajasExtemporaneas',
    'altasExtemporaneas',
    'licenciasExtemporaneas',
    'crearTalones',
    'gestionarPeriodoVacacional',
  ];

  static const Map<String, String> taskNames = {
    'bajasExtemporaneas': 'Bajas Extemporáneas',
    'altasExtemporaneas': 'Altas Extemporáneas',
    'licenciasExtemporaneas': 'Licencias Extemporáneas',
    'crearTalones': 'Crear Talones',
    'gestionarPeriodoVacacional': 'Período Vacacional',
  };

  // Material Icons for tasks (use with Icons class)
  static const Map<String, String> taskIconNames = {
    'bajasExtemporaneas': 'person_remove',
    'altasExtemporaneas': 'person_add',
    'licenciasExtemporaneas': 'description',
    'crearTalones': 'attach_money',
    'gestionarPeriodoVacacional': 'beach_access',
  };
}
