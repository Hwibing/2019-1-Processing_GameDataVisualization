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
    if (mouseHere(x, y, w, h)) {
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

class gameRow extends clickButton {
  game game_info;
  gameRow(int tx, int ty, int tw, int th, game G) {
    // rectangle
    super(tx, ty, tw, th);
    game_info=G;
  }

  @Override
  void fillAndStroke() {
    noStroke();
    if (mouseHere(x, y, w, h)) {
      fill(gray_color/2);
    }
  }
}
