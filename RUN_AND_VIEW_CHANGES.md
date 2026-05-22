# Guia para ejecutar el proyecto y ver cambios

Esta guia deja el entorno en el mismo estado que usamos para correr la app:

- Backend NestJS conectado a Supabase
- Flutter en Android Emulator
- Solucion a errores comunes (Gradle cache, NDK corrupto, poco espacio)

## 1) Backend (NestJS)

Ir a la carpeta backend e instalar dependencias:

```powershell
cd d:\proyectominiso\backend
npm install
```

Configurar `backend/.env` con Supabase (ejemplo):

```env
DB_HOST=aws-1-us-east-1.pooler.supabase.com
DB_PORT=6543
DB_USER=postgres.hleyhnmbaqkhyunbmsaa
DB_PASS=TU_PASSWORD
DB_NAME=postgres
DB_SSL=true
PORT=3000
```

Levantar backend:

```powershell
cd d:\proyectominiso\backend
npm run start:dev
```

Probar endpoint:

```powershell
curl http://localhost:3000/products
```

Si responde `200` con `[]` o lista de productos, backend OK.

## 2) Flutter SDK y Android

Si `flutter` no aparece en terminal, usar SDK en `C:\src\flutter` y agregar al PATH.

Comprobar:

```powershell
flutter --version
flutter doctor -v
```

Asegurar licencias Android:

```powershell
flutter doctor --android-licenses
```

## 3) Preparar proyecto Flutter

Desde la raiz de `flutter_app`:

```powershell
cd d:\proyectominiso\flutter_app
flutter create .
flutter pub get
flutter analyze
```

Esperado en analisis: `No issues found!`

## 4) Abrir emulador Android

Listar AVDs:

```powershell
C:\Users\contr\AppData\Local\Android\Sdk\emulator\emulator.exe -list-avds
```

Iniciar un AVD (ejemplo):

```powershell
C:\Users\contr\AppData\Local\Android\Sdk\emulator\emulator.exe -avd Medium_Phone_API_36.1
```

Verificar dispositivo:

```powershell
flutter devices
```

Debe aparecer `emulator-5554` en estado `device`.

## 5) Ejecutar app Flutter contra backend local

Para Android Emulator usar `10.0.2.2` hacia backend local:

```powershell
cd d:\proyectominiso\flutter_app
flutter run -d emulator-5554 --dart-define=API_BASE=http://10.0.2.2:3000 --dart-define=CLOUDINARY_CLOUD_NAME=tu_cloud_name --dart-define=CLOUDINARY_UPLOAD_PRESET=tu_preset
```

## 6) Soluciones rapidas a errores comunes

### Error: `No pubspec.yaml file found`

No estas en la carpeta correcta. Ejecuta desde:

```powershell
cd d:\proyectominiso\flutter_app
```

### Error Gradle: cache corrupto (`file-access.bin`)

Cerrar procesos Java/Gradle y limpiar cache:

```powershell
Get-Process java,javaw,gradle -ErrorAction SilentlyContinue | Stop-Process -Force
cmd /d /c "if exist %USERPROFILE%\.gradle\caches rmdir /s /q %USERPROFILE%\.gradle\caches"
```

### Error: `Espacio en disco insuficiente`

Ver espacio libre:

```powershell
Get-PSDrive C,D | Select-Object Name,Free,Used
```

Mover cache de Gradle a `D:` y reintentar:

```powershell
cd d:\proyectominiso\flutter_app
$env:GRADLE_USER_HOME='D:\gradle-home'
$env:TEMP='D:\temp'
$env:TMP='D:\temp'
flutter run -d emulator-5554 --dart-define=API_BASE=http://10.0.2.2:3000 --dart-define=CLOUDINARY_CLOUD_NAME=tu_cloud_name --dart-define=CLOUDINARY_UPLOAD_PRESET=tu_preset
```

### Error NDK corrupto (`source.properties` faltante)

Borrar NDK corrupto y dejar que Gradle lo baje de nuevo:

```powershell
Remove-Item -Recurse -Force C:\Users\contr\AppData\Local\Android\Sdk\ndk\27.0.12077973
```

## 7) Flujo final recomendado (en orden)

1. Levantar backend: `npm run start:dev` en `backend`.
2. Confirmar `GET /products` con `curl`.
3. Abrir emulador Android.
4. Ejecutar `flutter run` en `flutter_app` con `API_BASE=http://10.0.2.2:3000`.
5. Ver cambios en Home y en Add Product.

## 8) Nota de seguridad

- No subir `backend/.env` al repositorio.
- Rotar contrasenas/API keys si fueron compartidas.
