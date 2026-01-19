import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _serverUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _serverUrlController.text = AppConstants.baseUrl;
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Perfil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.username ?? 'Usuario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        user?.role.toUpperCase() ?? 'USER',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.3),
                      labelStyle:
                          const TextStyle(color: AppTheme.secondaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Configuración
            Text(
              'Configuración',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.color_lens,
                        color: AppTheme.primaryColor),
                    title: const Text('Tema'),
                    subtitle: Text(Provider.of<AppProvider>(context).isDarkMode
                        ? 'Modo Oscuro'
                        : 'Modo Claro'),
                    trailing: Switch(
                      value: Provider.of<AppProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<AppProvider>(context, listen: false)
                            .toggleTheme();
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications,
                        color: AppTheme.primaryColor),
                    title: const Text('Notificaciones'),
                    subtitle: const Text('Activadas'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: AppTheme.primaryColor,
                    ),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.sync, color: AppTheme.primaryColor),
                    title: Text('Actualización en tiempo real'),
                    subtitle: Text('Datos actualizándose cada 5 segundos'),
                    trailing:
                        Icon(Icons.check_circle, color: AppTheme.successColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Servidor
            const Text(
              'Conexión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URL del Servidor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _serverUrlController,
                      decoration: const InputDecoration(
                        hintText: 'https://tu-servidor.com',
                        prefixIcon:
                            Icon(Icons.link, color: AppTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.apiService
                              .setBaseUrl(_serverUrlController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL del servidor actualizada'),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                        },
                        child: const Text('Guardar URL'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Admin
            Text(
              'Administración',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.refresh, color: AppTheme.warningColor),
                    title: const Text('Resetear Servidor'),
                    subtitle:
                        const Text('Reiniciar backend (requiere confirmación)'),
                    trailing: const Icon(Icons.lock_outline,
                        color: AppTheme.warningColor),
                    onTap: () => _showResetServerDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Información
            const Text(
              'Información',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info, color: AppTheme.infoColor),
                    title: Text('Versión'),
                    trailing: Text('1.0.0',
                        style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.code, color: AppTheme.infoColor),
                    title: Text('Build'),
                    trailing: Text('1',
                        style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description,
                        color: AppTheme.infoColor),
                    title: const Text('Licencia'),
                    trailing: const Text('MIT',
                        style: TextStyle(color: AppTheme.textSecondary)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Cerrar sesión
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content: const Text('¿Estás seguro de cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                          ),
                          child: const Text('Cerrar Sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    await provider.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  void _showResetServerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: AppTheme.warningColor, size: 48),
        title: const Text('⚠️ Resetear Servidor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas reiniciar el servidor?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Esta acción:'),
            const SizedBox(height: 8),
            _buildWarningItem('Reiniciará el backend'),
            _buildWarningItem('Puede desconectar usuarios activos'),
            _buildWarningItem('Tomará unos segundos en completarse'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock, color: AppTheme.warningColor, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Acción protegida',
                      style: TextStyle(
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmResetServer(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.arrow_right,
              size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _confirmResetServer(BuildContext context) async {
    // Diálogo de confirmación final con código
    final codeController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación de Seguridad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Para confirmar, escribe: RESET'),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Código de confirmación',
                hintText: 'RESET',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.security),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeController.text.toUpperCase() == 'RESET') {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Código incorrecto'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Resetear Servidor'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _executeReset(context);
    }
  }

  void _executeReset(BuildContext context) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Reseteando servidor...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Ejecutar reset
    final provider = Provider.of<AppProvider>(context, listen: false);
    final result = await provider.resetServer();

    // Cerrar loading
    Navigator.pop(context);

    // Mostrar resultado
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          result['success'] ? Icons.check_circle : Icons.error,
          color:
              result['success'] ? AppTheme.successColor : AppTheme.errorColor,
          size: 48,
        ),
        title: Text(result['success'] ? 'Éxito' : 'Error'),
        content: Text(result['success']
            ? 'Servidor reiniciándose...\nEspera 10-15 segundos'
            : result['message'] ?? 'Error al resetear servidor'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    // Si fue exitoso, esperar 15 segundos y reconectar
    if (result['success']) {
      await Future.delayed(const Duration(seconds: 15));
      // El auto-refresh se encargará de reconectar automáticamente
    }
  }
}
