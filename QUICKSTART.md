# SIRH Monitor - Guía Rápida de Inicio

## 🚀 Inicio Rápido

### 1. Verificar Flutter

```powershell
flutter doctor -v
```

### 2. Instalar Dependencias

```powershell
cd C:\SIRH-IOS-ANDROID-APP
flutter pub get
```

### 3. Ejecutar en Modo Debug

```powershell
# Android
flutter run

# Windows (para pruebas)
flutter run -d windows

# Web (para pruebas)
flutter run -d chrome
```

### 4. Compilar para Producción

```powershell
# Android APK
flutter build apk --release

# El archivo estará en:
# build\app\outputs\flutter-apk\app-release.apk
```

## 📱 Instalar en Dispositivo Android

### Método 1: Depuración USB

1. Conectar dispositivo Android por USB
2. Habilitar "Depuración USB" en opciones de desarrollador
3. Ejecutar: `flutter run`

### Método 2: Instalar APK compilado

1. Compilar: `flutter build apk --release`
2. Copiar `app-release.apk` al dispositivo
3. Instalar el APK desde el explorador de archivos

## ⚙️ Configuración Importante

### Cambiar URL del Servidor

Editar: `lib/config/constants.dart`

```dart
// Línea 4:
static const String baseUrl = 'http://172.31.240.193:3000/api/mobile/monitor';
```

### Para desarrollo local:

```dart
// Usar la IP de tu máquina, no localhost
static const String baseUrl = 'http://172.31.240.193:3000/api/mobile/monitor';
```

## 🔑 Credenciales de Prueba

Las mismas que usas para el sistema SIRH web.

## ❓ Problemas Comunes

### "Flutter no reconocido"

```powershell
# Instalar Flutter desde:
# https://docs.flutter.dev/get-started/install/windows

# Agregar al PATH:
# C:\src\flutter\bin
```

### "No devices found"

```powershell
# Ver dispositivos disponibles
flutter devices

# Crear un emulador Android
flutter emulators --launch <emulator_id>
```

### Error de dependencias

```powershell
flutter clean
flutter pub get
```

## 📞 Soporte

Ver `README.md` completo para más información detallada.
