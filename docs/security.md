# Seguridad

## ✅ Reglas Básicas

- **Nunca** subir credenciales al repositorio
- Usar **variables de entorno** para datos sensibles
- Usar **Secret Manager** para secretos de aplicación

## 🔧 Configuración

```bash
# Copiar plantilla
cp Scripts/config.env.example Scripts/config.env

# Editar con tus valores
nano Scripts/config.env
```

## 🚨 Checklist

Antes de hacer commit:
- [ ] No hay credenciales hardcodeadas
- [ ] No hay paths absolutos
- [ ] `config.env` está en `.gitignore`
- [ ] Secretos están en Secret Manager

## 📝 Variables Requeridas

```bash
# config.env
PROJECT_ID="tu-proyecto-gcp"
GITHUB_USER="tu-usuario-github"
REGION="us-central1"
``` 