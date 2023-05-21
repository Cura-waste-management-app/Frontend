import 'dart:convert';

import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/community/Util/populate_random_data.dart';
import 'package:cura_frontend/features/community/Util/util.dart';
import 'package:cura_frontend/features/community/models/allEvents.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../common/debug_print.dart';
import '../features/conversation/providers/conversation_providers.dart';
import '../models/event.dart';
import '../models/member_detail.dart';

final allCommunitiesProvider = StateProvider<List<Community>>((ref) => []);
// final userCommunitiesProvider =
//     StateProvider<Map<String, Community>>((ref) => {});

class UserCommunitiesProvider extends StateNotifier<Map<String, Community>> {
  UserCommunitiesProvider() : super({});

  void updateCommunities(Community newCommunity) {
    state.remove(newCommunity.id);
    state[newCommunity.id ?? '0'] = newCommunity;
  }

  Community? get(String communityId) {
    return state[communityId];
  }
}

final currentEvent = StateProvider<Event?>((ref) => null);

final userCommunitiesProvider =
    StateNotifierProvider<UserCommunitiesProvider, Map<String, Community>>(
        (ref) => UserCommunitiesProvider());

final communityIdProvider = StateProvider<String>((ref) => "");
final communityProvider = StateProvider<Community?>((ref) => null);

final communitiesByCategoryProvider =
    StateProvider<List<Community>>((ref) => []);
final getAllCommunitiesProvider =
    FutureProvider.autoDispose<List<Community>>((ref) async {
  prints("getting community list");
  final response = await http
      .get(Uri.parse("$allCommunitiesAPI/${ref.read(userIDProvider)}"));
  prints("done");
  // prints(response.body);
  final list = json.decode(response.body) as List<dynamic>;
  List<Community> allCommunities =
      List<Community>.from(list.map((obj) => Community.fromJson(obj)).toList());
  // prints(allCommunities.length);
  ref.read(allCommunitiesProvider.notifier).state = allCommunities;
  return allCommunities;
});

final getUserCommunitiesProvider =
    FutureProvider.autoDispose<String>((ref) async {
  // prints(
  //     "getting user community list ${ref.read(userIDProvider)}  $getCommunitiesByUserIdAPI${ref.read(userIDProvider)}");
  final response = await http
      .get(Uri.parse("$getCommunitiesByUserIdAPI/${ref.read(userIDProvider)}"));
  prints("done");
  if (response.body == '') return "";
  final decodedJson = json.decode(response.body);

  final joinedCommunities = decodedJson['joinedCommunities'] as List<dynamic>;

  await storeJoinedCommunitiesId(joinedCommunities);

  final List<Community> userCommunitiesList = List<Community>.from(
      joinedCommunities.map((obj) => Community.fromJson(obj)).toList());

  // prints(userCommunitiesList.length);
  for (var element in userCommunitiesList) {
    ref.read(userCommunitiesProvider.notifier).state[element.id ?? '0'] =
        element;
  }

  return "done";
});
final getCommunityMembersProvider = FutureProvider.autoDispose
    .family<List<MemberDetail>, String>((ref, communityId) async {
  final response =
      await http.get(Uri.parse("$getUsersByCommunityAPI/$communityId"));

  final decodedJson = json.decode(response.body);

  final communitiesMembers = decodedJson['members'] as List<dynamic>;
  // prints(decodedJson['members']);

  final List<MemberDetail> communityMembersList = List<MemberDetail>.from(
      communitiesMembers.map((obj) => MemberDetail.fromJson(obj)).toList());

  return communityMembersList;
});

final getEventMembersProvider = FutureProvider.autoDispose
    .family<List<MemberDetail>, String>((ref, eventId) async {
  // prints("$getMembersByEventIdAPI/$eventId");
  final response =
      await http.get(Uri.parse("$getMembersByEventIdAPI/$eventId"));

  final decodedJson = json.decode(response.body);
  // prints(response.statusCode);
  final communitiesMembers = decodedJson['members'] as List<dynamic>;
  // prints(decodedJson['members']);

  final List<MemberDetail> eventMembersList = List<MemberDetail>.from(
      communitiesMembers.map((obj) => MemberDetail.fromJson(obj)).toList());

  return eventMembersList;
});

final getCommunitiesByCategoryProvider = FutureProvider.autoDispose
    .family<List<Community>, String>((ref, category) async {
  prints("getting community by category list");
  final response =
      await http.get(Uri.parse("$getCommunityByCategoryAPI/$category"));
  prints("done");
  // prints(response.body);
  final list = json.decode(response.body) as List<dynamic>;
  List<Community> allCommunities =
      List<Community>.from(list.map((obj) => Community.fromJson(obj)).toList());

  ref.read(communitiesByCategoryProvider.notifier).state = allCommunities;
  return allCommunities;
});

final getEventsProvider = FutureProvider.autoDispose
    .family<AllEvents, String>((ref, communityId) async {
  prints("getting event by community $communityId");
  final response = await http.get(Uri.parse(
      "$getEventsByCommunityIdAPI/$communityId/${ref.read(userIDProvider)}"));

  // if (response.statusCode == 201) {
  final data = jsonDecode(response.body);
  final List<Event> myEvents = (data['myevents'] as List)
      .map((event) => Event.fromJsonWithAdmin(event))
      .toList();
  storeJoinedEventsId(data['myevents'] as List);

  final List<Event> exploreEvents = (data['explore'] as List)
      .map((event) => Event.fromJsonWithAdmin(event))
      .toList();
  return AllEvents(explore: exploreEvents, myEvents: myEvents);
  // Use the exploreList and myEventsList as required
  // } else {
  //   throw Exception('Failed to load events');
  // }
});
