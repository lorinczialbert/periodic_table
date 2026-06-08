import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

// ─── Data model ────────────────────────────────────────────────────────────────
class _ChatMessage {
  final String role; // 'user' | 'assistant'
  final String content;

  const _ChatMessage({required this.role, required this.content});
}

// ─── Main screen ───────────────────────────────────────────────────────────────
class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  String _apiKey = '';

  // ── System prompt ─────────────────────────────────────────────────────────
  static const String _systemPrompt =
      'You are an expert chemistry tutor with deep knowledge spanning all '
      'branches of chemistry — organic, inorganic, physical, analytical, and '
      'biochemistry. You know the full periodic table, electron configurations, '
      'bonding theory (VSEPR, MO, VB), reaction mechanisms (SN1, SN2, E1, E2, '
      'additions, oxidations, reductions), thermodynamics, kinetics, '
      'electrochemistry, acid-base equilibria, spectroscopy (NMR, IR, MS, '
      'UV-Vis), and laboratory safety. '
      'You give accurate, concise answers with proper chemical notation '
      '(e.g. H₂O, CO₂, CH₄). Tailor depth to the question. '
      'When useful, mention real-world applications. '
      'Never guess — if unsure, say so.';

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── API key persistence ───────────────────────────────────────────────────
  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _apiKey = prefs.getString('claude_api_key') ?? '');
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('claude_api_key', key);
    setState(() => _apiKey = key.trim());
  }

  // ── API key dialog ────────────────────────────────────────────────────────
  void _showApiKeyDialog() {
    final ctrl = TextEditingController(text: _apiKey);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.key_rounded, color: AppTheme.accentCyan, size: 20),
            const SizedBox(width: 8),
            Text('Anthropic API Key',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get a free key at console.anthropic.com → API Keys',
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              obscureText: true,
              style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'sk-ant-api03-…',
                hintStyle: GoogleFonts.spaceGrotesk(color: AppTheme.textTertiary),
                filled: true,
                fillColor: AppTheme.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.spaceGrotesk(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              _saveApiKey(ctrl.text);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentCyan,
              foregroundColor: AppTheme.bgDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Save',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Send message + API call ───────────────────────────────────────────────
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    if (_apiKey.isEmpty) {
      _showApiKeyDialog();
      return;
    }

    _textController.clear();
    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // Build the messages array (full history for multi-turn context)
      final apiMessages = _messages
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

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
              'system': _systemPrompt,
              'messages': apiMessages,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final reply =
            (data['content'] as List<dynamic>)[0]['text'] as String;
        setState(() {
          _messages.add(_ChatMessage(role: 'assistant', content: reply));
          _isLoading = false;
        });
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final msg = (body['error'] as Map<String, dynamic>?)?['message']
            as String? ??
            'HTTP ${response.statusCode}';
        throw Exception(msg);
      }
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          role: 'assistant',
          content: '⚠️ ${e.toString().replaceFirst("Exception: ", "")}\n\n'
              'Check your API key or network connection.',
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentCyan, AppTheme.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.science_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text('AI Tutor',
              style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700, fontSize: 20)),
        ],
      ),
      actions: [
        // Key status icon
        IconButton(
          icon: Icon(
            _apiKey.isEmpty ? Icons.key_off_rounded : Icons.key_rounded,
            color: _apiKey.isEmpty
                ? AppTheme.catAlkali
                : AppTheme.accentCyan,
            size: 22,
          ),
          onPressed: _showApiKeyDialog,
          tooltip: 'API Key',
        ),
        // Clear chat
        if (_messages.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded,
                color: AppTheme.textSecondary, size: 22),
            onPressed: () => setState(() => _messages.clear()),
            tooltip: 'Clear chat',
          ),
      ],
    );
  }

  // ── Empty / welcome state ──────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
      child: Column(
        children: [
          // Atom icon
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentCyan.withOpacity(0.18),
                  AppTheme.accentPurple.withOpacity(0.08),
                ],
              ),
              border: Border.all(
                  color: AppTheme.accentCyan.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(Icons.science_rounded,
                color: AppTheme.accentCyan, size: 42),
          ),
          const SizedBox(height: 22),
          Text(
            'Chemistry AI Tutor',
            style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            'Powered by Claude — ask anything about elements, reactions, '
            'mechanisms, spectroscopy, and more.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textSecondary, fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 28),

          // API key setup prompt or suggestions
          if (_apiKey.isEmpty)
            _buildApiKeyPrompt()
          else
            _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildApiKeyPrompt() {
    return GestureDetector(
      onTap: _showApiKeyDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.accentCyan.withOpacity(0.45), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.accentCyan.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.key_rounded,
                  color: AppTheme.accentCyan, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add your API key to start',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  Text(
                    'Free at console.anthropic.com',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppTheme.accentCyan, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    const suggestions = [
      ('⚛️', 'Explain electron configurations of transition metals'),
      ('🧪', 'How does SN2 differ from SN1?'),
      ('⚗️', 'What makes noble gases unreactive?'),
      ('🔬', 'Explain the difference between NMR and IR spectroscopy'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try asking…',
          style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        const SizedBox(height: 10),
        ...suggestions.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                _textController.text = s.$2;
                _sendMessage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: AppTheme.bgElevated, width: 1),
                ),
                child: Row(
                  children: [
                    Text(s.$1, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.$2,
                        style: GoogleFonts.spaceGrotesk(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ),
                    const Icon(Icons.north_east_rounded,
                        color: AppTheme.textTertiary, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Message list ──────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _messages.length) return _buildTypingIndicator();
        return _buildBubble(_messages[i]);
      },
    );
  }

  Widget _buildBubble(_ChatMessage msg) {
    final isUser = msg.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI avatar
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.accentPurple, AppTheme.accentCyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.science_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: msg.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied to clipboard',
                        style: GoogleFonts.spaceGrotesk()),
                    backgroundColor: AppTheme.bgElevated,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? const LinearGradient(
                          colors: [Color(0xFF00B8D9), AppTheme.accentCyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isUser ? null : AppTheme.bgCard,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border: isUser
                      ? null
                      : Border.all(
                          color: AppTheme.bgElevated, width: 1),
                ),
                child: SelectableText(
                  msg.content,
                  style: GoogleFonts.spaceGrotesk(
                    color: isUser ? AppTheme.bgDark : AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight:
                        isUser ? FontWeight.w500 : FontWeight.w400,
                    height: 1.55,
                  ),
                ),
              ),
            ),
          ),

          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentPurple, AppTheme.accentCyan],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.science_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: AppTheme.bgElevated),
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ── Input bar ─────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.bgSurface,
          border:
              Border(top: BorderSide(color: AppTheme.bgElevated, width: 1)),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: _textController,
                  style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textPrimary, fontSize: 14),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: _apiKey.isEmpty
                        ? 'Add API key first…'
                        : 'Ask a chemistry question…',
                    hintStyle: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textTertiary, fontSize: 13),
                    filled: true,
                    fillColor: AppTheme.bgCard,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            _SendButton(
              isLoading: _isLoading,
              onTap: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Animated typing dots ──────────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value + i * 0.22) % 1.0;
            final brightness = phase < 0.5 ? phase * 2.0 : (1.0 - phase) * 2.0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Opacity(
                opacity: 0.25 + brightness * 0.75,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppTheme.accentCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentCyan.withOpacity(0.5),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─── Send button ───────────────────────────────────────────────────────────────
class _SendButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SendButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: isLoading
              ? null
              : const LinearGradient(
                  colors: [AppTheme.accentCyan, AppTheme.accentPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isLoading ? AppTheme.bgElevated : null,
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(13),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.accentCyan,
                ),
              )
            : const Icon(Icons.send_rounded,
                color: Colors.white, size: 20),
      ),
    );
  }
}
