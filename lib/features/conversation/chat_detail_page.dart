import 'dart:io';
import 'package:cura_frontend/features/conversation/components/conversation_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'components/message_bar.dart';
import '../image_uploads/cloudinary_upload.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ChatDetailPage extends StatefulWidget {
  final String imageURL;
  final String userName;
  final String chatUserID;

  const ChatDetailPage(
      {super.key,
      required this.imageURL,
      required this.userName,
      required this.chatUserID});

  @override
  // ignore: library_private_types_in_public_api
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  static const uid = "1";
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
  XFile? imageFile;
  bool isImageFullScreen = false;
  bool isKeyboardVisible = false;

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    scrollController.dispose();
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    connect();
    getUserChats();
  }

  void connect() {
    Provider.of<ChatsNotifier>(context, listen: false).connect();
  }

  void getUserChats() {
    Provider.of<ChatsNotifier>(context, listen: false)
        .getUserChats(widget.chatUserID);
  }

  Future<void> pickImage(ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  void sendImage(imgURL) {
    Provider.of<ChatsNotifier>(context, listen: false)
        .sendMessage("", widget.chatUserID, imgURL);
  }

  Future<String> imageUpload() async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile!.path,
            resourceType: CloudinaryResourceType.Image),
      );
      // print(response.secureUrl);
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print(e.message);
      return "Err";
    }
  }

  void toggleImageSize() {
    setState(() {
      isImageFullScreen = !isImageFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getUserChats();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
            child: ConversationAppBar(
                imageURL: widget.imageURL, userName: widget.userName)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              child:
                  Consumer<ChatsNotifier>(builder: (context, notifier, child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: notifier.userMessages.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                              alignment:
                                  (notifier.userMessages[index].receiverID ==
                                          uid
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                              child: notifier
                                          .userMessages[index].messageContent !=
                                      ""
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (notifier.userMessages[index]
                                                    .receiverID ==
                                                uid
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        notifier
                                            .userMessages[index].messageContent,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: toggleImageSize,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        height: 300.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: notifier.userMessages[index]
                                                        .senderID ==
                                                    uid
                                                ? Colors.blue[200]
                                                : const Color.fromARGB(
                                                    255, 224, 224, 224)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            notifier.userMessages[index].imgURL,
                                            fit: isImageFullScreen
                                                ? BoxFit.fitWidth
                                                : BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    )),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Color.fromARGB(255, 76, 75, 75),
                  ),
                  onPressed: () async {
                    await pickImage(ImageSource.gallery);
                    // upload image to cloudinary and get back the url
                    final imgURL = await imageUpload();                 
                    sendImage(imgURL);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 76, 75, 75),
                  ),
                  onPressed: () async {
                    await pickImage(ImageSource.camera);
                    // upload image to cloudinary and get back the url
                    final imgURL = await imageUpload();
                    sendImage(imgURL);
                  },
                ),
                FloatingActionButton(
                  onPressed: () {
                    Provider.of<ChatsNotifier>(context, listen: false)
                        .sendMessage(textController.text, widget.chatUserID,
                            widget.imageURL);
                    textController.clear();
                  },
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
