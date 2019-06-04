import controlP5.*;
import java.util.ArrayList;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.JOptionPane.ERROR_MESSAGE;
ControlP5 cp5;

DropdownList criteria; // search criteria
String[] criterias={"Title", "Entertainment", "Rate No."}; // criteria list
Textfield search_text; // typing area

XML search_result; // search result (from Game API)
int result_page=1; // result page
PFont fontB, fontR, fontL; // fonts
boolean isLoading=false; // for the "Loading" statement on the screen

void setup() {
  size(1600, 900); // window size
  cp5=new ControlP5(this);
  designSet();
}

void draw() {
  background(255);
  decorate();
}

void textSubmit() {
  // search corresponding games
  delay(100); // to stop the infinite submit

  if (criteria.getLabel()=="Criteria") {
    // Did not choose the criteria
    showMessageDialog(null, "Select the criteria.", "Alert", ERROR_MESSAGE);
    return;
  } else if (search_text.getText().length()<3) {
    // Text is too short
    showMessageDialog(null, "Type more than 2 letters.", "Alert", ERROR_MESSAGE);
    return;
  } else {
    // normal case
    isLoading=true;
    thread("getDataFromAPI");
  }

  delay(100); // to stop the infinite submit
  search_text.setText(""); // make textField empty

  while (isLoading) {
    println("Loading");
  }
  analyzeData();
}

void designSet() {
  // fonts
  fontB=createFont("NanumSquareRoundB.ttf", 35);
  fontR=createFont("NanumSquareRoundR.ttf", 18);
  fontL=createFont("NanumSquareRoundL.ttf", 20);

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
  fontR=createFont("NanumSquareRoundR.ttf", 45);

  // textfield
  search_text=cp5.addTextfield("search_text")
    .setPosition(845, 42).setSize(640, 45) // position and size
    .setColorBackground(color(60)).setColorActive(color(255, 128)).setColorForeground(0xff000000).setFont(fontL); // colors and fonts
  fontL=createFont("NanumSquareRoundL.ttf", 10);

  // bang (search button)
  cp5.addBang("textSubmit") // connecting to function 
    .setPosition(1520, 42).setSize(45, 45) // position and size
    .setImages(search_button_images); // set images
}

void decorate() {
  stroke(0); 
  fill(0);
  line(20, 125, 1580, 125);
  if (isLoading) { 
    textFont(fontR);
    textAlign(CENTER, CENTER);
    text("Loading", width/2, height/2);
  }

  textFont(fontB);
  textAlign(LEFT, TOP);
  text("게임 검색기 (3308 박해준)", 130, 45);

  try {
    textFont(fontL);
    text(search_result.toString(), 0, 0);
  } 
  catch (NullPointerException e) {
  }
}

void keyPressed() {
  if (search_text.isActive() && keyCode==ENTER) textSubmit();
}
