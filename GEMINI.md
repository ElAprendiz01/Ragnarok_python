# REGLAS MAESTRAS DE DESARROLLO - PROYECTO RAGNAROK

Este archivo define las directivas y restricciones obligatorias que **TODO asistente de IA (Antigravity/Gemini)** debe cumplir rigurosamente en cada interacción con este repositorio.

---

## 1. PRINCIPIO FUNDAMENTAL DE NO-REGRESIÓN (CERO "CHURUNCAS")
1. **Prohibido alterar o eliminar funcionalidad existente**:
   - NUNCA elimines, reemplaces, renombres ni ocultes controles de interfaz (`<select>`, inputs, botones, modales, pestañas, tablas) que ya estén funcionando.
   - Si se solicita una nueva característica, esta debe **integrarse y sumar** sin romper ni retirar lo que ya existía.
2. **Prohibido asumir cambios estéticos o de flujo**:
   - No reemplaces controles funcionales (como menús desplegables `<select>`) por componentes alternativos (como chips o botones) a menos que el usuario lo solicite expresamente con palabras directas.
   - Si consideras que una UI puede mejorar, **primero explica la propuesta y solicita autorización explícita antes de tocar el código**.
3. **Persistencia de configuración garantizada**:
   - Toda configuración que el usuario guarde (canales de Telegram, rutas, opciones de plataforma, filtros) DEBE persistir permanentemente en disco y reflejarse de inmediato en todos los selectores y modales correspondientes.

---

## 2. REGLA ESTRICTA DE ALCANCE Y TECNOLOGÍAS
1. **Zona de trabajo exclusiva: Rust (`rust_Ragnarok/`)**:
   - Toda la lógica del sistema, backend, API, procesamiento, descargas y servidor web reside y se desarrolla en **Rust**.
   - **EXTREMADAMENTE PROHIBIDO MODIFICAR ARCHIVOS PYTHON (`.py`)** fuera de `rust_Ragnarok/`.
   - Los archivos de Python solo se pueden consultar en modo lectura como referencia de algoritmos pasados, pero NUNCA modificarse.
2. **Límite estricto de modularidad en Rust**:
   - **Ningún archivo `.rs` debe sobrepasar las 300 líneas de código**.
   - Si un archivo se aproxima a las 280 líneas, debe dividirse y modularizarse de inmediato manteniendo nombres claros y directos.
3. **Compilación y verificación segura**:
   - Para verificar sintaxis y tipos sin colisionar con procesos en ejecución en Windows, utiliza siempre `cargo check`.
   - No compiles `cargo build --release` mientras el usuario tenga el binario en ejecución para evitar bloqueos de archivo en Windows (`access denied`).

---

## 3. INTEGRIDAD DE CONTRATOS (BACKEND RUST <-> JSON <-> FRONTEND JS)
1. **Sincronización exacta de esquemas**:
   - Antes de modificar cómo se lee o guarda un dato en el Frontend (`logica_panel.js`), verifica que la estructura en Rust (`src/models.rs`) tenga exactamente los mismos nombres de campos y tipos.
   - Cualquier campo nuevo en `ParametrosGlobales` debe tener `#[serde(default)]` para evitar fallos de deserialización.
   - Para compatibilidad con archivos JSON existentes, los campos críticos (como `canal_telegram` y `canales_telegram`) deben manejarse y sincronizarse tanto en la raíz como dentro de `publicacion`.
2. **Gestión de estado en Frontend**:
   - El estado local en `App` (en JavaScript) debe inicializarse leyendo el servidor y no debe sobreescribirse con arrays vacíos si una propiedad viene ausente; debe mantenerse el valor previo o el del disco.

---

## 4. PROTECCIÓN DE PROCESOS EN EJECUCIÓN
1. **No interrumpir procesos del usuario**:
   - Está prohibido matar (`kill`), terminar o reiniciar procesos que el usuario tenga activos (como servidores locales, descargas de video o navegadores Playwright/Chromium) a menos que el usuario lo ordene explícitamente.
   - Las pruebas o comandos deben respetar las instancias en curso del usuario.
