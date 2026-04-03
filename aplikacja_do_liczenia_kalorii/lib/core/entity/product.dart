import 'package:equatable/equatable.dart';

class Product extends Equatable{
  final String name;
  final int kcalPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;

  const Product({
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
  });

  @override
  String toString() => '$name ($kcalPer100g kcal)';

  @override
  List<Object?> get props => [name, kcalPer100g, proteinPer100g, fatPer100g, carbsPer100g];
}