import java.net.*;
import java.io.*;

InputStream input = null;
int loading_cnt;

XML search_result; // search result (from Game API)
int total_num=-1, page=0, max_page; // caution: page denoted and real value of page is different (delta -1)

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
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=1&pageno=1";
  if (!isThisLinkOK(APIlink)) {
    stopThread(-3);
    return;
  }

  // error check
  if (!isLoading) return; // thread killed
  search_result=loadXML(APIlink);
  // checking the errors of keyword
  if (search_result.getName()=="error") {
    stopThread(-2);
    return;
  }

  // getting all data
  total_num=search_result.getChild("tcount").getIntContent(); // get total results number
  if (!isLoading) return; // thread killed
  if (total_num>0) {
    if (total_num<=150) {
      // small data set
      APIlink="http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
        + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display="+total_num+"&pageno=1";
      if (!isThisLinkOK(APIlink)) {
        stopThread(-3);
        return;
      }
      search_result=loadXML(APIlink); // get all at once
    } else {
      // too large data set, so divide the whole data set
      loading_cnt=0;
      XML resXML=new XML("result"); // result xml; be going to be search_result
      XML tempXML; // temp result for getting the data of each page

      if (total_num<=1500) loading_gap=150;
      else loading_gap=int(sqrt(total_num)*5);
      while (loading_cnt*loading_gap<total_num) {
        loading_cnt+=1;
        APIlink="http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
          + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display="+loading_gap+"&pageno="+loading_cnt;
        if (!isLoading) return; // thread killed
        if (!isThisLinkOK(APIlink)) {
          stopThread(-3);
          return;
        }

        // get and move
        tempXML=loadXML(APIlink);
        XML items[]=tempXML.getChildren("item");
        for (XML i : items) {
          resXML.addChild(i);
        }
      }
      search_result=resXML;
    }
  }

  if (!(!isLoading || total_num<=0)) {
    // data analyze
    isAnalyzing=true;
    analyzeData(); // make structure to handle easily
    listUpdate(); // update list(page 0)

    if (!isLoading) return; // thread killed
    getStatistic();
  }

  // done
  isLoading=false; // done data loading
  isAnalyzing=false;
}

void analyzeData() {
  if (!isAnalyzing) return; // thread killed

  // analyze the XML file about games
  // it is guaranteed that total_num>0
  ArrayList<game> temp_games=new ArrayList();

  XML[] items=search_result.getChildren("item");
  for (XML i : items) { // for each items(games)
    if (!isAnalyzing) return; // thread killed
    String[] content = new String[7];
    for (int j=0; j<7; j+=1) {
      content[j]=i.getChild(elements[j]).getContent("NIL").trim(); // get attributes
    }
    temp_games.add(new game(content)); // makes new game object and add into ArrayList
  }

  // resetting some variables
  page=0; // page initialize
  max_page=(total_num-1)/10;
  games=temp_games;
}

void listUpdate() {
  // updates list, called when results are newly searched or page is changed
  list=new gameRow[10];
  for (int i=0; i<10; i+=1) {
    if (page*10+i>=total_num) break;
    game G=games.get(page*10+i);
    list[i]=new gameRow(60, i*60+250, 800, 55, G);
    list[i].setColor(192);
    list[i].setText(G.getAttribute(0));
  }
}

void sortAgain() {
  if (total_num<=0) return;
  // resetting some variables
  page=0; // page initialize
  Collections.sort(games);
  listUpdate();
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
