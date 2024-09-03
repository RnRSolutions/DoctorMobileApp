class DialogflowService {
  static Future<String> sendToDialogflow(String message) async {
    // Hardcoded response for testing
    if (message.toLowerCase() == "hello") {
      return "Hello! How are you?";
    } else {
      return "I didn't understand that. Can you please rephrase?";
    }
  }
}
