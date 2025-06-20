import 'package:flutter/material.dart';
import 'dart:math' as math;

// --- Modelos de Datos ---

class Point3D {
  final double x, y, z;
  Point3D(this.x, this.y, this.z);

  Point3D move(Direccion dir, double longitud) {
    switch (dir) {
      case Direccion.ingresa: return Point3D(x, y - longitud, z);
      case Direccion.sale: return Point3D(x, y + longitud, z);
      case Direccion.derecha: return Point3D(x + longitud, y, z);
      case Direccion.izquierda: return Point3D(x - longitud, y, z);
      case Direccion.arriba: return Point3D(x, y, z + longitud);
      case Direccion.abajo: return Point3D(x, y, z - longitud);
    }
  }
}

enum Direccion { ingresa, sale, derecha, izquierda, arriba, abajo }

class LineaTuberia {
  final Point3D inicio;
  final Point3D fin;
  final double longitud;
  final Direccion direccion;
  // Propiedades que el usuario puede cambiar
  Color color;
  String diametro;
  String material;

  LineaTuberia({
    required this.inicio,
    required this.fin,
    required this.longitud,
    required this.direccion,
    this.color = Colors.blue,
    this.diametro = '1/2"',
    this.material = 'Cobre',
  });
}

// --- El "Cerebro" de la App (Gestor de Estado) ---

class EstadoProyecto extends ChangeNotifier {
  String nombreProyecto = "perdi 4 horas de mi teimpo csmr!!!!";
  String nombreCliente = "";

  List<LineaTuberia> _lineas = [];
  Point3D _puntoActual = Point3D(0, 0, 0);
  bool _dibujoIniciado = false;
  
  // Usamos una pila para el "deshacer"
  final List<List<LineaTuberia>> _historial = [];

  // Getters públicos para que la UI pueda leer los datos
  List<LineaTuberia> get lineas => _lineas;
  bool get dibujoIniciado => _dibujoIniciado;

  static const double longitudPorDefecto = 100.0;

  void agregarSegmento(Direccion dir) {
    if (!_dibujoIniciado) {
      _limpiarDibujo();
      _dibujoIniciado = true;
    }

    _guardarEstadoParaDeshacer();

    final nuevoPunto = _puntoActual.move(dir, longitudPorDefecto);
    final nuevaLinea = LineaTuberia(
      inicio: _puntoActual,
      fin: nuevoPunto,
      longitud: longitudPorDefecto,
      direccion: dir,
    );

    _lineas.add(nuevaLinea);
    _puntoActual = nuevoPunto;

    // Notifica a todos los widgets que están escuchando que ha habido un cambio.
    notifyListeners();
  }

  void deshacer() {
    if (_historial.isNotEmpty) {
      _lineas = _historial.removeLast();
      if (_lineas.isNotEmpty) {
        _puntoActual = _lineas.last.fin;
        _dibujoIniciado = true;
      } else {
        _puntoActual = Point3D(0, 0, 0);
        _dibujoIniciado = false;
      }
      notifyListeners();
    }
  }

  void _guardarEstadoParaDeshacer() {
    // Creamos una copia profunda de la lista actual
    final estadoActual = _lineas.map((linea) => LineaTuberia(
      inicio: linea.inicio,
      fin: linea.fin,
      longitud: linea.longitud,
      direccion: linea.direccion,
      color: linea.color,
      diametro: linea.diametro,
      material: linea.material,
    )).toList();
    _historial.add(estadoActual);
  }

  void _limpiarDibujo() {
    _lineas = [];
    _historial.clear();
    _puntoActual = Point3D(0, 0, 0);
    notifyListeners();
  }

  // --- Funciones de Proyección Isométrica ---
  // Las mantenemos aquí porque son parte de la lógica del proyecto.
  static const double pixelsPorCm = 0.6;
  static final double anguloRadianes = math.pi / 6; // 30 grados

  Offset proyeccionIsometrica(Point3D punto) {
    final ix = (punto.x - punto.y) * math.cos(anguloRadianes);
    final iy = ((punto.x + punto.y) * math.sin(anguloRadianes)) - punto.z;
    return Offset(ix * pixelsPorCm, iy * pixelsPorCm);
  }
}