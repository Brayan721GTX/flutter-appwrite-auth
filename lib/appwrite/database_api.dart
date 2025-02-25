import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_app/appwrite/auth_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(dotenv.env['APPWRITE_URL']??'')
        .setProject(dotenv.env['APPWRITE_PROJECT_ID'])
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> getMessages() {
    return databases.listDocuments(
      databaseId: dotenv.env['APPWRITE_DATABASE_ID']?? '',
      collectionId: dotenv.env['COLLECTION_MESSAGES']?? '',
    );
  }

  Future<Document> addMessage({required String message}) {
    return databases.createDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']?? '',
        collectionId: dotenv.env['COLLECTION_MESSAGES']?? '',
        documentId: ID.unique(),
        data: {
          'text': message,
          'date': DateTime.now().toString(),
          'user_id': auth.userid
        });
  }

  Future<dynamic> deleteMessage({required String id}) {
    return databases.deleteDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']?? '',
        collectionId: dotenv.env['COLLECTION_MESSAGES']?? '',
        documentId: id);
  }
}
