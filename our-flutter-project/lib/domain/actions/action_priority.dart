const brdActionTriggerPriority = <String>[
  'A10',
  'A9',
  'A8',
  'A7',
  'A6',
  'A5',
  'A4',
  'B9',
  'B8',
  'B7',
  'B6',
  'B5',
  'B4',
  'B3',
  'B1',
  'A3',
  'A2',
  'A1',
  'B2',
  'C1',
  'C2',
  'C3',
  'C4',
  'C5',
  'C6',
  'C7',
  'C8',
  'A11',
  'B10',
];

List<String> orderActionTriggers(Iterable<String> triggers) {
  final remaining = triggers.toSet();
  final ordered = <String>[];

  for (final trigger in brdActionTriggerPriority) {
    if (remaining.remove(trigger)) ordered.add(trigger);
  }

  ordered.addAll(remaining.toList()..sort());
  return ordered;
}
