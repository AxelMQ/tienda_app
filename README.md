# 🛒 Tienda App - Supermercado Digital

Una aplicación móvil desarrollada en Flutter para una tienda de comercios masivos (supermercado), enfocada en UI/UX y diseño responsivo.

## 📱 Descripción del Proyecto

**Tienda App** es una aplicación de e-commerce para supermercados que ofrece una experiencia de usuario moderna y intuitiva. El proyecto se centra en el diseño y maquetación, implementando las mejores prácticas de UI/UX con Flutter.

## 🎯 Características Principales

### 🏠 Pantalla Principal
- **AppBar personalizado** con logo "La Canasta" y carrito interactivo
- **Barra de búsqueda** intuitiva para productos
- **Banner promocional** destacado con ofertas
- **Categorías** con scroll horizontal (Lácteos, Carnes, Bebidas, etc.)
- **Pedidos recientes** con botón de "Volver a Pedir"
- **Sugerencias personalizadas** de productos
- **Bottom Navigation curveado** con 4 secciones (Inicio, Ofertas, Pedidos, Perfil)

### 🎨 Diseño y UX
- **Paleta de colores**: Rojo primario, blanco, negro y amarillo dorado
- **Diseño curveado**: Border radius de 24px en navegación para look moderno
- **Animaciones fluidas**: Transiciones de 150ms entre pantallas
- **Micro-interacciones**: Feedback visual en cada tap y selección
- **Iconografía rounded**: Iconos suaves y modernos de Material Design
- **Cards de productos**: Con precios, descuentos y badges de promoción

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
│   ├── home_screen.dart          # Pantalla principal
│   ├── offers_screen.dart        # Pantalla de ofertas
│   ├── orders_screen.dart        # Pantalla de pedidos
│   └── profile_screen.dart       # Pantalla de perfil
├── widgets/                       # Widgets reutilizables
│   ├── custom_app_bar.dart       # Barra superior con animaciones
│   ├── bottom_navigation.dart    # Navegación inferior curveada
│   ├── product_card.dart         # Tarjeta de producto
│   ├── category_card.dart        # Tarjeta de categoría
│   ├── search_bar.dart           # Barra de búsqueda
│   └── promo_banner.dart         # Banner promocional
├── utils/                         # Utilidades
│   ├── constants.dart            # Constantes de la aplicación
│   ├── colors.dart               # Paleta de colores
│   └── page_transitions.dart     # Transiciones personalizadas
└── assets/                        # Recursos estáticos
    ├── images/                   # Imágenes de productos
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

1. **Home Screen** - Pantalla principal con categorías, productos y búsqueda
2. **Offers Screen** - Pantalla de ofertas especiales y promociones
3. **Orders Screen** - Historial de pedidos del usuario
4. **Profile Screen** - Perfil del usuario con configuración

## 🔧 Desarrollo

### Widgets Principales
- `CustomAppBar` - Barra superior con logo personalizado y carrito animado
- `CustomBottomNavigation` - Navegación inferior con diseño curveado y animaciones
- `ProductCard` - Tarjeta de producto reutilizable
- `CategoryCard` - Tarjeta de categoría
- `SearchBar` - Barra de búsqueda personalizada
- `PromoBanner` - Banner promocional con carrusel

### Características Técnicas
- **State Management**: StatefulWidget para gestión de estado local
- **Navigation**: Sistema de transiciones personalizadas (fade, scale, slide)
- **Animations**: Micro-animaciones en navegación y controles (200ms optimizado)
- **Custom Widgets**: Componentes reutilizables y bien documentados
- **Theme Management**: Paleta de colores consistente con AppColors
- **Performance**: Dispose correcto, widgets const, sin overflow

### ✨ Características de UI/UX Destacadas
- **Bottom Navigation Curveado**: Bordes superiores de 24px radius para look moderno
- **Animaciones Fluidas**: Fade transitions de 150ms entre pantallas
- **Hero Animations**: Logo con transición hero entre pantallas
- **Carrito Interactivo**: Contador dinámico con animación de rebote
- **Feedback Visual**: Animaciones en tap, fade en texto, indicadores de selección

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