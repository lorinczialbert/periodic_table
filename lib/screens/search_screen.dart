import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/element_tile.dart';
import 'element_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final results  = provider.filteredElements;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Search',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 26, fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                )),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary),
                onChanged: (v) => provider.setSearchQuery(v),
                decoration: InputDecoration(
                  hintText: 'Name, symbol, or atomic number…',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppTheme.textTertiary),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppTheme.textTertiary),
                          onPressed: () {
                            _controller.clear();
                            provider.setSearchQuery('');
                          })
                      : null,
                  filled: true,
                  fillColor: AppTheme.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Result count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  provider.searchQuery.isEmpty
                      ? 'All ${results.length} elements'
                      : '${results.length} result${results.length == 1 ? '' : 's'}',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textTertiary, fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Results
            Expanded(
              child: results.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final el = results[i];
                        return Column(
                          children: [
                            ElementListTile(
                              element: el,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ElementDetailScreen(element: el),
                                ),
                              ),
                            ),
                            if (i < results.length - 1)
                              Divider(
                                height: 1,
                                color: AppTheme.bgCard,
                                indent: 80,
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 52, color: AppTheme.textTertiary),
          const SizedBox(height: 12),
          Text('No elements found',
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Try a different name or symbol',
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textTertiary, fontSize: 13)),
        ],
      ),
    );
  }
}
