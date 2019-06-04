void getDataFromAPI() {
  // gets data from game API 
  String game_title, ent_name, rate_no;
  game_title=ent_name=rate_no="";

  // checks criteria
  switch((int)criteria.getValue()) {
  case 0:
    game_title=keyword.replace(" ", "%20");
    break;
  case 1:
    ent_name=keyword.replace(" ", "%20");
    break;
  case 2:
    rate_no=keyword.replace(" ", "%20");
    break;
  }
  
  // connects to the API, which is XML file format
  String APIlink=
    "http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=10&pageno=" + result_page;
  search_result=loadXML(APIlink);
  
  analyzeData();
  isLoading=false;
}

void analyzeData() {
  // analyze the XML file about games
  ArrayList<game> games=new ArrayList();
  total_num=search_result.getChild("tcount").getIntContent();

  if (total_num==0) {
  } else {
    XML[] items=search_result.getChildren("item");
    for (XML i : items) { // for each items(games)
      String[] content = new String[7];
      for (int j=0; j<7; j+=1) {
        content[j]=i.getChild(elements[j]).getContent("NIL"); // get attributes
      }
      games.add(new game(content)); // makes new game object and add into ArrayList
    }
  }
  
  PGames=games;
}

void showGames(ArrayList<game> games) {
  
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
