import 'package:reminder/model/db/db_interface.dart';

import 'db_env.dart';

class Tags implements DBInterface {
  static const idKey = "tag_id";
  static const tagKey = "tag";
  static const createdAtKey = DBEnv.createdAtKey;
  static const updatedAtKey = DBEnv.updatedAtKey;
}
