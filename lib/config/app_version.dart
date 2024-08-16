class AppVersion {
  static const String version = '0.8.1';
  static final String buildDate = _getBuildDate();

  static String _getBuildDate() {
    return '${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
  }

  static String getFullVersion() {
    return 'в. $version ($buildDate)';
  }
}
