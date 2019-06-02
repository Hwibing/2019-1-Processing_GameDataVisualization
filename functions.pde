XML getDataFromAPI(String game_title, String ent_name, String rate_no, int page) {
  // gets data from game API
  XML xml=null;
  String APIlink=
    "http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=10&pageno=" + page;

  // loading animation
  isLoading=true;
  thread("loading");
  xml=loadXML(APIlink);
  isLoading=false;

  return xml;
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}

void loading() {
  while (isLoading) {
    print("Loading");
  }
}
