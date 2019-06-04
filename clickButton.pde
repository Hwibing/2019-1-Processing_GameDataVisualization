class clickButton {
  int x, y; // location
  int w, h; // width and height of the box
  int r=0, g=0, b=0; // RGB code for box color

  void locate() {
    fillAndStroke();
    updateMouseState();
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

  void updateMouseState() {
    // updates mouse shape
    if (mouseHere(x, y, w, h)) {
      cursor(HAND);
    } else {
      cursor(ARROW);
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

class search_q extends clickButton {
  search_q(int tx, int ty, int tw, int th) {
    // rectangle
    super(tx, ty, tw, th);
  }
}
