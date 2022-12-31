import 'package:reminder/model/db/db_interface.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/db/tags.dart';

import 'db_env.dart';

class NotificationsTags implements DBInterface {
  static const idKey = "notification_tag_id";
  static const tagIdKey = Tags.idKey;
  static const notificationIdKey = Notifications.idKey;
  static const createAtKey = DBEnv.createdAtKey;
  static const updatedAtKey = DBEnv.updatedAtKey;
}
