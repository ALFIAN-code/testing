String formatReadableDate(DateTime? date) {

  if (date == null) return '-';

  final DateTime now = DateTime.now();
  final DateTime localDate = date.toLocal();
  final Duration difference = now.difference(localDate);

  if (difference.inSeconds < 60) {
    return 'beberapa detik lalu';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} menit lalu';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} jam lalu';
  } else {
    return '${difference.inDays} hari lalu';
  }
}
