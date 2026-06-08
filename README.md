# ⚗️ ChemTable

A professional periodic table app for Android, built with Flutter.  
Designed for chemists, students, and anyone who loves chemistry.

---

## Screenshots

> *Coming soon — add screenshots of your app here*

---

## Features

### 🔬 Interactive Periodic Table
- Full 118-element periodic table with colour-coded categories
- Tap any element to open its detailed profile
- Lanthanide and actinide series displayed below the main table

### 🔍 Element Search
- Instant search by name, symbol, or atomic number
- Filter by category (alkali metals, noble gases, transition metals, etc.)

### 🧪 Element Detail Screen
Each element has 6 information tabs:

| Tab | Content |
|-----|---------|
| **Physical** | Atomic mass, melting/boiling points, density, phase, oxidation states |
| **Electronic** | Electron configuration, electronegativity scale, 3D molecular geometry |
| **Isotopes** | Major isotopes with natural abundance %, half-lives, and nucleosynthesis origin |
| **Chemistry** | Acid/base character, common ions, crystal structure |
| **Reactions** | AI-generated key reactions (powered by Claude) |
| **History** | Discovery year, discoverer, etymology of the element name |

### 🧮 Calculators
- Molar mass calculator
- Concentration / dilution calculator
- Ideal gas law (PV = nRT)
- Electrochemistry (Nernst equation)
- More in progress

### 🤖 AI Chemistry Tutor
- Chat interface powered by the **Claude API** (claude-opus-4-8)
- Expert chemistry system prompt — reactions, mechanisms, spectroscopy, bonding
- Full multi-turn conversation with context memory
- Suggested starter questions on the welcome screen

---

## Tech Stack

| | |
|--|--|
| **Framework** | Flutter (Dart) |
| **State management** | Provider |
| **HTTP** | `http` package (REST calls to Claude API & Wikipedia) |
| **Fonts** | Google Fonts — Space Grotesk |
| **Image caching** | `cached_network_image` |
| **Key storage** | `shared_preferences` |
| **Theme** | Custom dark AMOLED theme (`#07090F` background) |

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.12
- Android device or emulator (API 21+)

### Run locally

```bash
git clone https://github.com/lorinczialbert/periodic_table.git
cd periodic_table
flutter pub get
flutter run
```

### AI features (optional)

The AI Tutor and AI-generated reactions require a free Anthropic API key:

1. Sign up at [console.anthropic.com](https://console.anthropic.com)
2. Create an API key under **API Keys**
3. In the app, go to the **AI Tutor** tab → tap the key icon → paste your key

Your key is stored locally on the device only — it is never sent anywhere except directly to the Anthropic API.

---

## Project Structure

```
lib/
├── data/
│   ├── elements.dart          # All 118 elements with scientific data
│   └── element_extras.dart    # Isotopes, crystal structures, ions, nucleosynthesis
├── models/
│   └── element.dart           # ChemElement model + ElementCategory enum
├── providers/
│   └── app_provider.dart      # App-level state
├── screens/
│   ├── home_screen.dart        # Bottom navigation shell
│   ├── table_screen.dart       # Periodic table grid
│   ├── search_screen.dart      # Search + filter
│   ├── element_detail_screen.dart  # 6-tab element profile
│   ├── calculators_screen.dart # Chemistry calculators
│   └── ai_tutor_screen.dart    # Claude-powered chat tutor
├── theme/
│   └── app_theme.dart          # Colours, text styles, dark theme
└── widgets/
    └── element_tile.dart       # Individual element cell widget
```

---

## Roadmap

- [ ] Equation balancer
- [ ] Solubility rules reference
- [ ] Spectroscopy database (NMR, IR, MS)
- [ ] Reaction predictor
- [ ] iOS release
- [ ] Google Play release

---

## License

MIT — free to use and modify.

---
