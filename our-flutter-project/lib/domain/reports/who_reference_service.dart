import '../../models/models.dart';
import 'report_models.dart';

class WhoReferenceService {
  const WhoReferenceService();

  static const boys = <int, WhoReference>{
    5: WhoReference(age: 5, height: 110, weight: 18, bmi: 15.3),
    6: WhoReference(age: 6, height: 115, weight: 20, bmi: 15.3),
    7: WhoReference(age: 7, height: 121, weight: 23, bmi: 15.5),
    8: WhoReference(age: 8, height: 127, weight: 26, bmi: 15.7),
    9: WhoReference(age: 9, height: 133, weight: 29, bmi: 16.0),
    10: WhoReference(age: 10, height: 138, weight: 32, bmi: 16.4),
    11: WhoReference(age: 11, height: 144, weight: 37, bmi: 16.9),
    12: WhoReference(age: 12, height: 151, weight: 41, bmi: 17.5),
    13: WhoReference(age: 13, height: 157, weight: 46, bmi: 18.2),
    14: WhoReference(age: 14, height: 163, weight: 49, bmi: 19.0),
    15: WhoReference(age: 15, height: 169, weight: 55, bmi: 19.8),
    16: WhoReference(age: 16, height: 173, weight: 60, bmi: 20.5),
    17: WhoReference(age: 17, height: 175, weight: 64, bmi: 21.1),
    18: WhoReference(age: 18, height: 176, weight: 67, bmi: 21.7),
  };

  static const girls = <int, WhoReference>{
    5: WhoReference(age: 5, height: 111, weight: 18, bmi: 15.2),
    6: WhoReference(age: 6, height: 115, weight: 20, bmi: 15.3),
    7: WhoReference(age: 7, height: 121, weight: 23, bmi: 15.4),
    8: WhoReference(age: 8, height: 127, weight: 26, bmi: 15.7),
    9: WhoReference(age: 9, height: 133, weight: 29, bmi: 16.1),
    10: WhoReference(age: 10, height: 138, weight: 32, bmi: 16.6),
    11: WhoReference(age: 11, height: 145, weight: 36, bmi: 17.2),
    12: WhoReference(age: 12, height: 154, weight: 41, bmi: 18.0),
    13: WhoReference(age: 13, height: 156, weight: 45, bmi: 18.8),
    14: WhoReference(age: 14, height: 160, weight: 50, bmi: 19.6),
    15: WhoReference(age: 15, height: 161, weight: 53, bmi: 20.2),
    16: WhoReference(age: 16, height: 162, weight: 55, bmi: 20.7),
    17: WhoReference(age: 17, height: 163, weight: 56, bmi: 21.0),
    18: WhoReference(age: 18, height: 163, weight: 57, bmi: 21.3),
  };

  WhoReference? referenceFor(ChildProfile child, {DateTime? atDate}) {
    final age = _ageAt(child.dateOfBirth, atDate ?? DateTime.now());
    return (child.isFemale ? girls : boys)[age];
  }

  int _ageAt(DateTime dob, DateTime atDate) {
    var age = atDate.year - dob.year;
    if (atDate.month < dob.month ||
        (atDate.month == dob.month && atDate.day < dob.day)) {
      age--;
    }
    return age;
  }
}
