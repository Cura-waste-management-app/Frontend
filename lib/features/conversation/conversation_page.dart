import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/conversation/components/conversation_app_bar.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:cura_frontend/models/chat_message.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:cura_frontend/models/event.dart';
import 'package:cura_frontend/models/user_conversation.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/screens/other_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pd;
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../../providers/constants/variables.dart';
import '../community/community_detail_page.dart';
import '../community/event_detail_page.dart';
import '../profile/screens/view_profile.dart';
import 'components/message_widget.dart';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ConversationPage extends ConsumerStatefulWidget {
  final String imageURL;
  final String chatRecipientName;
  final String receiverID;
  final Event? event;
  final Community? community; //refactor it
  const ConversationPage(
      {super.key,
      required this.imageURL,
      required this.chatRecipientName,
      required this.receiverID,
      this.event,
      this.community});

  @override
  // ignore: library_private_types_in_public_api
  _ConversationPageState createState() => _ConversationPageState();
}

//todo get user details from id
class _ConversationPageState extends ConsumerState<ConversationPage> {
  final String serverConnectionFailed =
      'Unable to connect to the server. Check Your Internet Connection';

  final uuid = Uuid();
  final filter = ProfanityFilter();
  var _listener;
  late Box<UserConversation> chatBox;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isKeyboardVisible = false;
  final ImagePicker picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
  XFile? imageFile;
  bool isImageFullScreen = false;

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    // FocusManager.instance.primaryFocus?.unfocus();
    _listener?.cancel();
    super.dispose();
  }

  // _loadGroupDetails() {
  //   if (ConversationType.community.type ==
  //       ref.read(conversationTypeProvider).type) {
  //   } else if (ConversationType.event.type ==
  //       ref.read(conversationTypeProvider).type) {}
  // }

  void selectDescription() {
    print('selecting desc');
    ConversationType conversationType =
        ref.read(conversationTypeProvider.notifier).state;
    if (conversationType.type == ConversationType.user.type) {
      pd.Provider.of<HomeListingsNotifier>(context, listen: false)
          .getUserInfo(widget.receiverID)
          .then((_) {
        Navigator.of(context).pushNamed(OtherProfileScreen.routeName);
      }).catchError((value) {
        bool vali = value.toString() == ('Exception: Timeout');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: vali == false
              ? Text(
                  "Could not fetch user details",
                )
              : Text("Server is unreachable!"),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: "Ok", onPressed: () {}),
        ));
      });
    } else if (conversationType.type == ConversationType.event.type) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailPage(id: widget.receiverID),
        ),
      );
    } else if (conversationType.type == ConversationType.community.type) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityDetailsPage(id: widget.receiverID),
        ),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  // void sendMessage(imgURL) {
  //   var newMessage = ChatMessage(
  //       senderID: ref.read(userIDProvider),
  //       receiverID: widget.receiverID,
  //       messageContent: filter.censor(textController.text),
  //       imgURL: imgURL,
  //       timeStamp: "9:00");
  //   ref.read(messageSendProvider(newMessage));
  //   final chatMessages = [
  //     ...ref.read(allMessageProvider.notifier).state,
  //     newMessage
  //   ];
  //   ref.read(allMessageProvider.notifier).state = chatMessages;
  // }

  Future<String> imageUpload(String uri) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(uri,
            resourceType: CloudinaryResourceType.Image),
      );
      print(response.secureUrl);
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print(e.message);
      return "Error";
    }
  }

  void toggleImageSize() {
    setState(() {
      isImageFullScreen = !isImageFullScreen;
    });
  }

  List<types.Message> _messages = [];
  late types.User _user;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    print(widget.receiverID);
    _user = types.User(
        id: ref.read(userIDProvider),
        imageUrl: ref.read(userProvider.notifier).state.avatarURL,
        firstName: ref.read(userProvider.notifier).state.userName);
  }

  @override
  Widget build(BuildContext context) {
    // getUserChats();
    // final oldChats = ref.watch(oldChatsProvider); // modify for community also
    // final socket = ref.watch(socketProvider);
    // final allMessages = ref.watch(allMessageProvider);
    print('rebuilding conversations');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
            child: ConversationAppBar(
          imageURL: widget.imageURL,
          userName: widget.chatRecipientName,
          selectDescription: selectDescription,
        )),
      ),
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAttachmentPressed,
        // onMessageTap: _handleMessageTap,
        // onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        // showUserAvatars: true,
        showUserNames: true,
        user: _user,
      ),
    );
  }

  void _handleAttachmentPressed() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select image source'),
        actions: <Widget>[
          TextButton(
            child: const Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
    _handleImageSelection(source);
    return;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection(ImageSource.gallery);
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection(source) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final uri = await imageUpload(result.path);
      if (uri == 'Error') {
        showSnackBar(context: context, content: serverConnectionFailed);
        return;
      }
      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result.name,
        size: bytes.length,
        uri: uri,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  //todo get messages after certain point
  void _loadMessages() async {
    chatBox = await Hive.openBox<UserConversation>('chat');

    if (chatBox.get(widget.receiverID) != null) {
      final messages = chatBox.get(widget.receiverID)!.conversations;
      // for (int i = 0; i < messages.length; i++) {
      //   print(messages[i].toJson());
      // }
      setState(() {
        if (messages.isNotEmpty) _messages = messages;
      });
    }
    _listener = chatBox.watch(key: widget.receiverID).listen((event) {
      if (event.value != null) {
        print("in listener conversation");
        setState(() {
          final messages = chatBox
              .get(widget.receiverID, defaultValue: UserConversation())
              ?.conversations;
          if (messages!.isNotEmpty) {
            _messages = messages;
          }
        });
      }
    });
  }

  void _addMessage(message) async {
    // chatBox.clear();
    // return;
    var newMessage = {
      'senderId': ref.read(userIDProvider),
      'receiverId': ref.read(receiverIDProvider),
      'createdAt': message.createdAt.toString(),
      'content': jsonEncode(message.toJson())
    };

    print(newMessage);
    await http.post(
      //todo handle pubsub and make sure if message not sent don't display
      Uri.parse(addUserMessageAPI),
      body: newMessage,
    );
    var messages =
        chatBox.get(widget.receiverID, defaultValue: UserConversation());
    messages!.conversations.insert(0, message);
    chatBox.put(widget.receiverID, messages);
    String messageSendAPI = ref.read(conversationTypeProvider.notifier).state ==
            ConversationType.user
        ? 'chat'
        : 'groupChat';
    ref.read(conversationEmitSocketProvider).emit(messageSendAPI, newMessage);
  }
}
