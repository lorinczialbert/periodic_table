import 'package:flutter/foundation.dart';
import '../models/element.dart';
import '../data/elements.dart';

class AppProvider extends ChangeNotifier {
  // Filter
  ElementCategory? _selectedCategory;
  ElementCategory? get selectedCategory => _selectedCategory;

  // Search
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // All elements
  List<ChemElement> get elements => allElements;

  List<ChemElement> get filteredElements {
    var list = allElements;
    if (_selectedCategory != null) {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) =>
        e.name.toLowerCase().contains(q) ||
        e.symbol.toLowerCase().contains(q) ||
        e.atomicNumber.toString().contains(q)
      ).toList();
    }
    return list;
  }

  void setCategory(ElementCategory? cat) {
    _selectedCategory = _selectedCategory == cat ? null : cat;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }
}
