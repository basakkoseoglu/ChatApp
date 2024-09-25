import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat&auth servis
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //metin alanı odağı için
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    //odak düğümüne dinleyici ekle
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //gecikmeye neden olur, böylece klavyenin görünmesi için zaman kalır,
        //ardından kalan alan miktarı hesaplanır
        //ve ardından aşağı kaydırılır
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    //liste görünümünün oluşturulması için biraz bekleyin, ardından aşağıya doğru kaydırın otomatik kaydrıma denilebilri
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll kontrolü
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  //mesaj gönderme
  void sendMessage() async {
    //eğer texfield'ın içinde bir şey varsa
    if (_messageController.text.isNotEmpty) {
      //mesaj gönderildi
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      //mesaj gönderildikten sonra temizleme
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //tüm mesajlar görüntüle
          Expanded(
            child: _buildMessageList(),
          ),

          //kullanıcı girişi
          _buildUserInput(),
        ],
      ),
    );
  }

  //mesajlaarı listele
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          //hata
          if (snapshot.hasError) {
            return const Text("Hata");
          }
          //yüklenme
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Yükleniyor..");
          }
          //listeyi döndür
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  //mesaj yapısı
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //şu anki kullanıcı
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //Gönderen geçerli kullanıcı ise mesajı sağa, aksi halde sola hizala
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  //mesaj girişi
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //Textfield alanın çoğunu kaplamalıdır
          Expanded(
            child: MyTextField(
              hintText: "Mesaj yazınız.",
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          //gönderme butonu
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
