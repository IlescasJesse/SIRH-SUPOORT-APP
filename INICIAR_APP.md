# 🚀 Guía de Inicio Rápido - SIRH App

## ✅ Pre-requisitos Verificados

Tu instalación actual de Flutter:

- ✅ Flutter 3.38.6 instalado
- ✅ Dart 3.10.7
- ✅ Chrome disponible
- ✅ Edge disponible
- ✅ Windows Desktop disponible

## 📱 Dispositivos Disponibles

Puedes ejecutar la app en estos dispositivos:

### 1️⃣ Chrome (Navegador Web) - **RECOMENDADO**

```powershell
flutter run -d chrome
```

### 2️⃣ Edge (Navegador Web)

```powershell
flutter run -d edge
```

### 3️⃣ Windows (Aplicación Desktop)

⚠️ Requiere Visual Studio con "Desktop development with C++" instalado

```powershell
flutter run -d windows
```

## 🎯 Iniciar la Aplicación - Paso a Paso

### Opción 1: Desde la Terminal de VSCode (RECOMENDADO)

1. Abre la terminal en VSCode (`` Ctrl + ` ``)
2. Asegúrate de estar en el directorio del proyecto:
   ```powershell
   cd C:\SIRH-IOS-ANDROID-APP
   ```
3. Instala/actualiza dependencias:
   ```powershell
   flutter pub get
   ```
4. Ejecuta la app en Chrome:
   ```powershell
   flutter run -d chrome
   ```

### Opción 2: Usar el Debugger de VSCode

1. Presiona `F5` o ve a **Run > Start Debugging**
2. Selecciona el dispositivo (Chrome, Edge o Windows)
3. La app se compilará y ejecutará automáticamente

## 🔍 Ver Dispositivos Disponibles

Para ver todos los dispositivos conectados:

```powershell
flutter devices
```

## 🛠️ Comandos Útiles

### Instalar dependencias

```powershell
flutter pub get
```

### Limpiar proyecto (si hay errores)

```powershell
flutter clean
flutter pub get
```

### Ver versión de Flutter

```powershell
flutter --version
```

### Modo Hot Reload

Una vez que la app esté corriendo:

- Presiona `r` en la terminal para hot reload
- Presiona `R` para hot restart
- Presiona `q` para salir

## ⚡ Modo Release (Optimizado)

Para mejor rendimiento en producción:

```powershell
# Chrome
flutter run -d chrome --release

# Edge
flutter run -d edge --release

# Windows
flutter run -d windows --release
```

## 🐛 Solución de Problemas

### Si Flutter no se reconoce en terminal externa de Windows:

1. Cierra todas las terminales de Windows
2. Abre una nueva terminal PowerShell
3. Si persiste, reinicia tu PC

### Si hay errores de compilación:

```powershell
flutter clean
flutter pub get
flutter run -d chrome
```

### Si Chrome no abre:

```powershell
# Verifica que Chrome esté instalado
flutter run -d edge  # Usa Edge como alternativa
```

## 📝 Notas Importantes

- **Primera ejecución**: La primera vez tardará más (compila todo)
- **Hot Reload**: Cambios posteriores son instantáneos
- **Puerto por defecto**: La app web corre en http://localhost:XXXXX
- **Mejor experiencia**: Usa Chrome para desarrollo web

## 🎨 Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada
├── screens/              # Pantallas de la app
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   └── ...
├── services/             # Servicios (API, Auth)
├── models/               # Modelos de datos
└── widgets/              # Componentes reutilizables
```

## 🔗 Enlaces Útiles

- [Documentación Flutter](https://flutter.dev/docs)
- [API del Proyecto](https://api.sirh.com) _(ajusta según tu API)_
- [Comandos útiles](./COMANDOS_UTILES.md)

---

**¿Listo para empezar?** Ejecuta:

```powershell
flutter run -d chrome
```
