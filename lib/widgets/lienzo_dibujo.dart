// lib/widgets/lienzo_dibujo.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/proyecto_tuberias.dart'; // Importamos las clases, no las redefinimos

// 1. El Widget principal que se coloca en la pantalla
class LienzoDibujo extends StatelessWidget {
  const LienzoDibujo({super.key});

  @override
  Widget build(BuildContext context) {
    // 'watch' se asegura de que el lienzo se redibuje cada vez que el estado cambie
    final estadoProyecto = context.watch<EstadoProyecto>();

    // CustomPaint es el widget de Flutter que nos permite dibujar libremente
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200], // Un fondo para el lienzo
      child: CustomPaint(
        painter: _LienzoDibujoPainter(estadoProyecto),
      ),
    );
  }
}

// 2. La clase "Pintor" que contiene la lógica de dibujo
class _LienzoDibujoPainter extends CustomPainter {
  final EstadoProyecto estadoProyecto;

  _LienzoDibujoPainter(this.estadoProyecto);

  @override
  void paint(Canvas canvas, Size size) {
    // Centramos el punto de origen (0,0,0) en medio de la pantalla
    canvas.translate(size.width / 2, size.height / 2);

    final paint = Paint()
      ..strokeWidth = 3.0 // Grosor de la línea
      ..style = PaintingStyle.stroke;

    // Dibujamos cada línea del proyecto
    for (var linea in estadoProyecto.lineas) {
      // Usamos la función de proyección del modelo para convertir 3D a 2D
      final p1 = estadoProyecto.proyeccionIsometrica(linea.inicio);
      final p2 = estadoProyecto.proyeccionIsometrica(linea.fin);

      paint.color = linea.color; // Usamos el color definido en la línea
      canvas.drawLine(p1, p2, paint);
    }
  }

  // Le decimos a Flutter que redibuje siempre que haya un cambio
  @override
  bool shouldRepaint(covariant _LienzoDibujoPainter oldDelegate) {
    return true;
  }
}