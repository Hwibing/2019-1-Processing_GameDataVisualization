void getDataFromAPI() {
  String game_title, ent_name, rate_no;
  game_title=ent_name=rate_no="";

  // checks criteria
  switch((int)criteria.getValue()) {
  case 0:
    game_title=search_text.getText().replace(" ", "%20");
    break;
  case 1:
    ent_name=search_text.getText().replace(" ", "%20");
    break;
  case 2:
    rate_no=search_text.getText().replace(" ", "%20");
    break;
  }
  // gets data from game API
  String APIlink=
    "http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=10&pageno=" + result_page;
  search_result=loadXML(APIlink);
  isLoading=false;
}

ArrayList<game> analyzeData() {
  int totalNum=search_result.getChild("tcount").getIntContent();
  ArrayList<game> games=new ArrayList();

  if (totalNum==0) {
  } else {
    XML[] items=search_result.getChildren("item");
    for (XML i : items) {
      String[] content = new String[7];
      for (int j=0; j<7; j+=1) {
        content[j]=i.getContent(elements[j]);
      }
      games.add(new game(content));
    }
  }

  return games;
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
