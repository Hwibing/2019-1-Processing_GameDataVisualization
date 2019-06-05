pageButton prev_btn, post_btn; // page changing numbers
gameRow[] list = new gameRow[10]; // gamerow array

class clickButton {
  int x, y; // location
  int w, h; // width and height of the box
  int gray_color=128; // gray color value for box color

  void locate() {
    fillAndStroke();
    rect(x, y, w, h); // drawing button
  }

  void fillAndStroke() {
    // set Button design(stroke, fill), depends on the mouse location
    noStroke();
    if (mouseHere(this)) {
      fill(0xFF-gray_color);
    } else {
      fill(gray_color);
    }
  }

  void click() {
    // nothing - should override
  }

  void setColor(int tg) {
    // setting the color of button
    gray_color=tg;
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
  int page_num=0;

  pageButton(int tx, int ty, int ts) {
    // square
    super(tx, ty, ts);
  }

  @Override
  void fillAndStroke() {
    // set Button design(stroke, fill), depends on the mouse location
    if (mouseHere(this)) {
      stroke(0);
      fill(#AB149B);
    } else {
      noStroke();
      fill(#124411);
    }
  }

  @Override
  void click() {
    println(page, page_num);
    if (page+page_num<0 || page+page_num>max_page) {
      return;
    }
    page+=page_num;
    listUpdate();
    println(page, page_num);
  }

  void setPageNum(int move_page) {
    page_num=move_page;
  }
}

class gameRow extends clickButton {
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
    void locate() {
    super.locate();
    textFont(fontR);
    textAlign(CENTER, CENTER);
    fill(0);
    text(game_info.getAttribute(0), x, y, w, h);
  }

  @Override
    void click() {
    last_game=game_info;
  }
}
