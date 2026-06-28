class ActionCatalogItem {
  final String code;
  final Set<String> triggers;
  final String content;
  final String category;
  final int slot;
  final String? gender;
  final int? minAge;
  final int? maxAge;
  final int sortOrder;

  const ActionCatalogItem({
    required this.code,
    required this.triggers,
    required this.content,
    required this.category,
    this.slot = 1,
    this.gender,
    this.minAge,
    this.maxAge,
    this.sortOrder = 0,
  });
}
