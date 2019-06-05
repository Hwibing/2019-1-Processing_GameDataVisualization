import java.net.*;
import java.io.*;

InputStream input = null;
int loading_cnt;

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
  String APIlink="http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=10&pageno=1";
  // TODO: cutting a lot of datas
  if (isThisLinkOK(APIlink)) search_result=loadXML(APIlink);
  else {
    stopThread(-3);
    return;
  }

  // checking the errors of keyword
  if (search_result.getName()=="error") {
    stopThread(-2);
    return;
  }

  total_num=search_result.getChild("tcount").getIntContent(); // get total results number
  // getting all data
  if (total_num>0) {
    if (total_num<=150) { // small amount
      APIlink="http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
        + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display="+total_num+"&pageno=1";
      if (isThisLinkOK(APIlink)) search_result=loadXML(APIlink); // get all at once
      else {
        stopThread(-3);
        return;
      }
    } else {
      // too large data set
      // get many times, small amount per each time
      loading_cnt=0; // 
      search_result=null;
      XML resXML=new XML("result"); // result xml; be going to be search_result
      XML tempXML; // temp result for getting the data of each page
      while (loading_cnt*15<total_num) {
        loading_cnt+=1;
        APIlink="http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
          + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=15&pageno="+loading_cnt;
        if (!isThisLinkOK(APIlink)) {
          stopThread(-3);
          return;
        }
        tempXML=loadXML(APIlink); // get data from API
        // copying all items to resXML
        XML items[]=tempXML.getChildren("item");
        for (XML i : items) {
          resXML.addChild(i);
        }
      }
      search_result=resXML;
    }
  }
  analyzeData(); // make structure to handle easily
  isLoading=false; // done data loading
}

void analyzeData() {
  // analyze the XML file about games
  ArrayList<game> temp_games=new ArrayList();

  if (total_num==0) {
  } else {
    XML[] items=search_result.getChildren("item");
    for (XML i : items) { // for each items(games)
      String[] content = new String[7];
      for (int j=0; j<7; j+=1) {
        content[j]=i.getChild(elements[j]).getContent("NIL").trim(); // get attributes
      }
      temp_games.add(new game(content)); // makes new game object and add into ArrayList
    }
  }

  // resetting some variables
  page=0;
  max_page=total_num/10;
  games=temp_games;
  listUpdate();
}

void listUpdate() {
  // updates list, called when results are newly searched or page is changed
  list=new gameRow[10];
  for (int i=0; i<10; i+=1) {
    if (page*10+i>=total_num) break;
    list[i]=new gameRow(60, i*60+250, 800, 55, games.get(page*10+i));
    list[i].setColor(192);
  }
}

void showGames() {
  // show games and related layouts.
  // primary information
  textFont(fontL);
  textAlign(LEFT, TOP);
  fill(0);
  text("There are total of "+total_num+" search results.", 60, 160);
  text("(page "+(page+1)+"/"+(max_page+1)+")", 60, 190);

  // page buttons
  prev_btn.locate();
  post_btn.locate();
  fill(255);
  textFont(fontR);
  textAlign(CENTER, CENTER);
  text("←", 810, 175);
  text("→", 845, 175);

  // gamerows
  for (gameRow i : list) {
    try {
      i.locate();
    }
    catch (NullPointerException e) {
      break;
    }
  }
}

void stopThread(int error_num) {
  total_num=error_num;
  isLoading=false;
}

boolean isThisLinkOK(String test_url) {
  try {
    URL url = new URL(test_url);
    URLConnection connection = url.openConnection();
    input = connection.getInputStream();
    return true;
  } 
  catch (Exception e) {
    return false;
  }
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}

boolean mouseHere(clickButton cb) {
  return mouseHere(cb.x, cb.y, cb.w, cb.h);
}
