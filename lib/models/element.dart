import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ElementCategory {
  alkaliMetal,
  alkalineEarthMetal,
  transitionMetal,
  postTransitionMetal,
  metalloid,
  reactiveNonmetal,
  halogen,
  nobleGas,
  lanthanide,
  actinide,
  unknownProperties,
}

extension ElementCategoryExt on ElementCategory {
  String get label {
    switch (this) {
      case ElementCategory.alkaliMetal:        return 'Alkali Metal';
      case ElementCategory.alkalineEarthMetal: return 'Alkaline Earth';
      case ElementCategory.transitionMetal:    return 'Transition Metal';
      case ElementCategory.postTransitionMetal:return 'Post-Transition';
      case ElementCategory.metalloid:          return 'Metalloid';
      case ElementCategory.reactiveNonmetal:   return 'Reactive Nonmetal';
      case ElementCategory.halogen:            return 'Halogen';
      case ElementCategory.nobleGas:           return 'Noble Gas';
      case ElementCategory.lanthanide:         return 'Lanthanide';
      case ElementCategory.actinide:           return 'Actinide';
      case ElementCategory.unknownProperties:  return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case ElementCategory.alkaliMetal:        return AppTheme.catAlkali;
      case ElementCategory.alkalineEarthMetal: return AppTheme.catAlkalineEarth;
      case ElementCategory.transitionMetal:    return AppTheme.catTransition;
      case ElementCategory.postTransitionMetal:return AppTheme.catPostTransition;
      case ElementCategory.metalloid:          return AppTheme.catMetalloid;
      case ElementCategory.reactiveNonmetal:   return AppTheme.catNonmetal;
      case ElementCategory.halogen:            return AppTheme.catHalogen;
      case ElementCategory.nobleGas:           return AppTheme.catNobleGas;
      case ElementCategory.lanthanide:         return AppTheme.catLanthanide;
      case ElementCategory.actinide:           return AppTheme.catActinide;
      case ElementCategory.unknownProperties:  return AppTheme.catUnknown;
    }
  }
}

class ChemElement {
  final int atomicNumber;
  final String symbol;
  final String name;
  final String atomicMass;
  final ElementCategory category;
  final int period;
  final int group;
  final int tableRow;  // visual row in the full grid (rows 1-7 main, 9-10 f-block)
  final int tableCol;  // visual column (1-18)
  final String block;
  final String electronConfig;
  final double? electronegativity;
  final double? meltingPoint;   // °C
  final double? boilingPoint;   // °C
  final double? density;        // g/cm³
  final List<int> oxidationStates;
  final String discoveredBy;
  final String discoveryYear;
  final String phase;
  final String summary;

  const ChemElement({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.atomicMass,
    required this.category,
    required this.period,
    required this.group,
    required this.tableRow,
    required this.tableCol,
    required this.block,
    required this.electronConfig,
    this.electronegativity,
    this.meltingPoint,
    this.boilingPoint,
    this.density,
    required this.oxidationStates,
    required this.discoveredBy,
    required this.discoveryYear,
    required this.phase,
    required this.summary,
  });

  Color get color => category.color;

  String get wikiUrl =>
      'https://en.wikipedia.org/api/rest_v1/page/summary/$name';

  String? get imageUrl {
    // Use Wikipedia's standard element image path
    return 'https://upload.wikimedia.org/wikipedia/commons/thumb/'
        '${_wikiImagePath()}';
  }

  // Fallback: PubChem element structure image
  String get pubchemImageUrl =>
      'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/$name/PNG';

  String _wikiImagePath() => '';  // filled dynamically via API
}
