import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/element.dart';
import '../theme/app_theme.dart';
import '../data/element_extras.dart';

class ElementDetailScreen extends StatefulWidget {
  final ChemElement element;
  const ElementDetailScreen({super.key, required this.element});

  @override
  State<ElementDetailScreen> createState() => _ElementDetailScreenState();
}

class _ElementDetailScreenState extends State<ElementDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // ── Wiki image ─────────────────────────────────────────────────────────────
  String? _imageUrl;
  bool _loadingImage = true;

  // ── AI reactions ───────────────────────────────────────────────────────────
  String? _reactionsText;
  bool _reactionsLoading = false;
  String _apiKey = '';

  // ── Extras data ────────────────────────────────────────────────────────────
  ElementExtras? get _extras => getElementExtras(el.atomicNumber);

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 6, vsync: this);
    _fetchWikiImage();
    _loadApiKey();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _fetchWikiImage() async {
    try {
      final uri = Uri.parse(
          'https://en.wikipedia.org/api/rest_v1/page/summary/${widget.element.name}');
      final res = await http.get(uri, headers: {'accept': 'application/json'});
      if (res.statusCode == 200) {
        final url =
            (json.decode(res.body)['thumbnail']?['source'] as String?);
        if (mounted) setState(() { _imageUrl = url; _loadingImage = false; });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingImage = false);
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _apiKey = prefs.getString('claude_api_key') ?? '');
  }

  Future<void> _generateReactions() async {
    if (_apiKey.isEmpty) return;
    setState(() => _reactionsLoading = true);

    try {
      final prompt =
          'For the element ${el.name} (${el.symbol}, Z=${el.atomicNumber}):\n\n'
          'List exactly 6 of its most important chemical reactions.\n'
          'Use this exact format for each:\n\n'
          'REACTION 1:\n'
          'Equation: [balanced chemical equation with proper subscripts]\n'
          'Conditions: [temperature, catalyst, medium]\n'
          'Significance: [2-3 sentences on industrial or chemical importance]\n\n'
          'Include reactions showing different oxidation states (if applicable), '
          'reactions with water, acids, bases, oxygen, and key industrial processes.';

      final response = await http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {
              'x-api-key': _apiKey,
              'anthropic-version': '2023-06-01',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'claude-opus-4-8',
              'max_tokens': 2048,
              'system':
                  'You are an expert chemistry reference. Give accurate, concise '
                  'chemical data. Use Unicode superscripts/subscripts where possible.',
              'messages': [
                {'role': 'user', 'content': prompt}
              ],
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final text =
            (data['content'] as List<dynamic>)[0]['text'] as String;
        if (mounted) setState(() { _reactionsText = text; _reactionsLoading = false; });
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _reactionsText = '⚠️ Could not load reactions: $e';
          _reactionsLoading = false;
        });
      }
    }
  }

  ChemElement get el => widget.element;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      // NestedScrollView: outer scroll handles the collapsing header + sticky tab bar;
      // each inner tab's ListView/SingleChildScrollView scrolls independently —
      // this is the proper fix for the "can't scroll to the bottom" bug.
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
          _buildSliverAppBar(el.color, innerBoxIsScrolled),
          SliverToBoxAdapter(child: _buildSummaryCard()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(_buildTabBar(), AppTheme.bgDark),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _physicalTab(),
            _electronicTab(),
            _isotopesTab(),
            _chemistryTab(),
            _reactionsTab(),
            _historyTab(),
          ],
        ),
      ),
    );
  }

  // ── Sliver App Bar ────────────────────────────────────────────────────────
  SliverAppBar _buildSliverAppBar(Color color, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
      backgroundColor: AppTheme.bgSurface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient backdrop
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.35), AppTheme.bgDark],
                ),
              ),
            ),
            // Photo
            if (_imageUrl != null)
              Positioned(
                right: 16, top: 60, bottom: 30, width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: _imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppTheme.bgCard),
                    errorWidget: (_, __, ___) =>
                        _photoPlaceholder(color),
                  ),
                ),
              )
            else if (!_loadingImage)
              Positioned(
                right: 24, top: 60, bottom: 30, width: 120,
                child: _photoPlaceholder(color),
              ),
            // Symbol + name
            Positioned(
              left: 24, bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: color.withValues(alpha: 0.5)),
                    ),
                    child: Text(el.category.label,
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Text(el.symbol,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 72,
                          color: color,
                          fontWeight: FontWeight.w800,
                          height: 0.9)),
                  Text(el.name,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600)),
                  Text(
                      'Z = ${el.atomicNumber}  ·  '
                      '${el.block}-block  ·  Period ${el.period}',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoPlaceholder(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border:
              Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Center(
          child: Text(el.symbol,
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 48,
                  color: color.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

  // ── Summary card ──────────────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.bgElevated),
      ),
      child: Text(el.summary,
          style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.6)),
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────────────────
  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabs,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w600, fontSize: 13),
      unselectedLabelStyle:
          GoogleFonts.spaceGrotesk(fontSize: 13),
      indicator: BoxDecoration(
        color: el.color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: el.color.withValues(alpha: 0.5)),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(text: 'Physical'),
        Tab(text: 'Electronic'),
        Tab(text: 'Isotopes'),
        Tab(text: 'Chemistry'),
        Tab(text: 'Reactions'),
        Tab(text: 'History'),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 1 — Physical properties
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _physicalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoRow(Icons.scale_rounded, 'Atomic Mass',
            '${el.atomicMass} u'),
        _infoRow(Icons.thermostat, 'Melting Point',
            el.meltingPoint != null
                ? '${el.meltingPoint!.toStringAsFixed(1)} °C'
                : '—'),
        _infoRow(Icons.bubble_chart, 'Boiling Point',
            el.boilingPoint != null
                ? '${el.boilingPoint!.toStringAsFixed(1)} °C'
                : '—'),
        _infoRow(Icons.density_medium, 'Density',
            el.density != null ? '${el.density} g/cm³' : '—'),
        _infoRow(Icons.wb_sunny_rounded, 'Phase at STP',
            el.phase),
        _infoRow(Icons.layers_rounded, 'Group / Period',
            'Group ${el.group > 0 ? el.group : "f-block"}  ·  Period ${el.period}'),
        _infoRow(Icons.numbers_rounded, 'Block',
            '${el.block.toUpperCase()}-block'),
        if (el.oxidationStates.isNotEmpty)
          _infoRow(Icons.swap_horiz_rounded, 'Oxidation States',
              el.oxidationStates
                  .map((v) => v > 0 ? '+$v' : '$v')
                  .join(', ')),
        const SizedBox(height: 80),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 2 — Electronic structure + molecular geometry
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _electronicTab() {
    final en = el.electronegativity;
    final extras = _extras;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _bigCard('Electron Configuration', el.electronConfig, el.color),
        const SizedBox(height: 12),
        _infoRow(Icons.electric_bolt_rounded, 'Electronegativity',
            en != null ? '$en (Pauling)' : '—'),
        _infoRow(Icons.layers_rounded, 'Period', '${el.period}'),
        _infoRow(Icons.grid_3x3_rounded, 'Group',
            el.group > 0 ? '${el.group}' : 'f-block'),
        _infoRow(Icons.science_rounded, 'Block',
            '${el.block.toUpperCase()}-block'),
        _electronegativityBar(en),
        if (extras != null && extras.keyGeometry.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionHeader(
              Icons.view_in_ar_rounded, '3D Molecular Geometry'),
          _geometryCard(extras.keyGeometry),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _geometryCard(String geometry) {
    // Split on '·' to get individual compounds, show each as a row
    final parts = geometry.split('·').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: el.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: parts.asMap().entries.map((e) {
          final i = e.key;
          final part = e.value;
          // Split on ':' → compound name + geometry description
          final colon = part.indexOf(':');
          final compound = colon > 0 ? part.substring(0, colon).trim() : part;
          final desc = colon > 0 ? part.substring(colon + 1).trim() : '';
          return Column(
            children: [
              if (i > 0)
                const Divider(color: AppTheme.bgElevated, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: el.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(compound,
                          style: GoogleFonts.spaceGrotesk(
                              color: el.color,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ),
                    if (desc.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(desc,
                            style: GoogleFonts.spaceGrotesk(
                                color: AppTheme.textSecondary,
                                fontSize: 13)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _electronegativityBar(double? en) {
    if (en == null) return const SizedBox.shrink();
    final frac = (en / 4.0).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.bgElevated),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Electronegativity Scale (Pauling)',
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Row(children: [
            Text('0',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textTertiary, fontSize: 11)),
            const SizedBox(width: 6),
            Expanded(
              child: Stack(children: [
                Container(
                    height: 8,
                    decoration: BoxDecoration(
                        color: AppTheme.bgElevated,
                        borderRadius: BorderRadius.circular(4))),
                FractionallySizedBox(
                  widthFactor: frac,
                  child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppTheme.catNonmetal.withValues(alpha: 0.6),
                            el.color
                          ]),
                          borderRadius: BorderRadius.circular(4))),
                ),
              ]),
            ),
            const SizedBox(width: 6),
            Text('4.0 (F)',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textTertiary, fontSize: 11)),
          ]),
          const SizedBox(height: 4),
          Text('${el.symbol}: $en',
              style: GoogleFonts.spaceGrotesk(
                  color: el.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 3 — Isotopes + nucleosynthesis
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _isotopesTab() {
    final extras = _extras;
    if (extras == null) {
      return _emptyTab('No isotope data available for this element.');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Nucleosynthesis ─────────────────────────────────────────────────
        _sectionHeader(Icons.auto_awesome_rounded, 'Nucleosynthesis'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: el.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: el.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.star_rounded,
                  color: el.color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(extras.nucleosynthesis,
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        height: 1.55)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Isotope table ───────────────────────────────────────────────────
        _sectionHeader(
            Icons.format_list_numbered_rounded, 'Known Isotopes'),
        const SizedBox(height: 8),

        // Header row
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
          decoration: const BoxDecoration(
            color: AppTheme.bgElevated,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Text('Isotope',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5))),
            Expanded(
                flex: 3,
                child: Text('Abundance',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5))),
            Expanded(
                flex: 4,
                child: Text('Half-life / Status',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5))),
          ]),
        ),

        // Data rows
        Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            border: Border.all(color: AppTheme.bgElevated),
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12)),
          ),
          child: Column(
            children: extras.isotopes
                .asMap()
                .entries
                .map((e) {
              final idx = e.key;
              final iso = e.value;
              final abStr = iso.abundance > 0
                  ? '${iso.abundance.toStringAsFixed(
                      iso.abundance < 0.01 ? 4 : iso.abundance < 1 ? 3 : 2)}%'
                  : 'trace / synthetic';
              final statusStr = iso.isStable
                  ? 'Stable'
                  : iso.halfLife ?? 'Radioactive';
              final statusColor = iso.isStable
                  ? AppTheme.catNobleGas
                  : AppTheme.catAlkali;

              return Column(
                children: [
                  if (idx > 0)
                    const Divider(
                        color: AppTheme.bgElevated,
                        height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 11),
                    child: Row(children: [
                      Expanded(
                          flex: 3,
                          child: Text(iso.label,
                              style: GoogleFonts.spaceGrotesk(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600))),
                      Expanded(
                          flex: 3,
                          child: Text(abStr,
                              style: GoogleFonts.spaceGrotesk(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12))),
                      Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor
                                  .withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                            child: Text(statusStr,
                                style: GoogleFonts.spaceGrotesk(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.w600)),
                          )),
                    ]),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 4 — Chemistry: acid/base, crystal structure, ions, geometry
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _chemistryTab() {
    final extras = _extras;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Acid / base character
        _sectionHeader(
            Icons.science_rounded, 'Acid / Base Character & Reactivity'),
        const SizedBox(height: 8),
        _descriptionCard(
          extras?.acidBaseChar ?? '—',
          el.color,
          Icons.opacity_rounded,
        ),
        const SizedBox(height: 16),

        // Oxidation states (repeated here for chemical context)
        if (el.oxidationStates.isNotEmpty) ...[
          _sectionHeader(
              Icons.swap_horiz_rounded, 'Oxidation States'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: el.oxidationStates.map((state) {
              final label = state > 0 ? '+$state' : '$state';
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: el.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: el.color.withValues(alpha: 0.4)),
                ),
                child: Text(label,
                    style: GoogleFonts.spaceGrotesk(
                        color: el.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Common ions
        if (extras != null && extras.commonIons.isNotEmpty) ...[
          _sectionHeader(
              Icons.electric_bolt_rounded, 'Common Ions'),
          const SizedBox(height: 8),
          _tagList(extras.commonIons, el.color),
          const SizedBox(height: 16),
        ],

        // Crystal structure
        if (extras != null) ...[
          _sectionHeader(
              Icons.view_in_ar_rounded, 'Crystal Structure'),
          const SizedBox(height: 8),
          _descriptionCard(
            extras.crystalStructure,
            el.color,
            Icons.grid_view_rounded,
          ),
        ],

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _tagList(List<String> items, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.bgElevated),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((ion) => Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: color.withValues(alpha: 0.3)),
          ),
          child: Text(ion,
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        )).toList(),
      ),
    );
  }

  Widget _descriptionCard(String text, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.bgElevated),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    height: 1.55)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 5 — Reactions (AI-powered)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _reactionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AI badge
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  AppTheme.accentPurple,
                  AppTheme.accentCyan
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text('Generated by Claude',
                    style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_apiKey.isEmpty) ...[
          _noApiKeyCard(),
        ] else if (_reactionsText == null && !_reactionsLoading) ...[
          _generateButton(),
        ] else if (_reactionsLoading) ...[
          const SizedBox(height: 60),
          const Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                    color: AppTheme.accentCyan, strokeWidth: 2),
                SizedBox(height: 16),
              ],
            ),
          ),
          Center(
            child: Text('Generating reactions for ${el.name}…',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textSecondary)),
          ),
        ] else ...[
          _buildReactionsContent(_reactionsText!),
          const SizedBox(height: 12),
          // Regenerate button
          GestureDetector(
            onTap: () =>
                setState(() { _reactionsText = null; }),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.bgElevated),
              ),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh_rounded,
                        color: AppTheme.textSecondary, size: 16),
                    const SizedBox(width: 6),
                    Text('Regenerate',
                        style: GoogleFonts.spaceGrotesk(
                            color: AppTheme.textSecondary,
                            fontSize: 13)),
                  ]),
            ),
          ),
        ],

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _generateButton() {
    return GestureDetector(
      onTap: _generateReactions,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.accentCyan.withValues(alpha: 0.4)),
        ),
        child: Column(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                AppTheme.accentCyan,
                AppTheme.accentPurple
              ]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text('Generate Reactions',
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
              'Uses Claude AI to list 6 key reactions of ${el.name} '
              'with other compounds',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ]),
      ),
    );
  }

  Widget _noApiKeyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.catAlkali.withValues(alpha: 0.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.key_off_rounded, color: AppTheme.catAlkali, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('API key needed',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                    'Add your Anthropic API key in the AI Tutor tab '
                    'to generate reactions for this element.',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.5)),
              ]),
        ),
      ]),
    );
  }

  Widget _buildReactionsContent(String raw) {
    // Split on "REACTION N:" pattern
    final sections = raw.split(RegExp(r'REACTION\s+\d+\s*:', caseSensitive: false));
    final blocks = sections.where((s) => s.trim().isNotEmpty).toList();

    if (blocks.isEmpty) {
      // Fallback: just show as plain text
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.bgElevated),
        ),
        child: SelectableText(raw,
            style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary,
                fontSize: 13,
                height: 1.6)),
      );
    }

    return Column(
      children: blocks.asMap().entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _reactionCard(e.key + 1, e.value.trim()),
        );
      }).toList(),
    );
  }

  Widget _reactionCard(int n, String content) {
    // Try to extract Equation / Conditions / Significance
    String equation = '', conditions = '', significance = '';
    for (final line in content.split('\n')) {
      final l = line.trim();
      if (l.toLowerCase().startsWith('equation:')) {
        equation = l.substring('equation:'.length).trim();
      } else if (l.toLowerCase().startsWith('conditions:')) {
        conditions = l.substring('conditions:'.length).trim();
      } else if (l.toLowerCase().startsWith('significance:')) {
        significance = l.substring('significance:'.length).trim();
      }
    }

    // If parsing failed, show raw block
    if (equation.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: el.color.withValues(alpha: 0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _reactionHeader(n),
          const SizedBox(height: 8),
          SelectableText(content,
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  height: 1.55)),
        ]),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: el.color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + equation
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: _reactionHeader(n),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: el.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(
              equation,
              style: GoogleFonts.spaceGrotesk(
                  color: el.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4),
            ),
          ),

          if (conditions.isNotEmpty)
            _reactionDetail(
                Icons.thermostat_rounded, 'Conditions', conditions),
          if (significance.isNotEmpty) ...[
            const Divider(
                color: AppTheme.bgElevated, height: 1),
            _reactionDetail(Icons.info_outline_rounded,
                'Significance', significance),
          ],
        ],
      ),
    );
  }

  Widget _reactionHeader(int n) {
    return Row(children: [
      Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: el.color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text('$n',
              style: GoogleFonts.spaceGrotesk(
                  color: el.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
      ),
      const SizedBox(width: 8),
      Text('Reaction $n',
          style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _reactionDetail(
      IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 15, color: AppTheme.textTertiary),
            const SizedBox(width: 8),
            Text('$label: ',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: Text(value,
                  style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.5)),
            ),
          ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 6 — History
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _historyTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _bigCard('Discovered by', el.discoveredBy, el.color),
        const SizedBox(height: 12),
        _infoRow(Icons.calendar_today_rounded, 'Discovery Year',
            el.discoveryYear),
        _infoRow(Icons.public_rounded, 'Origin of Name',
            _nameOrigin()),
        const SizedBox(height: 80),
      ],
    );
  }

  String _nameOrigin() {
    const origins = {
      'Hydrogen':   'Greek: hydro (water) + genes (forming)',
      'Helium':     'Greek: Helios (Sun)',
      'Lithium':    'Greek: lithos (stone)',
      'Beryllium':  'Greek: beryllos (beryl mineral)',
      'Boron':      'Arabic: buraq / Persian: burah (borax)',
      'Carbon':     'Latin: carbo (charcoal)',
      'Nitrogen':   'Greek: nitron + genes (nitre-forming)',
      'Oxygen':     'Greek: oxys (sharp/acid) + genes (forming)',
      'Fluorine':   'Latin: fluere (to flow)',
      'Neon':       'Greek: neos (new)',
      'Sodium':     'Medieval Latin: sodanum; symbol Na from Latin natrium',
      'Magnesium':  'Magnesia, a region of ancient Greece',
      'Aluminium':  'Latin: alumen (alum)',
      'Silicon':    'Latin: silex / silicis (flint)',
      'Phosphorus': 'Greek: phosphoros (light-bearer)',
      'Sulfur':     'Latin: sulphur (brimstone)',
      'Chlorine':   'Greek: chloros (pale green)',
      'Argon':      'Greek: argos (inactive / lazy)',
      'Potassium':  'English: potash; symbol K from Latin kalium',
      'Calcium':    'Latin: calx (lime)',
      'Scandium':   'Scandinavia (Latin: Scandia)',
      'Titanium':   'Greek Titans – sons of the Earth goddess',
      'Vanadium':   'Vanadis, an old Norse name for Freya',
      'Chromium':   'Greek: chroma (colour)',
      'Manganese':  'Magnesia (region of Greece) via Latin manganese',
      'Iron':       'Anglo-Saxon; symbol Fe from Latin ferrum',
      'Cobalt':     'German: Kobold (goblin / underground spirit)',
      'Nickel':     'German: Kupfernickel (false copper / St. Nick\'s copper)',
      'Copper':     'Island of Cyprus (ancient source); symbol Cu from Latin cuprum',
      'Zinc':       'German: Zink (spike / tooth) or Persian: seng (stone)',
      'Gallium':    'Latin: Gallia (France) + gallus (rooster)',
      'Germanium':  'Latin: Germania (Germany)',
      'Arsenic':    'Greek: arsenikon / Latin: arsenicum (yellow orpiment)',
      'Selenium':   'Greek: Selene (Moon)',
      'Bromine':    'Greek: bromos (stench)',
      'Krypton':    'Greek: kryptos (hidden)',
      'Rubidium':   'Latin: rubidus (deep red)',
      'Strontium':  'Strontian, a village in Scotland',
      'Yttrium':    'Ytterby, a village in Sweden',
      'Zirconium':  'Arabic: zarqun (gold-coloured)',
      'Niobium':    'Niobe, daughter of Tantalus in Greek mythology',
      'Molybdenum': 'Greek: molybdos (lead)',
      'Technetium': 'Greek: technetos (artificial)',
      'Ruthenium':  'Latin: Ruthenia (Russia)',
      'Rhodium':    'Greek: rhodon (rose) – for rose-coloured salts',
      'Palladium':  'Asteroid Pallas (named after Pallas Athena)',
      'Silver':     'Anglo-Saxon; symbol Ag from Latin argentum',
      'Cadmium':    'Latin: cadmia (calamine ore) / Cadmus of Greek mythology',
      'Indium':     'Indigo-blue spectral line',
      'Tin':        'Anglo-Saxon; symbol Sn from Latin stannum',
      'Antimony':   'Greek: anti + monos (not alone); symbol Sb from Latin stibium',
      'Tellurium':  'Latin: tellus (Earth)',
      'Iodine':     'Greek: ioeides (violet-coloured)',
      'Xenon':      'Greek: xenos (stranger / foreigner)',
      'Caesium':    'Latin: caesius (sky-blue)',
      'Barium':     'Greek: barys (heavy)',
      'Lanthanum':  'Greek: lanthanein (to lie hidden)',
      'Cerium':     'Dwarf planet / asteroid Ceres',
      'Gold':       'Anglo-Saxon; symbol Au from Latin aurum',
      'Mercury':    'Planet Mercury; symbol Hg from Latin hydrargyrum (liquid silver)',
      'Lead':       'Anglo-Saxon; symbol Pb from Latin plumbum',
      'Bismuth':    'German: Wismut (white meadow) or Arabic: bi ismid',
      'Radium':     'Latin: radius (ray)',
      'Uranium':    'Planet Uranus (named after the Greek god)',
      'Plutonium':  'Dwarf planet Pluto (named after the Roman god)',
      'Americium':  'The Americas',
    };
    return origins[el.name] ?? '—';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Shared UI helpers
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _sectionHeader(IconData icon, String title) {
    return Row(children: [
      Icon(icon, size: 16, color: el.color),
      const SizedBox(width: 8),
      Text(title,
          style: GoogleFonts.spaceGrotesk(
              color: el.color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6)),
    ]);
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bgElevated),
      ),
      child: Row(children: [
        Icon(icon, size: 18, color: el.color.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        Text(value,
            style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _bigCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: GoogleFonts.spaceGrotesk(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Text(value,
            style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _emptyTab(String message) {
    return Center(
      child: Text(message,
          style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textSecondary, fontSize: 14)),
    );
  }
}

// ─── Sticky tab bar delegate ───────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _bg;

  const _TabBarDelegate(this._tabBar, this._bg);

  @override
  double get minExtent => _tabBar.preferredSize.height + 16;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 16;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: overlapsContent
          ? const BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: AppTheme.bgElevated, width: 1)))
          : null,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old._tabBar != _tabBar || old._bg != _bg;
}
