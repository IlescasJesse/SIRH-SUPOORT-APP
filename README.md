# SIRH Monitor - Aplicación Móvil

Aplicación móvil multiplataforma (Android/iOS) desarrollada en Flutter para monitorear y controlar el sistema SIRH.

## 🎨 Características

- ✅ Diseño moderno en **Modo Oscuro**
- 📊 Dashboard con estadísticas en tiempo real
- 🔄 Ejecución remota de tareas de Agenda
- 📝 Visualización de logs detallados
- 🔒 Autenticación segura con JWT
- 🌐 Control de acceso por IP Whitelist
- 🎯 Material Design 3

## 📋 Requisitos Previos

### Flutter SDK

1. Descargar Flutter desde: https://docs.flutter.dev/get-started/install/windows
2. Extraer el archivo ZIP en `C:\src\flutter`
3. Agregar `C:\src\flutter\bin` al PATH del sistema

### Android Studio (para Android)

1. Descargar desde: https://developer.android.com/studio
2. Instalar Android SDK
3. Crear un dispositivo virtual (AVD)

### Xcode (para iOS - solo macOS)

1. Instalar desde App Store
2. Configurar simuladores iOS

## 🚀 Instalación

### 1. Verificar Instalación de Flutter

```powershell
flutter doctor
```

Esto verificará todas las dependencias necesarias.

### 2. Instalar Dependencias del Proyecto

```powershell
cd C:\SIRH-IOS-ANDROID-APP
flutter pub get
```

### 3. Configurar la URL del Servidor

Editar `lib/config/constants.dart`:

```dart
// Cambiar a tu servidorz
static const String baseUrl = 'https://tu-servidor.com/api/mobile/monitor';

// O para desarrollo local:
// static const String baseUrl = 'http://192.168.1.100:3000/api/mobile/monitor';
```

## ▶️ Ejecutar la Aplicación

### Android

#### Usando un Emulador:

```powershell
# Listar emuladores disponibles
flutter emulators

# Iniciar un emulador
flutter emulators --launch <emulator_id>

# Ejecutar la app
flutter run
```

#### Usando un Dispositivo Físico:

1. Habilitar **Opciones de desarrollador** en Android
2. Activar **Depuración USB**
3. Conectar el dispositivo por USB
4. Ejecutar:

```powershell
flutter devices
flutter run
```

### iOS (Solo macOS)

```bash
# Abrir simulador iOS
open -a Simulator

# Ejecutar la app
flutter run
```

### Windows (Desarrollo)

```powershell
flutter run -d windows
```

### Web (Desarrollo)

```powershell
flutter run -d chrome
```

## 🏗️ Compilar para Producción

### Android APK

```powershell
flutter build apk --release
```

El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (para Google Play)

```powershell
flutter build appbundle --release
```

### iOS (Solo macOS)

```bash
flutter build ios --release
```

## 📱 Estructura del Proyecto

```
lib/
├── main.dart                  # Punto de entrada
├── config/
│   ├── theme.dart            # Tema oscuro personalizado
│   └── constants.dart        # Constantes y configuración
├── models/
│   ├── user_model.dart       # Modelo de usuario
│   ├── dashboard_model.dart  # Modelo del dashboard
│   └── agenda_log_model.dart # Modelo de logs
├── services/
│   ├── api_service.dart      # Cliente HTTP para API
│   └── auth_service.dart     # Servicio de autenticación
├── providers/
│   └── app_provider.dart     # Estado global de la app
├── screens/
│   ├── splash_screen.dart    # Pantalla de inicio
│   ├── login_screen.dart     # Pantalla de login
│   ├── dashboard_screen.dart # Dashboard principal
│   ├── agenda_screen.dart    # Gestión de tareas
│   ├── logs_screen.dart      # Visualización de logs
│   └── settings_screen.dart  # Configuración
└── widgets/
    ├── stat_card.dart        # Tarjeta de estadística
    ├── agenda_task_card.dart # Tarjeta de tarea
    └── log_item.dart         # Item de log expandible
```

## 🎨 Paleta de Colores (Modo Oscuro)

| Color      | Hex       | Uso                   |
| ---------- | --------- | --------------------- |
| Primary    | `#00D9FF` | Acentos principales   |
| Secondary  | `#6C63FF` | Elementos secundarios |
| Accent     | `#FF6584` | Destacados            |
| Background | `#0A0E21` | Fondo principal       |
| Surface    | `#1D1E33` | Superficies elevadas  |
| Card       | `#282A40` | Tarjetas              |
| Success    | `#4CAF50` | Éxito                 |
| Warning    | `#FFA726` | Advertencia           |
| Error      | `#EF5350` | Error                 |
| Info       | `#29B6F6` | Información           |

## 🔧 Configuración del Backend

### 1. Crear Middleware de IP Whitelist

Crear archivo: `src/middleware/ipWhitelist.js` en el backend.

### 2. Crear Rutas Móviles

Crear archivo: `src/routes/monitor/mobile.routes.js` en el backend.

### 3. Actualizar app.js

```javascript
// Agregar ruta móvil
app.use("/api/mobile/monitor", require("./routes/monitor/mobile.routes"));
```

### 4. Configurar Variables de Entorno

En el archivo `.env` del backend:

```env
# IPs permitidas (separadas por comas)
ALLOWED_IPS=192.168.1.100,10.0.0.50

# Permitir todas en desarrollo
# ALLOWED_IPS=*
```

## 🔐 Seguridad

- **JWT Authentication**: Tokens seguros para cada sesión
- **IP Whitelist**: Solo IPs autorizadas pueden conectarse
- **HTTPS**: Usar siempre en producción
- **Secure Storage**: Tokens guardados de forma segura

## 🐛 Solución de Problemas

### Error: "Flutter command not found"

```powershell
# Verificar que Flutter esté en el PATH
$env:Path -split ';' | Select-String flutter

# Si no está, agregarlo temporalmente:
$env:Path += ";C:\src\flutter\bin"
```

### Error: "No connected devices"

```powershell
# Verificar dispositivos
flutter devices

# Iniciar emulador
flutter emulators --launch <emulator_id>
```

### Error de dependencias

```powershell
# Limpiar y reinstalar
flutter clean
flutter pub get
```

### Hot Reload no funciona

Presiona `r` en la terminal para hot reload o `R` para hot restart.

## 📚 Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Material Design 3](https://m3.material.io/)
- [Dart Language](https://dart.dev/)
- [Provider State Management](https://pub.dev/packages/provider)

## 🤝 Uso de la App

### 1. Login

- Usuario y contraseña del sistema SIRH
- La app valida las credenciales con el backend

### 2. Dashboard

- Ver estadísticas generales
- Estado del servidor
- Actividad reciente

### 3. Agenda

- Ejecutar tareas programadas manualmente
- Ver estadísticas de cada tarea

### 4. Logs

- Ver historial detallado de ejecuciones
- Filtrar por estado (completado, error, etc.)
- Expandir para ver detalles completos

### 5. Ajustes

- Cambiar URL del servidor
- Configurar notificaciones
- Cerrar sesión

## 📝 Notas Importantes

1. **Modo Desarrollo**: La app puede conectarse a `localhost` usando la IP de tu máquina
2. **Producción**: Usar siempre HTTPS y configurar correctamente las IPs permitidas
3. **Permisos**: La app requiere permisos de internet
4. **Compatibilidad**: Requiere Android 5.0+ (API 21+) o iOS 11+

## 🎯 Próximas Características

- [ ] Notificaciones push
- [ ] Modo claro/oscuro configurable
- [ ] Gráficos de rendimiento
- [ ] Exportar logs a PDF
- [ ] Biometría para login
- [ ] Soporte para múltiples servidores

---

**Versión**: 1.0.0  
**Desarrollado con**: Flutter 3.x  
**Licencia**: MIT
