import controlP5.*;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.JOptionPane.ERROR_MESSAGE;
ControlP5 cp5;

DropdownList criteria; // search criteria
String[] criterias={"게임명", "배급사명", "분류번호"}; // criteria list
Textfield search_text; // typing area
String keyword;

PFont fontB, fontR, fontRbig, fontL; // fonts
boolean isLoading=false; // for the "Loading" statement on the screen

void setup() {
  size(1600, 900); // window size
  cp5=new ControlP5(this);
  cp5Set();

  // new page buttons
  first_btn=(pageButton)new pageButton(725, 160, 30).setExtreme(true).setPageNum(-1).setText("◀");
  prev_btn=(pageButton)new pageButton(760, 160, 30).setPageNum(-1).setText("←");
  post_btn=(pageButton)new pageButton(795, 160, 30).setPageNum(1).setText("→");
  last_btn=(pageButton)new pageButton(830, 160, 30).setExtreme(true).setPageNum(1).setText("▶");

  // sort buttons
  name_sort=(sortButton)new sortButton(1200, 195, 100, 30).setSort(elements[0]).setText("게임명순");
  date_sort=(sortButton)new sortButton(760, 195, 100, 30).setSort(elements[6]).setText("날짜순");
}

void draw() {
  background(255);
  decorate();
}

void textSubmit() {
  total_num=-1; // not searched yet
  last_game=null; // reset
  search_text.setText(keyword); // recovery
  date_sort.setText("날짜순 ▼");

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
    getDataFromAPI();
  }
  delay(100);
}

void decorate() {
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
    if (total_num>0) {
      if (total_num<=150) {
        // small data set
        text("Loading...\n"+"(total "+total_num+" results)", width/2, height/2);
      } else {
        // big data set
        text("Loading...\n"+"(total "+(loading_cnt*150<total_num ? loading_cnt*150:total_num)+"/"+total_num+" results)", width/2, height/2);
      }
    } else text("Loading...\n", width/2, height/2);
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
      showGames(); // game lists
    }
  }
}

void cp5Set() {
  // fonts
  fontB=createFont("NanumSquareRoundB.ttf", 35);
  fontR=createFont("NanumSquareRoundR.ttf", 20);
  fontL=createFont("NanumSquareRoundL.ttf", 24);
  fontRbig=createFont("NanumSquareRoundR.ttf", 45);

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
    search_text.setText("");
    thread("textSubmit");
  }
}

void mouseClicked() {
  if (isLoading) return;
  for (gameRow i : list) {
    if (i==null) break;
    if (mouseHere(i)) {
      // gameRow list element clicked
      i.click();
      return;
    }
  }
  if (total_num>0) { // only works if search result exists
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
    }
  }
}
