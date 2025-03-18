String getPostposition(String word) {
  if (word.isEmpty) return word; // 빈 문자열 처리

  final lastChar = word.runes.last; // 마지막 글자의 유니코드
  final hasFinalConsonant = (lastChar - 0xAC00) % 28 != 0; // 종성 유무 확인

  return word + (hasFinalConsonant ? "이" : "가");
}

String getObjectMarker(String word) {
  if (word.isEmpty) return word; // 빈 문자열 처리

  final lastChar = word.runes.last; // 마지막 글자의 유니코드
  final hasFinalConsonant = (lastChar - 0xAC00) % 28 != 0; // 종성 유무 확인

  return word + (hasFinalConsonant ? "을" : "를");
}
