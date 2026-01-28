#!/bin/sh

# 1. Instalar Flutter
# Cambia "stable" por la versión que necesites si es muy específica, pero stable suele funcionar.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $CI_WORKSPACE/flutter
export PATH="$CI_WORKSPACE/flutter/bin:$PATH"

# 2. Bajar las dependencias de Flutter (esto genera el Generated.xcconfig)
echo "Instalando dependencias de Flutter..."
cd $CI_WORKSPACE
flutter pub get

# 3. Instalar los Pods de iOS
echo "Instalando Pods..."
cd ios
pod install

echo "¡Listo! El entorno está preparado."