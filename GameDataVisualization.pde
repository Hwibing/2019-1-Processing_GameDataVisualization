import controlP5.*;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.JOptionPane.ERROR_MESSAGE; 
ControlP5 cp5;

DropdownList criteria;
String[] criterias={"Title", "Company", "Class number"};
Textfield searchText;

XML searchData;
PFont fontB, fontR, fontL;

void setup() {
  size(1600, 900); // window size
  cp5=new ControlP5(this);
  fontB=createFont("NanumSquareRoundB.ttf", 33);
  fontR=createFont("NanumSquareRoundR.ttf", 18);
  fontL=createFont("NanumSquareRoundL.ttf", 20);


  // dropdown list
  criteria=cp5.addDropdownList("Criteria", 0, 0, 148, 120).setPosition(650, 50).setItemHeight(30).setBarHeight(30)
    .setBackgroundColor(color(190)).setColorBackground(color(60)).setColorActive(color(255, 128)).setFont(fontR);
  criteria.getCaptionLabel().toUpperCase(false);
  criteria.getValueLabel().toUpperCase(false);
  for (String i : criterias) criteria.addItem(i, i);
  criteria.close();

  // textfield
  searchText=cp5.addTextfield("searchText").setPosition(845, 42).setSize(640, 45)
    .setColorBackground(color(60)).setColorActive(color(255, 128)).setColorForeground(0xff000000).setFont(fontL);

  // bang (search button)
  cp5.addBang("textSubmit").setPosition(1520, 42).setSize(45, 45)
    .setColorBackground(color(60)).setColorActive(color(128)).setColorForeground(0xff000000);
}

void draw() {
  background(255);
  decorating();
}

XML getDataFromAPI(String game_title, String ent_name, String rate_no, int page) {
  // gets data from game API
  XML xml=null;
  String APIlink=
    "http://www.grac.or.kr/WebService/GameSearchSvc.asmx/game?"
    + "gametitle=" + game_title + "&entname=" + ent_name + "&rateno=" + rate_no + "&display=10&pageno=" + page;

  xml=loadXML(APIlink);
  return xml;
}

void decorating() {
  stroke(0); 
  fill(0);
  line(20, 125, 1580, 125);
  textFont(fontB);
  textAlign(LEFT, TOP);
  text("Game Search Engine (3308 Hwibing) ", 30, 45);
}

void textSubmit() {
  if (criteria.getLabel()=="Criteria") {
    // Did not choose the criteria
    delay(100);
    showMessageDialog(null, "Select the criteria.", "Alert", ERROR_MESSAGE);
    delay(100);
  } else if (searchText.getText().length()==0) {
    // Did not input any text
    delay(100);
    showMessageDialog(null, "Type the keywords.", "Alert", ERROR_MESSAGE);
    delay(100);
  } else {
    // normal case
  }
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
