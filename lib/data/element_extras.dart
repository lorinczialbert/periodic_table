// Extra scientific data for all 118 elements:
//   • Major isotopes & natural abundance
//   • Crystal structure
//   • Common ionic forms
//   • Nucleosynthesis pathway
//   • Acid / base character of element / oxide

class IsotopeInfo {
  final int massNumber;
  final String label; // e.g. "¹H", "²H (D)", "U-238"
  final double abundance; // natural % — 0 means trace/synthetic
  final bool isStable;
  final String? halfLife; // non-null if radioactive (e.g. "12.3 y", "4.47 Gy")

  const IsotopeInfo(
    this.massNumber,
    this.label,
    this.abundance,
    this.isStable, {
    this.halfLife,
  });
}

class ElementExtras {
  final List<IsotopeInfo> isotopes;
  final String crystalStructure;
  final List<String> commonIons;
  final String nucleosynthesis;
  final String acidBaseChar;
  final String keyGeometry; // key compound geometry (empty if none)

  const ElementExtras({
    required this.isotopes,
    required this.crystalStructure,
    required this.commonIons,
    required this.nucleosynthesis,
    required this.acidBaseChar,
    this.keyGeometry = '',
  });
}

// ─── Lookup by atomic number ───────────────────────────────────────────────────
const Map<int, ElementExtras> kElementExtras = {
  // ── Period 1 ─────────────────────────────────────────────────────────────────
  1: ElementExtras(
    isotopes: [
      IsotopeInfo(1,  '¹H',       99.9855, true),
      IsotopeInfo(2,  '²H (D)',    0.0145,  true),
      IsotopeInfo(3,  '³H (T)',    0.0,     false, halfLife: '12.3 y'),
    ],
    crystalStructure: 'Orthorhombic (α-H₂, solid)',
    commonIons: ['H⁺ (proton)', 'H⁻ (hydride)'],
    nucleosynthesis: 'Big Bang nucleosynthesis (primordial, ~75 % of baryonic matter)',
    acidBaseChar: 'Neutral as H₂; donates H⁺ in water (Brønsted acid); H⁻ is strongly basic',
    keyGeometry: 'H₂: linear · H₂O: bent, 104.5° · H₂O₂: dihedral ~112°',
  ),
  2: ElementExtras(
    isotopes: [
      IsotopeInfo(3,  '³He',  0.0002,  true),
      IsotopeInfo(4,  '⁴He',  99.9998, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC) under pressure',
    commonIons: ['He – no stable ions (noble gas)'],
    nucleosynthesis: 'Big Bang nucleosynthesis (~25 % primordial) + stellar H-burning (pp chain)',
    acidBaseChar: 'Chemically inert – no oxide, no acid/base behaviour',
    keyGeometry: 'No compounds under normal conditions',
  ),

  // ── Period 2 ─────────────────────────────────────────────────────────────────
  3: ElementExtras(
    isotopes: [
      IsotopeInfo(6,  '⁶Li',   7.59,  true),
      IsotopeInfo(7,  '⁷Li',  92.41,  true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Li⁺'],
    nucleosynthesis: 'Big Bang nucleosynthesis (trace) + cosmic-ray spallation of C/O',
    acidBaseChar: 'Strongly basic oxide (Li₂O); LiOH is a strong base',
    keyGeometry: 'LiH: linear · Li₂O: linear O–Li–O (ionic)',
  ),
  4: ElementExtras(
    isotopes: [
      IsotopeInfo(9,  '⁹Be',  100.0, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP)',
    commonIons: ['Be²⁺'],
    nucleosynthesis: 'Cosmic-ray spallation of C, N, O in the interstellar medium',
    acidBaseChar: 'Amphoteric oxide (BeO); dissolves in both acid and base',
    keyGeometry: 'BeCl₂: linear · Be(OH)₂: tetrahedral Be',
  ),
  5: ElementExtras(
    isotopes: [
      IsotopeInfo(10, '¹⁰B',  19.9,  true),
      IsotopeInfo(11, '¹¹B',  80.1,  true),
    ],
    crystalStructure: 'Rhombohedral (α-B₁₂ icosahedral framework)',
    commonIons: ['B³⁺', 'BO₃³⁻ (borate)', 'BO₂⁻ (metaborate)', 'BF₄⁻ (tetrafluoroborate)'],
    nucleosynthesis: 'Cosmic-ray spallation of C, N, O',
    acidBaseChar: 'Weak Lewis acid; B₂O₃ is mildly acidic',
    keyGeometry: 'BF₃: trigonal planar · BF₄⁻: tetrahedral · B₂H₆: bridged, 3-centre 2e⁻ bonds',
  ),
  6: ElementExtras(
    isotopes: [
      IsotopeInfo(12, '¹²C',  98.93, true),
      IsotopeInfo(13, '¹³C',   1.07, true),
      IsotopeInfo(14, '¹⁴C',   0.0,  false, halfLife: '5 730 y'),
    ],
    crystalStructure: 'Hexagonal (graphite) / Diamond cubic (face-centred cubic)',
    commonIons: ['CO₃²⁻ (carbonate)', 'HCO₃⁻ (bicarbonate)', 'CN⁻ (cyanide)', 'C²²⁻ (acetylide)'],
    nucleosynthesis: 'Stellar nucleosynthesis – triple-alpha process in helium-burning stars',
    acidBaseChar: 'CO₂ forms carbonic acid (H₂CO₃) – weakly acidic; CO is neutral',
    keyGeometry: 'CO₂: linear · CH₄: tetrahedral, 109.5° · C₂H₂: linear · benzene: planar, 120°',
  ),
  7: ElementExtras(
    isotopes: [
      IsotopeInfo(14, '¹⁴N',  99.636, true),
      IsotopeInfo(15, '¹⁵N',   0.364, true),
    ],
    crystalStructure: 'Cubic (α-N₂, solid below 35 K)',
    commonIons: ['NH₄⁺ (ammonium)', 'NO₂⁻ (nitrite)', 'NO₃⁻ (nitrate)', 'N₃⁻ (azide)'],
    nucleosynthesis: 'Stellar CNO cycle; also from core He/C burning in massive stars',
    acidBaseChar: 'N₂O₅ → HNO₃ (strongly acidic); NH₃ is a weak base',
    keyGeometry: 'N₂: linear, triple bond · NH₃: trigonal pyramidal, 107.8° · NO₂: bent, 134.1°',
  ),
  8: ElementExtras(
    isotopes: [
      IsotopeInfo(16, '¹⁶O',  99.757, true),
      IsotopeInfo(17, '¹⁷O',   0.038, true),
      IsotopeInfo(18, '¹⁸O',   0.205, true),
    ],
    crystalStructure: 'Monoclinic (solid O₂)',
    commonIons: ['O²⁻ (oxide)', 'O₂²⁻ (peroxide)', 'O₂⁻ (superoxide)', 'OH⁻ (hydroxide)'],
    nucleosynthesis: 'Stellar nucleosynthesis – CNO cycle & neon burning in massive stars',
    acidBaseChar: 'Most metal oxides are basic; non-metal oxides are acidic',
    keyGeometry: 'H₂O: bent, 104.5° · O₃: bent, 117.8° · OF₂: bent, 103.2°',
  ),
  9: ElementExtras(
    isotopes: [
      IsotopeInfo(19, '¹⁹F',  100.0, true),
    ],
    crystalStructure: 'Monoclinic (solid F₂)',
    commonIons: ['F⁻ (fluoride)'],
    nucleosynthesis: 'Stellar nucleosynthesis – neutrino process in supernovae and AGB stars',
    acidBaseChar: 'HF is a weak acid (strong H-bonds); F₂O is weakly acidic',
    keyGeometry: 'HF: linear · OF₂: bent, 103° · SF₄: see-saw (10 e⁻ around S)',
  ),
  10: ElementExtras(
    isotopes: [
      IsotopeInfo(20, '²⁰Ne',  90.48, true),
      IsotopeInfo(21, '²¹Ne',   0.27, true),
      IsotopeInfo(22, '²²Ne',   9.25, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Ne – no stable ions (noble gas)'],
    nucleosynthesis: 'Stellar nucleosynthesis – carbon/neon burning in massive stars',
    acidBaseChar: 'Chemically inert',
    keyGeometry: 'No stable compounds under normal conditions',
  ),

  // ── Period 3 ─────────────────────────────────────────────────────────────────
  11: ElementExtras(
    isotopes: [
      IsotopeInfo(23, '²³Na',  100.0, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Na⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – carbon-burning and neon-burning shells',
    acidBaseChar: 'Strongly basic oxide (Na₂O); NaOH is a strong base',
    keyGeometry: 'NaCl: cubic lattice (ionic) · Na₂O: anti-fluorite structure',
  ),
  12: ElementExtras(
    isotopes: [
      IsotopeInfo(24, '²⁴Mg',  78.99, true),
      IsotopeInfo(25, '²⁵Mg',  10.00, true),
      IsotopeInfo(26, '²⁶Mg',  11.01, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP)',
    commonIons: ['Mg²⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – carbon burning and neutron capture in AGB stars',
    acidBaseChar: 'Moderately basic oxide (MgO); Mg(OH)₂ is a weak base',
    keyGeometry: 'MgO: rock-salt (ionic) · MgCl₂: layer structure · [Mg(H₂O)₆]²⁺: octahedral',
  ),
  13: ElementExtras(
    isotopes: [
      IsotopeInfo(27, '²⁷Al',  100.0, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Al³⁺', 'AlO₂⁻ (aluminate)', 'Al(OH)₄⁻'],
    nucleosynthesis: 'Stellar nucleosynthesis – carbon-burning and proton-capture in massive stars',
    acidBaseChar: 'Amphoteric oxide (Al₂O₃); Al(OH)₃ dissolves in both HCl and NaOH',
    keyGeometry: 'AlCl₃: trigonal planar (monomer) / dimer Al₂Cl₆ · Al₂O₃: corundum (hexagonal)',
  ),
  14: ElementExtras(
    isotopes: [
      IsotopeInfo(28, '²⁸Si',  92.23, true),
      IsotopeInfo(29, '²⁹Si',   4.67, true),
      IsotopeInfo(30, '³⁰Si',   3.10, true),
    ],
    crystalStructure: 'Diamond cubic (Fd3̄m)',
    commonIons: ['SiO₄⁴⁻ (orthosilicate)', 'SiO₃²⁻ (metasilicate)', 'SiF₆²⁻'],
    nucleosynthesis: 'Stellar nucleosynthesis – oxygen/silicon burning in massive stars',
    acidBaseChar: 'Weakly acidic oxide (SiO₂); SiO₂ + NaOH → Na₂SiO₃',
    keyGeometry: 'SiH₄: tetrahedral, 109.5° · SiO₄⁴⁻: tetrahedral · SiF₄: tetrahedral',
  ),
  15: ElementExtras(
    isotopes: [
      IsotopeInfo(31, '³¹P',  100.0, true),
    ],
    crystalStructure: 'Orthorhombic (white P₄) / complex (black P layers)',
    commonIons: ['PO₄³⁻ (phosphate)', 'HPO₄²⁻', 'H₂PO₄⁻', 'PO₃³⁻ (phosphite)', 'P³⁻ (phosphide)'],
    nucleosynthesis: 'Stellar nucleosynthesis – oxygen burning in massive stars',
    acidBaseChar: 'P₄O₁₀ is strongly acidic; H₃PO₄ is a medium-strength acid',
    keyGeometry: 'PCl₃: trigonal pyramidal, 100° · PCl₅: trigonal bipyramidal · PO₄³⁻: tetrahedral',
  ),
  16: ElementExtras(
    isotopes: [
      IsotopeInfo(32, '³²S',  94.99, true),
      IsotopeInfo(33, '³³S',   0.75, true),
      IsotopeInfo(34, '³⁴S',   4.25, true),
      IsotopeInfo(36, '³⁶S',   0.01, true),
    ],
    crystalStructure: 'Orthorhombic (α-S₈ rings)',
    commonIons: ['S²⁻ (sulfide)', 'SO₃²⁻ (sulfite)', 'SO₄²⁻ (sulfate)', 'HSO₄⁻ (bisulfate)', 'S₂O₃²⁻ (thiosulfate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – oxygen burning and explosive nucleosynthesis in supernovae',
    acidBaseChar: 'SO₃ → H₂SO₄ (strongly acidic); SO₂ → H₂SO₃ (weakly acidic)',
    keyGeometry: 'H₂S: bent, 92.3° · SO₂: bent, 119.5° · SO₃: trigonal planar, 120° · SF₆: octahedral',
  ),
  17: ElementExtras(
    isotopes: [
      IsotopeInfo(35, '³⁵Cl',  75.76, true),
      IsotopeInfo(37, '³⁷Cl',  24.24, true),
    ],
    crystalStructure: 'Orthorhombic (solid Cl₂)',
    commonIons: ['Cl⁻ (chloride)', 'ClO⁻ (hypochlorite)', 'ClO₂⁻ (chlorite)', 'ClO₃⁻ (chlorate)', 'ClO₄⁻ (perchlorate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – explosive oxygen/neon burning in supernovae',
    acidBaseChar: 'HCl is a strong acid; Cl₂O₇ → HClO₄ (strongest common acid)',
    keyGeometry: 'HCl: linear · ClF₃: T-shaped · ClO₄⁻: tetrahedral · PCl₅-type: see above',
  ),
  18: ElementExtras(
    isotopes: [
      IsotopeInfo(36, '³⁶Ar',   0.334, true),
      IsotopeInfo(38, '³⁸Ar',   0.063, true),
      IsotopeInfo(40, '⁴⁰Ar',  99.600, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Ar – no stable ions (noble gas)'],
    nucleosynthesis: '⁴⁰Ar from radioactive decay of ⁴⁰K; ³⁶Ar and ³⁸Ar from stellar nucleosynthesis',
    acidBaseChar: 'Chemically inert',
    keyGeometry: 'No stable compounds',
  ),

  // ── Period 4 ─────────────────────────────────────────────────────────────────
  19: ElementExtras(
    isotopes: [
      IsotopeInfo(39, '³⁹K',  93.258, true),
      IsotopeInfo(40, '⁴⁰K',   0.012, false, halfLife: '1.25 Gy'),
      IsotopeInfo(41, '⁴¹K',   6.730, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['K⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – oxygen burning; ⁴⁰K by explosive Si burning',
    acidBaseChar: 'Strongly basic oxide (K₂O); KOH is a strong base',
    keyGeometry: 'KCl: rock-salt ionic · KO₂: superoxide structure',
  ),
  20: ElementExtras(
    isotopes: [
      IsotopeInfo(40, '⁴⁰Ca',  96.941, true),
      IsotopeInfo(42, '⁴²Ca',   0.647, true),
      IsotopeInfo(43, '⁴³Ca',   0.135, true),
      IsotopeInfo(44, '⁴⁴Ca',   2.086, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Ca²⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – silicon burning and explosive nucleosynthesis',
    acidBaseChar: 'Basic oxide (CaO / quicklime); Ca(OH)₂ is a moderately strong base',
    keyGeometry: 'CaF₂: fluorite cubic · CaCO₃: rhombohedral (calcite) · CaO: rock-salt',
  ),
  21: ElementExtras(
    isotopes: [
      IsotopeInfo(45, '⁴⁵Sc',  100.0, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP)',
    commonIons: ['Sc³⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process in AGB stars',
    acidBaseChar: 'Basic/amphoteric oxide (Sc₂O₃)',
    keyGeometry: '[Sc(H₂O)₆]³⁺: octahedral · ScCl₃: layer structure',
  ),
  22: ElementExtras(
    isotopes: [
      IsotopeInfo(46, '⁴⁶Ti',   8.25, true),
      IsotopeInfo(47, '⁴⁷Ti',   7.44, true),
      IsotopeInfo(48, '⁴⁸Ti',  73.72, true),
      IsotopeInfo(49, '⁴⁹Ti',   5.41, true),
      IsotopeInfo(50, '⁵⁰Ti',   5.18, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP) α-Ti / BCC β-Ti (>882 °C)',
    commonIons: ['Ti²⁺', 'Ti³⁺', 'Ti⁴⁺ (TiO₂, TiCl₄)'],
    nucleosynthesis: 'Stellar nucleosynthesis – silicon burning and explosive α-rich freeze-out',
    acidBaseChar: 'TiO₂ is amphoteric (mostly weakly basic); TiCl₄ hydrolyses to acidic solution',
    keyGeometry: 'TiO₂: rutile (octahedral Ti) · TiCl₄: tetrahedral · TiO₂ anatase: distorted octahedral',
  ),
  23: ElementExtras(
    isotopes: [
      IsotopeInfo(50, '⁵⁰V',   0.25, true),
      IsotopeInfo(51, '⁵¹V',  99.75, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['V²⁺', 'V³⁺', 'VO²⁺ (vanadyl, V⁴⁺)', 'VO₄³⁻ / VO₃⁻ (vanadate, V⁵⁺)'],
    nucleosynthesis: 'Stellar nucleosynthesis – oxygen and silicon burning',
    acidBaseChar: 'Amphoteric – V₂O₅ is acidic; lower oxides basic',
    keyGeometry: 'VCl₄: tetrahedral · [VO(H₂O)₅]²⁺: square pyramidal · VO₄³⁻: tetrahedral',
  ),
  24: ElementExtras(
    isotopes: [
      IsotopeInfo(50, '⁵⁰Cr',   4.35, true),
      IsotopeInfo(52, '⁵²Cr',  83.79, true),
      IsotopeInfo(53, '⁵³Cr',   9.50, true),
      IsotopeInfo(54, '⁵⁴Cr',   2.37, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Cr²⁺', 'Cr³⁺', 'CrO₄²⁻ (chromate, Cr⁶⁺)', 'Cr₂O₇²⁻ (dichromate, Cr⁶⁺)'],
    nucleosynthesis: 'Stellar nucleosynthesis – silicon burning in massive stars',
    acidBaseChar: 'Cr₂O₃ (Cr³⁺) is amphoteric; CrO₃ (Cr⁶⁺) is strongly acidic',
    keyGeometry: '[Cr(H₂O)₆]³⁺: octahedral · CrO₄²⁻: tetrahedral · Cr(CO)₆: octahedral',
  ),
  25: ElementExtras(
    isotopes: [
      IsotopeInfo(55, '⁵⁵Mn',  100.0, true),
    ],
    crystalStructure: 'Complex cubic (α-Mn, 58 atoms/unit cell)',
    commonIons: ['Mn²⁺', 'Mn³⁺', 'Mn⁴⁺ (MnO₂)', 'MnO₄²⁻ (manganate, Mn⁶⁺)', 'MnO₄⁻ (permanganate, Mn⁷⁺)'],
    nucleosynthesis: 'Stellar nucleosynthesis – silicon burning',
    acidBaseChar: 'MnO (basic) → MnO₂ (amphoteric) → Mn₂O₇ (acidic, strongly oxidising)',
    keyGeometry: '[Mn(H₂O)₆]²⁺: octahedral · MnO₄⁻: tetrahedral · MnCl₂: distorted octahedral',
  ),
  26: ElementExtras(
    isotopes: [
      IsotopeInfo(54, '⁵⁴Fe',   5.85, true),
      IsotopeInfo(56, '⁵⁶Fe',  91.75, true),
      IsotopeInfo(57, '⁵⁷Fe',   2.12, true),
      IsotopeInfo(58, '⁵⁸Fe',   0.28, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC) α-Fe (room temp) / FCC γ-Fe (>912 °C)',
    commonIons: ['Fe²⁺ (ferrous)', 'Fe³⁺ (ferric)', 'FeO₄²⁻ (ferrate, Fe⁶⁺, powerful oxidant)'],
    nucleosynthesis: 'End product of stellar fusion (iron peak); explosive Si burning in supernovae',
    acidBaseChar: 'FeO (basic), Fe₂O₃ (weakly basic), Fe(OH)₃ precipitates at pH ~3–4',
    keyGeometry: '[Fe(H₂O)₆]²⁺: octahedral · Fe(CO)₅: trigonal bipyramidal · haem Fe: square planar',
  ),
  27: ElementExtras(
    isotopes: [
      IsotopeInfo(59, '⁵⁹Co',  100.0, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP) / FCC above 422 °C',
    commonIons: ['Co²⁺', 'Co³⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – silicon burning and s-process',
    acidBaseChar: 'CoO and Co₂O₃ are basic',
    keyGeometry: '[Co(NH₃)₆]³⁺: octahedral · CoCl₄²⁻: tetrahedral · Co(CO)₄⁻: tetrahedral',
  ),
  28: ElementExtras(
    isotopes: [
      IsotopeInfo(58, '⁵⁸Ni',  68.08, true),
      IsotopeInfo(60, '⁶⁰Ni',  26.22, true),
      IsotopeInfo(61, '⁶¹Ni',   1.14, true),
      IsotopeInfo(62, '⁶²Ni',   3.63, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Ni²⁺', 'Ni³⁺ (in NiOOH)'],
    nucleosynthesis: 'Stellar nucleosynthesis – silicon burning; ⁵⁶Ni → ⁵⁶Co → ⁵⁶Fe (decay chain)',
    acidBaseChar: 'NiO and Ni(OH)₂ are weakly basic',
    keyGeometry: '[Ni(H₂O)₆]²⁺: octahedral · Ni(CO)₄: tetrahedral · [Ni(CN)₄]²⁻: square planar',
  ),
  29: ElementExtras(
    isotopes: [
      IsotopeInfo(63, '⁶³Cu',  69.17, true),
      IsotopeInfo(65, '⁶⁵Cu',  30.83, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Cu⁺ (cuprous)', 'Cu²⁺ (cupric)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process neutron capture',
    acidBaseChar: 'CuO (basic); Cu₂O (basic); Cu(OH)₂ is weakly amphoteric',
    keyGeometry: '[Cu(H₂O)₄]²⁺: square planar (Jahn-Teller) · CuCl₂: chain structure · Cu(I) tetrahedral',
  ),
  30: ElementExtras(
    isotopes: [
      IsotopeInfo(64, '⁶⁴Zn',  48.6, true),
      IsotopeInfo(66, '⁶⁶Zn',  27.9, true),
      IsotopeInfo(67, '⁶⁷Zn',   4.1, true),
      IsotopeInfo(68, '⁶⁸Zn',  18.8, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP, distorted c/a)',
    commonIons: ['Zn²⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and explosive nucleosynthesis',
    acidBaseChar: 'Amphoteric – ZnO and Zn(OH)₂ dissolve in both acids and strong bases',
    keyGeometry: '[Zn(H₂O)₆]²⁺: octahedral · ZnCl₄²⁻: tetrahedral · ZnO: wurtzite (tetrahedral Zn)',
  ),
  31: ElementExtras(
    isotopes: [
      IsotopeInfo(69, '⁶⁹Ga',  60.11, true),
      IsotopeInfo(71, '⁷¹Ga',  39.89, true),
    ],
    crystalStructure: 'Orthorhombic (unique – gallium melts at 29.8 °C)',
    commonIons: ['Ga³⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process in AGB stars',
    acidBaseChar: 'Amphoteric – Ga₂O₃ dissolves in strong acid and base',
    keyGeometry: 'GaCl₃: dimer Ga₂Cl₆ (bridged) · GaAs: zinc-blende structure · [Ga(H₂O)₆]³⁺: octahedral',
  ),
  32: ElementExtras(
    isotopes: [
      IsotopeInfo(70, '⁷⁰Ge',  20.57, true),
      IsotopeInfo(72, '⁷²Ge',  27.45, true),
      IsotopeInfo(73, '⁷³Ge',   7.75, true),
      IsotopeInfo(74, '⁷⁴Ge',  36.50, true),
    ],
    crystalStructure: 'Diamond cubic',
    commonIons: ['Ge²⁺', 'Ge⁴⁺', 'GeO₄⁴⁻ (germanate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process neutron capture in AGB stars',
    acidBaseChar: 'GeO₂ is weakly acidic; GeO is weakly basic; Ge(OH)₄ is amphoteric',
    keyGeometry: 'GeH₄: tetrahedral · GeCl₄: tetrahedral · GeO₂: rutile-type (octahedral Ge)',
  ),
  33: ElementExtras(
    isotopes: [
      IsotopeInfo(75, '⁷⁵As',  100.0, true),
    ],
    crystalStructure: 'Rhombohedral (layered arsenic)',
    commonIons: ['As³⁻ (arsenide)', 'AsO₃³⁻ (arsenite, As³⁺)', 'AsO₄³⁻ (arsenate, As⁵⁺)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process neutron capture',
    acidBaseChar: 'As₂O₃ weakly acidic; H₃AsO₄ is a weak acid',
    keyGeometry: 'AsCl₃: trigonal pyramidal · AsF₅: trigonal bipyramidal · AsO₄³⁻: tetrahedral',
  ),
  34: ElementExtras(
    isotopes: [
      IsotopeInfo(76, '⁷⁶Se',   9.37, true),
      IsotopeInfo(77, '⁷⁷Se',   7.63, true),
      IsotopeInfo(78, '⁷⁸Se',  23.77, true),
      IsotopeInfo(80, '⁸⁰Se',  49.61, true),
    ],
    crystalStructure: 'Hexagonal (trigonal Se-chain allotrope) / monoclinic (Se₈ rings)',
    commonIons: ['Se²⁻ (selenide)', 'SeO₃²⁻ (selenite)', 'SeO₄²⁻ (selenate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process neutron capture',
    acidBaseChar: 'SeO₂ → H₂SeO₃ (weakly acidic); H₂Se is weakly acidic',
    keyGeometry: 'H₂Se: bent, 91° · SeO₂: bent · SeO₄²⁻: tetrahedral · SeF₆: octahedral',
  ),
  35: ElementExtras(
    isotopes: [
      IsotopeInfo(79, '⁷⁹Br',  50.69, true),
      IsotopeInfo(81, '⁸¹Br',  49.31, true),
    ],
    crystalStructure: 'Orthorhombic (solid Br₂)',
    commonIons: ['Br⁻ (bromide)', 'BrO₃⁻ (bromate)', 'BrO₄⁻ (perbromate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process',
    acidBaseChar: 'HBr is a strong acid; Br₂ is oxidising',
    keyGeometry: 'HBr: linear · BrF₃: T-shaped · BrO₃⁻: trigonal pyramidal',
  ),
  36: ElementExtras(
    isotopes: [
      IsotopeInfo(82, '⁸²Kr',  11.593, true),
      IsotopeInfo(83, '⁸³Kr',  11.500, true),
      IsotopeInfo(84, '⁸⁴Kr',  56.987, true),
      IsotopeInfo(86, '⁸⁶Kr',  17.279, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Kr – no stable ions (noble gas, except KrF₂ etc.)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process neutron capture in AGB stars',
    acidBaseChar: 'Chemically inert; KrF₂ is a strong oxidiser',
    keyGeometry: 'KrF₂: linear (hypervalent)',
  ),

  // ── Period 5 (key elements) ───────────────────────────────────────────────────
  37: ElementExtras(
    isotopes: [
      IsotopeInfo(85, '⁸⁵Rb',  72.17, true),
      IsotopeInfo(87, '⁸⁷Rb',  27.83, false, halfLife: '49.2 Gy'),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Rb⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process; ⁸⁷Rb from r-process',
    acidBaseChar: 'Strongly basic oxide (Rb₂O); RbOH is a strong base',
    keyGeometry: 'RbCl: rock-salt ionic',
  ),
  38: ElementExtras(
    isotopes: [
      IsotopeInfo(86, '⁸⁶Sr',   9.86, true),
      IsotopeInfo(87, '⁸⁷Sr',   7.00, true),
      IsotopeInfo(88, '⁸⁸Sr',  82.58, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Sr²⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process (AGB stars); ⁸⁷Sr radiogenic from ⁸⁷Rb',
    acidBaseChar: 'Basic oxide (SrO); Sr(OH)₂ is a moderately strong base',
    keyGeometry: 'SrO: rock-salt · SrTiO₃: perovskite (octahedral Ti in Sr cubic framework)',
  ),
  40: ElementExtras(
    isotopes: [
      IsotopeInfo(90, '⁹⁰Zr',  51.45, true),
      IsotopeInfo(91, '⁹¹Zr',  11.22, true),
      IsotopeInfo(92, '⁹²Zr',  17.15, true),
      IsotopeInfo(94, '⁹⁴Zr',  17.38, true),
    ],
    crystalStructure: 'Hexagonal Close-Packed (HCP) α-Zr / BCC β-Zr',
    commonIons: ['Zr⁴⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process in AGB stars',
    acidBaseChar: 'ZrO₂ (zirconia) is amphoteric',
    keyGeometry: 'ZrO₂: monoclinic (7-coordinate Zr) · ZrCl₄: tetrahedral',
  ),
  42: ElementExtras(
    isotopes: [
      IsotopeInfo(92, '⁹²Mo',  14.53, true),
      IsotopeInfo(95, '⁹⁵Mo',  15.84, true),
      IsotopeInfo(96, '⁹⁶Mo',  16.67, true),
      IsotopeInfo(98, '⁹⁸Mo',  24.39, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Mo²⁺–Mo⁶⁺', 'MoO₄²⁻ (molybdate)', 'Mo₂O₇²⁻'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and p-process',
    acidBaseChar: 'MoO₃ is acidic; lower Mo oxides are basic or amphoteric',
    keyGeometry: 'MoO₄²⁻: tetrahedral · Mo(CO)₆: octahedral · MoCl₅: square pyramidal',
  ),
  47: ElementExtras(
    isotopes: [
      IsotopeInfo(107, '¹⁰⁷Ag',  51.84, true),
      IsotopeInfo(109, '¹⁰⁹Ag',  48.16, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Ag⁺', 'Ag²⁺ (rare)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process neutron capture',
    acidBaseChar: 'Ag₂O is weakly basic; AgNO₃ gives neutral to slightly acidic solutions',
    keyGeometry: '[Ag(NH₃)₂]⁺: linear · AgCl: rock-salt · AgF: rock-salt',
  ),
  50: ElementExtras(
    isotopes: [
      IsotopeInfo(112, '¹¹²Sn',   0.97, true),
      IsotopeInfo(114, '¹¹⁴Sn',   0.66, true),
      IsotopeInfo(116, '¹¹⁶Sn',  14.54, true),
      IsotopeInfo(118, '¹¹⁸Sn',  24.22, true),
      IsotopeInfo(120, '¹²⁰Sn',  32.58, true),
    ],
    crystalStructure: 'Tetragonal (white β-Sn) / Diamond cubic (gray α-Sn)',
    commonIons: ['Sn²⁺ (stannous)', 'Sn⁴⁺ (stannic)', 'SnO₃²⁻ (stannate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process (magic number, many stable isotopes)',
    acidBaseChar: 'SnO (basic/amphoteric), SnO₂ (amphoteric), Sn(OH)₄ dissolves in NaOH',
    keyGeometry: 'SnCl₄: tetrahedral · SnCl₂: bent (lone pair) · [SnCl₆]²⁻: octahedral',
  ),
  53: ElementExtras(
    isotopes: [
      IsotopeInfo(127, '¹²⁷I',  100.0, true),
    ],
    crystalStructure: 'Orthorhombic (solid I₂)',
    commonIons: ['I⁻ (iodide)', 'IO₃⁻ (iodate)', 'IO₄⁻ (periodate)', 'I₃⁻'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process',
    acidBaseChar: 'HI is a strong acid; I₂ is weakly soluble, forms acidic solutions with I⁻',
    keyGeometry: 'IF₅: square pyramidal · IF₇: pentagonal bipyramidal · I₃⁻: linear',
  ),
  56: ElementExtras(
    isotopes: [
      IsotopeInfo(134, '¹³⁴Ba',   2.42, true),
      IsotopeInfo(136, '¹³⁶Ba',   7.85, true),
      IsotopeInfo(137, '¹³⁷Ba',  11.23, true),
      IsotopeInfo(138, '¹³⁸Ba',  71.70, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Ba²⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process in AGB stars',
    acidBaseChar: 'Strongly basic oxide (BaO); Ba(OH)₂ is a strong base',
    keyGeometry: 'BaSO₄: orthorhombic (9-coordinate Ba) · BaO: rock-salt',
  ),

  // ── Lanthanides (summary entries) ────────────────────────────────────────────
  57: ElementExtras(
    isotopes: [
      IsotopeInfo(138, '¹³⁸La',   0.089, false, halfLife: '102 Gy'),
      IsotopeInfo(139, '¹³⁹La',  99.911, true),
    ],
    crystalStructure: 'Double Hexagonal Close-Packed (dhcp) / FCC (β-La)',
    commonIons: ['La³⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process in AGB stars',
    acidBaseChar: 'Basic oxide (La₂O₃); La(OH)₃ is a strong base among lanthanides',
    keyGeometry: '[La(H₂O)₉]³⁺: tricapped trigonal prismatic',
  ),
  58: ElementExtras(
    isotopes: [
      IsotopeInfo(140, '¹⁴⁰Ce',  88.450, true),
      IsotopeInfo(142, '¹⁴²Ce',  11.114, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC) / dhcp',
    commonIons: ['Ce³⁺', 'Ce⁴⁺ (ceric, strong oxidant)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process',
    acidBaseChar: 'CeO₂ (basic); Ce³⁺ solutions weakly acidic',
    keyGeometry: '[Ce(NO₃)₆]²⁻: 12-coordinate · CeO₂: fluorite structure',
  ),

  // ── Period 6 transition metals ───────────────────────────────────────────────
  74: ElementExtras(
    isotopes: [
      IsotopeInfo(182, '¹⁸²W',  26.50, true),
      IsotopeInfo(183, '¹⁸³W',  14.31, true),
      IsotopeInfo(184, '¹⁸⁴W',  30.64, true),
      IsotopeInfo(186, '¹⁸⁶W',  28.43, true),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC) – highest mp of all metals (3422 °C)',
    commonIons: ['W⁴⁺', 'W⁶⁺', 'WO₄²⁻ (tungstate)', 'W₁₂O₄₂¹²⁻ (polytungstate)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process neutron capture',
    acidBaseChar: 'WO₃ is acidic (tungstic acid); lower oxides amphoteric',
    keyGeometry: 'WO₄²⁻: tetrahedral · W(CO)₆: octahedral · WF₆: octahedral',
  ),
  78: ElementExtras(
    isotopes: [
      IsotopeInfo(192, '¹⁹²Pt',   0.78, true),
      IsotopeInfo(194, '¹⁹⁴Pt',  32.97, true),
      IsotopeInfo(195, '¹⁹⁵Pt',  33.83, true),
      IsotopeInfo(196, '¹⁹⁶Pt',  25.24, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Pt²⁺', 'Pt⁴⁺'],
    nucleosynthesis: 'Stellar nucleosynthesis – r-process in neutron star mergers',
    acidBaseChar: 'PtO₂ slightly acidic; PtO basic',
    keyGeometry: '[PtCl₄]²⁻: square planar (d⁸) · [PtCl₆]²⁻: octahedral (d⁶)',
  ),
  79: ElementExtras(
    isotopes: [
      IsotopeInfo(197, '¹⁹⁷Au',  100.0, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Au⁺ (aurous)', 'Au³⁺ (auric)', 'Au(CN)₂⁻'],
    nucleosynthesis: 'r-process in neutron star mergers and supernovae (kilonovae)',
    acidBaseChar: 'Au₂O₃ weakly amphoteric; Au does not dissolve in single acids',
    keyGeometry: '[AuCl₄]⁻: square planar · [Au(CN)₂]⁻: linear · Au metal: FCC',
  ),
  80: ElementExtras(
    isotopes: [
      IsotopeInfo(198, '¹⁹⁸Hg',   9.97, true),
      IsotopeInfo(200, '²⁰⁰Hg',  23.10, true),
      IsotopeInfo(202, '²⁰²Hg',  29.86, true),
      IsotopeInfo(204, '²⁰⁴Hg',   6.87, true),
    ],
    crystalStructure: 'Rhombohedral (solid Hg below −39 °C)',
    commonIons: ['Hg₂²⁺ (mercurous, dimeric!)', 'Hg²⁺ (mercuric)'],
    nucleosynthesis: 'Stellar nucleosynthesis – s-process and r-process',
    acidBaseChar: 'HgO weakly basic; HgCl₂ is a strong Lewis acid, hydrolyses slightly in water',
    keyGeometry: 'Hg₂Cl₂: linear Cl–Hg–Hg–Cl · [HgI₄]²⁻: tetrahedral · HgO: zigzag chains',
  ),
  82: ElementExtras(
    isotopes: [
      IsotopeInfo(206, '²⁰⁶Pb',  24.1, true),
      IsotopeInfo(207, '²⁰⁷Pb',  22.1, true),
      IsotopeInfo(208, '²⁰⁸Pb',  52.4, true),
      IsotopeInfo(204, '²⁰⁴Pb',   1.4, true),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Pb²⁺ (plumbous)', 'Pb⁴⁺ (plumbic)'],
    nucleosynthesis: 'End product of radioactive decay chains (U-238, U-235, Th-232) + s-process',
    acidBaseChar: 'PbO and PbO₂ are amphoteric; Pb(OH)₂ dissolves in acid and strong base',
    keyGeometry: '[PbCl₄]²⁻: tetrahedral · PbO: tetragonal litharge (lone pair stereochemically active)',
  ),
  83: ElementExtras(
    isotopes: [
      IsotopeInfo(209, '²⁰⁹Bi',  100.0, false, halfLife: '2.01×10¹⁹ y'),
    ],
    crystalStructure: 'Rhombohedral',
    commonIons: ['Bi³⁺', 'BiO⁺ (bismuthyl)', 'Bi⁵⁺ (rare)'],
    nucleosynthesis: 'r-process in neutron star mergers (heaviest "stable" element)',
    acidBaseChar: 'Bi₂O₃ is basic; Bi₂O₅ weakly acidic',
    keyGeometry: 'BiCl₃: trigonal pyramidal · Bi(NO₃)₃: complex polymeric · BiF₅: trigonal bipyramidal',
  ),

  // ── Radioactive and synthetic elements ────────────────────────────────────────
  84: ElementExtras(
    isotopes: [
      IsotopeInfo(210, 'Po-210',  0.0, false, halfLife: '138.4 d'),
      IsotopeInfo(209, 'Po-209',  0.0, false, halfLife: '102 y'),
    ],
    crystalStructure: 'Simple Cubic (α-Po) / Rhombohedral (β-Po) – unique simple cubic metal',
    commonIons: ['Po²⁺', 'Po⁴⁺', 'PoO₃²⁻'],
    nucleosynthesis: 'Radioactive decay product of uranium/thorium decay chains',
    acidBaseChar: 'PoO₂ amphoteric',
    keyGeometry: 'PoO₂: distorted fluorite · PoCl₄: tetrahedral',
  ),
  86: ElementExtras(
    isotopes: [
      IsotopeInfo(222, 'Rn-222', 0.0, false, halfLife: '3.82 d'),
      IsotopeInfo(220, 'Rn-220', 0.0, false, halfLife: '55.6 s'),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC, predicted)',
    commonIons: ['Rn – typically no ions; RnF₂ proposed'],
    nucleosynthesis: 'Radioactive decay of radium-226 (from uranium-238 chain)',
    acidBaseChar: 'Chemically largely inert noble gas',
    keyGeometry: 'RnF₂: linear (predicted)',
  ),
  88: ElementExtras(
    isotopes: [
      IsotopeInfo(226, 'Ra-226', 0.0, false, halfLife: '1 600 y'),
      IsotopeInfo(228, 'Ra-228', 0.0, false, halfLife: '5.75 y'),
    ],
    crystalStructure: 'Body-Centred Cubic (BCC)',
    commonIons: ['Ra²⁺'],
    nucleosynthesis: 'Radioactive decay of uranium-238 and thorium-232 decay chains',
    acidBaseChar: 'Strongly basic oxide (RaO); Ra(OH)₂ is soluble and basic',
    keyGeometry: 'RaCl₂: ionic structure (isostructural with BaCl₂)',
  ),
  90: ElementExtras(
    isotopes: [
      IsotopeInfo(232, 'Th-232', 100.0, false, halfLife: '14.05 Gy'),
      IsotopeInfo(230, 'Th-230', 0.0, false, halfLife: '75.4 ky'),
    ],
    crystalStructure: 'Face-Centred Cubic (FCC)',
    commonIons: ['Th⁴⁺'],
    nucleosynthesis: 'r-process in neutron star mergers; primordial (long-lived)',
    acidBaseChar: 'ThO₂ is basic; Th(OH)₄ is weakly soluble',
    keyGeometry: '[Th(NO₃)₄(H₂O)₄]: 12-coordinate · ThO₂: fluorite structure',
  ),
  92: ElementExtras(
    isotopes: [
      IsotopeInfo(238, 'U-238', 99.2742, false, halfLife: '4.47 Gy'),
      IsotopeInfo(235, 'U-235',  0.7204, false, halfLife: '703.8 My'),
      IsotopeInfo(234, 'U-234',  0.0054, false, halfLife: '245.5 ky'),
    ],
    crystalStructure: 'Orthorhombic (α-U) – unique corrugated sheet structure',
    commonIons: ['U³⁺', 'U⁴⁺', 'UO₂²⁺ (uranyl, U⁶⁺)', 'U⁵⁺'],
    nucleosynthesis: 'r-process in neutron star mergers; primordial (detected in oldest stars)',
    acidBaseChar: 'UO₃ and U₃O₈ are amphoteric; UO₂ is basic',
    keyGeometry: 'UO₂²⁺: linear O=U=O · UO₂(NO₃)₂·6H₂O: hexagonal bipyramidal U',
  ),
  94: ElementExtras(
    isotopes: [
      IsotopeInfo(239, 'Pu-239', 0.0, false, halfLife: '24 110 y'),
      IsotopeInfo(240, 'Pu-240', 0.0, false, halfLife: '6 563 y'),
      IsotopeInfo(244, 'Pu-244', 0.0, false, halfLife: '80.8 My'),
    ],
    crystalStructure: 'Monoclinic (α-Pu) – most complex crystal structure of any pure element',
    commonIons: ['Pu³⁺', 'Pu⁴⁺', 'PuO₂²⁺ (plutonyl)'],
    nucleosynthesis: 'Synthetic (produced in nuclear reactors via neutron capture on U-238)',
    acidBaseChar: 'PuO₂ is basic; Pu solutions complex due to multiple oxidation states coexisting',
    keyGeometry: 'PuO₂: fluorite structure · [Pu(H₂O)₉]³⁺: tricapped trigonal prismatic',
  ),

  // ── Superheavy elements (118 entries needed; fill remaining ─────────────────
  93: ElementExtras(
    isotopes: [IsotopeInfo(237, 'Np-237', 0.0, false, halfLife: '2.14 My')],
    crystalStructure: 'Orthorhombic (α-Np)',
    commonIons: ['Np³⁺', 'Np⁴⁺', 'NpO₂⁺', 'NpO₂²⁺'],
    nucleosynthesis: 'Synthetic; trace amounts from natural neutron capture on U-238',
    acidBaseChar: 'NpO₂ is basic; Np solutions show multiple stable oxidation states',
    keyGeometry: 'NpO₂²⁺: linear (like UO₂²⁺)',
  ),
  95: ElementExtras(
    isotopes: [IsotopeInfo(243, 'Am-243', 0.0, false, halfLife: '7 370 y')],
    crystalStructure: 'Double Hexagonal Close-Packed (dhcp)',
    commonIons: ['Am³⁺', 'Am⁴⁺', 'AmO₂⁺', 'AmO₂²⁺'],
    nucleosynthesis: 'Synthetic (neutron capture on Pu-239 in reactors)',
    acidBaseChar: 'Basic; Am³⁺ is the most stable state in solution',
    keyGeometry: '[Am(H₂O)₉]³⁺: tricapped trigonal prismatic',
  ),
  96: ElementExtras(
    isotopes: [IsotopeInfo(247, 'Cm-247', 0.0, false, halfLife: '15.6 My')],
    crystalStructure: 'Double Hexagonal Close-Packed (dhcp)',
    commonIons: ['Cm³⁺'],
    nucleosynthesis: 'Synthetic (neutron capture and β-decay chain from Pu)',
    acidBaseChar: 'Basic oxide; Cm³⁺ highly stable',
    keyGeometry: '[Cm(H₂O)₉]³⁺: tricapped trigonal prismatic',
  ),
  97: ElementExtras(
    isotopes: [IsotopeInfo(247, 'Bk-247', 0.0, false, halfLife: '1 380 y')],
    crystalStructure: 'Double Hexagonal Close-Packed (dhcp)',
    commonIons: ['Bk³⁺', 'Bk⁴⁺'],
    nucleosynthesis: 'Synthetic (heavy-ion bombardment of Am/Cm)',
    acidBaseChar: 'Basic',
    keyGeometry: 'BkO₂: fluorite structure (Bk⁴⁺)',
  ),
  98: ElementExtras(
    isotopes: [IsotopeInfo(251, 'Cf-251', 0.0, false, halfLife: '900 y')],
    crystalStructure: 'Double Hexagonal Close-Packed (dhcp)',
    commonIons: ['Cf³⁺'],
    nucleosynthesis: 'Synthetic (heavy-ion bombardment)',
    acidBaseChar: 'Basic',
    keyGeometry: '[Cf(H₂O)₉]³⁺: predicted tricapped trigonal prismatic',
  ),
  99: ElementExtras(
    isotopes: [IsotopeInfo(252, 'Es-252', 0.0, false, halfLife: '471.7 d')],
    crystalStructure: 'Face-Centred Cubic (FCC, predicted)',
    commonIons: ['Es³⁺'],
    nucleosynthesis: 'Synthetic; first observed in fallout from Ivy Mike nuclear test (1952)',
    acidBaseChar: 'Basic',
    keyGeometry: 'Es³⁺ coordination chemistry poorly known',
  ),
  100: ElementExtras(
    isotopes: [IsotopeInfo(257, 'Fm-257', 0.0, false, halfLife: '100.5 d')],
    crystalStructure: 'Face-Centred Cubic (FCC, predicted)',
    commonIons: ['Fm²⁺', 'Fm³⁺'],
    nucleosynthesis: 'Synthetic (neutron irradiation of heavy actinides)',
    acidBaseChar: 'Basic',
    keyGeometry: 'Limited experimental data',
  ),
  101: ElementExtras(
    isotopes: [IsotopeInfo(258, 'Md-258', 0.0, false, halfLife: '51.5 d')],
    crystalStructure: 'Face-Centred Cubic (FCC, predicted)',
    commonIons: ['Md²⁺', 'Md³⁺'],
    nucleosynthesis: 'Synthetic (Es-253 + α particle bombardment)',
    acidBaseChar: 'Basic',
    keyGeometry: 'Limited experimental data',
  ),
  102: ElementExtras(
    isotopes: [IsotopeInfo(259, 'No-259', 0.0, false, halfLife: '58 min')],
    crystalStructure: 'Face-Centred Cubic (FCC, predicted)',
    commonIons: ['No²⁺', 'No³⁺'],
    nucleosynthesis: 'Synthetic (heavy-ion fusion)',
    acidBaseChar: 'Basic; No²⁺ unusually stable for actinide',
    keyGeometry: 'Limited experimental data',
  ),
  103: ElementExtras(
    isotopes: [IsotopeInfo(266, 'Lr-266', 0.0, false, halfLife: '11 h')],
    crystalStructure: 'Unknown (predicted HCP)',
    commonIons: ['Lr³⁺'],
    nucleosynthesis: 'Synthetic (Cf-252 + B-10 bombardment)',
    acidBaseChar: 'Basic',
    keyGeometry: 'No known stable compounds',
  ),
  104: ElementExtras(
    isotopes: [IsotopeInfo(267, 'Rf-267', 0.0, false, halfLife: '1.3 h')],
    crystalStructure: 'Unknown (predicted HCP)',
    commonIons: ['Rf⁴⁺'],
    nucleosynthesis: 'Synthetic (Cf-249 + C-12 bombardment)',
    acidBaseChar: 'Predicted to behave like Zr/Hf',
    keyGeometry: 'RfCl₄: predicted tetrahedral',
  ),
  105: ElementExtras(
    isotopes: [IsotopeInfo(268, 'Db-268', 0.0, false, halfLife: '16 h')],
    crystalStructure: 'Unknown',
    commonIons: ['Db⁵⁺'],
    nucleosynthesis: 'Synthetic (Cf-249 + N-15 bombardment)',
    acidBaseChar: 'Predicted to behave like Nb/Ta',
    keyGeometry: 'DbCl₅: predicted trigonal bipyramidal',
  ),
  106: ElementExtras(
    isotopes: [IsotopeInfo(271, 'Sg-271', 0.0, false, halfLife: '1.9 min')],
    crystalStructure: 'Unknown',
    commonIons: ['Sg⁶⁺'],
    nucleosynthesis: 'Synthetic (Cf-249 + O-18 bombardment)',
    acidBaseChar: 'Predicted to behave like W/Mo',
    keyGeometry: 'SgO₂Cl₂: predicted tetrahedral',
  ),
  107: ElementExtras(
    isotopes: [IsotopeInfo(270, 'Bh-270', 0.0, false, halfLife: '61 s')],
    crystalStructure: 'Unknown',
    commonIons: ['Bh⁷⁺'],
    nucleosynthesis: 'Synthetic (Bi-209 + Cr-54 bombardment)',
    acidBaseChar: 'Predicted like Re',
    keyGeometry: 'BhO₃Cl predicted',
  ),
  108: ElementExtras(
    isotopes: [IsotopeInfo(269, 'Hs-269', 0.0, false, halfLife: '9.7 s')],
    crystalStructure: 'Unknown (predicted HCP)',
    commonIons: ['Hs⁸⁺ (in HsO₄)'],
    nucleosynthesis: 'Synthetic (Pb-208 + Fe-58 bombardment)',
    acidBaseChar: 'HsO₄ is volatile (like OsO₄)',
    keyGeometry: 'HsO₄: predicted tetrahedral',
  ),
  109: ElementExtras(
    isotopes: [IsotopeInfo(278, 'Mt-278', 0.0, false, halfLife: '7.6 s')],
    crystalStructure: 'Unknown (predicted FCC)',
    commonIons: ['Mt³⁺, Mt⁵⁺ predicted'],
    nucleosynthesis: 'Synthetic (Bi-209 + Fe-58 bombardment)',
    acidBaseChar: 'Predicted noble-metal-like',
    keyGeometry: 'No characterized compounds',
  ),
  110: ElementExtras(
    isotopes: [IsotopeInfo(281, 'Ds-281', 0.0, false, halfLife: '11 s')],
    crystalStructure: 'Unknown',
    commonIons: ['Ds²⁺, Ds⁴⁺ predicted'],
    nucleosynthesis: 'Synthetic (Pb-208 + Ni-62 bombardment)',
    acidBaseChar: 'Predicted noble-metal-like (like Pt)',
    keyGeometry: 'No characterized compounds',
  ),
  111: ElementExtras(
    isotopes: [IsotopeInfo(282, 'Rg-282', 0.0, false, halfLife: '2 ms (Rg-281)')],
    crystalStructure: 'Unknown',
    commonIons: ['Rg⁺ predicted'],
    nucleosynthesis: 'Synthetic (Bi-209 + Ni-64 bombardment)',
    acidBaseChar: 'Predicted like Au',
    keyGeometry: 'No characterized compounds',
  ),
  112: ElementExtras(
    isotopes: [IsotopeInfo(285, 'Cn-285', 0.0, false, halfLife: '30 s')],
    crystalStructure: 'Unknown (predicted FCC or gas at room temperature)',
    commonIons: ['Cn²⁺ predicted (like Hg)'],
    nucleosynthesis: 'Synthetic (Pb-208 + Zn-70 bombardment)',
    acidBaseChar: 'Predicted noble gas-like behavior (relativistic effects)',
    keyGeometry: 'No characterized compounds',
  ),
  113: ElementExtras(
    isotopes: [IsotopeInfo(286, 'Nh-286', 0.0, false, halfLife: '10 s')],
    crystalStructure: 'Unknown',
    commonIons: ['Nh⁺, Nh³⁺ predicted'],
    nucleosynthesis: 'Synthetic (Bi-209 + Zn-70 bombardment)',
    acidBaseChar: 'Predicted like Tl',
    keyGeometry: 'No characterized compounds',
  ),
  114: ElementExtras(
    isotopes: [IsotopeInfo(289, 'Fl-289', 0.0, false, halfLife: '2.1 s')],
    crystalStructure: 'Unknown (possibly gas at room temperature)',
    commonIons: ['Fl²⁺, Fl⁴⁺ predicted'],
    nucleosynthesis: 'Synthetic (Pu-244 + Ca-48 bombardment)',
    acidBaseChar: 'Predicted noble-gas-like (strong relativistic effects)',
    keyGeometry: 'No characterized compounds',
  ),
  115: ElementExtras(
    isotopes: [IsotopeInfo(290, 'Mc-290', 0.0, false, halfLife: '0.65 s')],
    crystalStructure: 'Unknown',
    commonIons: ['Mc⁺, Mc³⁺ predicted'],
    nucleosynthesis: 'Synthetic (Am-243 + Ca-48 bombardment)',
    acidBaseChar: 'Predicted like Bi',
    keyGeometry: 'No characterized compounds',
  ),
  116: ElementExtras(
    isotopes: [IsotopeInfo(293, 'Lv-293', 0.0, false, halfLife: '61 ms')],
    crystalStructure: 'Unknown',
    commonIons: ['Lv²⁺ predicted'],
    nucleosynthesis: 'Synthetic (Cm-248 + Ca-48 bombardment)',
    acidBaseChar: 'Predicted like Po; possibly volatile',
    keyGeometry: 'No characterized compounds',
  ),
  117: ElementExtras(
    isotopes: [IsotopeInfo(294, 'Ts-294', 0.0, false, halfLife: '51 ms')],
    crystalStructure: 'Unknown',
    commonIons: ['Ts⁻, Ts⁺ predicted'],
    nucleosynthesis: 'Synthetic (Bk-249 + Ca-48 bombardment)',
    acidBaseChar: 'Predicted like a heavy halogen/At',
    keyGeometry: 'No characterized compounds',
  ),
  118: ElementExtras(
    isotopes: [IsotopeInfo(294, 'Og-294', 0.0, false, halfLife: '0.69 ms')],
    crystalStructure: 'Unknown (possibly solid at room temperature – predicted FCC)',
    commonIons: ['Og – possibly Og²⁺ (unlike other noble gases due to relativistic effects)'],
    nucleosynthesis: 'Synthetic (Cf-249 + Ca-48 bombardment)',
    acidBaseChar: 'Predicted to be reactive (unlike other noble gases) due to relativistic orbital compression',
    keyGeometry: 'No characterized compounds; predicted to form OgF₄',
  ),
};

// ── Missing elements that have basic data but no detailed entry above ──────────
// These fill in remaining elements (39, 41, 43-46, 48-49, 51-52, 54-55, 59-73, 75-77, 81, 85, 87, 89, 91)
// For a minimal but complete lookup, we provide fallback data inline.
const Map<int, ElementExtras> _kFallback = {
  39: ElementExtras(isotopes: [IsotopeInfo(89, '⁸⁹Y', 100.0, true)], crystalStructure: 'HCP', commonIons: ['Y³⁺'], nucleosynthesis: 's-process in AGB stars', acidBaseChar: 'Basic oxide (Y₂O₃)'),
  41: ElementExtras(isotopes: [IsotopeInfo(93, '⁹³Nb', 100.0, true)], crystalStructure: 'BCC', commonIons: ['Nb³⁺', 'Nb⁵⁺', 'NbO₃⁻'], nucleosynthesis: 's-process in AGB stars', acidBaseChar: 'Nb₂O₅ weakly acidic'),
  43: ElementExtras(isotopes: [IsotopeInfo(99, 'Tc-99', 0.0, false, halfLife: '211 ky')], crystalStructure: 'HCP', commonIons: ['Tc⁴⁺', 'TcO₄⁻ (pertechnetate)'], nucleosynthesis: 'Synthetic (fission product); trace in nature via neutron capture on Mo', acidBaseChar: 'Tc₂O₇ acidic'),
  44: ElementExtras(isotopes: [IsotopeInfo(102, '¹⁰²Ru', 31.55, true), IsotopeInfo(104, '¹⁰⁴Ru', 18.62, true)], crystalStructure: 'HCP', commonIons: ['Ru²⁺', 'Ru³⁺', 'Ru⁴⁺', 'RuO₄ (Ru⁸⁺)'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'RuO₄ strongly acidic/oxidising'),
  45: ElementExtras(isotopes: [IsotopeInfo(103, '¹⁰³Rh', 100.0, true)], crystalStructure: 'FCC', commonIons: ['Rh³⁺'], nucleosynthesis: 'r-process and p-process', acidBaseChar: 'Rh₂O₃ basic'),
  46: ElementExtras(isotopes: [IsotopeInfo(106, '¹⁰⁶Pd', 27.33, true), IsotopeInfo(108, '¹⁰⁸Pd', 26.46, true)], crystalStructure: 'FCC', commonIons: ['Pd²⁺', 'Pd⁴⁺'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'PdO weakly basic'),
  48: ElementExtras(isotopes: [IsotopeInfo(112, '¹¹²Cd', 24.13, true), IsotopeInfo(114, '¹¹⁴Cd', 28.73, true)], crystalStructure: 'HCP (distorted)', commonIons: ['Cd²⁺'], nucleosynthesis: 's-process in AGB stars', acidBaseChar: 'CdO basic; Cd(OH)₂ weakly amphoteric'),
  49: ElementExtras(isotopes: [IsotopeInfo(113, '¹¹³In', 4.29, true), IsotopeInfo(115, '¹¹⁵In', 95.71, false, halfLife: '4.41×10¹⁴ y')], crystalStructure: 'Face-Centred Tetragonal', commonIons: ['In³⁺'], nucleosynthesis: 's-process in AGB stars', acidBaseChar: 'In₂O₃ amphoteric'),
  51: ElementExtras(isotopes: [IsotopeInfo(121, '¹²¹Sb', 57.21, true), IsotopeInfo(123, '¹²³Sb', 42.79, true)], crystalStructure: 'Rhombohedral', commonIons: ['Sb³⁺', 'SbO₃³⁻', 'SbO₄³⁻ (Sb⁵⁺)'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Sb₂O₃ amphoteric; Sb₂O₅ weakly acidic'),
  52: ElementExtras(isotopes: [IsotopeInfo(130, '¹³⁰Te', 34.08, true), IsotopeInfo(128, '¹²⁸Te', 31.74, true)], crystalStructure: 'Hexagonal (trigonal chain)', commonIons: ['Te²⁻', 'TeO₃²⁻', 'TeO₄²⁻'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'H₂Te weakly acidic; TeO₃ amphoteric'),
  54: ElementExtras(isotopes: [IsotopeInfo(132, '¹³²Xe', 26.89, true), IsotopeInfo(129, '¹²⁹Xe', 26.44, true)], crystalStructure: 'FCC', commonIons: ['XeF⁺', 'XeO₃ (covalent)', 'XeO₄ (covalent)'], nucleosynthesis: 's-process and r-process neutron capture', acidBaseChar: 'XeO₃ acidic (reacts with base); XeO₄ very unstable'),
  55: ElementExtras(isotopes: [IsotopeInfo(133, '¹³³Cs', 100.0, true)], crystalStructure: 'BCC', commonIons: ['Cs⁺'], nucleosynthesis: 's-process in AGB stars', acidBaseChar: 'CsOH is the strongest common alkali base'),
  59: ElementExtras(isotopes: [IsotopeInfo(141, '¹⁴¹Pr', 100.0, true)], crystalStructure: 'dhcp', commonIons: ['Pr³⁺', 'Pr⁴⁺'], nucleosynthesis: 's-process', acidBaseChar: 'Basic'),
  60: ElementExtras(isotopes: [IsotopeInfo(142, '¹⁴²Nd', 27.2, true), IsotopeInfo(144, '¹⁴⁴Nd', 23.8, false, halfLife: '2.29×10¹⁵ y')], crystalStructure: 'dhcp', commonIons: ['Nd³⁺'], nucleosynthesis: 's-process', acidBaseChar: 'Basic'),
  61: ElementExtras(isotopes: [IsotopeInfo(145, 'Pm-145', 0.0, false, halfLife: '17.7 y')], crystalStructure: 'dhcp', commonIons: ['Pm³⁺'], nucleosynthesis: 'Fission product; trace in Nd ores via neutron capture', acidBaseChar: 'Basic'),
  62: ElementExtras(isotopes: [IsotopeInfo(152, '¹⁵²Sm', 26.75, true), IsotopeInfo(154, '¹⁵⁴Sm', 22.75, true)], crystalStructure: 'Rhombohedral', commonIons: ['Sm³⁺', 'Sm²⁺'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Basic'),
  63: ElementExtras(isotopes: [IsotopeInfo(151, '¹⁵¹Eu', 47.81, true), IsotopeInfo(153, '¹⁵³Eu', 52.19, true)], crystalStructure: 'BCC', commonIons: ['Eu³⁺', 'Eu²⁺ (unusually stable for lanthanide)'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Basic'),
  64: ElementExtras(isotopes: [IsotopeInfo(158, '¹⁵⁸Gd', 24.84, true), IsotopeInfo(160, '¹⁶⁰Gd', 21.86, true)], crystalStructure: 'HCP', commonIons: ['Gd³⁺'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Basic'),
  65: ElementExtras(isotopes: [IsotopeInfo(159, '¹⁵⁹Tb', 100.0, true)], crystalStructure: 'HCP', commonIons: ['Tb³⁺', 'Tb⁴⁺'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Basic'),
  66: ElementExtras(isotopes: [IsotopeInfo(164, '¹⁶⁴Dy', 28.18, true)], crystalStructure: 'HCP', commonIons: ['Dy³⁺'], nucleosynthesis: 's-process', acidBaseChar: 'Basic'),
  67: ElementExtras(isotopes: [IsotopeInfo(165, '¹⁶⁵Ho', 100.0, true)], crystalStructure: 'HCP', commonIons: ['Ho³⁺'], nucleosynthesis: 's-process', acidBaseChar: 'Basic'),
  68: ElementExtras(isotopes: [IsotopeInfo(166, '¹⁶⁶Er', 33.61, true)], crystalStructure: 'HCP', commonIons: ['Er³⁺'], nucleosynthesis: 's-process', acidBaseChar: 'Basic'),
  69: ElementExtras(isotopes: [IsotopeInfo(169, '¹⁶⁹Tm', 100.0, true)], crystalStructure: 'HCP', commonIons: ['Tm³⁺', 'Tm²⁺'], nucleosynthesis: 's-process', acidBaseChar: 'Basic'),
  70: ElementExtras(isotopes: [IsotopeInfo(174, '¹⁷⁴Yb', 31.83, true)], crystalStructure: 'FCC', commonIons: ['Yb³⁺', 'Yb²⁺'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Basic'),
  71: ElementExtras(isotopes: [IsotopeInfo(175, '¹⁷⁵Lu', 97.40, true), IsotopeInfo(176, '¹⁷⁶Lu', 2.60, false, halfLife: '37.6 Gy')], crystalStructure: 'HCP', commonIons: ['Lu³⁺'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Basic'),
  72: ElementExtras(isotopes: [IsotopeInfo(178, '¹⁷⁸Hf', 27.28, true), IsotopeInfo(180, '¹⁸⁰Hf', 35.24, true)], crystalStructure: 'HCP (α-Hf) / BCC (β-Hf)', commonIons: ['Hf⁴⁺'], nucleosynthesis: 's-process in AGB stars', acidBaseChar: 'HfO₂ weakly basic'),
  73: ElementExtras(isotopes: [IsotopeInfo(180, '¹⁸⁰ᵐTa', 0.012, false, halfLife: '>10¹⁵ y'), IsotopeInfo(181, '¹⁸¹Ta', 99.988, true)], crystalStructure: 'BCC', commonIons: ['Ta⁵⁺', 'TaO₃⁻'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Ta₂O₅ weakly acidic'),
  75: ElementExtras(isotopes: [IsotopeInfo(185, '¹⁸⁵Re', 37.40, true), IsotopeInfo(187, '¹⁸⁷Re', 62.60, false, halfLife: '41.2 Gy')], crystalStructure: 'HCP', commonIons: ['Re⁴⁺', 'ReO₄⁻ (perrhenate, Re⁷⁺)'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Re₂O₇ acidic; Re(IV) oxide amphoteric'),
  76: ElementExtras(isotopes: [IsotopeInfo(192, '¹⁹²Os', 40.93, true), IsotopeInfo(190, '¹⁹⁰Os', 26.26, true)], crystalStructure: 'HCP', commonIons: ['Os²⁺', 'Os⁴⁺', 'OsO₄ (Os⁸⁺ volatile)', 'OsO₄²⁻'], nucleosynthesis: 'r-process in neutron star mergers', acidBaseChar: 'OsO₄ is acidic; OsO₄ is a strong oxidant'),
  77: ElementExtras(isotopes: [IsotopeInfo(191, '¹⁹¹Ir', 37.3, true), IsotopeInfo(193, '¹⁹³Ir', 62.7, true)], crystalStructure: 'FCC', commonIons: ['Ir³⁺', 'Ir⁴⁺'], nucleosynthesis: 'r-process in neutron star mergers', acidBaseChar: 'IrO₂ weakly basic'),
  81: ElementExtras(isotopes: [IsotopeInfo(203, '²⁰³Tl', 29.52, true), IsotopeInfo(205, '²⁰⁵Tl', 70.48, true)], crystalStructure: 'HCP / BCC', commonIons: ['Tl⁺ (thallous)', 'Tl³⁺ (thallic)'], nucleosynthesis: 's-process and r-process', acidBaseChar: 'Tl₂O basic; Tl₂O₃ weakly amphoteric'),
  85: ElementExtras(isotopes: [IsotopeInfo(210, 'At-210', 0.0, false, halfLife: '8.1 h')], crystalStructure: 'Unknown (predicted FCC)', commonIons: ['At⁻', 'At⁺', 'AtO₃⁻'], nucleosynthesis: 'Radioactive decay of uranium via Ra-223/Ra-219 decay chains', acidBaseChar: 'HAt is a strong acid; At₂O₅ acidic'),
  87: ElementExtras(isotopes: [IsotopeInfo(223, 'Fr-223', 0.0, false, halfLife: '22 min')], crystalStructure: 'BCC (predicted)', commonIons: ['Fr⁺'], nucleosynthesis: 'Radioactive decay of Ac-227 (in actinium decay series)', acidBaseChar: 'FrOH predicted to be the strongest alkali hydroxide'),
  89: ElementExtras(isotopes: [IsotopeInfo(227, 'Ac-227', 0.0, false, halfLife: '21.77 y')], crystalStructure: 'FCC', commonIons: ['Ac³⁺'], nucleosynthesis: 'Radioactive decay of U-235 via Pa-231', acidBaseChar: 'Ac₂O₃ basic; Ac(OH)₃ very insoluble'),
  91: ElementExtras(isotopes: [IsotopeInfo(231, 'Pa-231', 0.0, false, halfLife: '32 760 y'), IsotopeInfo(233, 'Pa-233', 0.0, false, halfLife: '26.98 d')], crystalStructure: 'Body-Centred Tetragonal', commonIons: ['Pa³⁺', 'Pa⁴⁺', 'Pa⁵⁺', 'PaO₂⁺'], nucleosynthesis: 'Radioactive decay of U-235 (Pa-231) and from neutron capture on Th-232', acidBaseChar: 'Pa₂O₅ weakly acidic; Pa(V) dominant in aqueous chemistry'),
};

/// Get extras for a given atomic number (falls back to minimal placeholder).
ElementExtras? getElementExtras(int atomicNumber) {
  return kElementExtras[atomicNumber] ?? _kFallback[atomicNumber];
}
