color color_list[]={#E6194B, #F58231, #FFE119, #3CB44B, #46F0F0, #4363D8, #911EB4, #F032E6};
boolean isShowingAge=true;

void showMainDisplay() {
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
    brkBtn.locate();
    textFont(fontRbig);
    fill(0);
    if (!isAnalyzing) {
      if (total_num>0) {
        if (total_num<=150) {
          // small data set
          text("Loading\n"+"(total "+total_num+" results)", width/2, height/2);
        } else {
          // big data set
          text("Loading\n"+"(total "+(loading_cnt*150<total_num ? loading_cnt*150:total_num)+"/"+total_num+" results)", width/2, height/2);
        }
      } else {
        text("Loading\n", width/2, height/2);
      }
    } else {
      text("Analyzing\n", width/2, height/2);
    }
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
      if (breaked) {
        // catching break error
        isLoading=isAnalyzing=breaked=false;
        total_num=-1;
        return;
      }
      showGames(); // game lists
      showStatistic(); // statistics
    }
  }
}

void showGames() {
  // show games and related layouts.
  // primary information
  textFont(fontL);
  textAlign(LEFT, TOP);
  fill(0);
  text("There are "+total_num+" search results for \""+keyword+"\".", 60, 160);
  text("(page "+(page+1)+"/"+(max_page+1)+")", 60, 190);

  // page buttons
  first_btn.locate();
  prev_btn.locate();
  post_btn.locate();
  last_btn.locate();

  // page buttons
  name_sort.locate();
  date_sort.locate();

  // gamerows
  for (gameRow i : list) {
    try {
      i.locate();
    }
    catch (NullPointerException e) {
      break;
    }
  }

  // last clicked game info
  textFont(fontLsmall);
  fill(64);
  noStroke();
  rect(920, 670, 620, 175);
  fill(255);
  textAlign(LEFT, TOP);
  try {
    text(last_game.toString(), 920, 670, 620, 175);
  }
  catch(NullPointerException e) {
    // None
  }
}

void showStatistic() {
  // box
  noFill();
  stroke(0);
  rect(920, 160, 620, 478); // border
  textAlign(LEFT, BOTTOM);
  textFont(fontLsmall);
  fill(0);
  text("Now showing: "+(isShowingAge ? "Age":"Year")+" data", 920, 638);

  if (isShowingAge) {
    // pie chart - age
    float lastAngle=-HALF_PI;
    int colorCnt=0;
    color mouseColor;

    // drawing pie chart
    for (String i : age_sort_result) {
      stroke(0);
      fill(color_list[colorCnt]);
      arc(1230, 399, 450, 450, lastAngle, lastAngle+(float)age.get(i)/total_num*TWO_PI); // drawing sector
      lastAngle+=(float)age.get(i)/total_num*TWO_PI;
      colorCnt+=1; // changing color
    }

    // textbox
    mouseColor=get(mouseX, mouseY); // get the color of mouse-located pixel
    for (int i=0; i<8; i+=1) {
      if (mouseColor==color_list[i]) {
        // mouse is here
        fill(255);
        stroke(0);
        rect(mouseX, mouseY-50, 125, 50);
        textFont(fontLsmall);
        fill(0);
        text(" "+age_sort_result.get(i)+"\n "+((float)age.get(age_sort_result.get(i))/total_num*100)+"%", mouseX, mouseY-50, 125, 50); // text (age and percentage)
      }
    }
  } else {
    // histogram and line graph - year
    // pillar
    float pillar_height=0;
    int max_year_value=max(year_arrange_result);
    for (int i=0; i<10; i+=1) {
      fill(0);
      stroke(255);
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195); // calculating pillar height
      rect(945+57*i, pillar_height, 57, 575-pillar_height);
    }

    // axis
    stroke(0);
    for (int i=0; i<=10; i+=1) {
      fill(0);
      textAlign(CENTER, TOP);
      textFont(fontLsmall);
      text(str(int(minYear+i*year_gap)), 945+57*i, 575);
    }
    line(940, 575, 1520, 575);

    // textBox
    for (int i=0; i<10; i+=1) {
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      if (mouseHere(945+57*i, (int)pillar_height, 57, 575-(int)pillar_height)) {
        fill(255);
        stroke(0);
        rect(mouseX, mouseY-50, 125, 50);
        textFont(fontLsmall);
        fill(0);
        text("", mouseX, mouseY-50, 125, 50); // text (age and percentage)        
      }
    }
  }
  graphBtn.locate();
}
