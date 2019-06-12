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
    if (!isAnalyzing) {
      if (total_num>0) {
        if (total_num<=150) {
          // small data set
          text("Loading...\n"+"(total "+total_num+" results)", width/2, height/2);
        } else {
          // big data set
          text("Loading...\n"+"(total "+(loading_cnt*150<total_num ? loading_cnt*150:total_num)+"/"+total_num+" results)", width/2, height/2);
        }
      } else {
        text("Loading...\n", width/2, height/2);
      }
    } else {
      text("Analyzing...\n", width/2, height/2);
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
      showGames(); // game lists
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
  try {
    fill(64);
    noStroke();
    rect(920, 670, 620, 175);
    fill(255);
    textAlign(LEFT, TOP);
    text(last_game.toString(), 920, 670, 620, 175);
  }
  catch(NullPointerException e) {
    // None
  }

  // statistics
  showStatistic();
}

void showStatistic() {
  noFill();
  stroke(0);
  rect(920, 160, 620, 478);
  line(920, 399, 1540, 399);
}
