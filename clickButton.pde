class clickButton {
  int x, y; // location
  int w, h; // width and height of the box
  int r=128, g=128, b=128; // RGB code for box color

  void locate() {
    fillAndStroke();
    rect(x, y, w, h); // drawing button
  }

  void fillAndStroke() {
    // set Button design(stroke, fill), depends on the mouse location
    noStroke();
    if (mouseHere(x, y, w, h)) {
      fill(0xFF-r, 0xFF-g, 0xFF-b);
    } else {
      fill(r, g, b);
    }
  }

  void click() {
    // nothing - should override
  }

  void setColor(int tr, int tg, int tb) {
    // setting the color of button
    r=tr;
    g=tg;
    b=tb;
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
}
