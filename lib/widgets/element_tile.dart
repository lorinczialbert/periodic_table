import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element.dart';
import '../theme/app_theme.dart';

class ElementTile extends StatelessWidget {
  final ChemElement element;
  final VoidCallback? onTap;
  final double size;
  final bool dimmed;

  const ElementTile({
    super.key,
    required this.element,
    this.onTap,
    this.size = 52,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final cat   = element.category;
    final color = cat.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.18 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: size,
          height: size * 1.15,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.55), width: 1),
          ),
          child: Stack(
            children: [
              // Atomic number — top-left
              Positioned(
                top: 3,
                left: 4,
                child: Text(
                  '${element.atomicNumber}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: size * 0.165,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Symbol — centred
              Center(
                child: Text(
                  element.symbol,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: size * 0.38,
                    color: color,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),

              // Name + mass — bottom
              Positioned(
                bottom: 3,
                left: 2,
                right: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      element.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: size * 0.135,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      element.atomicMass,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: size * 0.13,
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal tile used in search results list.
class ElementListTile extends StatelessWidget {
  final ChemElement element;
  final VoidCallback? onTap;

  const ElementListTile({super.key, required this.element, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: element.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: element.color.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            element.symbol,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              color: element.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      title: Text(
        element.name,
        style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${element.category.label}  ·  Z = ${element.atomicNumber}',
        style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Text(
        element.atomicMass,
        style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textTertiary,
          fontSize: 13,
        ),
      ),
    );
  }
}
