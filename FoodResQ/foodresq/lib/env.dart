import 'package:meta/meta.dart';

enum BuildFlavor { production, local, staging }

String get backendServer =>
    _env != null ? _env!.flavor.toString().split('.').last : 'Unknown';
BuildEnvironment? get env => _env;
BuildEnvironment? _env;

class BuildEnvironment {
  /// The backend server.
  final String baseUrl;
  final BuildFlavor flavor;

  BuildEnvironment._init({required this.flavor, required this.baseUrl});

  /// Sets up the top-level [env] getter on the first call only.
  static void init({@required flavor, @required baseUrl}) =>
      _env ??= BuildEnvironment._init(flavor: flavor, baseUrl: baseUrl);
}
