# Gestión de Bajas Extemporáneas - Implementación

## ✅ Archivos Creados

### 1. Modelo de Datos

**`lib/models/baja_model.dart`**

- Clase `BajaModel` con todos los campos necesarios
- Método `fromJson()` para parsear datos de API
- Propiedad `dateStatus` que calcula si la baja es: hoy, pasada o futura

### 2. Widget de Card

**`lib/widgets/baja_card_widget.dart`**

- Card individual para mostrar información de cada baja
- Badges de color según el estado (Hoy/Pasada/Futura)
- Botón "Procesar Baja" (solo visible para admin/superadmin)
- Soporte para modo claro y oscuro

### 3. Pantalla Principal

**`lib/screens/bajas_pendientes_screen.dart`**

- Lista de bajas pendientes con scroll
- Barra de búsqueda por nombre o número de empleado
- Filtros por chips: Todas, Hoy, Pasadas, Futuras
- Contador de bajas en el AppBar
- Pull to refresh
- Dialog de confirmación antes de procesar
- Loading indicator durante el proceso
- Snackbar con resultado de la operación

### 4. Servicios API

**`lib/services/api_service.dart`** (actualizado)

- `getBajasPendientes()`: GET /api/mobile/monitor/bajas/pendientes
- `ejecutarBaja(int bajaId)`: POST /api/mobile/monitor/bajas/ejecutar/:bajaId
- Manejo de errores 401, 404, etc.

### 5. Navegación

**`lib/screens/dashboard_screen.dart`** (actualizado)

- Card de acceso rápido a "Bajas Pendientes" en el dashboard
- Navegación directa con Navigator.push()

## 🎨 Características Implementadas

### Visualización

- ✅ Cards con diseño atractivo
- ✅ Badges de color según estado de fecha
- ✅ Iconos descriptivos
- ✅ Soporte modo claro/oscuro
- ✅ Contador de bajas en AppBar

### Funcionalidad

- ✅ Búsqueda en tiempo real
- ✅ Filtros por estado de fecha
- ✅ Pull to refresh
- ✅ Botón flotante de refresh
- ✅ Dialog de confirmación
- ✅ Loading durante proceso
- ✅ Snackbar con resultado

### Seguridad

- ✅ Botón "Procesar" solo visible para admin/superadmin
- ✅ Verificación de permisos en UI
- ✅ Manejo de token expirado
- ✅ Confirmación antes de procesar

### UX

- ✅ Mensajes claros de error
- ✅ Estados de carga
- ✅ Feedback visual inmediato
- ✅ Recarga automática tras procesar
- ✅ Animaciones smooth

## 📱 Cómo Usar

### 1. Acceso desde Dashboard

```dart
// En el dashboard hay un card "Bajas Pendientes"
// Toca el card para ir a la pantalla
```

### 2. Buscar Bajas

```dart
// Usa la barra de búsqueda superior
// Busca por nombre o número de empleado
```

### 3. Filtrar por Fecha

```dart
// Toca los chips: Todas, Hoy, Pasadas, Futuras
// La lista se actualiza automáticamente
```

### 4. Procesar una Baja

```dart
// Solo si eres admin/superadmin verás el botón
// Toca "Procesar Baja"
// Confirma en el dialog
// Espera el resultado
```

## 🔧 Endpoints Requeridos en Backend

### GET /api/mobile/monitor/bajas/pendientes

```json
{
  "bajas": [
    {
      "id": 1,
      "employee_name": "Juan Pérez",
      "numemp": "12345",
      "discharge_date": "2026-01-16",
      "reason": "Renuncia voluntaria",
      "numpla": "PL001",
      "status": "pending"
    }
  ]
}
```

### POST /api/mobile/monitor/bajas/ejecutar/:bajaId

```json
// Response exitoso:
{
  "success": true,
  "message": "Baja procesada exitosamente"
}

// Response error:
{
  "success": false,
  "message": "Error al procesar la baja"
}
```

## 🎯 Estados de Badge

| Estado     | Color             | Condición             |
| ---------- | ----------------- | --------------------- |
| **Hoy**    | Verde (success)   | discharge_date es hoy |
| **Pasada** | Rojo (error)      | discharge_date < hoy  |
| **Futura** | Naranja (warning) | discharge_date > hoy  |

## 🔒 Control de Permisos

```dart
final canProcess = provider.currentUser?.role == 'admin' ||
                  provider.currentUser?.role == 'superadmin';
```

Solo los usuarios admin y superadmin pueden ver y usar el botón "Procesar Baja".

## 📊 Campos del Modelo

```dart
class BajaModel {
  int id;                    // ID único de la baja
  String employeeName;       // Nombre del empleado
  String numemp;            // Número de empleado (NUMEMP)
  DateTime dischargeDate;   // Fecha de baja
  String reason;            // Motivo de la baja
  String numpla;            // Número de plaza (NUMPLA)
  String status;            // Estado: pending, processed, etc.
}
```

## 🚀 Próximos Pasos

Para que funcione completamente, el backend debe:

1. Implementar GET `/api/mobile/monitor/bajas/pendientes`

   - Retornar lista de bajas con status "pending"
   - Incluir todos los campos requeridos

2. Implementar POST `/api/mobile/monitor/bajas/ejecutar/:bajaId`

   - Verificar permisos del usuario
   - Procesar la baja en el sistema
   - Retornar success/error con mensaje

3. Proteger endpoints con autenticación JWT
   - Verificar rol admin/superadmin para POST

## 💡 Notas de Implementación

- La pantalla usa `Provider` para obtener el usuario actual
- Los colores se adaptan automáticamente al tema (claro/oscuro)
- El botón flotante permite refrescar en cualquier momento
- La búsqueda filtra por nombre y número de empleado simultáneamente
- Los filtros y búsqueda se pueden combinar

## 🐛 Manejo de Errores

- **401**: Sesión expirada → muestra error en snackbar
- **404**: Baja no encontrada → mensaje informativo
- **SocketException**: Sin conexión → mensaje de error de red
- Otros errores → mensaje genérico con detalles
