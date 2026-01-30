#!/bin/sh

# Detener el script si hay algún error
set -e

# Ir a la raíz del repositorio (la variable la pone Xcode Cloud automáticamente)
cd $CI_PRIMARY_REPOSITORY_PATH

# 1. Instalar Flutter (versión estable)
echo "Descargando e instalando Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# 2. Descargar artefactos de iOS necesarios
flutter precache --ios

# 3. Instalar dependencias de Dart/Flutter
echo "Ejecutando flutter pub get..."
flutter pub get

# 4. Instalar dependencias de CocoaPods (iOS)
echo "Instalando Pods..."
HOMEBREW_NO_AUTO_UPDATE=1 # Para que sea más rápido
brew install cocoapods

# Entrar a la carpeta ios y correr pod install
cd ios
pod install

echo "Configuración de Flutter terminada exitosamente."