import 'dart:convert';
import 'dart:io';

bool byr(String x) {
  var asInt = int.parse(x);
  return asInt >= 1920 && asInt <= 2002;
}

bool iyr(String x) {
  var asInt = int.parse(x);
  return asInt >= 2010 && asInt <= 2020;
}

bool eyr(String x) {
  var asInt = int.parse(x);
  return asInt >= 2020 && asInt <= 2030;
}

bool hgt(String x) {
  late var cmMatch = RegExp(r'(\d{3})cm').firstMatch(x)?.group(1);
  late var inMatch = RegExp(r'(\d{2})in').firstMatch(x)?.group(1);

  if (cmMatch != null) {
    var cms = int.parse(cmMatch);
    return cms >= 150 && cms <= 193;
  }

  if (inMatch != null) {
    var inches = int.parse(inMatch);
    return inches >= 59 && inches <= 76;
  }

  return false;
}

bool ecl(String x) {
  return Set.from({'amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'})
      .contains(x);
}

bool hcl(String x) {
  return RegExp(r'#[0-9a-f]{6}').hasMatch(x);
}

bool pid(String x) {
  return RegExp(r'[0-9]{9}').hasMatch(x);
}

var passportValidation = {
  'byr': byr,
  'iyr': iyr,
  'eyr': eyr,
  'hgt': hgt,
  'hcl': hcl,
  'ecl': ecl,
  'pid': pid,
  'cid': (_) => true,
};

const MANDATORY_FIELDS = {
  'byr',
  'iyr',
  'eyr',
  'hgt',
  'hcl',
  'ecl',
  'pid',
};

void main(List<String> arguments) async {
  var result = 0;
  var passport = [];
  await File('../input.txt')
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .forEach((line) {
    passport.add(line);

    if (line == '') {
      var pairs = passport.join(' ').trim().split(' ');
      var attributes = {
        for (var attrPair in pairs.map((e) => e.split(':')))
          attrPair[0]: attrPair[1]
      };

      if (Set.from(attributes.keys).containsAll(MANDATORY_FIELDS) &&
          attributes.entries
              .every((entry) => passportValidation[entry.key]!(entry.value))) {
        result++;
      }

      passport = [];
    }
  });
  print(result);
}
