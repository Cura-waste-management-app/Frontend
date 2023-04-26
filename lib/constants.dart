import 'package:cura_frontend/providers/constants/variables.dart';
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
const unableToConnectToServer = 'Unable to connect to the server';

const defaultAssetImage = 'assets/images/male_user.png';
const defaultNetworkImage =
    'https://res.cloudinary.com/dmnvphmdi/image/upload/v1677324023/xubvbo8auabzzw4hvrcz.jpg';

const getConversationPartnersAPI =
    "$base_url/userChats/get-conversation-partners";
const addConversationPartnersAPI = "userChats/add-conversation-partners/";
const leaveCommunityAPI = '$base_url/community/leavecommunity';
const allCommunitiesAPI = '$base_url/community/allcommunities';

const getCommunityByIdAPI = '$base_url/community/getcommunitybyid';
const getUsersByCommunityAPI = '$base_url/community/getusersbycommunity';
const getCommunitiesByUserIdAPI = '$base_url/community/getcommunitybyuserid';
const joinCommunityAPI = '$base_url/community/joincommunity';
const deleteCommunityAPI = '$base_url/community/deletecommunity';
const createCommunityAPI = '$base_url/community/createcommunity';
const updateCommunityAPI = '$base_url/community/updatecommunity';
const getCommunityByCategoryAPI = '$base_url/community/getcommunitybycategory';
const checkIfMemberOfCommunityAPI = '$base_url/community/checkifthememberexist';
const checkIfCommunityNameExistAPI = '$base_url/community/checkCommunityName';

const getMembersByEventIdAPI = '$base_url/events/getmembersbyeventid';
const leaveEventAPI = '$base_url/events/leaveevent';
const joinEventAPI = '$base_url/events/joinevent';
const deleteEventAPI = '$base_url/events/deleteevent';
const createEventAPI = '$base_url/events/createevent';
const updateEventAPI = '$base_url/events/updateevent';
const checkIfEventNameExistAPI = '$base_url/events/checkEventName';
const checkIfMemberOfEventAPI = '$base_url/events/checkifthememberexist';
const getEventByIdAPI = '$base_url/events/geteventbyid';
const getEventsByCommunityIdAPI = '$base_url/events/geteventsbycommunityid';

const addUserMessageAPI = '$base_url/userChats/addMessage';
const getUserChatsAPI = '$base_url/userChats';

const localSocketIp = 'ws://$serverIp/';

const fetchUserAPI = '$base_url/user/fetch';
