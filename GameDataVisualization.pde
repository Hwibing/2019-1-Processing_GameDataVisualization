import controlP5.*;
ControlP5 cp5;

DropdownList criteria;
String[] criterias={"Title", "Company", "Classification number"};
Textfield searchText;

XML searchData;
PImage label;
PFont font;
void setup() {
  size(1600, 900); // window size
  cp5=new ControlP5(this);

  // dropdown list
  criteria=cp5.addDropdownList("Criteria").setPosition(650,60).setItemHeight(20).setBarHeight(15)
  .setBackgroundColor(color(190)).setColorBackground(color(60)).setColorActive(color(255, 128));
  //criteria.setFont(
  for (String i:criterias) criteria.addItem(i, i);
  criteria.close();
  
  label=loadImage("Label.png");
  label.resize(625, 92);
}

void draw() {
  background(255);
  decorating();
}

XML getDataFromAPI(String game_title, String ent_name, String rate_no, int page) {
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
  image(label, 10, 20);
  line(20, 125, 1580, 125);
}

void textSubmit() {
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
