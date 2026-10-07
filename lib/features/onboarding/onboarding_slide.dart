import 'package:flutter/material.dart';

class OnboardingSlide {
  final IconData? icon;
  final String? headline;
  final String? description;

  const OnboardingSlide({
    required this.icon,
    required this.headline,
    required this.description,
  });

  const OnboardingSlide.logo()
    : icon = null,
      headline = null,
      description = null;

  bool get isLogo => icon == null;

  static const List<OnboardingSlide> all = [
    OnboardingSlide.logo(),
    OnboardingSlide(
      icon: Icons.kitchen_rounded,
      headline: 'Your kitchen, digitized',
      description: 'Every ingredient in your pantry and every tool on your shelf, in one place.',
    ),
    OnboardingSlide(
      icon: Icons.restaurant_menu_rounded,
      headline: 'Cook with what you have',
      description: 'Recipes you can make right now, plus a grocery list for whatever is missing.',
    ),
    OnboardingSlide(
      icon: Icons.pie_chart_rounded,
      headline: 'Know your macros',
      description: 'Protein, carbs, and calories tracked from the meals you actually cook.',
    ),
    OnboardingSlide(
      icon: Icons.play_circle_rounded,
      headline: 'Share what you make',
      description: 'Post recipes as written steps or short videos, and scroll what everyone else is cooking.',
    ),
  ];
}
