const String APPLICATION_NAME = "Instagram";
double? screenWidth;
double? screenHeight;
bool get isWidthShrinkable => (screenWidth ?? 0) < 501;
bool get isTablet=>(screenWidth??0)<=1200 && (screenWidth??0)>525;
bool isDarkMode=true;
String? deviceName;
String? deviceId;
String? os;
const Map<String,String> reactions = {
  "FIRE": "🔥",
  "LIKE": "❤️",     // heart for like
  "LOVE": "💕",     // double heart or you can use 💖 💗 💝 💕
  "CARE": "🤗",
  "LAUGH": "😂",
  "WOW": "😮",
  "SAD": "😢",
  "ANGRY": "😡",
};
