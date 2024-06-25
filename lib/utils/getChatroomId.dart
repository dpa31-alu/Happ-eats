String getChatroomId(String id1, String id2)  {
  List<String> ids = [id1, id2];
  ids.sort();
  return ids.join();
}