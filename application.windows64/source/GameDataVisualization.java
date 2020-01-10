import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import static javax.swing.JOptionPane.showMessageDialog; 
import static javax.swing.JOptionPane.ERROR_MESSAGE; 
import java.util.Collections; 
import java.net.*; 
import java.io.*; 
import java.util.Iterator; 
import java.util.Comparator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GameDataVisualization extends PApplet {




ControlP5 cp5;

DropdownList criteria; // search criteria
String[] criterias={"게임명", "배급사명", "분류번호"}; // criteria list
Textfield search_text; // typing area
String keyword="";

PFont fontB, fontR, fontRbig, fontRmini, fontL, fontLsmall; // fonts
boolean isLoading=false, isAnalyzing=false, breaked=false; // for the state sentence on the screen
int loading_gap=0;

public void setup() {
   // window size
  cp5=new ControlP5(this);
  cp5Set();

  // new page buttons
  first_btn=(pageButton)new pageButton(725, 160, 30).setExtreme(true).setPageNum(-1).setText("◀");
  prev_btn=(pageButton)new pageButton(760, 160, 30).setPageNum(-1).setText("←");
  post_btn=(pageButton)new pageButton(795, 160, 30).setPageNum(1).setText("→");
  last_btn=(pageButton)new pageButton(830, 160, 30).setExtreme(true).setPageNum(1).setText("▶");

  // sort buttons
  name_sort=(sortButton)new sortButton(655, 195, 100, 30).setSort(elements[0]).setText("게임명순");
  date_sort=(sortButton)new sortButton(760, 195, 100, 30).setSort(elements[6]).setText("날짜순");

  // graph button
  graphBtn=(graphToggleButton)new graphToggleButton(1440, 608, 100, 30).setText("Toggle");

  // break button
  brkBtn=(breakButton)new breakButton(750, 350, 100, 30).setText("Break");
}

public void draw() {
  background(255);
  showMainDisplay();
}

public void textSubmit() {
  total_num=0; // not searched yet
  last_game=null; // reset
  breaked=false;
  name_sort.setText("게임명순");
  date_sort.setText("날짜순 ▼");

  // search corresponding games
  delay(100); // to prevent the infinite-clicking
  if (criteria.getLabel()=="Criteria") {
    // Did not choose the criteria
    showMessageDialog(null, "Select the criteria.", "Alert", ERROR_MESSAGE);
    return;
  } else if (keyword.length()<=2) {
    // Text is too short
    showMessageDialog(null, "Type more than 2 letters.", "Alert", ERROR_MESSAGE);
    return;
  } else {
    // normal case
    isLoading=true;
    getDataFromAPI();
  }
  delay(100);
}

public void cp5Set() {
  // fonts
  fontB=createFont("NanumSquareRoundB.ttf", 35);
  fontR=createFont("NanumSquareRoundR.ttf", 20);
  fontL=createFont("NanumSquareRoundL.ttf", 24);
  fontRbig=createFont("NanumSquareRoundR.ttf", 45);
  fontRmini=createFont("NanumSquareRoundR.ttf", 12);
  fontLsmall=createFont("NanumSquareRoundL.ttf", 18);

  // search buttonimages
  PImage search_button_images[]={loadImage("button1.png"), loadImage("button2.png"), loadImage("button3.png")};
  for (PImage i : search_button_images) i.resize(45, 45);

  // dropdown list
  criteria=cp5.addDropdownList("Criteria", 0, 0, 160, 160) // initial position, width, max height(including items)
    .setPosition(640, 45).setItemHeight(40).setBarHeight(40) // position and item/bar height
    .setBackgroundColor(color(190)).setColorBackground(color(60)).setColorActive(color(255, 128)).setFont(fontR); // colors and fonts
  criteria.getCaptionLabel().toUpperCase(false); // Inactivate auto-capitalizing
  criteria.getValueLabel().toUpperCase(false);
  for (String i : criterias) criteria.addItem(i, i); // adding items to dropdown list
  criteria.close();

  // textfield
  search_text=cp5.addTextfield("search_text")
    .setPosition(845, 42).setSize(640, 45) // position and size
    .setColorBackground(color(60)).setColorActive(color(255, 128)).setColorForeground(0xff000000).setFont(fontL); // colors and fonts

  // bang (search button)
  cp5.addBang("textSubmitbyClick") // connecting to function 
    .setPosition(1520, 42).setSize(45, 45) // position and size
    .setImages(search_button_images); // set images
}

public void textSubmitbyClick() {
  if (isLoading) return;
  keyword=search_text.getText();
  search_text.setText("");
  thread("textSubmit");
}

public void keyPressed() {
  if (isLoading) return; // ignore while loading
  if (search_text.isActive() && keyCode==ENTER) {
    // submit by pressing enter key
    keyword=search_text.getText();
    thread("textSubmit");
  }
}

public void mouseClicked() {
  if (isLoading) {
    if (mouseHere(brkBtn)) {
      brkBtn.click();
    }
    return;
  }
  for (gameRow i : list) {
    if (i==null) break;
    if (mouseHere(i)) {
      // gameRow list element clicked
      i.click();
      return;
    }
  }
  if (total_num>0 && !criteria.isOpen() && !breaked) { // only works if search result exists and dropdownlist is closed, catched break error
    if (mouseHere(first_btn)) {
      // first page
      first_btn.click();
    } else if (mouseHere(prev_btn)) {
      // previous page
      prev_btn.click();
    } else if (mouseHere(post_btn)) {
      // posterior page
      post_btn.click();
    } else if (mouseHere(last_btn)) {
      // last page
      last_btn.click();
    } else if (mouseHere(name_sort)) {
      // button text reset and sort by name
      name_sort.setText("게임명순");
      date_sort.setText("날짜순");
      name_sort.click();
    } else if (mouseHere(date_sort)) {
      // button text reset and sort by date
      name_sort.setText("게임명순");
      date_sort.setText("날짜순");
      date_sort.click();
    } else if (mouseHere(graphBtn)) {
      graphBtn.click();
    }
  }
}

public boolean mouseHere(float x, float y, float w, float h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
pageButton first_btn, prev_btn, post_btn, last_btn; // page changing numbers
sortButton name_sort, date_sort; // two kinds of sort button
gameRow[] list = new gameRow[10]; // gamerow array
graphToggleButton graphBtn;
breakButton brkBtn;


abstract class clickButton {
  int x, y; // location
  int w, h; // width and height of the box
  int gray_color=128; // gray color value for box color
  int text_color; // text color
  String label=""; // button text

  public void locate() {
    fillAndStroke(); // fill and stroke
    rect(x, y, w, h); // drawing button
    textFont(fontR); // text font set
    textAlign(CENTER, CENTER); // text aligning
    fill(text_color); // text color set
    text(label, x, y, w, h); // show text(label)
  }

  public void fillAndStroke() {
    // set button color and stroke (not text)
    if (mouseHere(this)) {
      // mouse is over the button
      stroke(0);
      fill(0xff0080FF);
    } else {
      noStroke();
      fill(gray_color);
    }
  }

  public void click() {
    // nothing - should override
  }

  public clickButton setColor(int foo) {
    gray_color=foo;
    return this;
  }

  public clickButton setTextColor(int bar) {
    text_color=bar;
    return this;
  }

  public clickButton setText(String str) {
    label=str;
    return this;
  }

  clickButton(int tx, int ty, int tw, int th) {
    // rectangle
    x=tx;
    y=ty;
    w=tw;
    h=th;
    this.setColor(64);
    this.setTextColor(255);
  }

  clickButton(int tx, int ty, int ts) {
    // square
    x=tx;
    y=ty;
    w=ts;
    h=ts;
    this.setColor(64);
    this.setTextColor(255);
  }
}

class pageButton extends clickButton {
  // changes the page of result
  int page_num=0;
  boolean extreme=false; // enabling extreme operation

  pageButton(int tx, int ty, int ts) {
    super(tx, ty, ts);
  }

  public @Override
    void click() {
    if (extreme) {
      // extreme button - to the first or last page
      if (page_num<0) {
        page=0;
      } else if (page_num>0) {
        page=max_page;
      }
      listUpdate();
    } else {
      // normal button - page +1 or -1
      if (page+page_num<0 || page+page_num>max_page) {
        return;
      }
      page+=page_num;
      listUpdate(); // update list
    }
  }

  public pageButton setPageNum(int move_page) {
    page_num=move_page;
    return this;
  }

  public pageButton setExtreme(boolean foo) {
    extreme=foo;
    return this;
  }
}

class gameRow extends clickButton {
  // each row of result
  game game_info;
  gameRow(int tx, int ty, int tw, int th, game G) {
    // rectangle
    super(tx, ty, tw, th);
    game_info=G;
    setTextColor(0);
  }

  public @Override
    void fillAndStroke() {
    // set Button design(stroke, fill), depends on the mouse location
    if (mouseHere(this)) {
      stroke(0);
      fill(gray_color*7/8);
    } else {
      noStroke();
      fill(gray_color);
    }
  }

  public @Override
    void click() {
    last_game=game_info;
  }
}

class sortButton extends clickButton {
  // changes the way of sorting
  String sorting_way="";

  sortButton(int tx, int ty, int tw, int th) {
    super(tx, ty, tw, th);
  }

  public sortButton setSort(String bar) {
    sorting_way=bar;
    return this;
  }

  public @Override
    void click() {
    if (sortMode.equals(sorting_way)) {
      // sorting direction toggle
      isDescending=!isDescending;
      if (isDescending) {
        this.setText(this.label+" ▼");
      } else {
        this.setText(this.label+" ▲");
      }
    } else {
      // new yardstick
      sortMode=sorting_way;
      isDescending=true;
      this.setText(this.label+" ▼");
    }
    sortAgain();
  }
}

class graphToggleButton extends clickButton {
  graphToggleButton(int tx, int ty, int tw, int th) {
    super(tx, ty, tw, th);
  }

  public @Override
    void click() {
    // graph toggled
    isShowingAge=!isShowingAge;
  }
}

class breakButton extends clickButton {
  breakButton(int tx, int ty, int tw, int th) {
    super(tx, ty, tw, th);
    text_color=0;
    gray_color=255;
  }

  public @Override
    void fillAndStroke() {
    // set button color and stroke (not text)
    if (mouseHere(this)) {
      // mouse is over the button
      noStroke();
      fill(0xff0080FF);
    } else {
      stroke(0);
      fill(gray_color);
    }
  }

  public @Override
    void click() {
    total_num=-1;
    isLoading=false;
    isAnalyzing=false;
    breaked=true;
  }
}

public boolean mouseHere(clickButton cb) {
  return mouseHere(cb.x, cb.y, cb.w, cb.h);
}


ArrayList<game> games;
game last_game;
String[] elements={"gametitle", "orgname", "entname", "hoperate", "givenrate", "rateno", "rateddate"}; // length: 7
String[] korean_elements={"게임명", "평가 기관", "배급사", "희망 등급", "부여 등급", "분류번호", "분류날짜"};
String sortMode="rateddate"; // sort by criteria above
boolean isDescending=true; // descending sort

class game implements Comparable<game> {
  // game class
  // contains data of a game
  String attributes[]=new String[7]; // same order as elements above

  game(String[] input) {
    attributes=input;
  }

  public String toString() {
    // convert game object to string
    String res="";
    for (int i=0; i<7; i+=1) {
      res+=korean_elements[i]+": "+attributes[i];
      if (i==1 || i==3) {
        res+=" / ";
        continue;
      }
      if (i<7-1) res+="\n";
    }
    return res;
  }

  public String getAttribute(int k) {
    return attributes[k];
  }

  @Override
    public int compareTo(game G) {
    // to use sort method
    for (int i=0; i<7; i+=1) {
      if (sortMode.equals(elements[i])) {
        return this.attributes[i].compareTo(G.attributes[i])*(isDescending? -1:1);
      }
    }
    return 0;
  }
}



InputStream input = null;
int loading_cnt;

XML search_result; // search result (from Game API)
int total_num=-1, page=0, max_page; // caution: page denoted and real value of page is different (delta -1)

public void getDataFromAPI() {
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
      else loading_gap=PApplet.parseInt(sqrt(total_num)*5);
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

public void analyzeData() {
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

public void listUpdate() {
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

public void sortAgain() {
  if (total_num<=0) return;
  // resetting some variables
  page=0; // page initialize
  Collections.sort(games);
  listUpdate();
}

public void stopThread(int error_num) {
  total_num=error_num;
  isLoading=false;
}

public boolean isThisLinkOK(String test_url) {
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
int color_list[]={0xffE6194B, 0xffF58231, 0xffFFE119, 0xff3CB44B, 0xff46F0F0, 0xff4363D8, 0xff911EB4, 0xffF032E6};
boolean isShowingAge=true;

public void showMainDisplay() {
  // segregation line
  stroke(0); 
  fill(0);
  line(20, 125, 1580, 125);

  // title
  fill(0);
  textFont(fontB);
  textAlign(LEFT, TOP);
  text("게임 검색기 (3308 박해준)", 125, 45);

  // state messages
  textFont(fontRbig);
  textAlign(CENTER, CENTER);
  if (isLoading) {
    // loading page
    brkBtn.locate();
    textFont(fontRbig);
    fill(0);
    if (!isAnalyzing) {
      if (total_num>0) {
        if (total_num<=150) {
          // small data set
          text("Loading\n"+"(total "+total_num+" results)", width/2, height/2);
        } else {
          // big data set
          text("Loading\n"+"(total "+(loading_cnt*loading_gap<total_num ? loading_cnt*loading_gap:total_num)+"/"+total_num+" results)", width/2, height/2);
          textAlign(LEFT, TOP);
          textFont(fontRmini);
          text("3000개 이상의 결과는 서버의 오류를 초래할 수 있습니다.", 20, 125);
        }
      } else {
        text("Loading\n", width/2, height/2);
      }
    } else {
      text("Analyzing\n", width/2, height/2);
    }
  } else {
    // loading complete - result page
    switch(total_num) {
    case -3: // error of server
      text("Server is having some trouble. Try it later.", width/2, height/2);
      break;
    case -2: // error of keywords
      text("Please check the keywords again.", width/2, height/2);
      break;
    case -1: // no search data
      text("Please enter the keywords in the search box.", width/2, height/2);
      break;
    case 0: // no such game
      text("No such game.", width/2, height/2);
      break;
    default:
      if (breaked) {
        // catching break error
        println("catched break error");
        isLoading=isAnalyzing=breaked=false;
        total_num=-1;
        return;
      }
      showGames(); // game lists
      showStatistic(); // statistics
    }
  }
}

public void showGames() {
  // show games and related layouts.
  // primary information
  textFont(fontL);
  textAlign(LEFT, TOP);
  fill(0);
  text("There are "+total_num+" search results for \""+keyword+"\".", 60, 160);
  text("(page "+(page+1)+"/"+(max_page+1)+")", 60, 190);

  // page buttons
  first_btn.locate();
  prev_btn.locate();
  post_btn.locate();
  last_btn.locate();

  // page buttons
  name_sort.locate();
  date_sort.locate();

  // gamerows
  for (gameRow i : list) {
    try {
      i.locate();
    }
    catch (NullPointerException e) {
      break;
    }
  }

  // last clicked game info
  textFont(fontLsmall);
  fill(64);
  noStroke();
  rect(920, 670, 620, 175);
  fill(255);
  textAlign(LEFT, TOP);
  try {
    text(last_game.toString(), 920, 670, 620, 175);
  }
  catch(NullPointerException e) {
    // None
  }
}

public void showStatistic() {
  // box
  noFill();
  stroke(0);
  rect(920, 160, 620, 478); // border
  textAlign(LEFT, BOTTOM);
  textFont(fontLsmall);
  fill(0);
  text("Now showing: "+(isShowingAge ? "Age":"Year")+" data", 920, 638);

  if (isShowingAge) {
    // pie chart - age
    float lastAngle=-HALF_PI;
    int colorCnt=0;
    int mouseColor;

    // drawing pie chart
    for (String i : age_sort_result) {
      stroke(0);
      fill(color_list[colorCnt]);
      arc(1230, 399, 450, 450, lastAngle, lastAngle+(float)age.get(i)/total_num*TWO_PI); // drawing sector
      lastAngle+=(float)age.get(i)/total_num*TWO_PI;
      colorCnt+=1; // changing color
    }

    // textbox
    mouseColor=get(mouseX, mouseY); // get the color of mouse-located pixel
    for (int i=0; i<8; i+=1) {
      if (mouseColor==color_list[i]) {
        // mouse is here
        fill(255);
        stroke(0);
        rect(mouseX, mouseY-50, 125, 50);
        textFont(fontLsmall);
        fill(0);
        text(" "+age_sort_result.get(i)+"\n "+((float)age.get(age_sort_result.get(i))/total_num*100)+"%", mouseX, mouseY-50, 125, 50); // text (age and percentage)
      }
    }
  } else {
    // histogram and line graph - year
    // pillar
    textFont(fontRmini);
    textAlign(LEFT, TOP);
    text("데이터가 적으면 제대로 표시되지 않을 수 있습니다.", 920, 160);
    float pillar_height=0;
    int max_year_value=max(year_arrange_result);
    for (int i=0; i<10; i+=1) {
      fill(0xff6699CC);
      stroke(255);
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195); // calculating pillar height
      rect(1008.6f+44.3f*i, pillar_height, 44.3f, 575-pillar_height);
    }

    // line graph - point
    for (int i=0; i<10; i+=1) {
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      fill(0);
      noStroke();
      ellipse(1008.6f+44.3f*i+22.2f, pillar_height, 3, 3);
    }

    // line graph - line
    for (int i=1; i<10; i+=1) {
      float pillar_height1=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      float pillar_height2=map(year_arrange_result[i-1], 0, max_year_value, 575, 195);
      stroke(0);
      line(1008.6f+44.3f*i+22.2f, pillar_height1, 1008.6f+44.3f*(i-1)+22.2f, pillar_height2);
    }
    line(1030.8f, map(year_arrange_result[0], 0, max_year_value, 575, 195), 986.4f, 575);
    line(1429.5f, map(year_arrange_result[9], 0, max_year_value, 575, 195), 1473.8f, 575);

    // axis
    stroke(0);
    for (int i=0; i<=10; i+=1) {
      fill(0);
      textAlign(CENTER, TOP);
      textFont(fontRmini);
      text(str(PApplet.parseInt(minYear+i*year_gap)), 1008.6f+44.3f*i, 575);
      line(1008.6f+44.3f*i, 573, 1008.6f+44.3f*i, 577); // gradation
    }
    line(940, 575, 1520, 575);

    // textBox
    for (int i=0; i<10; i+=1) {
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      if (mouseHere(1008.6f+44.3f*i, pillar_height, 44.3f, 575-pillar_height)) {
        fill(255);
        stroke(0);
        rect(mouseX, mouseY-50, 125, 50);
        textFont(fontLsmall);
        fill(0);
        text(str(PApplet.parseInt(minYear+i*year_gap))+"~"+str(PApplet.parseInt(minYear+(i+1)*year_gap))+"\n"+str(year_arrange_result[i]), mouseX, mouseY-50, 125, 50);
      }
    }
  }
  graphBtn.locate();
}



HashMap<String, Integer> age=new HashMap<String, Integer>(); // age and # of corresponding result 
HashMap<String, Integer> years=new HashMap<String, Integer>(); // year and # of corresponding result
ArrayList<String> age_sort_result=new ArrayList<String>(); // (only) age list
ArrayList<String> year_list=new ArrayList<String>(); // (only) year list
int[] year_arrange_result=new int[10]; // histogram data
int minYear, maxYear; // min year, max year (in year list)
float year_gap; // histogram gap

public void getStatistic() {
  if (!isLoading) return; // thread killed
  if (total_num<=0) return;

  // counts the appropriate data and provide statistics.
  age.clear();
  for (game G : games) {
    // Getting age data
    String ageTemp=G.getAttribute(4);
    if (age.containsKey(ageTemp)) {
      // value update
      age.put(ageTemp, age.get(ageTemp)+1);
    } else {
      // new
      age.put(ageTemp, 1);
    }
  }
  if (age.containsKey("")) {
    age.put("N/A", age.remove(""));
  }

  // age list sort
  Iterator temp;
  temp=sortHashMapByValue(age);
  age_sort_result.clear();
  while (temp.hasNext()) {
    String k = (String) temp.next();
    age_sort_result.add(k);
  }

  // year data processing
  years.clear();
  year_list.clear();
  // counts the appropriate data and provide statistics.
  for (game G : games) {
    // Getting years data
    String yearTemp="";
    try {
      // get year part of string
      yearTemp=G.getAttribute(6).substring(0, 4);
    } 
    catch(StringIndexOutOfBoundsException e) {
      yearTemp="";
    } 
    finally {
      if (years.containsKey(yearTemp)) {
        // value update
        years.put(yearTemp, years.get(yearTemp)+1);
      } else {
        // new
        years.put(yearTemp, 1);
      }
      if (!year_list.contains(yearTemp)) {
        year_list.add(yearTemp);
      }
    }
  }
  years.remove("");
  year_list.remove("");
  Collections.sort(year_list);

  // cutting data
  minYear=PApplet.parseInt(year_list.get(0));
  maxYear=PApplet.parseInt(year_list.get(year_list.size()-1));
  year_gap=(float)(maxYear-minYear)/10;

  // data arrange
  for (int i=0; i<10; i+=1) {
    year_arrange_result[i]=0;
  }
  for (String i : year_list) {
    int index=PApplet.parseInt((PApplet.parseInt(i)-minYear)/year_gap);
    try {
      year_arrange_result[index]+=years.get(i);
    } 
    catch(ArrayIndexOutOfBoundsException e) {
      // out of bound
      year_arrange_result[9]+=years.get(i);
    }
  }
}

public Iterator sortHashMapByValue(final HashMap map) {
  ArrayList<String> list = new ArrayList();
  list.addAll(map.keySet());
  Collections.sort(list, new Comparator() {
    public int compare(Object o1, Object o2) {
      Object v1 = map.get(o1);
      Object v2 = map.get(o2);
      return ((Comparable) v1).compareTo(v2);
    }
  }
  );
  Collections.reverse(list);
  return list.iterator();
}
  public void settings() {  size(1600, 900); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GameDataVisualization" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
