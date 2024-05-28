class AlfabetKeywordsBuilder {
  List<String> keywords = [];

  AlfabetKeywordsBuilder add(String? keyword) {
    if (keyword != null) {
      // ignore: parameter_assignments
      keyword =
          keyword.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9\s,]'), '');
      keywords.add(keyword);
    }
    // ignore: avoid_returning_this
    return this;
  }

  AlfabetKeywordsBuilder addAll(List<String?> keywordsList) {
    for (final keyword in keywordsList) {
      add(keyword);
    }
    // ignore: avoid_returning_this
    return this;
  }

  AlfabetKeywordsBuilder descriptionToKeywords(String description) {
    // Split the description into words
    final words = description.split(' ');

    // Remove verbs from the list of words
    keywords.addAll(
      words
          .where(
            (word) =>
                !_verbList.contains(word.replaceAll(' ', '').toLowerCase()),
          )
          .toList(),
    );

    // Return the instance of AlfabetKeywordsBuilder
    // ignore: avoid_returning_this
    return this;
  }

  AlfabetKeywordsBuilder addTogether(List<String?> keywordsList) {
    var keyword = '';
    for (final element in keywordsList) {
      if (element != null) {
        keyword = keyword + element;
      }
    }
    add(keyword);

    // ignore: avoid_returning_this
    return this;
  }

  AlfabetKeywordsBuilder addSplit(String? input, String separator) {
    if (input != null) {
      addAll(
        input
            .split(separator)
            .map((word) => word.trim())
            .where((word) => word.isNotEmpty)
            .toList(), // Convert to List<String?>
      );
    }
    // ignore: avoid_returning_this
    return this;
  }

  List<String> build() {
    // Customize additional build logic if needed
    return keywords
        .map(
          (e) => e
              .replaceAll(RegExp(r'[^a-zA-Z0-9\s,]'), '')
              // ignore: unnecessary_raw_strings
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
              .replaceAll(' ', '')
              .toLowerCase(),
        )
        .where((e) => e.isNotEmpty && e != 'null')
        .toSet()
        .toList();
  }

  final _verbList = <String>[
    'no',
    'time',
    'pass',
    'pls',
    'need',
    'money',
    'a',
    'i',
    'am',
    'is',
    'are',
    'was',
    'were',
    'being',
    'been',
    'have',
    'has',
    'had',
    'did',
    'do',
    'does',
    'shall',
    'will',
    'should',
    'would',
    'may',
    'might',
    'can',
    'could',
    'must',
    'ought',
    'to',
    'used',
    'for',
    'in',
    'up',
    'size',
    'on',
    'of',
    'at',
    'and',
    '&',
    'by',
    'be',
    'with',
    'from',
    'about',
    'under',
    'over',
    'above',
    'below',
    'through',
    'during',
    'after',
    'before',
    'between',
    'among',
    'beside',
    'around',
    'against',
    'across',
    'along',
    'toward',
    'within',
    'without',
    'beside',
    'beyond',
    'inside',
    'outside',
    'near',
    'far',
    'behind',
    'in front of',
    'through',
    'into',
    'alongside',
    'amid',
    'among',
    'amidst',
    'atop',
    'beneath',
    'betwixt',
    'beyond',
    'by means of',
    'down',
    'inside of',
    'onto',
    'out of',
    'outside of',
    'throughout',
    'underneath',
    'unto',
    'upon',
    'within',
    'across from',
    'ahead of',
    'apart from',
    'aside from',
    'away from',
    'back to',
    'because of',
    'close to',
    'due to',
    'far from',
    'inside',
    'instead of',
    'near to',
    'next to',
    'on behalf of',
    'on top of',
    'opposite to',
    'outside',
    'prior to',
    'regardless of',
    'thanks to',
    'to the detriment of',
    'to the advantage of',
    'to the east of',
    'to the left of',
    'to the right of',
    'to the south of',
    'to the west of',
    'together with',
    'up to',
    'with regard to',
    'with respect to',
    'worth of',
    'in addition to',
    'in front of',
    'in lieu of',
    'in place of',
    'in spite of',
    'in view of',
    'on account of',
    'on top of',
    'out from',
    'out of',
    'over to',
    'owing to',
    'prior to',
    'subsequent to',
    'up against',
    'up until',
    'upstairs from',
    'alongside of',
    'opposite of',
    'up above',
    'down below',
    'away across',
    'in between',
    'out between',
    'outside between',
    'inside between',
    'over between',
    'under between',
    'within between',
    'between',
    'made',
    'rs',
    'mrp',
    'New',
    'what',
    'an',
    'of',
    'more',
    'he',
    'than',
    'or',
  ];
}

List<String> keywordsBuilder(String caseNumber) {
  List<String> caseSearchList = <String>[];
  String temp = "";

  List<String> nameSplits = caseNumber.split(" ");
  for (int i = 0; i < nameSplits.length; i++) {
    String name = "";

    for (int k = i; k < nameSplits.length; k++) {
      name = "$name${nameSplits[k]} ";
    }
    temp = "";

    for (int j = 0; j < name.length; j++) {
      temp = temp + name[j];
      caseSearchList.add(temp.toLowerCase().replaceAll(" ", ""));
    }
  }
  return caseSearchList.toSet().toList();
}
