import 'package:cura_frontend/server_ip.dart';
import 'package:flutter/material.dart';

const kSecondaryColor = Color(0xFF8B94BC);
const kGreenColor = Color(0xFF2b4743);
const kLightGreenColor = Color(0xFF48726c);
const ktextHeadingColor = Color(0xFF76cbbf);
const kRedColor = Color(0xFFE92E30);
const kYellowColor = Color(0xFFdda23f);
const kGrayColor = Color(0xFFC1C1C1);
const kBlackColor = Color(0xFF101010);
const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF740001), Color(0xFFD3A625)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double kDefaultPadding = 20.0;

const hiveChatBox = 'chat';
const hiveDataBox = 'dataBox';
const joinedCommunityIdListKey = 'joinedCommunityIdList';
const joinedEventIdListKey = 'joinedEventIdList';
const imageUploadErrorText = 'Unable to upload image to the server';
const imageLoadError = 'Unable to fetch image from the server';
const noCommunityExist = 'Oops no Community Exist. Why not starts with you';
const noNewEvents = 'No new events';
const noJoinedEvents = 'No joined events';

const defaultAssetImage = 'assets/images/male_user.png';
const defaultNetworkImage =
    'https://res.cloudinary.com/dmnvphmdi/image/upload/v1677324023/xubvbo8auabzzw4hvrcz.jpg';

const getConversationPartnersAPI = "get-conversation-partners";
const addConversationPartnersAPI = "add-conversation-partners";
const leaveCommunityAPI = 'community/leavecommunity/';
const allCommunitiesAPI = 'community/allcommunities';

const getCommunityById = 'community/getcommunitybyid/';
const getUsersByCommunity = 'community/getusersbycommunity/';
const getCommunitiesByUserId = 'community/getcommunitybyuserid/';
const joinCommunityAPI = 'community/joincommunity/';
const deleteCommunityAPI = 'community/deletecommunity/';
const getCommunityByCategory = 'community/getcommunitybycategory';
const checkIfMemberOfCommunity = 'community/checkifthememberexist';
const checkIfCommunityNameExistAPI =
    'http://$serverIp/community/checkCommunityName';

const getMembersByEventId = 'events/getmembersbyeventid/';
const leaveEventAPI = 'events/leaveevent/';
const joinEventAPI = 'events/joinevent/';
const deleteEventAPI = 'events/deleteevent/';
const checkIfEventNameExistAPI = 'events/checkEventName';
const checkIfMemberOfEvent = 'events/checkifthememberexist';
const getEventById = 'events/geteventbyid/';
