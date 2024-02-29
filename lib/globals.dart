library nfc_app.globals;

import 'dart:io';

// final String API_URL="https://ebusinesscard.ga";
// final String API_URL="https://360smartbusinesscard.com/pro";
//final String API_URL="https://360smartbusinesscard.com";
//final String API_URL="https://xepinas-ae01.sanipex.com/smartcards";

//final String API_URL="https://cards.sanipex.com/smartcards";
final String API_URL="https://smartcard.etihad.ae";

//https://sanipexgroup.360websitedemo.com
//https://cards.sanipex.com/smartcards/

String USER_TOKEN="";
String USER_ID="";
String USER_NAME="";
String USER_EMAIL="";
String USER_PASSWORD="";
String REMEMBER_ME="";
String LOGIN="";
String primaryName="";
String primaryImage ="https://ebusinesscard.ga/avatars/default.jpg";
String SOCIAL_TYPE="";

String current_profile="";
Map<String,Object> singleCardToWrite;
File selectedAvatarImage;
File selectedCoverImage;
bool permissionGranted=true;

// String IMG;
// GlobalKey<ScaffoldState> SCAFFOLD_KEY;