//Carbon Infovisual Prototype Beta
//Project can be found at:
//https://github.com/mathijsvann/Carbon-Infovisual

int screenstate=0; //What state is the screen in

boolean mouseOver = false; //Slider lock
boolean lock = false;

boolean locked = false;  //Pop-Up lock
boolean mouseOverP = false;
boolean popup = false;
//Pop-Up x and y values
int ax=0;
int ey=0;
int fx=0;
int fy=0;

float kWh=5000; //Starting value for demo purposes
float kWhLM=5200; //Last Month

boolean mouseOverCR = false; //Circle Right top
boolean mouseOverCL = false; //Circle Left top
boolean pressCR = false;
boolean pressCL = false;

int ypos=450; //Starting position
int xpos;
int xOffset = 0; 
int yOffset = 0; 
int trans =225;

int n=4 ; //IMPORTANT: Amount of Pages. 

int [] pos = new int[n+1];
int page=0; //Starting Page
int scl=10; //Only for width
int [] track = new int[scl*10];

//Image Processing
PImage[] fragment;
PImage[] general;

PImage[] background;
int k = 2; //Amount of background images per folder. 2 -> A medium and great performance

PImage[]otherIcons;
int icons=5; // [PLUS/SETTINGS/RETURN*2]
int home=0;

String url="https://raw.githubusercontent.com/mathijsvann/Carbon-Infovisual/main/"; //Access online images stored in GitHub

int grbr=0; //General Bracket for progress

int clicktimer=0;

void setup() {
  size(800, 500); //Screen Size

  //Load all icons (from Flaticon)
  fragment=new PImage[n];
  for (int k=0; k<fragment.length; k++) {
    fragment[k]=loadImage(url + str(k) + ".png");
    //fragment[k]=loadImage(str(k) + ".png"); //Offline Version
  }

  //Load all General Images
  background=new PImage[n];
  for (int i=0; i<background.length; i++) {
    background[i]=loadImage(url + str(i) + ".jpg");
    //background[i]=loadImage(str(i) + ".jpg"); //Offline Version
  }

  //Create Choice points xposition
  for (int i=0; i<n; i++) {
    pos[i]=(i+1)*width/(n+1)-(scl*5);
  }

  //Load all General Images
  general=new PImage[n];
  for (int i=0; i<general.length; i++) {
    general[i]=loadImage(url + str(i) + ".jpg");
    //general[i]=loadImage(str(i) + ".jpg"); //Offline Version
  }

  //Load all Background Images
  background=new PImage[n*k];
  int r=0;
  while (r<(n*k)) {
    for (int z=0; z<n; z++) {
      for (int i=0; i<k; i++) {
        background[r]=loadImage(url + str(z) + "/" + str(i) + ".jpg");
        r+=1;
      }
    }
  }

  //Load all Background Images
  otherIcons=new PImage[icons];
  for (int i=0; i<otherIcons.length; i++) {
    otherIcons[i]=loadImage(url + "logonav/" + i + ".png");
    //otherIcons[i]=loadImage("logonav/" + ".png"); //Offline Version
  }

  xpos=pos[0]; //Starting position
}

void draw() {
  background(200); //Background seen in fade out
  backGround(); //Add Background

  //CircleLeft
  if (dist(mouseX, mouseY, 20, 20)<50) {
    mouseOverCL=true;
  } else {
    mouseOverCL=false;
  }

  //CircleRight
  if (dist(mouseX, mouseY, width-20, 20)<50) {
    mouseOverCR=true;
  } else {
    mouseOverCR=false;
  }

  //INSERT OPTION OF WHAT SCREEN IT WILL SHOW.

  //Draw Side Box Left
  pushMatrix();
  translate(20, 20);

  //INSERT TEXT
  //https://www.youtube.com/watch?v=woaR-CJEwqc Table Loading


  fill(255, 160);
  beginShape();
  for (int a=0; a<90; a++) {
    vertex(50 * sin(PI * 2 * a / 360), 50* cos(PI * 2 * a / 360));
  }
  vertex(250, 0);   //Size box.
  vertex(250, 300);
  vertex(0, 300);
  endShape();
  if (screenstate==0) {
    home=0; //Set home to 0.
    for (int q=0; q<40; q++) { //Create Fade Out 
      fill(255, 160-q*4);
      rect(0, 300+q*2, 250, 2);
    }
  }
  popMatrix();

  //Define if Mouse is Over Pop-Up on the Right
  if (mouseX>width-220+ax && mouseX<width-20 && mouseY>20 && mouseY < 80+ey && mouseOverCR==false) { //Square Inside when not activated
    mouseOverP = true;
  } else {
    mouseOverP =false;
  }

  //Determine Lock on Pop-Up
  if (popup == false && locked == true) {
    popup = true;
  } else if (popup == true && locked == true) {
    popup = false;
  }


  //Draw Side Box Right
  pushMatrix();
  translate(width-270, 20);

  fill(255, 160);
  beginShape();
  for (int a=270; a<360; a++) {
    vertex(250 + (50 * sin(PI * 2 * a / 360)), 50* cos(PI * 2 * a / 360));
  }
  vertex(250, 60);   //D
  vertex(50, 60); //C
  vertex(50, 0); //B
  endShape();

  //Extending part
  beginShape();
  if (popup ==true && screenstate==0) {
    if (ey<80) {
      ax -= (50/8);
      ey += 10;
      fx -= (50/8);
      fy += 10;
      locked=false;
    }
  } else if (popup==false && screenstate==0) {
    if (ey>0) {
      ax += (50/8);
      ey -= 10;
      fx += (50/8);
      fy -= 10;
      locked=false;
    } else if (screenstate!=0) {
      ax = 0;
      ey = 0;
      fx = 0;
      fy = 0;
    }
  }
  vertex(50+ax, 0); //A
  vertex (50, 0); //B
  vertex(50, 60); //C
  vertex(250, 60); //D
  vertex(250, 60+ey); //E
  vertex(50+fx, 60+ey); //F
  endShape();

  //Text
  textSize(40);
  fill(0);
  text("Tips", 80, 35);

  popMatrix();

  slider(); //Display Slider
  icon(); //Display Icons

  //Calculate Bracket
  grbr=0;

  if (screenstate==0) { //Determine if Screen is in the main state
    //Determine if mouse is over position
    if (mouseX >= xpos && mouseX < xpos + scl*10) {  //X-Position. < instead of <= to make sure track[int(abs(mouseX-xpos))] doesn't create an error down the line
      if (mouseY >= ypos+50 && mouseY <= ypos + 300) {  //Y-Position rect.
        mouseOver = true;
        trans=225;
      }

      //Determine if over top triangle
      if (mouseY >= ypos && mouseY < ypos+50) { //Left side triangle
        for (int i=0; i<(scl*5); i++) {
          track[i]=ypos+50-i;
          if (int(mouseY) > track[int(abs(mouseX-xpos))]) { 
            mouseOver = true;
            trans=225;
          } else {
            mouseOver = false;
          }
        }
        for (int i=50; i<(scl*10); i++) { //Right side triangle
          track[i]=ypos+(i-50);
          if (int(mouseY) > track[int(abs(mouseX-xpos))]) {
            mouseOver = true;
            trans=225;
          } else {
            mouseOver = false;
          }
        }
      } else if (mouseY<ypos) {
        mouseOver = false;
      }
    } else {
      mouseOver = false;
    }
  }

  println(home);

  //Inser Button Left
  if (mouseOverCL==true) {
    tint(255, 240);
    if (pressCL ==true) {
      if (screenstate!=1) {
        screenstate=1;
        home+=1;
        pressCL=false;
      } else if (screenstate ==1) {
        screenstate=0;
        pressCL=false;
      }
    }
  } else {
    tint(255, 160);
  }
  if (screenstate!=1) { 
    image(otherIcons[0], 10, 10, 40, 40);
  } else if (home<=1){ //Make sure that with multiple presses home buton appears
    image(otherIcons[2], 10, 10, 40, 40);
  }
  else{
  image(otherIcons[4], 10, 10, 40, 40);
  }

  //Insert Button Right
  if (mouseOverCR==true) {
    tint(255, 240);
    if (pressCR ==true) {
      if (screenstate!=2) {
        home+=1;
        screenstate=2;
        pressCR=false;
      } else if (screenstate ==2) {
        screenstate=0;
        pressCR=false;
      }
    }
  } else {
    tint(255, 160);
  }
  if (screenstate!=2) { 
    image(otherIcons[1], width-50, 10, 40, 40);
  } else if (home<=1){
    image(otherIcons[3], width-50, 10, 40, 40);
  }
  else{
    image(otherIcons[4], width-50, 10, 40, 40);
  }
  tint(255, 255);//Reset Transperancy

  //Determine what gridpoint is closest
  for (int i=0; i<n; i++) {
    if (dist(xpos, 0, pos[i], 0) <(width/(2*n+3))) {
      page =i;
    }
  }

  if (mouseOver==false) {
    trans=180; //Seethrough when no mouse over it
  }

  //Fluently move Slider to Page position
  if (lock == false) {
    if (dist(xpos, 0, pos[page], 0)<6) {
      xpos=pos[page];
    } else if (xpos-pos[page]>5) {
      xpos -=5;
    } else if (xpos-pos[page]<5) {
      xpos +=5;
    }
  }

  //Draw ScreenStates 1 and 2 netural background
  if (screenstate !=0) {
    fill(255, 160);
    rect(20, 320, 250, height-340); //Under Left Bar
    rect(270, 20, width-490, height-40); //Middle Slap
    rect(width-220, 80, 200, height-100); //Under Right Bar
  }
}

void mousePressed() {
  //MouseOverSlider
  if (mouseOver == true && screenstate==0) { 
    lock =true;
  } else {
    lock =false;
  }
  xOffset = mouseX-xpos;

  //MouseOverPopUp
  if (mouseOverP == true && screenstate==0) {
    locked=true;
  } else {
    locked=false;
  }

  //Making Buttons Left and Right Clickable
  if (mouseOverCR==true) {
    pressCR=true;
  } else {
    pressCR=false;
  }
  if (mouseOverCL==true) {
    pressCL=true;
  } else {
    pressCL=false;
  }
}

void mouseDragged() {
  if (lock==true && mouseOver==true) {
    xpos = mouseX-xOffset;
  }
}

void mouseReleased() {
  lock = false;
  pressCR=false;
  pressCL=false;
}

void slider() { //Determine Slider
  pushMatrix();
  translate(xpos, ypos);
  if (mouseOver == true && ypos >= 420) { //Go up. Add [&& lock==true] if only move up when pressed.
    ypos -= 5;
  } else if (mouseOver == false && ypos <= 450) { //Go Down
    ypos += 5;
  }
  //Draw Arrow
  fill(102, trans); //Color and oppacity
  scale(scl, 10); //Size
  noStroke();
  beginShape();
  vertex(0, 5);
  vertex(0, 25);
  vertex(10, 25);
  vertex(10, 5);
  vertex(5, 0);
  endShape(CLOSE);
  popMatrix();
}

void icon() { //Show icon above arrow
  fill(100);
  noStroke();
  if (screenstate==0) {
    for (int p=0; p<n; p++) {
      if (mouseOver==false) {
        if (p==page) {
          tint(255, 200);
          image(fragment[p], pos[p]+(scl*3), 440 - (scl*4), scl*4, scl*4);//BIG ICON
        } else if (p-1==page || p+1==page) { //MEDIUM ICON
          tint(255, 160);
          image(fragment[p], (pos[p]+(scl*4)), 440 - (scl*3), scl*3, scl*3);
        } else { //SMALL ICON
          tint(255, 160);
          image(fragment[p], (pos[p]+(scl*5)), 440 - (scl*2), scl*2, scl*2);
        }
      } else if (mouseOver ==true) { //When mouse is over Icon
        if (p==page) {
          tint(255, 255);
          image(fragment[p], pos[p]+(scl*3), 400 - (scl*4), scl*4, scl*4);//BIG ICON
        } else if (p-1==page || p+1==page) { //MEDIUM ICON
          tint(255, 200);
          image(fragment[p], (pos[p]+(scl*4)), 420 - (scl*3), scl*3, scl*3);
        } else { //SMALL ICON
          tint(255, 160);
          image(fragment[p], (pos[p]+(scl*5)), 440 - (scl*2), scl*2, scl*2);
        }
      }
    }
    tint(255, 255); //Reset Tint
  }
}

void backGround() {
  for (int pg=0; pg<=n; pg++) {
    if (page ==pg && xpos >=pos[pg] && xpos < pos[pg+1]) {
      image(background[pg], 0, 0, width, height);
    } else if (page == pg +1 && xpos >=pos[pg] && xpos < pos[pg+1]) { //Transition to next image
      tint(255, 255+5*((pos[pg]+(dist(pos[0], 0, pos[1], 0)/2)-xpos)));
      image(background[pg], 0, 0, width, height);
      tint(255, 255);
      image(background[pg+1], (width- (((-(pos[pg]+(dist(pos[0], 0, pos[1], 0)/2)-xpos))/(pos[pg+1]-pos[pg]))*width*2) ), 0, width, height); //Slide
    } else if (page <= 0 && page == pg && xpos <= pos[0]) {
      image(background[0], 0, 0, width, height);
    } else if (page <= (n-1) && page == pg && xpos >= pos[n-1]) {
      image(background[n-1], 0, 0, width, height);
    }
  }
}
