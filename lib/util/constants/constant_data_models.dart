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
    CommunityTypeModel(type: 'Food', icon: Icons.restaurant),
    CommunityTypeModel(type: 'Cloth', icon: Icons.checkroom),
    CommunityTypeModel(type: 'Furniture', icon: Icons.chair_outlined),
    CommunityTypeModel(type: 'Other', icon: Icons.more_outlined)
  ];

  static List<Event> eventList = [
    Event(
      id: '1',
      name: 'Event 1',
      description: 'Lorem ipsum dolor sit amet',
      adminId: 'admin1',
      totalMembers: '10',
      communityID: 'community1',
      timestamp: '2 days ago',
      location: '123 Main St, Anytown, USA',
    ),
    Event(
      id: '2',
      name: 'Event 2',
      description: 'Lorem ipsum dolor sit amet',
      adminId: 'admin2',
      totalMembers: '5',
      communityID: 'community2',
      timestamp: '5 days ago',
      location: '456 Elm St, Anytown, USA',
    ),
    Event(
      id: '3',
      name: 'Event 3',
      description: 'Lorem ipsum dolor sit amet',
      adminId: 'admin3',
      totalMembers: '8',
      communityID: 'community3',
      timestamp: '1 week ago',
      location: '789 Oak St, Anytown, USA',
    ),
    Event(
      id: '4',
      name: 'Event 4',
      description: 'Lorem ipsum dolor sit amet',
      adminId: 'admin4',
      totalMembers: '12',
      communityID: 'community4',
      timestamp: '3 weeks ago',
      location: '1011 Pine St, Anytown, USA',
    ),
    Event(
      id: '5',
      name: 'Event 5',
      description: 'Lorem ipsum dolor sit amet',
      adminId: 'admin5',
      totalMembers: '6',
      communityID: 'community5',
      timestamp: '1 month ago',
      location: '1213 Cedar St, Anytown, USA',
    ),
  ];
}
