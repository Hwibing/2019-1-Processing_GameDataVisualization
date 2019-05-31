import controlP5.*;

ControlP5 cp5;
ListBox criteria; 
Textfield searchText;

XML searchData;
PImage label;

void setup() {
  size(1600, 900);
  
  cp5=new ControlP5(this);
  
  cp5.addListBox("criteria").setPosition(650,50).setBarHeight(25).setItemHeight(25);
  /*criteria.addItem("Title");
  criteria.addItem("Studio");
  criteria.addItem("Signification");*/
  
  cp5.addTextfield("searchText").setPosition(400,400).setSize(100,50).setAutoClear(false);
  cp5.addBang("TextSubmit").setPosition(500,400).setSize(100,50);
  
  label=loadImage("Label.png");
  label.resize(625, 95);
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
  stroke(0); fill(0);
  image(label, 10, 20);
  line(20,125,1580,125);
}

void textSubmit() {
  
}

boolean mouseHere(int x, int y, int w, int h) {
  // rectangle range
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
