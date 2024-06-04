import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config{
  static const String appName = 'Smartlink Manager';

  static const String logoAddress = 'https://firebasestorage.googleapis.com/v0/b/smartlink-pro.appspot.com/o/logo%2FArtboard%201manager.png?alt=media&token=fa863fff-e6f7-4193-8087-f18903438f72';

  static const String signInPageImageAssetAddress = 'assets/intro/Admin-amico.png';

  static DateFormat dateTimeFormatter = DateFormat('dd.MM.yyyy  HH:mm');
  static DateFormat dateFormatter = DateFormat('dd.MM.yyyy');

  static late FirebaseAuth auth;
  static late FirebaseFirestore fireStore;
  static late FirebaseApp firebaseApp;
  static late FirebaseStorage firebaseStorage;
  static late SharedPreferences sharedPreferences;

  static const String managerCollection = 'managers';
  static const String uid = 'uid';
  static const String username = 'username';
  static const String password = 'password';
  static String placeId = "placeId";
  static String managerId = "managerId";

  static String loginLogsCollection = "loginLogs";
  static String loginDate = "loginDate";

  static String roomsCollection = "rooms";
  static const String id = "id";
  static const String status = "status";
  static const String public = "public";
  static const String name = "name";
  static const String location = "location";
  static const String occupiedBy = "occupiedBy";
  static const String occupiedTill = "occupiedTill";
  static const String occupiedFrom = "occupiedFrom";


  static String placesCollection = "places";
  static String description = "description";
  static String descriptionDe = "descriptionDe";
  static String postCode = "postCode";
  static String stars = "stars";
  static String images = "images";
  static String showPublic = "showPublic";
  static String address = "address";
  static String hasGroupChat = "hasGroupChat";
  static String hasTicketSystem = "hasTicketSystem";
  static String hasNews = "hasNews";
  static String instagram = "instagram";
  static String facebook = "facebook";
  static String email = "email";
  static String website = "website";
  static String phoneNumber = "phoneNumber";
  static String city = "city";
  static String country = "country";
  static String about = "about";
  static String groupChatEnabled = "groupChatEnabled";
  static String newsEnabled = "newsEnabled";
  static String ticketSystemEnabled = "ticketSystemEnabled";
  static String phoneNumbers = "phoneNumbers";


  static String ticketsCollection = "tickets";
  static const String ticketMessageCollection = "ticketMessages";
  static String read = "read";
  static String lastSender = "lastSender";
  static String lastMessageDateTime = "lastMessageDateTime";
  static String subject = "subject";
  static String senderUid = "senderUid";
  static String createDateTime = "createDateTime";


  static String newsCollection = "news";
  static String title = "title";
  static String publishDateTime = "publishDateTime";

  static const String groupChatCollection = "groupChat";
  static const String text = "text";
  static const String dateTime = "dateTime";

  static String userCollection = "users";
  static String code = "code";

  static String historyCollection = "history";
  static String logDateTime = "logDateTime";
  static String loggerUid = "loggerUid";
  static String setStatusTo = "setStatusTo";

  static String imageUrl = "imageUrl";
  static String passportNumber = "passportNumber";
  static String firstname = "firstname";
  static String lastname = "lastname";


  static String guestsCollection = "guests";
  static String guestId = "guestId";
  static String roomId = "roomId";
  static String startDateTime = "startDateTime";
  static String endDateTime = "endDateTime";

  static String userAccessCollection = "userAccess";

}