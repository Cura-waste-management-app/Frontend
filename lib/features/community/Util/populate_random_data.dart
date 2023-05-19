import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/models/event.dart';

class PopulateRandomData {
  static Community community = Community(
      imgURL: '',
      description: '',
      adminId: '',
      category: 'Food',
      name: '',
      location: '',
      totalMembers: '');
  static Event event = Event(
      name: '',
      description: '',
      adminId: '',
      communityId: '',
      postTime: '',
      imgURL: '',
      location: '');
}
