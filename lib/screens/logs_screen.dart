import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/app_provider.dart';
import '../widgets/log_item.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _agendaFilter = 'todos';
  String _serverFilter = 'todos';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadAgendaLogs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                isDark ? AppTheme.surfaceColorDark : AppTheme.surfaceColorLight,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor:
                isDark ? AppTheme.primaryColorDark : AppTheme.primaryColorLight,
            unselectedLabelColor: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            indicatorColor:
                isDark ? AppTheme.primaryColorDark : AppTheme.primaryColorLight,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.dns), text: 'SERVER'),
              Tab(icon: Icon(Icons.calendar_today), text: 'AGENDA'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildServerLogsTab(isDark),
              _buildAgendaLogsTab(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServerLogsTab(bool isDark) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark
                  ? AppTheme.surfaceColorDark
                  : AppTheme.surfaceColorLight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Todos', 'todos', _serverFilter, (value) {
                      setState(() => _serverFilter = value);
                    }, isDark),
                    _buildFilterChip('200 ✓', '200', _serverFilter, (value) {
                      setState(() => _serverFilter = value);
                    }, isDark),
                    _buildFilterChip('400 ⚠', '400', _serverFilter, (value) {
                      setState(() => _serverFilter = value);
                    }, isDark),
                    _buildFilterChip('500 ✗', '500', _serverFilter, (value) {
                      setState(() => _serverFilter = value);
                    }, isDark),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_queue,
                      size: 80,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Logs del Servidor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Próximamente disponible',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAgendaLogsTab(bool isDark) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        var logs = provider.agendaLogs;

        if (_agendaFilter != 'todos') {
          logs = logs.where((log) => log.estado == _agendaFilter).toList();
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark
                  ? AppTheme.surfaceColorDark
                  : AppTheme.surfaceColorLight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Todos', 'todos', _agendaFilter, (value) {
                      setState(() => _agendaFilter = value);
                    }, isDark),
                    _buildFilterChip(
                        'Completados ✓', 'completado', _agendaFilter, (value) {
                      setState(() => _agendaFilter = value);
                    }, isDark),
                    _buildFilterChip('Iniciados ⟳', 'iniciado', _agendaFilter,
                        (value) {
                      setState(() => _agendaFilter = value);
                    }, isDark),
                    _buildFilterChip('Errores ✗', 'error', _agendaFilter,
                        (value) {
                      setState(() => _agendaFilter = value);
                    }, isDark),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.loadAgendaLogs(),
                color: isDark
                    ? AppTheme.primaryColorDark
                    : AppTheme.primaryColorLight,
                child: logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 80,
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay logs disponibles',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return LogItem(log: logs[index]);
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, String currentFilter,
      Function(String) onSelected, bool isDark) {
    final isSelected = currentFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(value),
        backgroundColor: isDark ? AppTheme.cardColorDark : Colors.grey[100],
        selectedColor:
            (isDark ? AppTheme.primaryColorDark : AppTheme.primaryColorLight)
                .withOpacity(0.2),
        checkmarkColor:
            isDark ? AppTheme.primaryColorDark : AppTheme.primaryColorLight,
        labelStyle: TextStyle(
          color: isSelected
              ? (isDark
                  ? AppTheme.primaryColorDark
                  : AppTheme.primaryColorLight)
              : (isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
