import 'package:cura_frontend/models/community_type_widget.dart';
import 'package:flutter/material.dart';

import '../../features/community/models/community_type_model.dart';
import '../../models/community.dart';
import '../../models/event.dart';

class ConstantDataModels {
  static List<Community> communityList = [
    Community(
        name: 'ChandigarhNGO',
        location: 'Chandigarh',
        totalMembers: '25',
        description: "helpful community",
        adminId: '1',
        category: "food",
        id: "123",
        imgURL: "assets/images/female_user.png"),
    Community(
        name: 'DelhiNGO',
        location: 'Delhi',
        totalMembers: '47',
        description: "helpful community",
        adminId: '1',
        id: "123",
        category: "food",
        imgURL: "assets/images/female_user.png"),
    Community(
        name: 'FoodSaver',
        location: 'Agra',
        totalMembers: '32',
        description: "helpful community",
        adminId: '1',
        id: "123",
        category: "food",
        imgURL: "assets/images/female_user.png"),
    Community(
        name: 'ChandigarhNGO',
        location: 'Chandiagrh',
        totalMembers: '25',
        description: "helpful community",
        adminId: '1',
        category: "food",
        id: "123",
        imgURL: "assets/images/female_user.png"),
    Community(
        name: 'DelhiNGO',
        location: 'Delhi',
        totalMembers: '47',
        description: "helpful community",
        adminId: '1',
        category: "food",
        id: "123",
        imgURL: "assets/images/female_user.png")
  ];
  static List<CommunityTypeModel> communityTypeList = [
    CommunityTypeModel(type: CommunityType.food, icon: Icons.restaurant),
    CommunityTypeModel(type: CommunityType.cloth, icon: Icons.checkroom),
    CommunityTypeModel(
        type: CommunityType.furniture, icon: Icons.chair_outlined),
    CommunityTypeModel(type: CommunityType.other, icon: Icons.more_outlined)
  ];

  static List<Event> eventList = [];
}
