import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

String formatTimeAgo(String date) {
  final now = DateTime.now();
  final difference = now.difference(DateTime.parse(date));

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
  } else {
    return 'just now';
  }
}

Future<void> storeJoinedCommunitiesId(communitiesList) async {
  if (communitiesList == null) return;
  var dataBox = await Hive.openBox<List<String>>(hiveDataBox);
  List<String> communityIdList = [];
  communitiesList.forEach((element) {
    communityIdList.add(element['_id']);
  });
  dataBox.put(joinedCommunityIdListKey, communityIdList);
}

Future<void> storeJoinedEventsId(eventsList) async {
  if (eventsList == null) return;
  var dataBox = await Hive.openBox<List<String>>(hiveDataBox);
  List<String> eventIdList = [];
  eventsList.forEach((element) {
    eventIdList.add(element['_id']);
  });
  dataBox.put(joinedEventIdListKey, eventIdList);
}
