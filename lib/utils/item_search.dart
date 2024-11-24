import 'package:string_similarity/string_similarity.dart';

class ItemSearch {
  final Map<String, String> itemIndex = {};

  ItemSearch(List<String> itemList) {
    for (var item in itemList) {
      itemIndex[item.toLowerCase()] = item;
    }
  }

  String? searchItem(String query, {double similarityThreshold = 0.6}) {
    query = query.toLowerCase();

    if (itemIndex.containsKey(query)) {
      return itemIndex[query];
    }

    String? bestMatch;
    double bestScore = 0.0;

    for (var item in itemIndex.keys) {
      double score = StringSimilarity.compareTwoStrings(query, item);
      if (score > similarityThreshold && score > bestScore) {
        bestMatch = itemIndex[item];
        bestScore = score;
      }
    }

    if (bestMatch != null) {
      return bestMatch.toUpperCase();
    } else {
      return query.toUpperCase();
    }
  }
}
