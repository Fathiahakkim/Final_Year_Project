class ObdCache {
  static Map<String, dynamic>? latestObd;

  static void set(Map<String, dynamic> data) {
    latestObd = data;
  }

  static void clear() {
    latestObd = null;
  }
}
