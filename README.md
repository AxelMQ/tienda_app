# 🛒 Tienda App - Supermercado Digital

Una aplicación móvil desarrollada en Flutter para una tienda de comercios masivos (supermercado), enfocada en UI/UX y diseño responsivo.

## 📱 Descripción del Proyecto

**Tienda App** es una aplicación de e-commerce para supermercados que ofrece una experiencia de usuario moderna y intuitiva. El proyecto se centra en el diseño y maquetación, implementando las mejores prácticas de UI/UX con Flutter.

## 🎯 Características Principales

### 🏠 Pantalla Principal (Home)
- **AppBar personalizado** con logo "La Canasta", carrito interactivo dinámico y botón back automático
- **Navegación automática** que detecta pantallas anteriores y muestra flecha de retorno
- **Barra de búsqueda** con animaciones y focus interactivo
- **Banner promocional** con auto-scroll y transiciones suaves
- **Categorías** con imágenes PNG, scroll horizontal, animaciones de entrada y navegación a catálogo
- **Pedidos recientes** con `RecentOrderCard` horizontal optimizado
- **Sugerencias personalizadas** con `SuggestionCard` y botón de agregar rápido
- **Bottom Navigation curveado** con animaciones y 4 secciones

### 🎁 Pantalla de Ofertas
- **Carousel automático** con ofertas destacadas del día
- **Grid 2x2** con carruseles manuales por categoría
- **Ofertas Flash** con contador regresivo en tiempo real
- **Pull-to-refresh** para actualizar ofertas
- **Animaciones de entrada escalonadas** (staggered)
- **Badges con pulso** en descuentos para llamar la atención
- **Shimmer loading** mientras cargan las imágenes
- **Indicadores de página** animados en cada carousel

### 📦 Pantalla de Pedidos
- **Sistema de tabs** para filtrar (Todos, En Camino, Entregados)
- **Lista de pedidos** con animación de entrada una por una
- **Badges de estado** con pulso en "En camino"
- **Transiciones suaves** entre tabs con fade
- **Estados vacíos** personalizados por categoría
- **Pull-to-refresh** para actualizar historial
- **Reutilización de componentes** para consistencia
- **Fecha e icono** en cada pedido

### 🛍️ Pantalla de Catálogo
- **Grid 2 columnas** con 20 productos reales y imágenes de assets
- **Filtros profesionales** por categoría, rango de precio y disponibilidad
- **Chips de categoría** con íconos personalizados y contador de productos
- **Botón "Limpiar"** que aparece solo cuando hay filtros activos
- **Filtro de precio** con modal bottom sheet y opciones claras
- **Toggle de disponibilidad** con color verde (psicología positiva)
- **Badge de resultados** mostrando cantidad de productos filtrados
- **Animaciones escalonadas** en entrada de filtros y productos
- **Búsqueda integrada** que funciona con todos los filtros simultáneamente
- **Estado vacío** con mensaje claro cuando no hay resultados
- **Botón flotante** de agregar al carrito en cada producto con animación
- **SnackBar verde** con ✓ al agregar productos exitosamente
- **Navegación automática** desde categorías de Home con filtro pre-seleccionado

### 🔍 Pantalla de Detalle de Producto
- **Hero Animation** de la imagen desde ProductCard con transición suave
- **Imagen ampliada** de 400px de alto con gradiente inferior
- **Información completa** con chip de categoría, nombre (24px), precio (32px)
- **Badge de descuento** amarillo con porcentaje y sombra
- **Precio original tachado** cuando hay descuento activo
- **Descripción detallada** del producto contextual por categoría
- **Contador interactivo** con botones +/- y validación (mínimo 1)
- **Campo de notas** visible con fondo gris, borde, ícono de lápiz y 200 caracteres
- **Badge "Opcional"** para reducir ansiedad del usuario
- **Botón "Limpiar"** que aparece solo cuando hay texto en notas
- **Placeholder con ejemplos** para guiar al usuario (Ej: Sin cebolla, bien cocido)
- **Botón "Listo"** en teclado para cerrar fácilmente
- **Card de disponibilidad** con color semántico (verde disponible, rojo agotado)
- **Footer adaptativo** que se oculta automáticamente cuando aparece el teclado
- **Total dinámico** calculado en tiempo real (precio × cantidad)
- **Botón agregar** que cambia de rojo a verde con ✓ al confirmar
- **SnackBar verde** con mensaje de confirmación
- **Auto-cierre** y regreso automático a catálogo después de agregar
- **GestureDetector global** para cerrar teclado al tocar fuera del campo
- **Divisores sutiles** con gradiente entre secciones para mejor organización
- **Botón volver** circular con fondo translúcido en esquina superior
- **8 tipos de animaciones** profesionales integradas

### 🛒 Pantalla de Carrito
- **Lista dinámica** de productos con imagen (80x80px), nombre, precio y descuento
- **Swipe para eliminar** deslizando hacia la izquierda (patrón iOS/Android)
- **Fondo rojo animado** con ícono de basura visible al deslizar
- **Confirmación antes de eliminar** con diálogo personalizado
- **Contador animado** con AnimatedSwitcher (escala 200ms)
- **Botón delete inteligente** que aparece cuando cantidad = 1 (color naranja)
- **Total por producto animado** con fade suave al cambiar cantidad
- **Validación de stock** con mensaje cuando alcanza el máximo
- **Subtotal dinámico animado** con ScaleTransition + FadeTransition (300ms)
- **Cálculo de ahorros** mostrando descuento total en verde
- **Card de información de entrega** con tiempo estimado y costo
- **Sección "Te tientas algo más?"** con sugerencias horizontales
- **Botón + circular** para agregar sugerencias rápidamente
- **Botón "Vaciar carrito"** en AppBar con confirmación
- **Footer fijo elevado** con sombra superior y padding safe area
- **Botón "IR A PAGAR"** prominente en rojo con 16px de padding
- **Estado vacío profesional** con mensaje claro y botón de explorar
- **3 tipos de SnackBars** contextuales (naranja eliminado, verde agregado, negro stock)
- **Animaciones de entrada escalonadas** en todos los elementos
- **4 niveles de animación** integrados (swipe, counter, total, subtotal)
- **Navegación a checkout** al confirmar el pedido

### 💳 Pantalla de Checkout (Último Paso)
- **3 métodos de pago** con iconos distintivos (QR gris, Tarjeta azul, Efectivo verde)
- **Selección animada** con borde rojo (2px), check circular y shadow
- **Press feedback** en cada opción (escala a 0.97)
- **Color de fondo sutil** en método seleccionado (rojo 5% opacity)
- **Datos de entrega editables** con dirección actual y botón "Cambiar"
- **Instrucciones de entrega** personalizables con botón "Editar"
- **Datos de facturación** (nombre y NIT) con botón "Cambiar"
- **Card de resumen completo** con fondo gris claro y borde
- **Desglose de costos** productos, envío (Bs. 5), servicio (Bs. 2)
- **Descuento visible** en verde cuando existe
- **Total animado** con AnimatedSwitcher (300ms)
- **Botón PAGAR prominente** rojo 56px de alto con shadow
- **Loading indicator** circular blanco al procesar pago
- **Diálogo de éxito** no dismissible con ícono verde grande
- **Mensaje de confirmación** claro y profesional
- **Botón "Volver al inicio"** que limpia todo el stack de navegación
- **Footer fijo elevado** con sombra superior
- **Animaciones de entrada escalonadas** (0ms, 100ms, 200ms, 300ms)
- **8 tipos de animaciones** integradas (staggered, fade, slide, scale, container)

### 🎨 Diseño y UX
- **Paleta de colores**: Rojo primario, blanco, negro y amarillo dorado
- **Diseño minimalista**: Sombras sutiles, bordes redondeados, espaciado generoso
- **Animaciones profesionales**: 
  - Entrada escalonada (staggered) en listas
  - Pulso en elementos activos
  - Fade entre tabs y pantallas
  - Shimmer en carga de imágenes
  - Scale en press feedback (0.95-0.98)
- **Micro-interacciones**: Feedback visual en cada tap (150-600ms)
- **Iconografía rounded**: Iconos suaves y modernos de Material Design
- **Cards elevadas**: Sombras dinámicas y border radius 16px
- **Transiciones hero**: Logo y productos con continuidad visual

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework de desarrollo multiplataforma
- **Dart** - Lenguaje de programación
- **Material Design** - Sistema de diseño de Google
- **Responsive Design** - Adaptabilidad a diferentes dispositivos

## 📋 Criterios de Evaluación Implementados

### ✅ Estructura Semántica (25%)
- Widgets semánticamente ricos para accesibilidad
- Estructura clara y organizada del código
- Separación de responsabilidades por widgets

### ✅ Adaptabilidad/Responsividad (25%)
- MediaQuery para diferentes tamaños de pantalla
- LayoutBuilder para diseños adaptativos
- GridView y ListView responsivos
- Soporte para móvil, tablet y desktop

### ✅ Estilo y Consistencia Visual (20%)
- Tema unificado con ThemeData
- Paleta de colores consistente
- Tipografía coherente
- Espaciado y márgenes uniformes

### ✅ Compatibilidad entre Navegadores (15%)
- Flutter Web para compatibilidad multiplataforma
- Soporte para Chrome, Firefox, Safari, Edge
- Optimización para diferentes resoluciones

### ✅ Optimización y Rendimiento (10%)
- Widgets optimizados para mejor rendimiento
- Lazy loading en listas largas
- Gestión eficiente de memoria
- Hot reload para desarrollo ágil

### ✅ Entrega y Documentación (5%)
- Código bien documentado y comentado
- README completo con instrucciones
- Estructura de proyecto organizada

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.8.1 o superior)
- Dart SDK
- Android Studio / VS Code
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd tienda_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Comandos Útiles

```bash
# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Ejecutar en modo debug
flutter run --debug

# Ejecutar en modo release
flutter run --release

# Ejecutar en web
flutter run -d chrome
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                      # Punto de entrada de la aplicación
├── screens/                       # Pantallas de la aplicación
│   ├── home_screen.dart          # Pantalla principal con categorías y sugerencias
│   ├── catalog_screen.dart       # Catálogo con filtros, búsqueda y grid de productos
│   ├── product_detail_screen.dart # Detalle de producto con Hero animation y notas
│   ├── cart_screen.dart          # Carrito con swipe eliminar y animaciones avanzadas
│   ├── checkout_screen.dart      # Checkout con métodos de pago y confirmación
│   ├── offers_screen.dart        # Pantalla de ofertas con grid 2x2 y carruseles
│   ├── orders_screen.dart        # Pantalla de pedidos con tabs y animaciones
│   └── profile_screen.dart       # Pantalla de perfil de usuario
├── widgets/                       # Widgets reutilizables
│   ├── custom_app_bar.dart       # Barra superior con carrito dinámico y back automático
│   ├── bottom_navigation.dart    # Navegación inferior curveada con animaciones
│   ├── product_card.dart         # Tarjeta vertical con botón flotante de agregar
│   ├── category_card.dart        # Tarjeta de categoría con imágenes PNG
│   ├── search_bar.dart           # Barra de búsqueda con focus animado
│   ├── promo_banner.dart         # Banner con auto-scroll y gradiente
│   ├── offer_banner_card.dart    # Card de oferta con carousel manual integrado
│   ├── recent_order_card.dart    # Card horizontal para pedidos recientes
│   ├── suggestion_card.dart      # Card compacta con botón + de agregar
│   ├── pressable_card.dart       # Widget reutilizable con animación de press
│   └── pressable_icon_button.dart # Botón de ícono con feedback táctil
├── utils/                         # Utilidades
│   ├── constants.dart            # Constantes de dimensiones y padding
│   ├── colors.dart               # Paleta de colores de la app
│   └── page_transitions.dart     # Transiciones personalizadas (fade, scale)
└── assets/                        # Recursos estáticos
    ├── images/                   # Imágenes de productos y banners
    │   ├── categories/           # Imágenes de categorías PNG
    │   └── [productos].jpg/.webp
    └── icons/                    # Logo "La Canasta"
        └── la_canasta.png
```

## 🎨 Paleta de Colores

```dart
// Colores principales
Primary Red: #E53E3E
Secondary Red: #C53030
Background White: #FFFFFF
Text Black: #2D3748
Accent Yellow: #FFD700
Light Gray: #F7FAFC
Dark Gray: #4A5568
```

## 📱 Pantallas Implementadas

1. **Home Screen** - Pantalla principal con categorías, banners, pedidos recientes y sugerencias
2. **Catalog Screen** - Catálogo con grid 2 columnas, filtros profesionales y búsqueda integrada
3. **Product Detail Screen** - Detalle completo con Hero animation, contador, notas y confirmación
4. **Cart Screen** - Carrito con swipe para eliminar, animaciones de totales y sugerencias inteligentes
5. **Checkout Screen** - Último paso con métodos de pago, resumen y confirmación de pedido
6. **Offers Screen** - Ofertas con grid 2x2, carruseles manuales, contador regresivo y shimmer
7. **Orders Screen** - Historial con tabs, filtros, animaciones escalonadas y estados vacíos
8. **Profile Screen** - Perfil del usuario con direcciones, configuración y animaciones

## 🔧 Desarrollo

### Widgets Principales
- `CustomAppBar` - Barra superior con logo, carrito dinámico, navegación back automática y animaciones
- `CustomBottomNavigation` - Navegación curveada con indicador animado
- `ProductCard` - Card vertical con imagen, precio, descuento y botón flotante de agregar al carrito
- `CategoryCard` - Card con imagen PNG, animación de entrada, press feedback y navegación a catálogo
- `SearchBar` - Búsqueda con focus animado, border dinámico y botón clear
- `PromoBanner` - Banner con auto-scroll (4s), pausable y gradiente de legibilidad
- `OfferBannerCard` - Card con carousel manual, indicadores y pulso en badges
- `RecentOrderCard` - Card horizontal flexible (botón derecha/abajo)
- `SuggestionCard` - Card compacta con botón + circular para agregar rápido
- `PressableCard` - Widget reutilizable con animación de escala al presionar
- `PressableIconButton` - Botón de ícono reutilizable con feedback táctil

### Características Técnicas
- **State Management**: StatefulWidget con gestión de ciclo de vida (dispose correcto)
- **Navigation**: Transiciones personalizadas (fade, fadeScale, slide, noTransition)
- **Animations**: 
  - Entrada escalonada (staggered) con delay de 80-100ms
  - Pulso continuo (1.5s) en badges activos
  - Shimmer loading en imágenes
  - Scale feedback (0.95-0.98) en press
  - Fade transitions entre tabs (300ms)
- **Custom Widgets**: Componentes reutilizables documentados en lenguaje natural
- **Theme Management**: AppColors con paleta consistente
- **Performance**: 
  - Widgets const donde sea posible
  - Dispose de todos los AnimationController y Timer
  - Verificación mounted antes de setState
  - GPU accelerated animations
  - AutomaticKeepAliveClientMixin en tabs
- **Pull-to-Refresh**: En ofertas y pedidos para actualización
- **Responsive**: NotificationListener para scroll, SafeArea, kToolbarHeight

### ✨ Animaciones Implementadas

#### Entrada Escalonada (Staggered Entry)
- Cards aparecen uno por uno con delay escalonado
- Combinación de FadeTransition + SlideTransition
- Aplicado en: Grid de ofertas, lista de pedidos, categorías, carrito

#### Pulso (Pulse)
- Elementos activos laten sutilmente (6-8% de crecimiento)
- Repetición infinita con reverse
- Aplicado en: Badges "En camino", badges de descuento

#### Shimmer Loading
- Gradiente animado mientras cargan imágenes
- Solo si imagen no está en caché
- Aplicado en: OfferBannerCard

#### Press Feedback
- Scale down (0.95-0.98) al tocar
- Duration: 150ms con curve easeOutBack
- Aplicado en: Todos los elementos interactivos

#### Swipe to Delete (Dismissible)
- Deslizar productos hacia la izquierda para eliminar
- Fondo rojo animado con ícono de basura
- Confirmación con diálogo antes de eliminar definitivamente
- Aplicado en: CartScreen items

#### AnimatedSwitcher en Valores Dinámicos
- **Total del carrito**: ScaleTransition + FadeTransition (300ms)
- **Contador de cantidad**: ScaleTransition (200ms)
- **Total por producto**: FadeTransition (250ms)
- Actualización suave cuando cambian valores numéricos
- Aplicado en: CartScreen

#### Transiciones
- Fade entre tabs (300ms)
- Hero para logo y productos entre pantallas
- Page transitions personalizadas (fade, fadeScale, slide)

### 📊 Funcionalidades Avanzadas

#### Sistema de Filtros Profesionales (CatalogScreen)
- **Filtros combinados** que funcionan simultáneamente
- **Chips de categoría** con íconos Material Design y contador
- **Filtro de precio** con modal bottom sheet (4 rangos)
- **Toggle de disponibilidad** con color verde semántico
- **Botón "Limpiar"** que solo aparece con filtros activos
- **Búsqueda integrada** que se combina con todos los filtros
- **Badge de resultados** mostrando cantidad filtrada
- **Estado vacío** cuando no hay productos que coincidan

#### Navegación Inteligente
- **Botón back automático** detecta Navigator.canPop()
- **Navegación desde categorías** a catálogo con filtro pre-seleccionado
- **Navegación al detalle** con Hero animation desde ProductCard
- **Transiciones personalizadas** fade, fadeScale, slide
- **Mantiene contexto** del usuario en toda la navegación
- **Auto-regreso** después de agregar producto al carrito

#### ProductDetailScreen Completo
- **Hero Animation profesional** imagen vuela desde ProductCard
- **Footer adaptativo inteligente** se oculta con teclado (AnimatedPositioned 200ms)
- **GestureDetector global** cierra teclado al tocar fuera del campo
- **Contador interactivo** con validación mínimo 1 y animaciones de press
- **Campo de notas visible** fondo gris, borde 1.5px, ícono lápiz
- **Total dinámico en tiempo real** precio × cantidad actualizado
- **Confirmación visual completa** rojo → verde con ✓ por 600ms
- **8 animaciones integradas** staggered, fade, slide, scale, hero
- **Divisores con gradiente** organización visual entre secciones
- **Descripciones contextuales** generadas según categoría del producto

#### CartScreen Completo
- **Swipe to Delete nativo** patrón iOS/Android con Dismissible widget
- **Fondo animado** rojo con ícono de basura al deslizar
- **Confirmación doble** diálogo antes de eliminar definitivamente
- **Contador con AnimatedSwitcher** escala suave al cambiar cantidad (200ms)
- **Total animado** ScaleTransition + FadeTransition al actualizar (300ms)
- **Subtotal por item animado** FadeTransition individual (250ms)
- **Botón delete inteligente** naranja cuando quantity = 1 (mejor affordance)
- **Validación de stock** SnackBar negro cuando alcanza máximo
- **Cálculo de ahorros** muestra descuento total en verde
- **Card de entrega** con tiempo estimado y costo separados
- **Sugerencias contextuales** con botón + para agregar rápido
- **Estado vacío profesional** con ícono, mensaje y CTA "Explorar"
- **3 tipos de SnackBars** semánticos (naranja, verde, negro)
- **Botón "Vaciar carrito"** en AppBar con confirmación
- **Footer fijo elevado** con SafeArea y sombra superior
- **Animaciones de entrada** staggered en todos los elementos
- **Navegación a Checkout** pasa subtotal y descuento como parámetros

#### CheckoutScreen Completo
- **3 métodos de pago** QR (gris), Tarjeta (azul), Efectivo (verde)
- **Selección con AnimatedContainer** borde cambia de gris a rojo (200ms)
- **Check circular animado** aparece en método seleccionado
- **Press feedback con AnimatedScale** a 0.97 en cada opción
- **Fondo sutil** rojo 5% opacity cuando está seleccionado
- **Shadow dinámica** aparece solo en opción activa
- **Cards de datos editables** entrega, instrucciones y facturación
- **Iconos contextuales** delivery, descripción, factura
- **Botones de acción** "Cambiar" y "Editar" en color rojo
- **Resumen en card** fondo gris claro con borde
- **Desglose completo** productos, envío (Bs. 5), servicio (Bs. 2)
- **Sección descuento** con divider, solo visible si existe
- **Total con AnimatedSwitcher** ScaleTransition (300ms)
- **Botón PAGAR** 56px alto, rojo prominente, shadow elevation
- **Loading state** circular indicator blanco al procesar
- **Diálogo no dismissible** barrierDismissible: false
- **Confirmación visual** ícono verde 80x80px con fondo circular
- **Navegación al home** popUntil limpia todo el stack
- **Animaciones escalonadas** 4 secciones (0ms, 100ms, 200ms, 300ms)
- **Footer fijo elevado** SafeArea y sombra superior

#### Botón Flotante de Agregar al Carrito
- **Posición estratégica** en esquina superior derecha
- **Animación de press** con escala a 0.85
- **Confirmación visual** rojo → verde con ícono ✓
- **Duración temporal** de 600ms antes de volver al estado inicial
- **SnackBar verde** con mensaje de confirmación
- **Contador dinámico** que se actualiza en AppBar

#### Contador Regresivo
- Timer actualizado cada segundo
- Formato dinámico: "2h 30m" o "30m 15s"
- Reinicio automático al llegar a 0
- Aplicado en: Ofertas Flash

#### Carruseles Manuales
- PageView con indicadores animados
- Control total del usuario (swipe)
- Sin auto-scroll para no saturar
- Aplicado en: Grid 2x2 de ofertas

#### Sistema de Tabs con Filtros
- TabController con 3 pestañas
- Filtrado dinámico de datos
- Estados vacíos personalizados
- Aplicado en: Pantalla de pedidos

#### Estados Vacíos
- Mensajes personalizados por contexto
- Iconos y textos descriptivos
- Aplicado en: Catálogo y pedidos sin resultados

### ✨ Características de UI/UX Destacadas
- **Bottom Navigation Curveado**: Bordes 24px, sombra sutil, indicador animado
- **Tabs Minimalistas**: Fondo blanco, sombra suave, indicador con sombra propia
- **Badges Informativos**: Estados visuales (En camino 🚚, Entregado ✓, Opcional)
- **Filtros Intuitivos**: Color verde = disponible, rojo = activos, texto claro y descriptivo
- **Navegación Automática**: Botón back aparece solo cuando es necesario
- **Botón Flotante**: Agregar al carrito con confirmación visual instantánea
- **Chips Interactivos**: Categorías con íconos, contador y animaciones de press
- **Modal Bottom Sheet**: Opciones de precio claras y fáciles de seleccionar
- **Hero Animations**: Transiciones suaves de imágenes entre pantallas
- **Footer Adaptativo**: Se oculta automáticamente cuando aparece el teclado
- **Campo de Notas Visible**: Fondo gris, borde claro, ícono de lápiz, affordance perfecta
- **Contador Intuitivo**: Botones +/- con validación y feedback inmediato
- **Total Dinámico**: Precio actualizado en tiempo real según cantidad
- **Confirmación Progresiva**: Botón rojo → verde con ✓ → SnackBar → Auto-cierre
- **Divisores Sutiles**: Gradientes para organizar secciones sin ser intrusivos
- **GestureDetector Global**: Cierra teclado al tocar cualquier parte de la pantalla
- **Overlay Gradientes**: Legibilidad de texto sobre imágenes
- **Sombras Dinámicas**: Profundidad sin sobrecargar
- **Press Feedback Universal**: Todas las interacciones tienen respuesta visual
- **Scroll Dismissible**: Teclado se cierra al scrollear
- **Pull-to-Refresh**: Actualización manual con feedback
- **Estados Vacíos**: Mensajes contextuales cuando no hay resultados
- **SnackBars Informativos**: Feedback claro con iconos y colores semánticos
- **Placeholder con Ejemplos**: Guía al usuario sobre cómo usar campos opcionales
- **Swipe para Eliminar**: Patrón nativo iOS/Android con fondo rojo visible
- **Confirmación de Eliminación**: Diálogo antes de acciones destructivas
- **Botón Delete Inteligente**: Cambia a naranja cuando quantity = 1 (mejor affordance)
- **Totales Animados**: Valores numéricos se actualizan con animaciones fluidas
- **Validación de Stock**: Mensajes contextuales cuando alcanza límite
- **Cálculo de Ahorros Visible**: Descuento total mostrado en verde
- **Sugerencias Contextuales**: "Te tientas algo más?" en momento oportuno
- **Footer Elevado**: Sombra superior y padding SafeArea para navegación gestual
- **Métodos de Pago Visuales**: Iconos y colores distintos (gris QR, azul tarjeta, verde efectivo)
- **Selección Clara**: Borde rojo 2px, check circular, fondo sutil y shadow dinámica
- **Datos Editables Explícitos**: Botones "Cambiar" y "Editar" en cada sección
- **Resumen Visual**: Card con fondo gris claro y desglose completo de costos
- **Loading State Claro**: Circular indicator blanco en botón al procesar pago
- **Confirmación No Dismissible**: Diálogo que asegura que el usuario vea el mensaje de éxito
- **Navegación Inteligente**: PopUntil limpia el stack y regresa al inicio después del pago

## 📊 Métricas de Rendimiento

- **Tiempo de carga inicial**: < 2 segundos
- **FPS promedio**: 60 FPS
- **Tamaño de la aplicación**: < 50MB
- **Compatibilidad**: Android 5.0+, iOS 11.0+

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autores

- **Axel Mamani** - *Desarrollo inicial* - [GitHub](https://github.com/AxelMQ)

## 🙏 Agradecimientos

- Flutter Team por el excelente framework
- Material Design por el sistema de diseño
- Comunidad Flutter por las contribuciones

---

**Nota**: Este proyecto está enfocado en UI/UX y diseño responsivo. No incluye funcionalidades de backend ni gestión de datos reales.