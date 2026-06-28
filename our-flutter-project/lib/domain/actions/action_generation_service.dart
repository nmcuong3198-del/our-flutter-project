import 'action_catalog.dart';
import 'action_priority.dart';

const practiceCategories = <String>['quan_sat', 'giao_tiep', 'ho_tro'];

class ActionGenerationService {
  const ActionGenerationService();

  List<ActionCatalogItem> selectMonthlyActions({
    required Iterable<String> selectedTriggers,
    required Iterable<ActionCatalogItem> catalog,
    Iterable<String> recentlyUsedCatalogCodes = const [],
  }) {
    final orderedTriggers = orderActionTriggers(selectedTriggers);
    if (orderedTriggers.isEmpty) return const [];

    final catalogItems = catalog.toList()
      ..sort((a, b) {
        final categoryCompare = _categoryRank(
          a.category,
        ).compareTo(_categoryRank(b.category));
        if (categoryCompare != 0) return categoryCompare;
        final slotCompare = a.slot.compareTo(b.slot);
        if (slotCompare != 0) return slotCompare;
        final sortCompare = a.sortOrder.compareTo(b.sortOrder);
        if (sortCompare != 0) return sortCompare;
        return a.code.compareTo(b.code);
      });
    final usedCodes = recentlyUsedCatalogCodes.toSet();
    final selected = <ActionCatalogItem>[];

    for (final category in practiceCategories) {
      ActionCatalogItem? match;
      for (final trigger in orderedTriggers) {
        for (final item in catalogItems) {
          if (item.category != category) continue;
          if (!item.triggers.contains(trigger)) continue;
          if (usedCodes.contains(item.code)) continue;
          match = item;
          break;
        }
        if (match != null) break;
      }
      if (match != null) {
        selected.add(match);
        usedCodes.add(match.code);
      }
    }

    return selected;
  }

  int _categoryRank(String category) {
    final index = practiceCategories.indexOf(category);
    return index == -1 ? practiceCategories.length : index;
  }
}
