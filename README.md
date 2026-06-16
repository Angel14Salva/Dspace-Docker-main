# DSpace 9 - Repositorio Institucional

DSpace 7 (versión 9) con Docker para repositorio institucional.

## Características Especiales

✅ **Compatible con ALICIA/CONCYTEC (Perú)**
- OAI-PMH configurado para cosecha
- Metadatos Dublin Core cualificado
- Cumplimiento con estándares DRIVER 2.0

---

## Requisitos del Servidor

- **Sistema:** Ubuntu 20.04+ / Debian 11+ / Amazon Linux 2
- **Docker:** 24.0+
- **Docker Compose:** 2.20+
- **RAM:** 8GB mínimo (16GB recomendado)
- **Disco:** 50GB mínimo (100GB recomendado)
- **CPU:** 2 núcleos mínimo

---

## 🔥 Puertos del Firewall

Debes abrir los siguientes puertos en tu servidor:

| Puerto | Servicio | Protocolo | Descripción |
|--------|----------|-----------|-------------|
| 80 | Nginx | TCP | Frontend y Backend HTTP |
| 443 | Nginx | TCP | HTTPS (opcional) |
| 5432 | PostgreSQL | TCP | Solo localhost (no exponer) |
| 8080 | DSpace Backend | TCP | Solo localhost (no exponer) |
| 8983 | Solr | TCP | Solo localhost (no exponer) |

### Comandos para abrir puertos (Ubuntu/Debian):

```bash
# Abrir puerto 80
sudo ufw allow 80/tcp

# Abrir puerto 443 (si usas HTTPS)
sudo ufw allow 443/tcp

# Recargar firewall
sudo ufw reload

# Verificar puertos abiertos
sudo ufw status
```

---

## 📋 Lista de Archivos a Modificar

Debes reemplazar `3.135.187.106` por tu IP pública o dominio en los siguientes archivos:

### 1. `.env`
```bash
PUBLIC_HOST=TU_IP_O_DOMINIO
```

### 2. `dspace-angular/config.yml`
```yaml
rest:
  ssl: false
  host: "TU_IP_O_DOMINIO"
  port: 80
  nameSpace: /server
```

### 3. `config/backend/local.cfg`
```
dspace.ui.url = http://TU_IP_O_DOMINIO
dspace.server.url = http://TU_IP_O_DOMINIO/server
```

### 4. `docker-compose.yml` (variables de entorno)
```yaml
environment:
  - DSPACE_HOST=TU_IP_O_DOMINIO
  - DSPACE_REST_HOST=TU_IP_O_DOMINIO
```

---

## 🚀 Instalación Paso a Paso

### 1. Clonar el repositorio

```bash
# Usando SSH (recomendado)
git clone git@github.com:andres31416YT/Dspace-Docker.git
cd DSpace

# O usando HTTPS
git clone https://github.com/andres31416YT/Dspace-Docker.git
cd DSpace
```

### 2. Configurar tu IP/Dominio

Edita los archivos mencionados en la sección anterior y reemplaza `3.135.187.106` por tu IP pública o nombre de dominio.

### 3. Iniciar los contenedores

```bash
# Descargar imágenes y levantar servicios
docker-compose up -d
```

### 4. Verificar que estén corriendo

```bash
docker-compose ps
```

Deberías ver:
- `dspace-db` - PostgreSQL (puerto 5432)
- `dspace-solr` - Solr (puerto 8983)  
- `dspace` - Backend REST (puerto 8080)
- `dspace-angular` - Frontend (puerto 4000)
- `dspace-nginx` - Proxy reverso (puerto 80)

### 5. Esperar a que inicialice (~10-15 minutos)

```bash
# Ver logs en tiempo real
docker-compose logs -f

# O solo del backend
docker-compose logs -f dspace
```

El sistema está listo cuando veas mensajes como:
- `Dspace server startup complete`
- No hay errores de conexión en los logs

---

## 🔗 URLs de Acceso

| Servicio | URL |
|----------|-----|
| **Frontend** | http://TU_IP_O_DOMINIO |
| **Backend API** | http://TU_IP_O_DOMINIO/server/api |
| **Solr Admin** | http://TU_IP_O_DOMINIO:8983/solr |
| **OAI-PMH** | http://TU_IP_O_DOMINIO/oai |

---

## 👤 Crear Administrador

### Opción 1: Interactivo

```bash
# Entrar al contenedor del backend
docker exec -it dspace-backend bash

# Crear administrador
/dspace/bin/dspace create-administrator
```

Responde las preguntas:
- Email: admin@tudominio.edu
- Password: (elige una contraseña segura)
- First name: Admin
- Last name: User

### Opción 2: Automático (sin interacción)

```bash
docker exec -it dspace /dspace/bin/dspace create-administrator << 'EOF'

admin@tudominio.edu
TuPassword123
TuPassword123
Admin
Usuario
y
EOF
```

---

## 🏛️ Integración con ALICIA (CONCYTEC Perú)

Tu DSpace está configurado para ser cosechado por ALICIA. El endpoint OAI-PMH está habilitado automáticamente.

### URLs para ALICIA

| Servicio | URL |
|----------|-----|
| **Endpoint OAI-PMH** | http://TU_IP_O_DOMINIO/oai |
| **Set por defecto** | hdl_ (handle) |

### Metadatos Obligatorios para ALICIA (Guía 2.1.0)

Tu repositorio debe incluir estos 11 metadatos obligatorios:

| # | Metadato | Descripción |
|---|----------|-------------|
| 1 | dc.contributor.author | Autor/es del recurso |
| 2 | dc.date.issued | Fecha de publicación |
| 3 | dc.identifier.uri | URI o Handle del recurso |
| 4 | dc.description.abstract | Resumen/abstract |
| 5 | dc.language.iso | Idioma (ISO 639-3) |
| 6 | dc.publisher | Editorial/Institución |
| 7 | dc.relation.uri | URI del proyecto o fuente |
| 8 | dc.rights | Derechos de acceso |
| 9 | dc.source | Fuente del recurso |
| 10 | dc.title | Título |
| 11 | dc.type | Tipo de recurso |

### Metadatos para Tesis/Trabajos de Investigación

Para trabajos que conducen a grado académico (según SUNEDU):

| # | Metadato | Descripción |
|---|----------|-------------|
| 27 | dc.subject.ocde | Clasificación OCDE |
| 28 | dc.audience | Público objetivo |
| 29 | dc.audience.educationLevel | Nivel educativo |
| 30 | dc.description.degree | Grado o título |
| 31 | dc.description.degree-grantor | Institución que otorga |
| 32 | dc.description.degree-discipline | Disciplina del grado |

### Vocabularios Controlados Recomendados

- **dc.type:** Usar [tipología COAR](https://vocabularies.coar-repositories.org/)
- **dc.subject.ocde:** Usar códigos OCDE (ej: `https://purl.org/pe-repo/ocde/ford#1.02.02`)
- **dc.rights.uri:** Usar licencias [Creative Commons](https://creativecommons.org/licenses/) (preferible CC BY 4.0)

### Formatos de Exportación OAI

El endpoint soporta:
- `oai_dc` (Dublin Core simple)
- `oai_datacite` (DataCite)

### Validación con LA Referencia

Puedes validar tu OAI-PMH antes del registro oficial en ALICIA:
https://lareferencia.redclara.net/rf/procval

---

## 🔧 Configuración Avanzada

### SSL/HTTPS

1. Edita `nginx.conf` y descomenta las líneas de redirect a HTTPS
2. Obtén certificados SSL (Let's Encrypt, etc.)
3. Actualiza las URLs en:
   - `config/backend/local.cfg`
   - `dspace-angular/config.yml`

### Variables de entorno importantes (.env)

```bash
# Base de datos
DB_NAME=dspace
DB_USER=dspace
DB_PASSWORD=tu_password_seguro
DB_HOST=dspace-db

# Configuración
DSPACE_HOST=TU_IP
DSPACE_ADMIN=admin@tudominio.edu
```

---

## 📚 Comandos Útiles

```bash
# Ver todos los logs
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f dspace
docker-compose logs -f dspace-angular

# Reiniciar un servicio
docker-compose restart dspace

# Parar todos los servicios
docker-compose down

# Iniciar servicios
docker-compose up -d

# Ver estado
docker-compose ps

# Acceder a un contenedor
docker exec -it dspace bash
docker exec -it dspace-angular sh

# Rebuild y reiniciar
docker-compose build dspace
docker-compose up -d --no-deps dspace
```

---

## 💾 Mantenimiento

### Backup de Base de Datos

```bash
docker exec dspace-db pg_dump -U dspace dspace > backup_$(date +%Y%m%d).sql
```

### Backup de Archivos

```bash
docker cp dspace:/dspace/assetstore ./backup-assetstore
```

### Actualizar a nueva versión

```bash
git pull
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 🆘 Solución de Problemas

### Error 500 en el frontend
```bash
# Verificar que el backend esté corriendo
docker ps

# Ver logs del backend
docker-compose logs dspace
```

### No conecta al backend
- Verificar que `dspace-angular/config.yml` tenga la IP correcta
- Verificar que nginx esté proxyando correctamente
- Verificar que el backend esté escuchando en el puerto correcto

### iconos no aparecen
- Verificar que nginx tenga las reglas correctas para /assets/
- Verificar que el contenedor de Angular tenga los assets

### No puedo crear administrador
- Esperar a que el backend termine de inicializar (~10 minutos)
- Verificar que la base de datos esté corriendo

---

## 📁 Estructura del Proyecto

```
DSpace/
├── docker-compose.yml          # Orquestación de servicios
├── .env                       # Variables de entorno
├── nginx.conf                 # Configuración nginx
├── entrypoint-angular.sh      # Script de inicio Angular
├── postgres-init.sql          # Inicialización de base de datos
├── config/
│   └── backend/
│       └── local.cfg          # Configuración del backend
├── dspace-angular/
│   └── config.yml             # Configuración REST API del frontend
└── README.md                  # Este archivo
```

---

## 📞 Soporte

- **Documentación DSpace:** https://wiki.duraspace.org/display/DSDOC7x
- **Guía ALICIA:** https://alicia.concytec.gob.pe
- **LA Referencia:** https://lareferencia.redclara.net/

---

**Versión:** 9.0
**Fecha de creación:** 2026
