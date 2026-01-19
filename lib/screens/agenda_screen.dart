import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/app_provider.dart';
import '../widgets/agenda_task_card.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadAgendaStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final stats = provider.agendaStats;

        return RefreshIndicator(
          onRefresh: () => provider.loadAgendaStats(),
          color: primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Card(
                color: Theme.of(context).cardTheme.color,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.event_note,
                              color: primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tareas de Agenda',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  'Ejecutar tareas programadas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (stats != null) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              'Total',
                              '${stats['totalTasks'] ?? 0}',
                              AppTheme.infoColor,
                            ),
                            _buildStatItem(
                              'Exitosas',
                              '${stats['successfulTasks'] ?? 0}',
                              AppTheme.successColor,
                            ),
                            _buildStatItem(
                              'Fallidas',
                              '${stats['failedTasks'] ?? 0}',
                              AppTheme.errorColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tareas Disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              // Tareas
              ...AppConstants.agendaTasks.map((taskName) {
                return AgendaTaskCard(
                  taskName: taskName,
                  displayName: AppConstants.taskNames[taskName] ?? taskName,
                  icon: _getTaskIcon(taskName),
                  onExecute: () => _executeTask(context, taskName),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Future<void> _executeTask(BuildContext context, String taskName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Ejecución'),
        content: Text(
          '¿Estás seguro de ejecutar la tarea "${AppConstants.taskNames[taskName]}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ejecutar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<AppProvider>();

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppTheme.primaryColor),
                SizedBox(height: 16),
                Text('Ejecutando tarea...'),
              ],
            ),
          ),
        ),
      ),
    );

    final result = await provider.runAgendaTask(taskName);

    if (context.mounted) {
      Navigator.pop(context); // Cerrar loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Tarea ejecutada'),
          backgroundColor: result['success'] == true
              ? AppTheme.successColor
              : AppTheme.errorColor,
        ),
      );

      if (result['success'] == true) {
        provider.loadAgendaStats();
      }
    }
  }

  IconData _getTaskIcon(String taskName) {
    switch (taskName) {
      case 'bajasExtemporaneas':
        return Icons.person_remove;
      case 'altasExtemporaneas':
        return Icons.person_add;
      case 'licenciasExtemporaneas':
        return Icons.description;
      case 'crearTalones':
        return Icons.attach_money;
      case 'gestionarPeriodoVacacional':
        return Icons.beach_access;
      default:
        return Icons.task;
    }
  }
}
