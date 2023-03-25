import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/features/conversation/components/conversation_app_bar.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/chat_message.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final String imageURL;
  final String chatRecipientName;
  final String receiverID;
  final Event? event;
  final Community? community; //refactor it

  const ChatDetailPage(
      {super.key,
      required this.imageURL,
      required this.chatRecipientName,
      required this.receiverID,
      this.event,
      this.community});

  @override
  // ignore: library_private_types_in_public_api
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  static const uid = "1";

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isKeyboardVisible = false;
  final ImagePicker picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
  XFile? imageFile;
  bool isImageFullScreen = false;
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
    ref.read(socketProvider).connect();
    print(widget.receiverID);
  }

  Future<void> pickImage(ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  void sendMessage(imgURL) {
    var newMessage = ChatMessage(
        senderID: uid,
        receiverID: widget.receiverID,
        messageContent: textController.text,
        imgURL: imgURL,
        timeStamp: "9:00");
    ref.read(messageSendProvider(newMessage));
    final chatMessages = [
      ...ref.read(allMessageProvider.notifier).state,
      newMessage
    ];
    ref.read(allMessageProvider.notifier).state = chatMessages;
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

    final oldChats = ref.watch(oldChatsProvider); // modify for community also
    final socket = ref.watch(socketProvider);
    final allMessages = ref.watch(allMessageProvider);
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
                event: widget.event)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              physics: BouncingScrollPhysics(),
              child:
                  // Consumer<ChatsNotifier>(builder: (context, notifier, child) {
                  // return
                  Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SingleChildScrollView(
                          child: oldChats.when(
                        data: (oldChat) {
                          return ListView.builder(
                            itemCount: allMessages.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment: (allMessages[index].senderID == uid
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                                  child: allMessages[index].messageContent != ""
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                (allMessages[index].senderID !=
                                                        uid
                                                    ? Colors.grey.shade200
                                                    : Colors.blue[200]),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            allMessages[index].messageContent,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: toggleImageSize,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            height: isImageFullScreen
                                                ? null
                                                : 300.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: allMessages[index]
                                                            .senderID ==
                                                        uid
                                                    ? Colors.blue[200]
                                                    : const Color.fromARGB(
                                                        255, 224, 224, 224)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                allMessages[index].imgURL,
                                                fit: isImageFullScreen
                                                    ? BoxFit.fitWidth
                                                    : BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) {
                          print(error);
                          print(stackTrace);
                          return Text(error.toString());
                        },
                      ))
                      // }
                      ),
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
                    sendMessage(imgURL);
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
                    print(imgURL);
                    sendMessage(imgURL);
                  },
                ),
                FloatingActionButton(
                  onPressed: () {
                    sendMessage("images");
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
