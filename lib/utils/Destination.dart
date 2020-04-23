
import 'package:flutter/material.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Minhas Receitas', Icons.book, Colors.white),
  Destination('Compartilhadas Comigo', Icons.share, Colors.white)
];