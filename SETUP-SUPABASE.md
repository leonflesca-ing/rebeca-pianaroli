# Setup Supabase

Este paso se hace una sola vez para que la profesora pueda guardar rutinas online y generar links separados para cada clienta.

## 1. Crear proyecto gratis

1. Entrar a Supabase.
2. Crear un proyecto nuevo.
3. Guardar la password de base de datos en un lugar seguro.

## 2. Crear la tabla segura

1. En Supabase abrir SQL Editor.
2. Copiar todo el contenido de `supabase-schema.sql`.
3. Ejecutarlo.

Esto crea:
- Tabla `routines`.
- Seguridad por profesora autenticada.
- Funcion publica `get_routine_by_slug`, que permite que una clienta vea solo la rutina de su link.

## 3. Crear usuario de profesora

1. Ir a Authentication.
2. Crear usuario con email y clave para la profesora.
3. Ese email y clave se usan en el panel admin de la app.

## 4. Copiar credenciales publicas

En Supabase ir a Project Settings -> API y copiar:

- Project URL.
- anon public key.

Pegarlos en `config.js`:

```js
window.REBECA_CONFIG = {
  SUPABASE_URL: "https://TU-PROYECTO.supabase.co",
  SUPABASE_ANON_KEY: "TU_ANON_PUBLIC_KEY"
};
```

La anon key es publica por diseno. No pegar service role keys ni passwords en el codigo.

## 5. Usar la app

Panel profesora:

```text
https://leonflesca-ing.github.io/rebeca-pianaroli/?v=10&admin=1
```

La profesora:
- Entra con email y clave.
- Crea o edita la rutina.
- Pega links de videos, pueden ser links de Google Drive.
- Guarda online.
- Copia el link generado.

Clienta:

```text
https://leonflesca-ing.github.io/rebeca-pianaroli/?rutina=sabrina&v=10
```

Cada clienta ve solo la rutina correspondiente a su codigo.
