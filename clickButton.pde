pageButton first_btn, prev_btn, post_btn, last_btn; // page changing numbers
gameRow[] list = new gameRow[10]; // gamerow array

abstract class clickButton {
  int x, y; // location
  int w, h; // width and height of the box
  int gray_color=128; // gray color value for box color
  int text_color=0; // text color
  String label="";

  void locate() {
    fillAndStroke();
    rect(x, y, w, h); // drawing button
    textFont(fontR);
    textAlign(CENTER, CENTER);
    fill(text_color);
    text(label, x, y, w, h);
  }

  void fillAndStroke() {
    // set color and stroke
    if (mouseHere(this)) {
      stroke(0);
      fill(#0088FF);
    } else {
      noStroke();
      fill(gray_color);
    }
  }

  void click() {
    // nothing - should override
  }

  void setColor(int foo) {
    // setting the color of button
    gray_color=foo;
  }

  void setTextColor(int bar) {
    text_color=bar;
  }

  void setText(String str) {
    label=str;
  }

  int getCenterX() {
    return (x+x+w)/2;
  }

  int getCenterY() {
    return (y+y+h)/2;
  }

  clickButton(int tx, int ty, int tw, int th) {
    // rectangle
    x=tx;
    y=ty;
    w=tw;
    h=th;
  }

  clickButton(int tx, int ty, int ts) {
    // square
    x=tx;
    y=ty;
    w=ts;
    h=ts;
  }
}

class pageButton extends clickButton {
  // button which changes result page
  int page_num=0;
  boolean extreme=false; // if this is true, go to terminal page 

  pageButton(int tx, int ty, int ts) {
    // square
    super(tx, ty, ts);
    this.setColor(64);
  }

  @Override
    void fillAndStroke() {
    if (mouseHere(this)) {
      stroke(0);
      fill(#0088FF);
    } else {
      noStroke();
      fill(gray_color);
    }
  }

  @Override
    void click() {
    if (extreme) {
      if (page_num<0) {
        page=0;
      } else if (page_num>0) {
        page=max_page;
      }
      listUpdate();
    } else {
      if (page+page_num<0 || page+page_num>max_page) {
        return;
      }
      page+=page_num;
      listUpdate();
    }
  }

  void setPageNum(int move_page) {
    page_num=move_page;
  }

  void setExtreme(boolean foo) {
    extreme=foo;
  }
}

class gameRow extends clickButton {
  // shows search list
  game game_info;
  gameRow(int tx, int ty, int tw, int th, game G) {
    // rectangle
    super(tx, ty, tw, th);
    game_info=G;
    this.setColor(64);
  }

  @Override
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

  @Override
    void click() {
    last_game=game_info;
  }
}

class sortButton extends clickButton {
  // changes the way of sorting 
  int sort_way;

  sortButton(int tx, int ty, int tw, int th) {
    super(tx, ty, tw, th);
  }

  void setSort(int n) {
    sort_way=n;
  }

  @Override
    void click() {
  }
}
