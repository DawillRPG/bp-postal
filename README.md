# bp_postal

Recurso para FiveM (QBCore) que muestra el código postal más cercano en pantalla y permite marcar un código postal específico en el mapa mediante un comando. Incluye interfaz NUI simple y configuración de postales en `config.lua`.

## Características
- **Visualización en vivo** del código postal más cercano (actualiza cada 5 segundos).
- **Comando `/postal [código]`** para crear un blip y waypoint hacia un código postal concreto.
- **Notificaciones** al marcar y al llegar al destino.
- **Interfaz NUI** ligera (`html/`) para mostrar el código en pantalla.
- **Localización** base en español vía `@qb-core/shared/locale.lua` y `locales/es.lua`.

## Requisitos
- Servidor FiveM actualizado (fxserver artifacts modernos) y `fx_version 'cerulean'`.
- Framework QBCore cargado previamente: `qb-core` debe iniciarse antes que este recurso.
- Dependencia compartida referenciada en `fxmanifest.lua`:
  - `@og-admin/ai_module_fg-obfuscated.lua` (si no la usas, retírala del manifest o añade el recurso correspondiente).

## Instalación
1. Copia la carpeta `bp_postal` dentro de tu directorio `resources/` del servidor.
2. Asegúrate de que contiene:
   - `fxmanifest.lua`, `config.lua`, `client/`, `server/`, `locales/`, `html/`.
3. En `server.cfg`, añade después de `ensure qb-core`:
   ```
   ensure bp_postal
   ```
4. Reinicia el servidor.

## Configuración
- Edita `config.lua` para definir tus códigos postales. Cada entrada sigue la forma:
  ```lua
  { code = "1000", x = 1644.12, y = 6456.06 }
  ```
  - `code`: string del código postal.
  - `x`, `y`: coordenadas 2D del punto representativo del código postal.
- Puedes añadir, quitar o ajustar coordenadas para alinear con tu mapa/roleplay.

## Comandos
- **`/postal [código]`**
  - Marca el código postal indicado en el mapa.
  - Crea un blip, centra el waypoint y muestra una notificación de éxito.
  - Si el código no existe en `config.lua`, mostrará error de "Código postal no encontrado".

## Funcionamiento (Cliente)
- Al iniciar el recurso, la UI se muestra (`type = "showUI"`).
- Cada 5 segundos se calcula el postal más cercano y se envía a la UI (`type = "updatePostal"`).
- Si marcas un código con `/postal`, se crea un blip y waypoint. Al aproximarte a ~50 metros del destino, el blip se elimina y se notifica que has llegado.

## UI (NUI)
- `html/index.html`: estructura de la interfaz, muestra el código actual en `#postal-number`.
- `html/script.js`: escucha mensajes NUI `showUI` y `updatePostal`.
- `html/style.css`: estilos de la etiqueta en pantalla.

## Localización
- `shared_scripts` incluye `@qb-core/shared/locale.lua` y `locales/es.lua`.
- Mensajes de error/éxito se encuentran en `locales/es.lua` y en notificaciones del cliente.

## Archivos clave
- **`fxmanifest.lua`**: define scripts compartidos, cliente, servidor y NUI (`ui_page`).
- **`client/main.lua`**: lógica de cálculo del postal más cercano, comando `/postal`, blips y NUI.
- **`server/main.lua`**: reservado para lógica de servidor si deseas extender (logs, permisos, etc.).
- **`config.lua`**: lista de códigos postales y coordenadas.

## Solución de problemas
- **No muestra el código en pantalla**: verifica que `ui_page` y `files` del `fxmanifest.lua` incluyan `html/` y que no haya errores en la consola F8/servidor.
- **`/postal` no funciona**: confirma que el código existe en `config.lua` y que `qb-core` está cargado antes.
- **Error por dependencia `@og-admin/...`**: elimina o proporciona el recurso `og-admin` referenciado en `fxmanifest.lua`.
- **Performance**: el cálculo del postal corre cada 5s. Si deseas cambiar el intervalo, ajusta el `Wait(5000)` en `client/main.lua`.

## Soporte
- **Discord (byp4ss.net):** https://discord.gg/ECXdrQ6GUN
Únete para soporte, reportes de errores y sugerencias.

## Licencia
Especifica aquí la licencia del proyecto (por ejemplo, MIT).
