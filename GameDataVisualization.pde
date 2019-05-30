void setup() {
  size(1600, 900);
  getDataFromAPI("x", "", "", 0);
}

void draw() {
  background(255);
}

XML getDataFromAPI(String game_title, String ent_name, String rate_no, int page) {
  XML xml=null;
  String APIlink=
    "http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=10&pageno=" + page;
    
  try {
    xml=loadXML(APIlink);
  } 
  catch(Exception e) {
    println("Please Check the Network Again.");
  }
  return xml;
}

boolean mouseHere(int x, int y, int w, int h) {
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
