#!/bin/bash

set -e

# Ir a la carpeta del repositorio
cd "$CI_PRIMARY_REPOSITORY_PATH"

# 1. Crear el archivo .env desde la variable de entorno de Xcode Cloud
echo "Creando archivo .env..."
# Asegúrate de haber creado la variable ENV_FILE_CONTENT en Xcode Cloud
if [ -n "$ENV_FILE_CONTENT" ]; then
    echo "$ENV_FILE_CONTENT" > .env
    echo ".env creado exitosamente."
else
    echo "ADVERTENCIA: No se encontró la variable ENV_FILE_CONTENT."
    # Si el archivo es obligatorio, descomenta la siguiente línea para que falle si no existe
    # exit 1
fi

# 2. Instalar Flutter
if ! command -v flutter &> /dev/null
then
    echo "Instalando Flutter SDK..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
    export PATH="$PATH:$HOME/flutter/bin"
else
    echo "Flutter ya estaba instalado."
fi

# 3. Instalar dependencias
echo "Ejecutando flutter pub get..."
flutter precache --ios
flutter pub get

# (Opcional) Solo descomenta esto si REALMENTE usas generación de código (freezed, json_serializable, etc.)
# Si tu proyecto no usa esto, déjalo comentado o fallará.
# flutter pub run build_runner build --delete-conflicting-outputs

# 4. Instalar CocoaPods
echo "Instalando CocoaPods..."
HOMEBREW_NO_AUTO_UPDATE=1 
brew install cocoapods

# 5. Instalar Pods de iOS
echo "Instalando Pods..."
cd ios
pod install --repo-update

echo "Configuración terminada. Xcode Cloud continuará con la compilación automática."