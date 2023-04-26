import 'dart:convert';

import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/community/Util/util.dart';
import 'package:cura_frontend/features/community/models/allEvents.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../features/conversation/providers/chat_providers.dart';
import 'package:http/http.dart' as http;

import '../features/conversation/providers/conversation_providers.dart';
import '../models/event.dart';
import '../models/member_detail.dart';
import 'constants/variables.dart';

final allCommunitiesProvider = StateProvider<List<Community>>((ref) => []);
final userCommunitiesProvider = StateProvider<List<Community>>((ref) => []);
final communityIdProvider = StateProvider<String>((ref) => "");

final communitiesByCategoryProvider =
    StateProvider<List<Community>>((ref) => []);
final getAllCommunitiesProvider =
    FutureProvider.autoDispose<List<Community>>((ref) async {
  print("getting community list");
  final response = await http
      .get(Uri.parse("$allCommunitiesAPI/${ref.read(userIDProvider)}"));
  print("done");
  // print(response.body);
  final list = json.decode(response.body) as List<dynamic>;
  List<Community> allCommunities =
      List<Community>.from(list.map((obj) => Community.fromJson(obj)).toList());
  print(allCommunities.length);
  ref.read(allCommunitiesProvider.notifier).state = allCommunities;
  return allCommunities;
});

final getUserCommunitiesProvider =
    FutureProvider.autoDispose<List<Community>>((ref) async {
  print(
      "getting user community list ${ref.read(userIDProvider)}  $base_url/$getCommunitiesByUserIdAPI${ref.read(userIDProvider)}");
  final response = await http
      .get(Uri.parse("$getCommunitiesByUserIdAPI/${ref.read(userIDProvider)}"));
  print("done");
  print(response.body);
  if (response.body == '') return [];
  final decodedJson = json.decode(response.body);

  final joinedCommunities = decodedJson['joinedCommunities'] as List<dynamic>;

  await storeJoinedCommunitiesId(joinedCommunities);

  final List<Community> userCommunitiesList = List<Community>.from(
      joinedCommunities.map((obj) => Community.fromJson(obj)).toList());

  print(userCommunitiesList.length);
  ref.read(userCommunitiesProvider.notifier).state = userCommunitiesList;

  return userCommunitiesList;
});
final getCommunityMembersProvider = FutureProvider.autoDispose
    .family<List<MemberDetail>, String>((ref, communityId) async {
  final response =
      await http.get(Uri.parse("$getUsersByCommunityAPI/$communityId"));

  final decodedJson = json.decode(response.body);

  final communitiesMembers = decodedJson['members'] as List<dynamic>;
  print(decodedJson['members']);

  final List<MemberDetail> communityMembersList = List<MemberDetail>.from(
      communitiesMembers.map((obj) => MemberDetail.fromJson(obj)).toList());

  return communityMembersList;
});

final getEventMembersProvider = FutureProvider.autoDispose
    .family<List<MemberDetail>, String>((ref, eventId) async {
  print("$getMembersByEventIdAPI/$eventId");
  final response =
      await http.get(Uri.parse("$getMembersByEventIdAPI/$eventId"));

  final decodedJson = json.decode(response.body);
  print(response.statusCode);
  final communitiesMembers = decodedJson['members'] as List<dynamic>;
  print(decodedJson['members']);

  final List<MemberDetail> eventMembersList = List<MemberDetail>.from(
      communitiesMembers.map((obj) => MemberDetail.fromJson(obj)).toList());

  return eventMembersList;
});

final getCommunitiesByCategoryProvider = FutureProvider.autoDispose
    .family<List<Community>, String>((ref, category) async {
  print("getting community by category list");
  final response =
      await http.get(Uri.parse("$getCommunityByCategoryAPI/$category"));
  print("done");
  print(response.body);
  final list = json.decode(response.body) as List<dynamic>;
  List<Community> allCommunities =
      List<Community>.from(list.map((obj) => Community.fromJson(obj)).toList());

  ref.read(communitiesByCategoryProvider.notifier).state = allCommunities;
  return allCommunities;
});

final getEventsProvider = FutureProvider.autoDispose
    .family<AllEvents, String>((ref, communityId) async {
  print("getting event by community $communityId");
  final response = await http.get(Uri.parse(
      "$getEventsByCommunityIdAPI/$communityId/${ref.read(userIDProvider)}"));
  print(response.body);

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
