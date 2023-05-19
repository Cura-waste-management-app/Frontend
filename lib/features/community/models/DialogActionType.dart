class DialogActionType {
  late String type = "";
  static final DialogActionType delete = DialogActionType(type: "delete");
  static final DialogActionType leave = DialogActionType(type: "leave");
  static final DialogActionType join = DialogActionType(type: "join");
  DialogActionType({required this.type}) {}
}
