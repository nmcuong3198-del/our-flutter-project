import '../../core/strings.dart';

class CheckinCodeSelection {
  final String code;
  final String type;
  final String label;

  const CheckinCodeSelection({
    required this.code,
    required this.type,
    required this.label,
  });
}

class CheckinCodeMapper {
  const CheckinCodeMapper._();

  static List<CheckinCodeSelection> selectionsFor({
    Iterable<String> emotions = const [],
    String? bodyStatus,
    Iterable<String> symptoms = const [],
    Iterable<String> influences = const [],
  }) {
    final selections = <String, CheckinCodeSelection>{};

    void add(String? code, String type, String label) {
      if (code == null) return;
      selections.putIfAbsent(
        code,
        () => CheckinCodeSelection(code: code, type: type, label: label),
      );
    }

    for (final label in emotions) {
      add(_emotionCodes[label], 'emotion', label);
    }
    if (bodyStatus != null) {
      add(_bodyCodes[bodyStatus], 'body', bodyStatus);
    }
    for (final label in symptoms) {
      add(_symptomCodes[label], _symptomTypes[label] ?? 'body', label);
    }
    for (final label in influences) {
      add(_influenceCodes[label], 'influence', label);
    }

    return selections.values.toList()..sort((a, b) => a.code.compareTo(b.code));
  }

  static Set<String> codesFor({
    Iterable<String> emotions = const [],
    String? bodyStatus,
    Iterable<String> symptoms = const [],
    Iterable<String> influences = const [],
  }) {
    return selectionsFor(
      emotions: emotions,
      bodyStatus: bodyStatus,
      symptoms: symptoms,
      influences: influences,
    ).map((selection) => selection.code).toSet();
  }

  static const _emotionCodes = <String, String>{
    'Vui vẻ': 'A1',
    S.emotionHappy: 'A1',
    'Phấn khích': 'A2',
    S.emotionNormal: 'A3',
    'Mệt': 'A4',
    S.emotionTired: 'A4',
    S.emotionSad: 'A5',
    S.emotionWorried: 'A6',
    'Áp lực': 'A7',
    S.emotionAngry: 'A8',
    'Cô đơn': 'A9',
    'Kiệt sức': 'A10',
    S.emotionSluggish: 'A10',
    S.emotionOther: 'A11',
  };

  static const _bodyCodes = <String, String>{
    S.bodyInPeriod: 'B1',
    S.bodyNone: 'B2',
    S.bodyNotInPeriod: 'B2',
    S.bodyDischarge: 'B10',
    S.bodyNocturnal: 'B10',
    S.bodyTension: 'B10',
    S.bodyPuberty: 'B10',
  };

  static const _symptomCodes = <String, String>{
    S.symptomHealthy: 'B2',
    S.symptomTired: 'A4',
    S.symptomHeadache: 'B3',
    S.symptomStomach: 'B4',
    S.symptomBack: 'B5',
    S.symptomNausea: 'B6',
    S.symptomDizzy: 'B7',
    S.symptomAcne: 'B8',
    S.symptomIrritable: 'B9',
    S.symptomOther: 'B10',
  };

  static const _symptomTypes = <String, String>{S.symptomTired: 'emotion'};

  static const _influenceCodes = <String, String>{
    'Học tập': 'C1',
    'Bạn bè': 'C2',
    'Gia đình': 'C3',
    'Mạng xã hội': 'C4',
    'Thầy cô': 'C5',
    'Giải trí/Game': 'C6',
    'Sức khoẻ': 'C7',
    'Khác': 'C8',
  };
}
