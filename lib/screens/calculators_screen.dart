import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/elements.dart';
import '../theme/app_theme.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Lab Calculators',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 26, fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              )),
            const SizedBox(height: 4),
            Text('Tap a card to open the calculator',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13, color: AppTheme.textTertiary,
              )),
            const SizedBox(height: 20),
            _CalcCard(
              icon: Icons.science_rounded,
              color: AppTheme.accentCyan,
              title: 'Molar Mass',
              subtitle: 'Enter a chemical formula → get M (g/mol)',
              builder: (_) => const _MolarMassCalc(),
            ),
            _CalcCard(
              icon: Icons.water_drop_rounded,
              color: AppTheme.catHalogen,
              title: 'Molarity',
              subtitle: 'Moles + volume → concentration (mol/L)',
              builder: (_) => const _MolarityCalc(),
            ),
            _CalcCard(
              icon: Icons.swap_horiz_rounded,
              color: AppTheme.catTransition,
              title: 'Dilution  (C₁V₁ = C₂V₂)',
              subtitle: 'Find any one of the four variables',
              builder: (_) => const _DilutionCalc(),
            ),
            _CalcCard(
              icon: Icons.percent_rounded,
              color: AppTheme.catAlkali,
              title: 'Percent Composition',
              subtitle: 'Mass % of each element in a formula',
              builder: (_) => const _PercentCompositionCalc(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Expandable Card ───────────────────────────────────────────────────────────
class _CalcCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;

  const _CalcCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  @override
  State<_CalcCard> createState() => _CalcCardState();
}

class _CalcCardState extends State<_CalcCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _expanded
              ? widget.color.withOpacity(0.5)
              : AppTheme.bgElevated,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15, fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          )),
                        Text(widget.subtitle,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11, color: AppTheme.textTertiary,
                          )),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: widget.color.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: widget.builder(context),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Formula Parser ────────────────────────────────────────────────────────────
class _FormulaParser {
  static final _massMap = {
    for (final e in allElements) e.symbol: double.tryParse(e.atomicMass) ?? 0.0
  };

  /// Returns {symbol: count} or throws FormatException on bad input.
  static Map<String, double> parse(String formula) {
    final result = <String, double>{};
    _parseSegment(formula, 0, formula.length, result, 1.0);
    return result;
  }

  static void _parseSegment(
      String f, int start, int end, Map<String, double> out, double mult) {
    int i = start;
    while (i < end) {
      if (f[i] == '(') {
        int depth = 1, j = i + 1;
        while (j < end && depth > 0) {
          if (f[j] == '(') depth++;
          if (f[j] == ')') depth--;
          j++;
        }
        // j is after ')'
        int numStart = j;
        while (j < end && _isDigit(f[j])) j++;
        double n = numStart == j ? 1 : double.parse(f.substring(numStart, j));
        _parseSegment(f, i + 1, j - (j - numStart) - 1, out, mult * n);
        i = j;
      } else if (_isUpper(f[i])) {
        int j = i + 1;
        while (j < end && _isLower(f[j])) j++;
        final sym = f.substring(i, j);
        int numStart = j;
        while (j < end && _isDigit(f[j])) j++;
        double n = numStart == j ? 1 : double.parse(f.substring(numStart, j));
        if (!_massMap.containsKey(sym)) {
          throw FormatException('Unknown element: $sym');
        }
        out[sym] = (out[sym] ?? 0) + n * mult;
        i = j;
      } else {
        i++;
      }
    }
  }

  static bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  static bool _isUpper(String c) => c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90;
  static bool _isLower(String c) => c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122;

  static double molarMass(String formula) {
    final map = parse(formula);
    final massMap = _massMap;
    double total = 0;
    for (final e in map.entries) total += (massMap[e.key] ?? 0) * e.value;
    return total;
  }
}

// ── 1. Molar Mass ─────────────────────────────────────────────────────────────
class _MolarMassCalc extends StatefulWidget {
  const _MolarMassCalc();
  @override State<_MolarMassCalc> createState() => _MolarMassCalcState();
}

class _MolarMassCalcState extends State<_MolarMassCalc> {
  final _ctrl = TextEditingController();
  String _result = '';
  String _breakdown = '';
  bool _error = false;

  void _calculate() {
    final formula = _ctrl.text.trim();
    if (formula.isEmpty) return;
    try {
      final map  = _FormulaParser.parse(formula);
      final mass = _FormulaParser.molarMass(formula);
      final massMap = { for (final e in allElements) e.symbol: double.tryParse(e.atomicMass) ?? 0.0 };
      final lines = map.entries.map((e) {
        final m = (massMap[e.key] ?? 0) * e.value;
        final pct = mass > 0 ? m / mass * 100 : 0;
        return '${e.key}: ${e.value.toStringAsFixed(0)} × ${massMap[e.key]?.toStringAsFixed(3)} = ${m.toStringAsFixed(3)} g/mol  (${pct.toStringAsFixed(1)}%)';
      });
      setState(() {
        _result = '${mass.toStringAsFixed(4)} g/mol';
        _breakdown = lines.join('\n');
        _error = false;
      });
    } on FormatException catch (e) {
      setState(() { _result = e.message; _breakdown = ''; _error = true; });
    }
  }

  @override
  Widget build(BuildContext context) => _calcBody(
    children: [
      _formulaField(_ctrl, 'e.g. H2O, Ca(OH)2, C6H12O6'),
      _calcButton('Calculate', AppTheme.accentCyan, _calculate),
      if (_result.isNotEmpty) _resultBox(_result, _breakdown, _error),
    ],
  );
}

// ── 2. Molarity ───────────────────────────────────────────────────────────────
class _MolarityCalc extends StatefulWidget {
  const _MolarityCalc();
  @override State<_MolarityCalc> createState() => _MolarityCalcState();
}

class _MolarityCalcState extends State<_MolarityCalc> {
  final _moles = TextEditingController();
  final _vol   = TextEditingController();
  final _conc  = TextEditingController();
  String _solve = 'Concentration'; // what to solve for
  String _result = '';

  void _calculate() {
    try {
      switch (_solve) {
        case 'Concentration':
          final n = double.parse(_moles.text);
          final v = double.parse(_vol.text) / 1000;
          final c = n / v;
          setState(() => _result = 'C = ${c.toStringAsFixed(4)} mol/L');
          break;
        case 'Moles':
          final c = double.parse(_conc.text);
          final v = double.parse(_vol.text) / 1000;
          final n = c * v;
          setState(() => _result = 'n = ${n.toStringAsFixed(4)} mol');
          break;
        case 'Volume':
          final c = double.parse(_conc.text);
          final n = double.parse(_moles.text);
          final v = n / c * 1000;
          setState(() => _result = 'V = ${v.toStringAsFixed(2)} mL');
          break;
      }
    } catch (_) {
      setState(() => _result = 'Check your inputs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _calcBody(children: [
      _dropdownField<String>(
        label: 'Solve for',
        value: _solve,
        items: ['Concentration', 'Moles', 'Volume'],
        onChanged: (v) => setState(() { _solve = v!; _result = ''; }),
      ),
      if (_solve != 'Moles')   _numField(_moles, 'Moles (mol)'),
      if (_solve != 'Volume')  _numField(_vol,   'Volume (mL)'),
      if (_solve != 'Concentration') _numField(_conc, 'Concentration (mol/L)'),
      _calcButton('Calculate', AppTheme.catHalogen, _calculate),
      if (_result.isNotEmpty) _resultBox(_result, '', false),
    ]);
  }
}

// ── 3. Dilution ───────────────────────────────────────────────────────────────
class _DilutionCalc extends StatefulWidget {
  const _DilutionCalc();
  @override State<_DilutionCalc> createState() => _DilutionCalcState();
}

class _DilutionCalcState extends State<_DilutionCalc> {
  final _c1 = TextEditingController();
  final _v1 = TextEditingController();
  final _c2 = TextEditingController();
  final _v2 = TextEditingController();
  String _solve = 'V₂';
  String _result = '';

  void _calculate() {
    try {
      double c1 = double.tryParse(_c1.text) ?? 0;
      double v1 = double.tryParse(_v1.text) ?? 0;
      double c2 = double.tryParse(_c2.text) ?? 0;
      double v2 = double.tryParse(_v2.text) ?? 0;
      switch (_solve) {
        case 'C₁': c1 = c2 * v2 / v1; setState(() => _result = 'C₁ = ${c1.toStringAsFixed(4)}'); break;
        case 'V₁': v1 = c2 * v2 / c1; setState(() => _result = 'V₁ = ${v1.toStringAsFixed(4)} mL'); break;
        case 'C₂': c2 = c1 * v1 / v2; setState(() => _result = 'C₂ = ${c2.toStringAsFixed(4)}'); break;
        case 'V₂': v2 = c1 * v1 / c2; setState(() => _result = 'V₂ = ${v2.toStringAsFixed(4)} mL'); break;
      }
    } catch (_) {
      setState(() => _result = 'Check your inputs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _calcBody(children: [
      _dropdownField<String>(
        label: 'Solve for',
        value: _solve,
        items: ['C₁', 'V₁', 'C₂', 'V₂'],
        onChanged: (v) => setState(() { _solve = v!; _result = ''; }),
      ),
      if (_solve != 'C₁') _numField(_c1, 'C₁ (initial concentration)'),
      if (_solve != 'V₁') _numField(_v1, 'V₁ (initial volume, mL)'),
      if (_solve != 'C₂') _numField(_c2, 'C₂ (final concentration)'),
      if (_solve != 'V₂') _numField(_v2, 'V₂ (final volume, mL)'),
      _calcButton('Calculate', AppTheme.catTransition, _calculate),
      if (_result.isNotEmpty) _resultBox(_result, '', false),
    ]);
  }
}

// ── 4. Percent Composition ───────────────────────────────────────────────────
class _PercentCompositionCalc extends StatefulWidget {
  const _PercentCompositionCalc();
  @override State<_PercentCompositionCalc> createState() => _PercentCompositionCalcState();
}

class _PercentCompositionCalcState extends State<_PercentCompositionCalc> {
  final _ctrl = TextEditingController();
  String _result = '';
  bool _error = false;

  void _calculate() {
    final formula = _ctrl.text.trim();
    if (formula.isEmpty) return;
    try {
      final map  = _FormulaParser.parse(formula);
      final mass = _FormulaParser.molarMass(formula);
      final massMap = { for (final e in allElements) e.symbol: double.tryParse(e.atomicMass) ?? 0.0 };
      final lines = map.entries.map((e) {
        final m   = (massMap[e.key] ?? 0) * e.value;
        final pct = mass > 0 ? m / mass * 100 : 0;
        return '${e.key}: ${pct.toStringAsFixed(2)}%';
      });
      setState(() {
        _result = lines.join('\n');
        _error  = false;
      });
    } on FormatException catch (e) {
      setState(() { _result = e.message; _error = true; });
    }
  }

  @override
  Widget build(BuildContext context) => _calcBody(
    children: [
      _formulaField(_ctrl, 'e.g. H2SO4, Ca3(PO4)2'),
      _calcButton('Calculate', AppTheme.catAlkali, _calculate),
      if (_result.isNotEmpty) _resultBox(_result, '', _error),
    ],
  );
}

// ── Shared helpers ────────────────────────────────────────────────────────────
Widget _calcBody({required List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: children.map((w) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: w,
    )).toList(),
  );
}

TextField _formulaField(TextEditingController ctrl, String hint) {
  return TextField(
    controller: ctrl,
    style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary),
    decoration: _inputDeco(hint),
  );
}

TextField _numField(TextEditingController ctrl, String label) {
  return TextField(
    controller: ctrl,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
    style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary),
    decoration: _inputDeco(label),
  );
}

InputDecoration _inputDeco(String label) => InputDecoration(
  labelText: label,
  labelStyle: GoogleFonts.spaceGrotesk(color: AppTheme.textTertiary, fontSize: 13),
  filled: true,
  fillColor: AppTheme.bgElevated,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
);

Widget _dropdownField<T>({
  required String label,
  required T value,
  required List<T> items,
  required ValueChanged<T?> onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.bgElevated,
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButton<T>(
      value: value,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      dropdownColor: AppTheme.bgElevated,
      hint: Text(label,
        style: GoogleFonts.spaceGrotesk(color: AppTheme.textTertiary, fontSize: 13)),
      items: items.map((v) => DropdownMenuItem<T>(
        value: v,
        child: Text(v.toString(),
          style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary)),
      )).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget _calcButton(String label, Color color, VoidCallback onTap) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: color.withOpacity(0.2),
      foregroundColor: color,
      side: BorderSide(color: color.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    child: Text(label,
        style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600)),
  );
}

Widget _resultBox(String main, String detail, bool isError) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isError
          ? AppTheme.catAlkali.withOpacity(0.08)
          : AppTheme.accentCyan.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isError
            ? AppTheme.catAlkali.withOpacity(0.4)
            : AppTheme.accentCyan.withOpacity(0.4),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(main,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isError ? AppTheme.catAlkali : AppTheme.accentCyan,
          )),
        if (detail.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(detail,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.6,
            )),
        ],
      ],
    ),
  );
}
