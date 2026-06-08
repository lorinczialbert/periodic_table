import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/element.dart';
import '../data/elements.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/element_tile.dart';
import 'element_detail_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  static const double _tileW = 56.0;
  static const double _tileH = 64.0;
  static const double _gap   = 2.0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final active   = provider.selectedCategory;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildCategoryChips(provider, active),
            const SizedBox(height: 8),
            Expanded(child: _buildTable(active)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.spaceGrotesk(
                fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.textPrimary,
              ),
              children: const [
                TextSpan(text: 'Chem'),
                TextSpan(
                  text: 'Table',
                  style: TextStyle(color: AppTheme.accentCyan),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '118 elements',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12, color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(AppProvider provider, ElementCategory? active) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: ElementCategory.values.map((cat) {
          final selected = active == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 6, top: 6),
            child: GestureDetector(
              onTap: () => provider.setCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? cat.color.withOpacity(0.25) : AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? cat.color : AppTheme.bgElevated,
                  ),
                ),
                child: Text(
                  cat.label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: selected ? cat.color : AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTable(ElementCategory? activeCategory) {
    return InteractiveViewer(
      minScale: 0.28,
      maxScale: 4.0,
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 18 * (_tileW + _gap) + _gap,
          height: 10 * (_tileH + _gap) + _gap + (_tileH * 0.4), // extra for spacer row
          child: Stack(
            children: [
              // Placeholder for lanthanides
              _buildPlaceholder(6, 3, '57–71', AppTheme.catLanthanide),
              // Placeholder for actinides
              _buildPlaceholder(7, 3, '89–103', AppTheme.catActinide),
              // Spacer label
              _buildRowLabel(8, ''),
              // Lanthanide label
              _buildFBlockLabel(9, 'Lanthanides', AppTheme.catLanthanide),
              // Actinide label
              _buildFBlockLabel(10, 'Actinides', AppTheme.catActinide),
              // All element tiles
              ...allElements.map((el) {
                final dimmed = activeCategory != null && el.category != activeCategory;
                return _buildTile(el, dimmed);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(ChemElement el, bool dimmed) {
    final left = (el.tableCol - 1) * (_tileW + _gap);
    final top  = _rowTop(el.tableRow);

    return Positioned(
      left: left,
      top:  top,
      child: ElementTile(
        element: el,
        size: _tileW,
        dimmed: dimmed,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ElementDetailScreen(element: el)),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(int row, int col, String label, Color color) {
    final left = (col - 1) * (_tileW + _gap);
    final top  = _rowTop(row);
    return Positioned(
      left: left, top: top,
      child: Container(
        width: _tileW, height: _tileH * 1.15,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9, color: color.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowLabel(int row, String label) {
    return Positioned(
      left: 0, top: _rowTop(row),
      child: SizedBox(width: 18 * (_tileW + _gap), height: _tileH * 0.4),
    );
  }

  Widget _buildFBlockLabel(int row, String label, Color color) {
    final top = _rowTop(row);
    return Positioned(
      left: 0, top: top,
      child: Container(
        width: 3 * (_tileW + _gap),
        height: _tileH * 1.15,
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 8,
            color: color.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  double _rowTop(int row) {
    // Row 8 is a half-height spacer
    if (row <= 7) return (row - 1) * (_tileH + _gap);
    if (row == 8) return 7 * (_tileH + _gap);
    // f-block starts after the spacer
    final spacerH = _tileH * 0.4;
    return 7 * (_tileH + _gap) + spacerH + (row - 9) * (_tileH + _gap);
  }
}
