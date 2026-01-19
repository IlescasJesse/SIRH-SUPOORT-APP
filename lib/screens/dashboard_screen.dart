import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/app_provider.dart';
import '../widgets/stat_card.dart';
import '../services/auth_service.dart';
import 'agenda_screen.dart';
import 'logs_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'bajas_pendientes_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    // Configurar callback para sesión expirada
    final provider = context.read<AppProvider>();
    provider.setSessionExpiredCallback(() {
      if (mounted) {
        _redirectToLogin();
      }
    });

    // Verificar sesión inicial
    await _checkSession();
  }

  Future<void> _checkSession() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();

    if (!isLoggedIn) {
      if (mounted) {
        _redirectToLogin();
      }
      return;
    }

    // Si hay sesión válida, cargar datos
    if (mounted) {
      setState(() => _isCheckingSession = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppProvider>().refreshAll();
      });
    }
  }

  void _redirectToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar loading mientras verifica sesión
    if (_isCheckingSession) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Widget> screens = [
      const _DashboardHome(),
      const AgendaScreen(),
      const LogsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIRH Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AppProvider>().refreshAll();
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.surfaceColorDark
            : AppTheme.surfaceColorLight,
        indicatorColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.primaryColorDark.withOpacity(0.3)
            : AppTheme.primaryColorLight.withOpacity(0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight),
            selectedIcon: Icon(Icons.dashboard,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryColorDark
                    : AppTheme.primaryColorLight),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight),
            selectedIcon: Icon(Icons.event_note,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryColorDark
                    : AppTheme.primaryColorLight),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight),
            selectedIcon: Icon(Icons.list_alt,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryColorDark
                    : AppTheme.primaryColorLight),
            label: 'Logs',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight),
            selectedIcon: Icon(Icons.settings,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryColorDark
                    : AppTheme.primaryColorLight),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardTheme.color;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final dashboard = provider.dashboard;
        final serverHealth = provider.serverHealth;

        if (provider.isLoading && dashboard == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => provider.refreshAll(),
          color: primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Bienvenida
              Card(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenido',
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                              ),
                            ),
                            Text(
                              provider.currentUser?.username ?? 'Usuario',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Estado del servidor
              if (serverHealth != null)
                Card(
                  color: AppTheme.successColor.withOpacity(isDark ? 0.2 : 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppTheme.successColor, size: 32),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Servidor en línea',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successColor,
                              ),
                            ),
                            Text(
                              'Uptime: ${_formatUptime(serverHealth['uptime'])}',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Estadísticas
              Text(
                'Estadísticas Generales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Logs',
                      value: '${dashboard?.totalLogs ?? 0}',
                      icon: Icons.list,
                      color: AppTheme.infoColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Exitosos',
                      value: '${dashboard?.completedTasks ?? 0}',
                      icon: Icons.check_circle,
                      color: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Fallidos',
                      value: '${dashboard?.failedTasks ?? 0}',
                      icon: Icons.error,
                      color: AppTheme.errorColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Tasa de Éxito',
                      value:
                          '${dashboard?.successRate.toStringAsFixed(1) ?? '0'}%',
                      icon: Icons.trending_up,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Acceso rápido a Bajas Pendientes
              Card(
                color: cardColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BajasPendientesScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_remove,
                            color: AppTheme.errorColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bajas Pendientes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Gestionar bajas extemporáneas',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: secondaryTextColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Actividad reciente
              Text(
                'Actividad Reciente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              if (dashboard?.recentActivities.isEmpty ?? true)
                Card(
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No hay actividad reciente',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                  ),
                )
              else
                ...dashboard!.recentActivities.take(5).map((activity) {
                  final isSuccess = activity.estado == 'completada';
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        isSuccess ? Icons.check_circle : Icons.error,
                        color: isSuccess
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                      title: Text(
                        activity.tarea,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        activity.mensaje,
                        style: TextStyle(color: secondaryTextColor),
                      ),
                      trailing: Text(
                        _formatTime(activity.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  String _formatUptime(dynamic uptime) {
    if (uptime == null) return '--';
    final totalSeconds = (uptime as num).toInt();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours}h ${minutes}m ${seconds}s';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
