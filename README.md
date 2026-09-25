# Carrito de compras — Clase 14

Aplicación Flutter de dos pantallas basada en la actividad del PDF de la Clase 14. El catálogo y el resumen comparten selección y total exclusivamente mediante `ChangeNotifierProvider`.

## Ejecutar

```powershell
flutter pub get
flutter run -d chrome
```

## Flujo de demostración

1. El catálogo abre con dos productos seleccionados para mostrar el estado bloqueado de `2 de 3`; elige un tercero para habilitar **Continuar**.
2. En el resumen se muestran los tres productos y el total calculado por el mismo `CartProvider`.
3. Pulsa **Proceder a pagar** para ver el diálogo de compra exitosa. **Aceptar** cierra el diálogo y conserva el resumen.

El total del ejemplo visual es **$199.000**: mochila ($45.000), audífonos ($65.000) y reloj ($89.000). La confirmación es una simulación de clase; no procesa pagos.

## Estructura

- `lib/providers/cart_provider.dart`: selección compartida, límite de tres y cálculo único del total.
- `lib/screens/catalog_screen.dart`: catálogo, contador y navegación bloqueada hasta completar la selección.
- `lib/screens/summary_screen.dart`: resumen y diálogo de compra exitosa.
- `lib/models/product.dart`: catálogo de cinco productos y formato de precios.
- `lib/shared/app_frame.dart`: marco adaptable al formato móvil de la referencia.

Las pantallas usan `context.watch` para reconstruir la interfaz y `context.read` dentro de callbacks para modificar o consultar el estado.
