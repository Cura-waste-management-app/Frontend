import 'package:flutter/material.dart';

import '../../features/community/models/community_type_model.dart';
import '../../models/community_list.dart';

class ConstantDataModels {
  static List<CommunityList> communityList = [
    CommunityList(
        communityName: 'ChandigarhNGO',
        communityLocation: 'Chandigarh',
        numberOfMembers: '25'),
    CommunityList(
        communityName: 'DelhiNGO',
        communityLocation: 'Delhi',
        numberOfMembers: '47'),
    CommunityList(
        communityName: 'FoodSaver',
        communityLocation: 'Agra',
        numberOfMembers: '32'),
    CommunityList(
        communityName: 'ChandigarhNGO',
        communityLocation: 'Chandiagrh',
        numberOfMembers: '25'),
    CommunityList(
        communityName: 'DelhiNGO',
        communityLocation: 'Delhi',
        numberOfMembers: '47')
  ];
  static List<CommunityTypeModel> communityTypeList = [
    CommunityTypeModel(type: 'Food', icon: Icons.restaurant),
    CommunityTypeModel(type: 'Cloth', icon: Icons.checkroom),
    CommunityTypeModel(type: 'Furniture', icon: Icons.chair_outlined),
    CommunityTypeModel(type: 'Other', icon: Icons.more_outlined)
  ];
}
