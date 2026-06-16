#!/bin/sh

set -e

echo "=========================================="
echo "Configurando frontend Angular..."
echo "=========================================="

# Copiar config.yml a la ubicación correcta si existe
if [ -f /app/config/config.yml ]; then
    echo "Copiando config.yml a /app/src/assets/config.json"
    cp /app/config/config.yml /app/src/assets/config.json
    echo "config.yml copiado correctamente"
else
    echo "ERROR: No se encontró /app/config/config.yml"
fi

# COPIAR FUENTES DE FONTAWESOME
echo "Copiando fuentes de FontAwesome..."
mkdir -p /app/src/assets/fonts

FONT_FOUND=false
if [ -d /app/node_modules/@fortawesome ]; then
    FONT_PATH=$(find /app/node_modules/@fortawesome -name "webfonts" -type d 2>/dev/null | head -1)
    if [ -n "$FONT_PATH" ] && [ -d "$FONT_PATH" ]; then
        cp -rn "$FONT_PATH"/* /app/src/assets/fonts/ 2>/dev/null || true
        echo "Fuentes copiadas desde @fortawesome"
        FONT_FOUND=true
    fi
fi

if [ "$FONT_FOUND" = "false" ] && [ -d /app/node_modules/font-awesome ]; then
    if [ -d /app/node_modules/font-awesome/fonts ]; then
        cp -rn /app/node_modules/font-awesome/fonts/* /app/src/assets/fonts/ 2>/dev/null || true
        echo "Fuentes copiadas desde font-awesome"
    fi
fi

echo "Verificando fuentes..."
ls -la /app/src/assets/fonts/ 2>/dev/null || echo "Directorio de fuentes no existe"

echo ""
echo "=========================================="
echo "Building Angular for PRODUCTION..."
echo "=========================================="

# Build de producción
npm run build -- --configuration production

echo ""
echo "=========================================="
echo "Instalando http-server y sirviendo archivos estáticos..."
echo "=========================================="

# Instalar http-server globalmente
npm install -g http-server

# Los archivos buildados están en /app/dist/browser
# Servir con http-server en puerto 4000
cd /app/dist/browser
exec http-server -p 4000 -a 0.0.0.0 -c-1 --cors
