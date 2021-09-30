// Easy: 4x4, 9 difficulty
// Normal: 5x5, 7 difficulty
// Hard: 6x6, 5 difficulty
// Impossible: 7x7, 3 difficulty

float app_size = 600;

String state = "Start";

String[] modes_list = {"Easy", "Normal", "Hard", "Impossible"};
int mode = 0;

int grid;
float diff;

float timer;
int score = 0;
int wrong_clicks = 0;
int max = 25;

float click_zone_x;
float click_zone_y;
float click_zone_size;

float line_y = app_size * (40.0/900);

void settings() {
  size(round(app_size), round(app_size*(950.0/900)));
}

void setup(){
  colorMode(HSB, 360, 100, 100);
  fill(0, 0, 0);
  noStroke();
  textSize(app_size/30);
}

void draw(){
  if (state == "Start"){
    background(0, 0, 100);
    fill(0, 0, 0);
    text("Number of puzzles: " + max + " (Recommended: 25)", line_y/3, line_y * 1);
    text("Use z and x to adjust this value.", line_y/3, line_y * 2);
    text("Difficulty: " + modes_list[mode], line_y/3, line_y * 3);
    text("Use c and v to adjust this value.", line_y/3, line_y * 4);
    text("Press r to restart at any time.", line_y/3, line_y * 5);   
    text("Click anywhere to begin.", line_y/3, line_y * 7);
    
    switch (modes_list[mode]){
      case "Easy":
        grid = 4;
        diff = 9;
        break;
      case "Normal":
        grid = 5;
        diff = 7;
        break;
      case "Hard":
        grid = 6;
        diff = 5;
        break;
      case "Impossible":
        grid = 7;
        diff = 3;
        break;
    }
  }
  
  if (state == "Game"){
    fill(0, 0, 100);
    rect(0, 0, app_size, app_size/7.5);
    fill(0, 0, 0);
    float current_time = (millis() - timer)/1000;
    text("Correct: " + score + "/" + max, line_y/4, line_y); 
    text("Incorrect: " + wrong_clicks, line_y/4, line_y * 2);
    textAlign(RIGHT);
    text("Timer: " + nf(current_time, 0, 2) + " seconds", app_size - line_y/4, line_y);
    textAlign(LEFT);
  }
  
  if (state == "End"){
    background(0, 0, 100);
    fill(0, 0, 0);
    
    float timer_seconds = timer/1000;
    float timer_avg = timer_seconds/max;
    float accuracy = float(max)/(max + wrong_clicks) * 100;
    
    text("Congratulations", line_y/3, line_y);
    text("You beat " + modes_list[mode] + " Mode (" + max + ") in " + nf(timer_seconds, 0, 3) + " seconds.", line_y/3, line_y * 2);
    text("Average speed: " + nf(timer_avg, 0, 3) + " seconds per puzzle.", line_y/3, line_y * 3);
    text("Wrong answers: " + wrong_clicks, line_y/3, line_y * 4);
    text("Accuracy: " + nf(accuracy, 0, 2) + "%", line_y/3, line_y * 5);
    text("Click anywhere to restart the game.", line_y/3, line_y * 6);
  }
}

void keyPressed(){
  if (state == "Start"){
    if (key == 'z' || key == 'Z'){
      if (max > 1) {
        max--;
      }
    }
    if (key == 'x' || key == 'X'){
      if (max < 100) {
        max++;
      }
    }
    if (key == 'c' || key == 'C'){
      if (mode > 0) {
        mode--;
      }
    }
    if (key == 'v' || key == 'V'){
      if (mode < modes_list.length - 1) {
        mode++;
      }
    }
  }
  
  if (state == "Game" || state == "End"){
    if (key == 'r' || key == 'R'){
      background(0, 0, 255);
      state = "Start";
    }
  }
}

void mousePressed() {
  if (state == "Start"){
    background(0, 0, 100);    
    score = 0;
    wrong_clicks = 0;
    draw_squares(app_size/18.0, app_size/7.5, app_size*(800.0/900), grid, diff);
    timer = millis();
    state = "Game";
    return;
  }
  if (state == "Game"){
    if (mouseX >= click_zone_x && mouseX <= click_zone_x + click_zone_size) {
      if (mouseY >= click_zone_y && mouseY <= click_zone_y + click_zone_size) {
        background(0, 0, 100);
        score++;
        if (score == max){
          timer = millis() - timer;
          state = "End";
        }
        else {
          draw_squares(app_size/18.0, app_size/7.5, app_size*(800.0/900), grid, diff);
        }
        return;
      }
    }
    if (mouseX >= app_size/18.0 && mouseX <= app_size/18.0 + app_size * (800.0/900)){
      if (mouseY >= app_size/9.0 && mouseY <= app_size/9.0 + app_size * (800.0/900)){
        wrong_clicks++;
      }
    }                                                                                                                                                                                                               
    return;
  }
  if (state == "End"){
    background(0, 0, 255);
    state = "Start";
    return;
  }
}

//square size: square_size * grid + square_size/10 * (grid - 1) = size  
//square_size = (10*size)/(11 * grid - 1)

void draw_squares(float x, float y, float size, int grid, float difficulty) {
  float x_pos = x;
  float y_pos = y;
  int answer_x = ceil(random(grid));
  int answer_y = ceil(random(grid));
  
  
  float h = random(360);
  float s = random(10, 90);
  float b = random(10, 90);
  
  float square_size = (10 * size)/(11 * grid - 1);
  float gap = square_size/10;
  
  int colour_change = ceil(random(2));
  color square_colour = color(h, s, b);
  color square_colour2 = square_colour;
  
  switch (colour_change){
    case 1:
      square_colour2 = color(h, s, b + difficulty);
      break;
    case 2:
      square_colour2 = color(h, s, b - difficulty);
      break;
  }
    
  for (int i = 1; i <= grid; i++){
    x_pos = x; 
    for (int j = 1; j <= grid; j++){
      fill(square_colour);
      if (j == answer_x && i == answer_y){
        fill(square_colour2);
      }
      square(x_pos, y_pos, square_size);
      x_pos += square_size + gap;
    }
    y_pos += (square_size + gap);
  }
  
  click_zone_x = x + (answer_x - 1) * (gap + square_size);
  click_zone_y = y + (answer_y - 1) * (gap + square_size);
  click_zone_size = square_size;
}
