import 'package:flutter/material.dart';
import './community_type.dart';

class CommunityDataModels {
  static List<CommunityType> communityTypeList = [
    CommunityType(type: 'Food', icon: Icons.restaurant),
    CommunityType(type: 'Cloth', icon: Icons.checkroom),
    CommunityType(type: 'Furniture', icon: Icons.chair_outlined),
    CommunityType(type: 'Other', icon: Icons.more_outlined)
  ];
}
