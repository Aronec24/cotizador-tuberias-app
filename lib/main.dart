import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modelos/proyecto_tuberias.dart';
import 'widgets/lienzo_dibujo.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EstadoProyecto(),
      child: const AppCotizadorTuberias(),
    ),
  );
}

class AppCotizadorTuberias extends StatelessWidget {
  const AppCotizadorTuberias({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotizador de Tuberías',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que el título se actualice cuando cambie el nombre del proyecto
    final nombreProyecto = context.watch<EstadoProyecto>().nombreProyecto;

    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto: $nombreProyecto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Cargar Proyecto',
            onPressed: () {
              // Lógica para cargar (la añadiremos más adelante)
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Guardar Proyecto',
            onPressed: () {
              // Lógica para guardar
            },
          ),
        ],
      ),
      body: const LienzoDibujo(), // Nuestro widget de dibujo personalizado
      bottomNavigationBar: const BarraControles(), // Nuestros botones de control
    );
  }
}

class BarraControles extends StatelessWidget {
  const BarraControles({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos 'read' dentro de callbacks para llamar a las funciones del estado
    final estado = context.read<EstadoProyecto>();

    return BottomAppBar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.arrow_downward), tooltip: "Ingresa (E)", onPressed: () => estado.agregarSegmento(Direccion.ingresa)),
            IconButton(icon: const Icon(Icons.arrow_upward), tooltip: "Sale (Q)", onPressed: () => estado.agregarSegmento(Direccion.sale)),
            IconButton(icon: const Icon(Icons.arrow_forward), tooltip: "Derecha (D)", onPressed: () => estado.agregarSegmento(Direccion.derecha)),
            IconButton(icon: const Icon(Icons.arrow_back), tooltip: "Izquierda (A)", onPressed: () => estado.agregarSegmento(Direccion.izquierda)),
            IconButton(icon: const Icon(Icons.expand_less), tooltip: "Arriba (W)", onPressed: () => estado.agregarSegmento(Direccion.arriba)),
            IconButton(icon: const Icon(Icons.expand_more), tooltip: "Abajo (S)", onPressed: () => estado.agregarSegmento(Direccion.abajo)),
            const VerticalDivider(),
            IconButton(icon: const Icon(Icons.undo), tooltip: "Deshacer", onPressed: estado.deshacer),
            IconButton(icon: const Icon(Icons.center_focus_strong), tooltip: "Centrar Vista", onPressed: () {
              // Lógica para centrar (a implementar en el lienzo)
            }),
            const VerticalDivider(),
             ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text("Cotizar"),
              onPressed: () {
                // Lógica para mostrar la cotización
              },
            ),
          ],
        ),
      ),
    );
  }
}