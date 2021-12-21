//Carbon Infovisual Prototype Alpha
//Project can be found at:
//https://github.com/mathijsvann/Carbon-Infovisual

boolean mouseOver = false;
boolean lock = false;
int ypos=450; //Starting position
int xpos;
int xOffset = 0; 
int yOffset = 0; 
int trans =225;

int n=7 ; //IMPORTANT: Amount of Pages. 

int [] pos = new int[n+1];
int page=0; //Starting Page
int scl=10; //Only for width
int [] track = new int[scl*10];

//Image Processing
PImage[] fragment;
PImage[] background;
String url="https://raw.githubusercontent.com/mathijsvann/Carbon-Infovisual/main/"; //Access online images stored in GitHub
int number_images = n; //Amount of background

void setup() {
  size(800, 500); //Screen Size

  //Load all icons (from Flaticon)
  fragment=new PImage[n];
  for (int k=0; k<fragment.length; k++) {
    fragment[k]=loadImage(url + str(k) + ".png");
    //fragment[k]=loadImage(str(k) + ".png"); //Offline Version
  }

  //Load all background Images
  background=new PImage[n];
  for (int i=0; i<background.length; i++) {
    background[i]=loadImage(url + str(i) + ".jpg");
    //background[i]=loadImage(str(i) + ".jpg"); //Offline Version
  }

  //Create Choice points xposition
  for (int i=0; i<n; i++) {
    pos[i]=(i+1)*width/(n+1)-(scl*5);
  }

  xpos=pos[0]; //Starting position
}

void draw() {
  background(255); //Refresh neutral background
  backGround(); //Add Background

  slider(); //Display Slider
  icon(); //Display Icons

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

  //Determine what gridpoint is closest
  for (int i=0; i<n; i++) {
    if (dist(xpos, 0, pos[i], 0) <(width/(2*n+3))) {
      page =i;
    }
  }

  if (mouseOver==false) {
    trans=100; //Seethrough when no mouse over it
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
}

void mousePressed() {
  if (mouseOver == true) {
    lock =true;
  } else {
    lock =false;
  }
  xOffset = mouseX-xpos;
}

void mouseDragged() {
  if (lock==true && mouseOver==true) {
    xpos = mouseX-xOffset;
  }
}

void mouseReleased() {
  lock = false;
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
  //println(fragment[0]);
  for (int p=0; p<n; p++) {
    if (mouseOver==false) {
      if (p==page) {
        tint(255, 200);
        image(fragment[p], pos[p]+(scl*3), 440 - (scl*4), scl*4, scl*4);//BIG ICON
      } else if (p-1==page || p+1==page) { //MEDIUM ICON
        tint(255, 110);
        image(fragment[p], (pos[p]+(scl*4)), 440 - (scl*3), scl*3, scl*3);
      } else { //SMALL ICON
        tint(255, 110);
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
        tint(255, 110);
        image(fragment[p], (pos[p]+(scl*5)), 440 - (scl*2), scl*2, scl*2);
      }
    }
  }
  tint(255, 255); //Reset Tint
}

void backGround() {
  for (int pg=0; pg<=n; pg++) {
    if (page ==pg && xpos >=pos[pg] && xpos < pos[pg+1]) {
      image(background[pg], 0, 0, width, height);
    } else if (page == pg +1 && xpos >=pos[pg] && xpos < pos[pg+1]) { //Transition to next image
      image(background[pg], 0, 0, width, height);
      image(background[pg+1], (width- (((-(pos[pg]+(dist(pos[0], 0, pos[1], 0)/2)-xpos))/(pos[pg+1]-pos[pg]))*width*2) ), 0, width, height); //Slide
    } else if (page <= 0 && page == pg && xpos <= pos[0]) {
      image(background[0], 0, 0, width, height);
    } else if (page <= (n-1) && page == pg && xpos >= pos[n-1]) {
      image(background[n-1], 0, 0, width, height);
    }
  }
}
