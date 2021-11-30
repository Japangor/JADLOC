import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'path_service.dart';

/// [PathPathProvider] uses the "path_provider" package to implement the [PathService]
/// It abstracts the utilities exposed by "path_provider" for a simpler API
@LazySingleton(as: PathService)
class PathPathProvider implements PathService {
  @override
  Future<Directory> getDocDir() async {
    return (await getApplicationDocumentsDirectory());
  }

  @override
  Future<Directory> getTempDir() async {
    return (await getTemporaryDirectory());
  }

  @override
  Future<Directory> getExternalDirectory() async {
    final dirs =
        await getExternalStorageDirectories(type: StorageDirectory.documents);

    if (dirs.isEmpty) {
      throw UnsupportedError(
        'Exporting to the external storage is not avaiable on your platform',
      ); // TODO: localize
    }

    return dirs[0];
  }

  @override
  Future checkCacheDir() async {
    if (!Platform.isAndroid || !Platform.isIOS) {
      final directory = await getTemporaryDirectory();

      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }
    }
  }
}
