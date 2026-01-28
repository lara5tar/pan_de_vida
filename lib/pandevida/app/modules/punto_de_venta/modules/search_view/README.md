# Módulo de Búsqueda de Libros (SearchView)

Este módulo proporciona una interfaz de búsqueda dedicada para libros en el sistema de punto de venta.

## Características

- 🔍 Búsqueda en tiempo real por:
  - Nombre del libro
  - Código de identificación (ID)
  - Código de barras
- 📷 Escaneo de códigos de barras integrado
- ✨ Resaltado de coincidencias en los resultados
- 📱 Interfaz responsive con scroll
- 🎨 Diseño consistente con el patrón de la aplicación (CustomScaffold)
- ➕ Integración con el módulo POS para agregar libros al carrito

## Estructura

```
search_view/
├── bindings/
│   └── search_view_binding.dart         # Inyección de dependencias
├── controllers/
│   └── search_view_controller.dart      # Lógica de búsqueda y control
├── views/
│   └── search_view.dart                 # Vista principal
└── widgets/
    ├── search_result_item_widget.dart   # Item individual de resultado
    ├── search_empty_state_widget.dart   # Estado vacío/sin resultados
    └── search_scanner_widget.dart       # Widget del escáner de códigos
```

## Uso

### Navegación desde POS

El módulo se integra automáticamente con el módulo POS. Al hacer clic en el botón "Buscar" en la vista POS, se abre la vista de búsqueda:

```dart
controller.goToSearchView();
```

### Navegación directa con callback

Para abrir la vista de búsqueda desde cualquier lugar y recibir el libro seleccionado:

```dart
Get.toNamed(
  Routes.SEARCH_VIEW,
  arguments: {
    'onBookSelected': (Book book) {
      // Hacer algo con el libro seleccionado
      print('Libro seleccionado: ${book.nombre}');
    }
  },
);
```

### Navegación simple (sin callback)

Para abrir la vista de búsqueda sin callback, los libros seleccionados mostrarán sus detalles:

```dart
Get.toNamed(Routes.SEARCH_VIEW);
```

## Componentes Principales

### SearchViewController

**Propiedades observables:**
- `books`: Lista completa de libros
- `searchQuery`: Texto de búsqueda actual
- `showScanner`: Estado de visibilidad del escáner
- `isLoading`: Estado de carga

**Métodos principales:**
- `filteredBooks`: Getter computado que filtra libros según la búsqueda
- `findBookByExactCode(String code)`: Busca libro por código exacto
- `selectBook(Book book)`: Maneja la selección de un libro
- `toggleScanner()`: Muestra/oculta el escáner de códigos
- `clearSearch()`: Limpia el campo de búsqueda

### SearchResultItemWidget

Widget que muestra un resultado de búsqueda individual con:
- Icono del libro
- Nombre del libro (con resaltado de coincidencias)
- Código del libro (con resaltado)
- Precio
- Stock disponible
- Indicador de estado de stock (verde/rojo)

**Características especiales:**
- Resaltado automático de texto que coincide con la búsqueda
- Colores condicionales según el stock
- Animación al tocar (InkWell)

### SearchScannerWidget

Widget para escanear códigos de barras con:
- Preview de la cámara
- Guías visuales para el escaneo
- Esquinas decorativas verdes
- Instrucciones en pantalla

## Integración con CameraService

El módulo utiliza el `CameraService` compartido para el escaneo de códigos:

1. Al iniciar, registra un callback para procesar códigos escaneados
2. Los códigos detectados actualizan automáticamente el campo de búsqueda
3. Se busca coincidencia exacta con el código escaneado
4. Al cerrar, limpia el callback para no interferir con otros módulos

## Estados de la Vista

### Estado de carga
Muestra un `LoadingWidget` mientras se cargan los libros desde el servicio.

### Estado inicial (sin búsqueda)
Muestra un mensaje invitando al usuario a escribir o escanear.

### Estado con resultados
Lista de libros que coinciden con la búsqueda, con contador de resultados.

### Estado sin resultados
Mensaje indicando que no se encontraron libros con ese criterio.

## Rutas

- **Nombre de ruta:** `SEARCH_VIEW`
- **Path:** `/search-books`
- **Binding:** `SearchViewBinding`

## Dependencias

El módulo requiere los siguientes servicios:
- `BooksService`: Para obtener la lista de libros
- `CameraService`: Para el escaneo de códigos de barras

Ambos servicios se inyectan automáticamente a través del `SearchViewBinding`.

## Flujo de Trabajo

1. Usuario abre la vista de búsqueda
2. Puede escribir en el campo de búsqueda o escanear un código
3. Los resultados se filtran en tiempo real
4. Al seleccionar un libro:
   - **Si hay callback:** Confirma y agrega al carrito, regresa al POS
   - **Si no hay callback:** Navega a los detalles del libro
5. El escáner puede expandirse/contraerse según necesidad

## Estilo Visual

El módulo sigue el patrón de diseño establecido en la aplicación:
- `CustomScaffold` como contenedor principal
- Fondo con imagen de la aplicación
- Banner superior
- Contenedores con `Colors.white.withValues(alpha: 0.9)`
- Bordes redondeados con `BorderRadius.circular(12)`
- Sombras suaves para profundidad
- Paleta de colores azul para elementos interactivos

## Notas Técnicas

- El campo de búsqueda usa `BarcodeScannerFieldWidget` que maneja su propio `TextEditingController`
- El resaltado de coincidencias usa `RichText` con `TextSpan`
- La búsqueda es case-insensitive
- El escáner tiene animación de expansión/contracción
- Se usa `Obx()` para reactividad automática con GetX

## Mejoras Futuras

- [ ] Búsqueda por categoría de libro
- [ ] Ordenamiento de resultados (por precio, nombre, stock)
- [ ] Filtros avanzados (rango de precios, disponibilidad)
- [ ] Historial de búsquedas recientes
- [ ] Sugerencias de búsqueda mientras se escribe
- [ ] Vista de cuadrícula como alternativa a la lista
- [ ] Búsqueda por voz
