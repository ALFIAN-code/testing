class AppUtil {
  AppUtil._();

  static bool isNetworkImage(String path) => !(path.contains('/storage/emulated') || path.startsWith('file://') || path.contains('com.regijaya.wms'));
  static String toPascalCase(String input) => input
        .split(' ')
        .map((String word) => word.isEmpty
        ? ''
        : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');


}

