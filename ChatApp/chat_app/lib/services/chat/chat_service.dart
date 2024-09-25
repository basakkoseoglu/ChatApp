import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //firestor ve kullanıucı
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //kullanıcı akışını al
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //her bir kullanıcıyı gözden geçirmek
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //mesaj gönder
  Future<void> sendMessage(String receiverID, String message) async {
    //mevcut kullanıcı bilgilerini al
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //yeni bir mesaj oluştur
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);
    //iki kullanıcı için sohbet odası kimliği oluşturun (benzersizliği sağlayacak şekilde sıralanmıştır)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //kimlikleri sıralayın; bu, sohbet odası kimliğinin herhangi bir 2 kişi için aynı olmasını sağlar
    String chatRoomID = ids.join('_');
    //veritabanına yeni mesaj ekle
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //mesaj al
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    //iki kullanıcı için bir sohbet odası kimliği oluşturun
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
