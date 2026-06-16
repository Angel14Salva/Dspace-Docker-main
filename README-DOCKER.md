# DSpace 7.x - Docker Compose para Producción AWS

## Requisitos

- AWS EC2 con 8GB RAM mínimo
- Docker y Docker Compose instalados
- Puerto 80 y 443 abiertos en el security group

## Archivos necesarios

| Archivo | Descripción |
|---------|-------------|
| `docker-compose.yml` | Servicios: PostgreSQL, Solr, Backend, Frontend, Nginx |
| `.env` | Credenciales y configuración |
| `nginx.conf` | Proxy reverso |

## Configuración

### 1. Variables de entorno

Edita el archivo `.env` con tu configuración:

```env
DB_NAME=dspace
DB_USER=dspace
DB_PASSWORD=TU_PASSWORD_AQUI
DSPACE_HOST=3.135.187.106
DSPACE_NAME=Repositorio Institucional - Universidad
ADMIN_EMAIL=admin@tuuniversidad.edu.pe
HANDLE_PREFIX=123456789
```

### 2. Despliega

```bash
docker-compose up -d
```

Espera 3-5 minutos a que los servicios inicien.

## URLs del sistema

| Servicio | URL |
|----------|-----|
| Frontend | http://3.135.187.106 |
| Backend API | http://3.135.187.106/server/api |
| OAI-PMH | http://3.135.187.106/oai |
| Solr Admin | http://3.135.187.106:8983/solr |

## Verificar servicios

```bash
# Ver estado de contenedores
docker-compose ps

# Ver logs
docker-compose logs -f dspace

# Probar API
curl http://localhost:8080/server/api

# Probar OAI-PMH
curl http://localhost:8080/server/oai?verb=Identify
```

## Integración con ALICIA (CONCYTEC)

El endpoint OAI-PMH está disponible en:

```
http://3.135.187.106/oai
```

Para registrar tu repositorio en ALICIA:
1. Ve a https://alicia.concytec.gob.pe/vufind/
2. Registra tu OAI-PMH endpoint
3. Configura el metadata format (oai_dc)

## Comandos útiles

```bash
# Reiniciar servicios
docker-compose restart

# Parar servicios
docker-compose down

# Ver logs de un servicio específico
docker-compose logs -f dspace-angular

# Acceder al contenedor
docker exec -it dspace-backend bash
```

## Notas

- El volumen `assetstore` guarda los archivos subidos
- La base de datos se guarda en `postgres_data`
- OAI-PMH está habilitado para ALICIA
