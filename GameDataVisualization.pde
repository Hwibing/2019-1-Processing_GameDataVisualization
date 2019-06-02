import controlP5.*;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.JOptionPane.ERROR_MESSAGE; 
ControlP5 cp5;

DropdownList criteria;
String[] criterias={"Title", "Company", "Class. number"};
Textfield searchText;

XML searchData;
PFont fontB, fontR, fontL;
boolean isLoading=false;

void setup() {
  size(1600, 900); // window size
  cp5=new ControlP5(this);
  fontB=createFont("NanumSquareRoundB.ttf", 33);
  fontR=createFont("NanumSquareRoundR.ttf", 18);
  fontL=createFont("NanumSquareRoundL.ttf", 20);
  PImage search_button_images[]={loadImage("button1.png"),loadImage("button2.png"),loadImage("button3.png")};
  for(PImage i:search_button_images) i.resize(45,45);

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
    .setColorBackground(color(60)).setColorActive(color(128)).setColorForeground(0xff000000).setImages(search_button_images);
}

void textSubmit() {
  // search corresponding games
  delay(100);
  if (criteria.getLabel()=="Criteria") {
    // Did not choose the criteria
    showMessageDialog(null, "Select the criteria.", "Alert", ERROR_MESSAGE);
  } else if (searchText.getText().length()==0) {
    // Did not input any text
    showMessageDialog(null, "Type the keywords.", "Alert", ERROR_MESSAGE);
  } else {
    // normal case
    String keywords=searchText.getText();
    switch((int)criteria.getValue()) {
    case 0:
      searchData=getDataFromAPI(keywords, "", "", 1);
      break;
    case 1:
      searchData=getDataFromAPI("", keywords, "", 1);
      break;
    case 2:
      searchData=getDataFromAPI("", "", keywords, 1);
      break;
    }
  }
  delay(100);
  searchText.setText("");
}

void draw() {
  background(255);
  decorating();
}

void decorating() {
  stroke(0); 
  fill(0);
  line(20, 125, 1580, 125);
  
  textFont(fontB);
  textAlign(LEFT, TOP);
  text("Game Search Engine (3308 Hwibing) ", 30, 45);
}

void keyPressed() {
  if (searchText.isActive() && keyCode==ENTER) textSubmit();
}
