# Vista de Punto de Venta (POS View)

## Descripción
Nueva vista de punto de venta para libros con cámara integrada para escaneo continuo de códigos de barras.

## Características

### 1. **Cámara Integrada**
- La cámara está visible por defecto en la vista
- Permite escanear códigos de barras sin necesidad de entrar y salir
- Se puede activar/desactivar con el botón en el header
- Incluye marco visual de guía para el escaneo
- Feedback visual cuando está procesando un código

### 2. **Gestión de Carrito**
- Lista de libros agregados con información detallada
- Cantidad editable directamente en cada ítem
- Selección de productos para edición rápida
- Cálculo automático de subtotales y total

### 3. **Acciones Rápidas**
- **Eliminar**: Remover libro seleccionado del carrito
- **Menos**: Decrementar cantidad del libro seleccionado
- **Más**: Incrementar cantidad del libro seleccionado
- **Buscar**: Buscar libros manualmente por nombre

### 4. **Checkout**
- Botón de "Vaciar" para limpiar todo el carrito
- Botón de "Procesar Venta" para finalizar la transacción
- Confirmaciones de seguridad antes de acciones importantes

## Ruta de Acceso
La nueva vista está disponible en la ruta: `/pos-view`

Puedes navegar a ella con:
```dart
Get.toNamed(Routes.POS_VIEW);
```

## Componentes Creados

### Controlador
- `pos_view_controller.dart`: Maneja toda la lógica del punto de venta

### Vista Principal
- `pos_view.dart`: Interfaz principal de la aplicación

### Widgets
- `pos_header_widget.dart`: Header con información y control de cámara
- `pos_camera_widget.dart`: Widget de cámara expandible
- `pos_book_item_widget.dart`: Ítem de libro en el carrito
- `pos_action_buttons_widget.dart`: Botones de acción rápida
- `pos_bottom_bar_widget.dart`: Barra inferior con total y checkout

## Patrón de Diseño
La vista sigue el patrón de diseño de la aplicación:
- Fondo con imagen (`background_general.jpg`)
- Contenedores con opacidad para transparencia
- Colores consistentes (azul marino, verde, rojo, etc.)
- Bordes redondeados y sombras
- Iconos descriptivos
- Feedback visual con snackbars

## Integración con Módulo Existente
- Utiliza el mismo `CameraService` del módulo mycart
- Comparte el modelo `Book` y `CartItem`
- Reutiliza el `BooksService` para búsqueda
- Usa el mismo diálogo de búsqueda manual

## Diferencias con MyCart
- Cámara visible por defecto y en la vista principal
- Diseño más compacto y optimizado para ventas rápidas
- Sin teclado físico, solo escaneo y búsqueda
- Interfaz más moderna con mejor UX
- Acciones más accesibles visualmente

## Próximas Mejoras Sugeridas
1. Integración con sistema de pagos
2. Generación de tickets/facturas
3. Historial de ventas
4. Múltiples formas de pago
5. Descuentos y promociones
6. Búsqueda por categorías
