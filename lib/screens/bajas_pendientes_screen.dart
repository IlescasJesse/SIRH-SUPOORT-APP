import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/baja_model.dart';
import '../services/api_service.dart';
import '../widgets/baja_card_widget.dart';
import '../providers/app_provider.dart';

class BajasPendientesScreen extends StatefulWidget {
  const BajasPendientesScreen({Key? key}) : super(key: key);

  @override
  State<BajasPendientesScreen> createState() => _BajasPendientesScreenState();
}

class _BajasPendientesScreenState extends State<BajasPendientesScreen> {
  final ApiService _apiService = ApiService();
  List<BajaModel> _bajas = [];
  List<BajaModel> _bajasFiltered = [];
  bool _isLoading = true;
  String _selectedFilter = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBajas();
    _searchController.addListener(_filterBajas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBajas() async {
    setState(() => _isLoading = true);
    try {
      final bajasData = await _apiService.getBajasPendientes();
      setState(() {
        _bajas = bajasData.map((data) => BajaModel.fromJson(data)).toList();
        _filterBajas();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);

      // Si es error de sesión, redirigir al login
      if (e.toString().contains('401') ||
          e.toString().contains('Sesión expirada') ||
          e.toString().contains('expirada')) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar bajas: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _filterBajas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _bajasFiltered = _bajas.where((baja) {
        final matchesSearch = baja.employeeName.toLowerCase().contains(query) ||
            baja.numemp.toLowerCase().contains(query);

        final matchesFilter = _selectedFilter == 'Todas' ||
            ((_selectedFilter == 'Hoy' && baja.dateStatus == 'today') ||
                (_selectedFilter == 'Pasadas' && baja.dateStatus == 'past') ||
                (_selectedFilter == 'Futuras' && baja.dateStatus == 'future'));

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  Future<void> _procesarBaja(BajaModel baja) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Proceso'),
        content: Text(
          '¿Estás seguro de procesar la baja de ${baja.employeeName}?\n\n'
          'Esta acción no se puede deshacer.',
        ),
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
            child: const Text('Procesar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

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
                Text('Procesando baja...'),
              ],
            ),
          ),
        ),
      ),
    );

    final result = await _apiService.ejecutarBaja(baja.id);

    if (mounted) {
      Navigator.pop(context); // Cerrar loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Operación completada'),
          backgroundColor:
              result['success'] ? AppTheme.successColor : AppTheme.errorColor,
        ),
      );

      if (result['success']) {
        _loadBajas(); // Recargar lista
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final canProcess = true; // Todos pueden procesar bajas

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bajas Pendientes'),
            Text(
              '${_bajasFiltered.length} baja(s)',
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBajas,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o número de empleado',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Todas'),
                const SizedBox(width: 8),
                _buildFilterChip('Hoy'),
                const SizedBox(width: 8),
                _buildFilterChip('Pasadas'),
                const SizedBox(width: 8),
                _buildFilterChip('Futuras'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Lista de bajas
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _bajasFiltered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _bajas.isEmpty
                                  ? 'No hay bajas pendientes'
                                  : 'No se encontraron bajas con los filtros aplicados',
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadBajas,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _bajasFiltered.length,
                          itemBuilder: (context, index) {
                            final baja = _bajasFiltered[index];
                            return BajaCardWidget(
                              baja: baja,
                              canProcess: canProcess,
                              onProcesar: () => _procesarBaja(baja),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadBajas,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
          _filterBajas();
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
