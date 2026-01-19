# 🔧 COMANDOS ÚTILES - SIRH MOBILE APP

## 📱 COMANDOS FLUTTER

### Instalación y Setup

```powershell
# Verificar instalación de Flutter
flutter doctor
flutter doctor -v

# Instalar dependencias del proyecto
cd C:\SIRH-IOS-ANDROID-APP
flutter pub get

# Actualizar dependencias
flutter pub upgrade

# Limpiar proyecto
flutter clean
```

### Ejecutar Aplicación

```powershell
# Listar dispositivos disponibles
flutter devices

# Ejecutar en modo debug (dispositivo predeterminado)
flutter run

# Ejecutar en un dispositivo específico
flutter run -d <device_id>

# Ejecutar en Windows (para pruebas)
flutter run -d windows

# Ejecutar en Chrome (para pruebas)
flutter run -d chrome

# Ejecutar con hot reload activado
flutter run --hot
```

### Compilar para Producción

```powershell
# Android APK (más pesado pero compatible)
flutter build apk --release

# Android App Bundle (optimizado para Google Play)
flutter build appbundle --release

# Ver tamaño del APK
flutter build apk --analyze-size

# Compilar con ofuscación (más seguro)
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

### Emuladores Android

```powershell
# Listar emuladores disponibles
flutter emulators

# Crear nuevo emulador
flutter emulators --create

# Iniciar un emulador
flutter emulators --launch <emulator_id>

# Ejemplo
flutter emulators --launch Pixel_5_API_30
```

### Debugging

```powershell
# Modo verbose (más información)
flutter run -v

# Ver logs en tiempo real
flutter logs

# Analizar rendimiento
flutter run --profile

# Ver árbol de widgets
flutter run --debug
# Luego presiona 'w' en la terminal
```

### Comandos en Ejecución

```
Durante flutter run, puedes presionar:

r  - Hot reload (recarga rápida)
R  - Hot restart (reinicio completo)
h  - Ayuda
q  - Salir
w  - Ver árbol de widgets
p  - Ver árbol de renderizado
o  - Cambiar entre Android y iOS
```

---

## 🖥️ COMANDOS BACKEND

### Servidor Node.js

```powershell
# Navegar al directorio
cd C:\SIRH-NODE\backendSIRH

# Instalar dependencias (si faltan)
npm install

# Instalar dependencias para móvil
npm install jsonwebtoken bcrypt

# Iniciar servidor (modo desarrollo)
npm run dev

# Iniciar servidor (modo producción)
npm start

# Ver logs en tiempo real
npm run dev | tee logs.txt
```

### Variables de Entorno

```powershell
# Ver variables configuradas
Get-Content .env

# Editar variables
notepad .env

# Agregar IP a whitelist
Add-Content .env "ALLOWED_IPS=192.168.1.100,*"
```

### MongoDB

```powershell
# Conectar a MongoDB (si tienes mongo cli)
mongo "mongodb://localhost:27017/sirh"

# Ver colecciones
show collections

# Ver usuarios
db.USERS.find().pretty()

# Crear usuario de prueba
db.USERS.insertOne({
  username: "admin",
  password: "$2b$10$...", // hash bcrypt
  email: "admin@sirh.com",
  role: "admin"
})
```

---

## 🌐 COMANDOS DE RED

### Obtener tu IP

```powershell
# Windows - PowerShell
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -like "*Wi-Fi*" -or $_.InterfaceAlias -like "*Ethernet*"}

# Forma simple
ipconfig | Select-String "IPv4"

# Ver todas las IPs
ipconfig /all
```

### Probar Conexión

```powershell
# Ping al servidor
Test-Connection 192.168.1.100

# Verificar puerto abierto
Test-NetConnection -ComputerName 192.168.1.100 -Port 3000

# cURL a la API
Invoke-RestMethod -Uri "http://localhost:3000/api/mobile/monitor/server/health" -Headers @{Authorization="Bearer token"}
```

---

## 📦 GESTIÓN DE PAQUETES

### Flutter Packages

```powershell
# Buscar un paquete
flutter pub search <nombre>

# Agregar paquete
flutter pub add <nombre>

# Ejemplo: agregar dio
flutter pub add dio

# Remover paquete
flutter pub remove <nombre>

# Ver paquetes instalados
flutter pub deps
```

### NPM Packages (Backend)

```powershell
cd C:\SIRH-NODE\backendSIRH

# Instalar paquete
npm install <nombre>

# Instalar paquete de desarrollo
npm install -D <nombre>

# Ver paquetes instalados
npm list

# Actualizar paquetes
npm update
```

---

## 🔍 ANÁLISIS Y TESTING

### Flutter Analysis

```powershell
# Analizar código
flutter analyze

# Formatear código
flutter format lib/

# Verificar rendimiento
flutter run --profile

# Ejecutar tests
flutter test

# Cobertura de tests
flutter test --coverage
```

### Inspeccionar APK

```powershell
# Ubicación del APK
cd build\app\outputs\flutter-apk

# Ver tamaño
Get-ChildItem app-release.apk | Select-Object Name, Length

# Instalar APK en dispositivo conectado
adb install app-release.apk
```

---

## 🔧 UTILIDADES

### ADB (Android Debug Bridge)

```powershell
# Listar dispositivos
adb devices

# Instalar APK
adb install ruta\al\archivo.apk

# Ver logs del dispositivo
adb logcat

# Captura de pantalla
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png

# Desinstalar app
adb uninstall com.sirh.sirh_monitor
```

### Git

```powershell
# Inicializar repositorio
cd C:\SIRH-IOS-ANDROID-APP
git init

# Agregar archivos
git add .

# Commit
git commit -m "Initial commit: Flutter SIRH Mobile App"

# Ver estado
git status

# Ver diferencias
git diff
```

---

## 📊 MONITOREO

### Monitor del Servidor

```powershell
# Ver procesos de Node.js
Get-Process -Name node

# Matar proceso si es necesario
Stop-Process -Name node

# Ver uso de puertos
netstat -ano | findstr :3000
```

### Monitor de la App

```powershell
# Durante flutter run:
flutter run --verbose

# Ver uso de memoria
flutter run --profile
# Luego abrir DevTools
```

---

## 🚀 DEPLOY

### Android (Google Play)

```powershell
# 1. Compilar App Bundle
flutter build appbundle --release

# 2. Firmar (si no está firmado)
# Ver: https://docs.flutter.dev/deployment/android

# 3. Ubicación del bundle
# build\app\outputs\bundle\release\app-release.aab
```

### iOS (App Store)

```bash
# Solo en macOS
flutter build ios --release

# Abrir Xcode
open ios/Runner.xcworkspace
```

---

## 🐛 DEBUG Y TROUBLESHOOTING

### Limpiar Todo

```powershell
# Flutter
flutter clean
flutter pub get

# Backend
cd C:\SIRH-NODE\backendSIRH
Remove-Item node_modules -Recurse -Force
npm install
```

### Resetear Flutter

```powershell
flutter clean
flutter pub cache clean
flutter pub get
```

### Logs Detallados

```powershell
# Flutter con logs completos
flutter run -v > logs.txt 2>&1

# Backend con logs
npm run dev > server-logs.txt 2>&1
```

---

## 📝 SHORTCUTS ÚTILES

### VS Code

```
Ctrl + Shift + P  - Comando palette
Ctrl + `          - Terminal
Ctrl + Space      - Autocompletar
F5                - Debug
Ctrl + K, Ctrl + F - Formatear
```

### Android Studio

```
Shift + F10       - Run
Alt + Enter       - Quick fix
Ctrl + Alt + L    - Formatear código
Double Shift      - Buscar todo
```

---

## 📚 RECURSOS RÁPIDOS

```powershell
# Documentación Flutter
start https://docs.flutter.dev/

# Material Design
start https://m3.material.io/

# Pub.dev (paquetes)
start https://pub.dev/

# GitHub Copilot Chat
# Pregunta sobre Flutter/Dart directamente
```

---

## 🎯 CHEAT SHEET RÁPIDO

```powershell
# Setup inicial
flutter doctor
cd C:\SIRH-IOS-ANDROID-APP
flutter pub get

# Ejecutar
flutter run

# Hot reload (durante ejecución)
# Presionar 'r'

# Compilar APK
flutter build apk --release

# Backend
cd C:\SIRH-NODE\backendSIRH
npm run dev

# Ver tu IP
ipconfig | Select-String "IPv4"

# Probar API
Invoke-RestMethod http://localhost:3000/api/mobile/monitor/server/health
```

---

**¡Guarda este archivo para referencia rápida!** 📌
