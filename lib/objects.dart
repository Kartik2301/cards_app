class User{//Total 7 Fields
  static String uid;

}

class Room{//Total 7 Fields
  //All stored in Database
  String roomId;
  //time denotes room creation time
  String createdAt;
  String source;
  String destination;
  String journeyTime;
  int numberOfMembers;
  bool isVacant;
}