import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/baja_model.dart';

class BajaCardWidget extends StatelessWidget {
  final BajaModel baja;
  final VoidCallback onProcesar;
  final bool canProcess;

  const BajaCardWidget({
    Key? key,
    required this.baja,
    required this.onProcesar,
    required this.canProcess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardTheme.color;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;

    final statusInfo = _getStatusInfo(baja.dateStatus);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y badge
            Row(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        baja.employeeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Núm. Empleado: ${baja.numemp}',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusInfo['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusInfo['label'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusInfo['color'],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            // Información de la baja
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de baja',
              _formatDate(baja.dischargeDate),
              secondaryTextColor,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.badge,
              'Plaza',
              baja.numpla,
              secondaryTextColor,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.work_outline,
              'Proyecto',
              baja.proyecto,
              secondaryTextColor,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.info_outline,
              'Motivo',
              baja.reason,
              secondaryTextColor,
            ),
            if (canProcess) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onProcesar,
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: const Text('Procesar Baja'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'today':
        return {
          'label': 'Hoy',
          'color': AppTheme.successColor,
        };
      case 'past':
        return {
          'label': 'Pasada',
          'color': AppTheme.errorColor,
        };
      case 'future':
        return {
          'label': 'Futura',
          'color': AppTheme.warningColor,
        };
      default:
        return {
          'label': 'Pendiente',
          'color': AppTheme.infoColor,
        };
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
