class clickButton {
  int x, y; // location
  int w, h; // width and height of the box
  int r=0, g=0, b=0; // RGB code for box color

  void locate() {
    noStroke();
    if(mouseHere(x,y,w,h)) {
      // when mouse is on the button
      fill(0xFF-r, 0xFF-g, 0xFF-b);
      cursor(HAND); // clickable
    }
    else {
      fill(r, g, b);
      cursor(ARROW); // back to ordinary state
    }
    rect(x, y, w, h); // drawing button
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
