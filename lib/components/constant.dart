import 'dart:ui';

// Theme Colors
const Color blueCustom = Color(0xFF1F74DD);
const Color gray950 = Color(0xFF1E1E1E);
const Color gray500 = Color(0xFF9E9E9E);
const Color gray400 = Color(0xFFB3B3B3);
const Color gray300 = Color(0xFFD9D9D9);
const Color gray100 = Color(0xFFF5F5F5);
const Color gray50 = Color(0xFFFAFAFA);
const Color gray25 = Color(0xFFFCFCFC);
const Color white = Color(0xFFFFFFFF);

// Images
//const String rnrLogo = 'assets/customlogo.png';
const String doctorImage = 'assets/doctor.jpg';
const String bluePlusLogo = 'assets/logo.png';

//const String baseUrl = "https://rnproducts.site/test-greenbless-web/api";

//const String LOCAL_BASE_URL = "http://192.168.1.4:8000/api";
const String LIVE_BASE_URL = "https://rnrobots.services/api";
const String LOCAL_BASE_URL = "https://rnproducts.site/test-greenbless-web/api";

// Toggle between local and live (change this to switch environments)
const String BASE_URL = LOCAL_BASE_URL;

// API Endpoints
const String DELETE_MESSAGE_URL = "/messages/delete/";
