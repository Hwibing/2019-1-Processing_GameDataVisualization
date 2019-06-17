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
          text("Loading\n"+"(total "+(loading_cnt*loading_gap<total_num ? loading_cnt*loading_gap:total_num)+"/"+total_num+" results)", width/2, height/2);
          textAlign(LEFT, TOP);
          textFont(fontRmini);
          text("3000개 이상의 결과는 서버의 오류를 초래할 수 있습니다.", 20, 125);
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
        println("catched break error");
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
    textFont(fontRmini);
    textAlign(LEFT, TOP);
    text("데이터가 적으면 제대로 표시되지 않을 수 있습니다.", 920, 160);
    float pillar_height=0;
    int max_year_value=max(year_arrange_result);
    for (int i=0; i<10; i+=1) {
      fill(#6699CC);
      stroke(255);
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195); // calculating pillar height
      rect(1008.6+44.3*i, pillar_height, 44.3, 575-pillar_height);
    }

    // line graph - point
    for (int i=0; i<10; i+=1) {
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      fill(0);
      noStroke();
      ellipse(1008.6+44.3*i+22.2, pillar_height, 3, 3);
    }

    // line graph - line
    for (int i=1; i<10; i+=1) {
      float pillar_height1=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      float pillar_height2=map(year_arrange_result[i-1], 0, max_year_value, 575, 195);
      stroke(0);
      line(1008.6+44.3*i+22.2, pillar_height1, 1008.6+44.3*(i-1)+22.2, pillar_height2);
    }
    line(1030.8, map(year_arrange_result[0], 0, max_year_value, 575, 195), 986.4, 575);
    line(1429.5, map(year_arrange_result[9], 0, max_year_value, 575, 195), 1473.8, 575);

    // axis
    stroke(0);
    for (int i=0; i<=10; i+=1) {
      fill(0);
      textAlign(CENTER, TOP);
      textFont(fontRmini);
      text(str(int(minYear+i*year_gap)), 1008.6+44.3*i, 575);
      line(1008.6+44.3*i, 573, 1008.6+44.3*i, 577); // gradation
    }
    line(940, 575, 1520, 575);

    // textBox
    for (int i=0; i<10; i+=1) {
      pillar_height=map(year_arrange_result[i], 0, max_year_value, 575, 195);
      if (mouseHere(1008.6+44.3*i, pillar_height, 44.3, 575-pillar_height)) {
        fill(255);
        stroke(0);
        rect(mouseX, mouseY-50, 125, 50);
        textFont(fontLsmall);
        fill(0);
        text(str(int(minYear+i*year_gap))+"~"+str(int(minYear+(i+1)*year_gap))+"\n"+str(year_arrange_result[i]), mouseX, mouseY-50, 125, 50);
      }
    }
  }
  graphBtn.locate();
}
