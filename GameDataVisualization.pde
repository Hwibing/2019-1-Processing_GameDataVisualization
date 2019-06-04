import controlP5.*;
import java.util.ArrayList;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.JOptionPane.ERROR_MESSAGE;
ControlP5 cp5;

DropdownList criteria; // search criteria
String[] criterias={"Title", "Entertainment", "Rate No."}; // criteria list
Textfield search_text; // typing area
String keyword;

XML search_result; // search result (from Game API)
int total_num=-1, page=0;
ArrayList<game> games;
gameRow[] list = new gameRow[10];

PFont fontB, fontR, fontRbig, fontL; // fonts
boolean isLoading=false; // for the "Loading" statement on the screen

void setup() {
  size(1600, 900); // window size
  cp5=new ControlP5(this);
  cp5Set();
}

void draw() {
  background(255);
  decorate();
}

void textSubmit() {
  total_num=-1; // not searched yet
  // search corresponding games
  delay(100); // to prevent the infinite-clicking
  if (criteria.getLabel()=="Criteria") {
    // Did not choose the criteria
    showMessageDialog(null, "Select the criteria.", "Alert", ERROR_MESSAGE);
    return;
  } else if (keyword.length()<3) {
    // Text is too short
    showMessageDialog(null, "Type more than 2 letters.", "Alert", ERROR_MESSAGE);
    return;
  } else {
    // normal case
    isLoading=true;
    thread("getDataFromAPI");
  }

  while (isLoading) {
    print("");
  }
  delay(100);
}

void decorate() {
  stroke(0); 
  fill(0);
  line(20, 125, 1580, 125);

  textFont(fontRbig);
  textAlign(CENTER, CENTER);
  if (isLoading) { 
    if (total_num>0) text("Loading...\n"+"(total "+total_num+" results)", width/2, height/2);
    else text("Loading...\n", width/2, height/2);
  } else {
    switch(total_num) {
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
      showGames();
    }
  }

  fill(0);
  textFont(fontB);
  textAlign(LEFT, TOP);
  text("게임 검색기 (3308 박해준)", 130, 45);
}

void cp5Set() {
  // fonts
  fontB=createFont("NanumSquareRoundB.ttf", 35);
  fontR=createFont("NanumSquareRoundR.ttf", 18);
  fontL=createFont("NanumSquareRoundL.ttf", 24);
  fontRbig=createFont("NanumSquareRoundR.ttf", 45);

  // search buttonimages
  PImage search_button_images[]={loadImage("button1.png"), loadImage("button2.png"), loadImage("button3.png")};
  for (PImage i : search_button_images) i.resize(45, 45);

  // dropdown list
  criteria=cp5.addDropdownList("Criteria", 0, 0, 148, 120) // initial position, width, max height(including items)
    .setPosition(650, 50).setItemHeight(30).setBarHeight(30) // position and item/bar height
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

void textSubmitbyClick() {
  if (isLoading) return;
  keyword=search_text.getText();
  search_text.setText(""); // make textfield empty
  thread("textSubmit");
}

void keyPressed() {
  if (isLoading) return; // ignore while loading
  if (search_text.isActive() && keyCode==ENTER) {
    // submit by pressing enter key
    keyword=search_text.getText();
    thread("textSubmit");
  }
}

void mouseClicked() {
  for (gameRow i : list) {
    if(i==null) return;
    if (mouseHere(i)) {
      // list element clicked
      i.click();
      return;
    }
  }
}
