import 'dart:convert';

import 'package:cura_frontend/features/community/models/allEvents.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/conversation/providers/chat_providers.dart';
import 'package:http/http.dart' as http;

import '../models/event.dart';

final allCommunitiesProvider = StateProvider<List<Community>>((ref) => []);
final userCommunitiesProvider = StateProvider<List<Community>>((ref) => []);
final communityIdProvider = StateProvider<String>((ref) => "");

final communitiesByCategoryProvider =
    StateProvider<List<Community>>((ref) => []);
final getAllCommunitiesProvider =
    FutureProvider.autoDispose<List<Community>>((ref) async {
  print("getting community list");
  final response = await http.get(
      Uri.parse("${ref.read(localHttpIpProvider)}community/allcommunities"));
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
  print("getting user community list");
  final response = await http.get(Uri.parse(
      "${ref.read(localHttpIpProvider)}community/getcommunitybyid/${ref.read(userIDProvider)}"));
  print("done");
  // print(response.body);
  final decodedJson = json.decode(response.body);
  final joinedCommunities = decodedJson['joinedCommunities'] as List<dynamic>;
  final List<Community> userCommunitiesList = List<Community>.from(
      joinedCommunities.map((obj) => Community.fromJson(obj)).toList());
  print(userCommunitiesList.length);
  ref.read(userCommunitiesProvider.notifier).state = userCommunitiesList;

  return userCommunitiesList;
});

final getCommunitiesByCategoryProvider = FutureProvider.autoDispose
    .family<List<Community>, String>((ref, category) async {
  print("getting community by category list");
  final response = await http.get(Uri.parse(
      "${ref.read(localHttpIpProvider)}community/getcommunitybycategory/$category"));
  print("done");
  print(response.body);
  final list = json.decode(response.body) as List<dynamic>;
  List<Community> allCommunities =
      List<Community>.from(list.map((obj) => Community.fromJson(obj)).toList());
  print(allCommunities.length);
  ref.read(communitiesByCategoryProvider.notifier).state = allCommunities;
  return allCommunities;
});
final getEventsProvider = FutureProvider.autoDispose
    .family<AllEvents, String>((ref, communityId) async {
  print("getting event by category list");
  final response = await http.get(Uri.parse(
      "${ref.read(localHttpIpProvider)}events/geteventsbycommunityid/${communityId}/${ref.read(userIDProvider)}"));
  print("done");
  // print(response.body);
  // if (response.statusCode == 201) {
  final data = jsonDecode(response.body);
  final List<Event> myEvents =
      (data['myevents'] as List).map((event) => Event.fromJson(event)).toList();
  final List<Event> exploreEvents =
      (data['explore'] as List).map((event) => Event.fromJson(event)).toList();
  return AllEvents(explore: exploreEvents, myEvents: myEvents);
  // Use the exploreList and myEventsList as required
  // } else {
  //   throw Exception('Failed to load events');
  // }
});
