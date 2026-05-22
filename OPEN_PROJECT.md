# Abrir y preparar el proyecto (Windows)

Pasos rápidos para dejar todo listo y abrir en Android Studio.

1) Preparar backend (desde PowerShell o CMD):

```bash
cd d:\proyectominiso\backend
\setup_windows.bat
```

Esto hará:
- copiar `.env.example` → `.env` si no existe
- lanzar `docker compose up -d` (Postgres)
- `npm install` y `npm run start:dev`

2) Preparar Flutter (Android Studio):

Abre una terminal y ejecuta:

```bash
cd d:\proyectominiso\flutter_app
\setup_windows.bat
```

Esto ejecutará `flutter create .` para generar las carpetas `android/` y `ios/` (si no existen) y hará `flutter pub get`.

3) Abrir en Android Studio:

- File → Open... → selecciona `d:\proyectominiso\flutter_app`
- Asegúrate de tener los plugins Flutter y Dart instalados y un AVD configurado.
- En Run Configurations añade en Additional run args:

```
--dart-define=API_BASE=http://10.0.2.2:3000 --dart-define=CLOUDINARY_CLOUD_NAME=tu_cloud --dart-define=CLOUDINARY_UPLOAD_PRESET=tu_preset
```

4) Ejecutar y probar

- Arranca el emulador Android (AVD) y ejecuta Run ▶ en Android Studio.
- Observa consola del backend y la consola de Flutter para mensajes.
