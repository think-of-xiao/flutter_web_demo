import 'package:logger/logger.dart';

class LogUtil {
  static final LogUtil _singleton = LogUtil._internal();
  late Logger _logger;

  factory LogUtil() {
    return _singleton;
  }

  LogUtil._internal() {
    _logger = Logger(
      printer: PrettyPrinter(),
      filter: DevelopmentFilter(),
    );
  }

  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }
}
