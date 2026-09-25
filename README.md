# Carrito Provider — Clase 14

Aplicación Flutter de dos pantallas para la actividad de la Clase 14. El catálogo exige elegir exactamente tres productos antes de abrir el resumen. La selección y el total se comparten mediante `ChangeNotifierProvider`.

## Ejecutar

```sh
flutter pub get
flutter run
```

También se puede ejecutar como app web con `flutter run -d chrome`.

## Flujo

1. Selecciona tres de los seis productos del catálogo. El botón para continuar permanece deshabilitado hasta llegar a tres.
2. Revisa los productos y el total en el resumen. La pantalla obtiene los datos del mismo `CartProvider`; no recibe argumentos de ruta.
3. Pulsa **Proceder a pagar** para abrir la confirmación con el total pagado. Cerrar el diálogo conserva la selección.

## Estructura

- `lib/providers/cart_provider.dart`: selección, límite de tres y cálculo único del total.
- `lib/screens/catalog_screen.dart`: catálogo, contador y navegación habilitada al completar la selección.
- `lib/screens/summary_screen.dart`: resumen reactivo y diálogo de compra exitosa.
- `lib/models/product.dart`: catálogo fijo de seis productos.

Las pantallas usan `context.watch` para reconstruir la interfaz y `context.read` dentro de callbacks para modificar o consultar el estado.
