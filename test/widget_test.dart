// Test para la aplicación Tienda App
//
// Este test verifica que la aplicación se ejecute correctamente
// y que los elementos principales estén presentes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tienda_app/main.dart';

void main() {
  testWidgets('Tienda App basic test', (WidgetTester tester) async {
    // Construir la aplicación y activar un frame
    await tester.pumpWidget(const TiendaApp());

    // Verificar que la aplicación se construya sin errores críticos
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verificar que el logo "La Canasta" esté presente
    expect(find.text('La Canasta'), findsOneWidget);
    
    // Verificar que la barra de búsqueda esté presente
    expect(find.byType(TextField), findsOneWidget);
    
    // Verificar que el texto de búsqueda esté presente
    expect(find.text('Buscar Producto'), findsOneWidget);
  });
}
