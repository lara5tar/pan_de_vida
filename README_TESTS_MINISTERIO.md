# Tests de Ministerio - Guía de Configuración

## Descripción
Este módulo permite crear y gestionar tests de ministerio con preguntas de opción múltiple.

## Estructura de Archivos

Los tests se encuentran en la carpeta:
```
assets/tests_ministerio/
├── test_1.json
├── test_2.json
├── test_3.json
└── test_4.json
```

## Formato del Archivo JSON

Cada archivo de test debe seguir esta estructura:

```json
{
  "id": "test_1",
  "titulo": "Nombre del Test",
  "descripcion": "Breve descripción del test",
  "preguntas": [
    {
      "id": "p1",
      "pregunta": "¿Texto de la pregunta?",
      "opciones": [
        {
          "id": "o1",
          "texto": "Opción 1",
          "iscorrecta": false
        },
        {
          "id": "o2",
          "texto": "Opción 2",
          "iscorrecta": true
        }
      ]
    }
  ]
}
```

## Cómo Agregar o Modificar Tests

### 1. Modificar un Test Existente

Edita cualquiera de los archivos `test_1.json` a `test_4.json`:

1. Abre el archivo JSON
2. Modifica el `titulo` y `descripcion` según necesites
3. Agrega o modifica preguntas en el array `preguntas`
4. Cada pregunta debe tener un `id` único
5. Cada opción debe tener un `id` único dentro de la pregunta

### 2. Agregar Nuevas Preguntas

Para agregar una nueva pregunta a un test existente:

```json
{
  "id": "p3",
  "pregunta": "¿Tu nueva pregunta?",
  "opciones": [
    {
      "id": "o1",
      "texto": "Primera opción",
      "iscorrecta": false
    },
    {
      "id": "o2",
      "texto": "Segunda opción",
      "iscorrecta": false
    },
    {
      "id": "o3",
      "texto": "Tercera opción",
      "iscorrecta": true
    },
    {
      "id": "o4",
      "texto": "Cuarta opción",
      "iscorrecta": false
    }
  ]
}
```

### 3. Agregar Más Tests (más de 4)

Si necesitas más de 4 tests:

1. Crea un nuevo archivo `test_5.json` en `assets/tests_ministerio/`
2. Sigue el formato JSON descrito arriba
3. Abre el archivo `lib/pandevida/app/modules/test_ministerio/controllers/test_ministerio_list_controller.dart`
4. Modifica la línea que define `testIds`:

```dart
final testIds = ['test_1', 'test_2', 'test_3', 'test_4', 'test_5'];
```

## Campos Importantes

### Test
- **id**: Identificador único del test (ej: "test_1")
- **titulo**: Nombre que se muestra en la lista de tests
- **descripcion**: Descripción breve del propósito del test

### Pregunta
- **id**: Identificador único de la pregunta (ej: "p1", "p2", etc.)
- **pregunta**: Texto completo de la pregunta
- **opciones**: Array de opciones de respuesta

### Opción
- **id**: Identificador único de la opción (ej: "o1", "o2", etc.)
- **texto**: Texto de la opción
- **iscorrecta**: `true` si es la respuesta correcta, `false` si no lo es

## Notas Importantes

1. Cada test debe tener un `id` único
2. Los IDs de preguntas deben ser únicos dentro del test
3. Los IDs de opciones deben ser únicos dentro de la pregunta
4. Puedes tener múltiples opciones correctas si lo deseas (para tests de personalidad)
5. Los cambios en los archivos JSON se reflejan automáticamente al reiniciar la app
6. Asegúrate de que el JSON esté correctamente formateado (sin comas extras al final)

## Ejemplo Completo

```json
{
  "id": "test_ejemplo",
  "titulo": "Test de Ejemplo",
  "descripcion": "Este es un test de ejemplo",
  "preguntas": [
    {
      "id": "p1",
      "pregunta": "¿Cuál es tu don espiritual principal?",
      "opciones": [
        {
          "id": "o1",
          "texto": "Enseñanza",
          "iscorrecta": false
        },
        {
          "id": "o2",
          "texto": "Servicio",
          "iscorrecta": false
        },
        {
          "id": "o3",
          "texto": "Liderazgo",
          "iscorrecta": false
        },
        {
          "id": "o4",
          "texto": "Misericordia",
          "iscorrecta": false
        }
      ]
    },
    {
      "id": "p2",
      "pregunta": "¿Dónde te sientes más cómodo sirviendo?",
      "opciones": [
        {
          "id": "o1",
          "texto": "En el escenario",
          "iscorrecta": false
        },
        {
          "id": "o2",
          "texto": "Detrás de cámaras",
          "iscorrecta": false
        },
        {
          "id": "o3",
          "texto": "Con grupos pequeños",
          "iscorrecta": false
        },
        {
          "id": "o4",
          "texto": "Uno a uno",
          "iscorrecta": false
        }
      ]
    }
  ]
}
```

## Comandos para Aplicar Cambios

Después de modificar los archivos JSON:

```bash
# Detener la app si está corriendo
# Ejecutar
flutter pub get
# Reiniciar la app
```
