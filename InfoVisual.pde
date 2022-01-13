//Carbon Infovisual Prototype Beta
//Project can be found at:
//https://github.com/mathijsvann/Carbon-Infovisual
//
//Made by Mathijs van Nieuwenhuijsen, BSc

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

//Measure Progress
float kWh=15569; //Starting value for demo purposes
float kWhLM=19420; //Last Month Value
float kWhA= 21382;//Last Month based on https://www.nibud.nl/consumenten/energie-en-water/ + kilometers https://www.cbs.nl/nl-nl/visualisaties/verkeer-en-vervoer/verkeer/verkeersprestaties-personenautos + gas https://learnmetrics.com/m3-gas-to-kwh/
int addingValue=0;
boolean checkmark=false;
int [] addedValues = new int [64]; //Add recently added values

int grbr=0; //General Bracket for progress

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
boolean [] overIcon= new boolean[n];

boolean [] numkey = new boolean[12]; //Amount of keys
int popupwarning=0;
int popupAdd=0;
boolean rowShift=false;
boolean rowDelete=false;
int deleteRow=0;
boolean rowDeleteA=false;

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
int icons=7; // [PLUS/SETTINGS/RETURN*2/HOME/2*CALC]
int home=0;

//Get Fonts Variables
PFont arial;
PFont arialbld;
PFont arialblk;

String ipsum="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ";

String url="https://raw.githubusercontent.com/mathijsvann/Carbon-Infovisual/main/"; //Access online images stored in GitHub


void setup() {
  size(800, 500); //Screen Size

  //Get Fonts
  arial=createFont(url + "fonts/arial.ttf", 28); //Text for Numpad
  arialbld=createFont(url +"fonts/arialbld.ttf", 100);
  arialblk=createFont(url +"fonts/arialblk.ttf", 50);

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

  //Draw Side Box Left
  pushMatrix();
  translate(20, 20);
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
  if (screenstate!=0){
    popup=false;
  }
  
  //Add Title Text Based on Variable
  if (screenstate==0) {
    fill(#2196f3, 230);
    textFont(arialblk);
    textSize(22);
    if (page==0) {
      text("OVERVIEW", 65, 40);
    }
    if (page==1) {
      text("NATURE", 80, 40);
    }
    if (page==2) {
      text("WATER", 90, 40);
    }
    if (page==3) {
      text("ANIMALS", 75, 40);
    }

    //Addd Basic Text Based on  Variable
    fill(0, 210);
    textFont(arial);
    textSize(15);
    text(ipsum, 20, 100, 210, 200);
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
  } else if (screenstate!=0) {
    ax = 0;
    ey = 0;
    fx = 0;
    fy = 0;
  }
  vertex(50+ax, 0); //A
  vertex (50, 0); //B
  vertex(50, 60); //C
  vertex(250, 60); //D
  vertex(250, 60+ey); //E
  vertex(50+fx, 60+ey); //F
  endShape();

  //Text
  if (screenstate==0) {
    if (popup==false) {
      fill(#2196f3, 140);
    }
    if (popup==true) {
      fill(#2196f3, 230);
    }
    textFont(arialblk);
    textSize(22);
    textAlign(CENTER);
    text("Tips", 125, 40);
    textAlign(LEFT);
  }

  textFont(arial);
  textSize(15);
  fill(0, (255*ey)/80);
  text(ipsum, 20, 70, 210, 70);

  popMatrix();

  if (screenstate==0) { //Only When Screen Is Main
    slider(); //Display Slider
    icon(); //Display Icons
  }

  //Calculate KwH Bracket
  if (int((1-(kWh/kWhLM))*100)>15) {
    grbr=1;
  } else {
    grbr=0;
  }

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

  //Inser Button Left
  if (mouseOverCL==true) {
    tint(255, 240);
    if (pressCL ==true) {
      if (screenstate!=1) {
        addingValue=0; //Reset Value when starting
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
  } else if (home<=1) { //Make sure that with multiple presses home buton appears
    image(otherIcons[2], 10, 10, 40, 40);
  } else {
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
  } else if (home<=1) {
    image(otherIcons[3], width-50, 10, 40, 40);
  } else {
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
  //When User can Add Data
  if (screenstate==1) {
    textFont(arial);
    textSize(17);
    fill(0, 250);
    text("Enter total amount of km driven", (width/2)-115, 100);
    textFont(arialblk);
    if (popupwarning>0) {
      fill(0, 250-popupwarning);
    }
    text(addingValue, (width/2)-115, 160);
    notepad();
    if (popupwarning>0) {
      fill(#f32121, popupwarning);
      textFont(arialblk);
      text("VALUE TOO HIGH", (width/2)-230, 160);
      popupwarning-=10;
    }
  }

  //Add Succes of Adding Kilomters
  if (popupAdd>0) {
    fill(#21f330, popupAdd);
    textFont(arialblk);
    text("KILOMETERS SAVED", (width/2)-260, 160);
    popupAdd-=10;
  }

  //All Data Screen
  if (screenstate==2) {
    pushMatrix();
    translate(100, 150); //Move into prosition

    //Header
    fill(#2196f3, 230);
    textFont(arialblk);
    textSize(28);
    textAlign(RIGHT);
    text("DATA", 75, 0);

    //Value Indicators
    fill(0, 190);
    textFont(arialbld);
    textSize(22);
    textAlign(CENTER);
    text("kWh", 150, 0);
    text("kg/CO2", 250, 0);

    //Added Indicator
    textAlign(LEFT);
    text("Recently Added", 450, 0);

    //Period & Progress Indicator
    textSize(21);
    textAlign(RIGHT); //Makes text push to the right instead of left.
    text("Last Month", 75, 50);
    text("This Month", 75, 100);
    text("Progress", 75, 150);
    text("%", 75, 200);
    textAlign(LEFT);

    //VALUES
    textFont(arial);
    textSize(20);
    textAlign(CENTER);

    //kWh
    text(int(kWhLM), 150, 50);
    text(int(kWh), 150, 100);
    text(int(kWhLM-kWh), 150, 150);

    //kg/CO2 (0.233kg CO2 per kWh) https://www.rensmart.com/Calculators/KWH-to-CO2
    text(int(0.233*kWhLM), 250, 50);
    text(int(0.233*kWh), 250, 100);
    text(int((0.233*kWhLM)-(kWh*0.233)), 250, 150);
    text(int((1-(kWh/kWhLM))*100), 250, 200);
    textAlign(LEFT); //Reset Text Align!

    //Added Values Strings
    for (int i=0; i<4; i++) { //-1 due to layout. looks better
      if (addedValues[i]!=0) {
        text(addedValues[i] + " km by car", 450, 50*(i+1));
        if (mouseX>750 && mouseX<780 && mouseY>50*(i+3)&& mouseY<50*(i+4)) {
          fill(#a01616, 240);
          deleteRow=i;
          rowDelete=true;
        } else {
          fill(#a01616, 150);
        }
        text("-", 650, 50*(i+1));
        fill(0, 190);
      }
    }

    //Aesthetic Buttons Witouth Value
    for (int i=0; i<3; i++) {
      if (mouseX>225*i+100 && mouseX<225*i+280 && mouseY>400 && mouseY<450) {
        fill(#79bcf2, 245);
      } else {
        fill(#79bcf2, 200);
      }
      rect(225*i, 250, 180, 50);
    }
    popMatrix();
  }

  //Calculate row shift
  if (rowShift==true) {
    for (int i=4; i>-1; ) {
      if (i!=0) {    
        addedValues[i]=addedValues[i-1]; //Add to Added Values String for 'All Numbers'
      }
      if (i==0) {
        addedValues[0]=addingValue;
        rowShift=false;
        screenstate=0;
      }
      i-=1;
    }
  }


  //Delete value from row
  if (rowDeleteA==true) {
    for (int i=deleteRow; i<(addedValues.length-1); i++) {
      addedValues[i]=addedValues[i+1];
      if (i==addedValues.length-2) {
        rowDeleteA=false;
        rowDelete=false;
      }
    }
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

  //Calculations of Added Value 
  if (screenstate==1) {
    for (int l=0; l<12; l++) {
      if (numkey[l]==true && mouseOverCL==false) { //OverCL makes sure pop up of l=11 doesn't show up when pressed
        if (l<9) { //Adding Value
          addingValue=(addingValue*10)+l+1;
          if (addingValue>=9999999) {
            addingValue=0; //Add reset pop-up
            popupwarning=800;
          }
          numkey[l]=false;
        } else if (l==9) { //Reset
          addingValue=0;
          numkey[l]=false;
        } else if (l==10) { //Press 0
          addingValue=addingValue*10;
          if (addingValue>=9999999) {
            addingValue=0; //Add reset pop-up
            popupwarning=800;
          }
        } else if (l==11) {
          if (addingValue !=0) {
            popupAdd=1000;
            kWh+=addingValue*0.83; //https://www.researchgate.net/figure/The-comparison-of-energy-consumption-of-per-kilometer-in-fuel-vehicle-and-EV-From-figure_fig1_334693982
            rowShift=true;
            checkmark=true;
          }
        }
      }
    }
  }

  //Moving to Page by PRESSING icon. Other part of code in [void icon()]
  for (int pl=0; pl<n; pl++) {
    if (overIcon[pl]==true) {
      xpos=pos[pl];
    }
  }

  if (rowDelete==true) {
    kWh-=(addedValues[deleteRow])*0.83;
    rowDeleteA=true;
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
  for (int p=0; p<n; p++) {
    if (mouseOver==false) {
      if (p==page) {
        tint(255, 240);
        image(fragment[p], pos[p]+(scl*3), 440 - (scl*4), scl*4, scl*4);//BIG ICON
      } else if (p-1==page || p+1==page) { //MEDIUM ICON
        tint(255, 220);
        image(fragment[p], (pos[p]+(scl*4)), 440 - (scl*3), scl*3, scl*3);
      } else { //SMALL ICON
        tint(255, 200);
        image(fragment[p], (pos[p]+(scl*5)), 440 - (scl*2), scl*2, scl*2);
      }
    } else if (mouseOver ==true) { //When mouse is over Icon
      if (p==page) {
        tint(255, 255);
        image(fragment[p], pos[p]+(scl*3), 400 - (scl*4), scl*4, scl*4);//BIG ICON
      } else if (p-1==page || p+1==page) { //MEDIUM ICON
        tint(255, 230);
        image(fragment[p], (pos[p]+(scl*4)), 420 - (scl*3), scl*3, scl*3);
      } else { //SMALL ICON
        tint(255, 215);
        image(fragment[p], (pos[p]+(scl*5)), 440 - (scl*2), scl*2, scl*2);
      }
    }
  }
  tint(255, 255); //Reset Tint

  //Determine if mouse is over Icon
  if (mouseOver==false) {
    for (int pc=0; pc<n; pc++) {
      if (pc==page) {
        if (mouseX>pos[pc]+(scl*3) && mouseX<pos[pc]+(scl*7) && mouseY>440 - (scl*4) && mouseY<440) {
          overIcon[pc]=true;
        } else {
          overIcon[pc]=false;
        }
      } else if (pc-1 ==page || pc+1 ==page) {
        if (mouseX>pos[pc]+(scl*4) && mouseX<pos[pc]+(scl*7) && mouseY>440 - (scl*3) && mouseY<440) {
          overIcon[pc]=true;
        } else {
          overIcon[pc]=false;
        }
      } else {
        if (mouseX>pos[pc]+(scl*5) && mouseX<pos[pc]+(scl*7) && mouseY>440 - (scl*2) && mouseY<440) {
          overIcon[pc]=true;
        } else {
          overIcon[pc]=false;
        }
      }
    }
  }
}

void backGround() {
  for (int pg=0; pg<=n; pg++) {
    //Bad or Good Image
    int pgb;
    if (grbr==0) {
      pgb=pg*2;
    } else {
      pgb=(pg*2)+1;
    }
    if (page ==pg && xpos >=pos[pg] && xpos < pos[pg+1]) {
      image(background[pgb], 0, 0, width, height);
    } else if (page == pg +1 && xpos >=pos[pg] && xpos < pos[pg+1]) { //Transition to next image
      tint(255, 255+5*((pos[pg]+(dist(pos[0], 0, pos[1], 0)/2)-xpos)));
      image(background[pgb], 0, 0, width, height);
      tint(255, 255);
      image(background[pgb+2], (width- (((-(pos[pg]+(dist(pos[0], 0, pos[1], 0)/2)-xpos))/(pos[pg+1]-pos[pg]))*width*2) ), 0, width, height); //Slide
    } else if (page <= 0 && page == pg && xpos <= pos[0]) {
      image(background[grbr], 0, 0, width, height);
    } else if (page <= (n-1) && page == pg && xpos >= pos[n-1]) {
      image(background[(n*2)-2+grbr], 0, 0, width, height);
    }
  }
}

void notepad() {    
  pushMatrix();
  translate((width/2)-120, 180); //Position Notepad
  int numberpad=0;
  for (int row=0; row<=3; row ++) { //Create a grid
    for (int col=0; col<=2; col++) {
      textFont(arial);
      if (mouseX>(80*col)+5+(width/2)-120 && mouseX<(80*(col+1))-5+(width/2)-120 && mouseY>(50*row)+185 && mouseY<(50*(row+1)+175)) {
        stroke(#79bcf2, 250);
        strokeWeight(2);
        fill(#79bcf2, 250);
        numkey[numberpad]=true;
      } else {
        noStroke();
        fill(#79bcf2, 180);
        numkey[numberpad]=false;
      }
      rect((80*col)+5, (50*row)+5, 70, 40, 2);
      fill(0, 220);
      if (numberpad<9) {
        text(numberpad+1, (80*col)+33, row*50+35);
      } else if (numberpad ==10) {
        text(0, (80*col)+33, row*50+35);
      }
      numberpad+=1;
    }
  }

  //Add 2 Logo's
  if (mouseX>5+((width/2)-120) && mouseX<75+((width/2)-120) && mouseY>335 && mouseY<375) {
    tint(255, 245);
    image(otherIcons[6], 25, 160, 30, 30);
  } else {
    tint(255, 170);
    image(otherIcons[6], 25, 160, 30, 30);
  }
  if ((mouseX>165+((width/2)-120) && mouseX<235+((width/2)-120))&& mouseY>335 && mouseY<375) {
    tint(255, 245);
    image(otherIcons[5], 185, 160, 30, 30);
  } else {
    tint(255, 170);
    image(otherIcons[5], 185, 160, 30, 30);
  }

  tint(255, 255);
  noStroke();
  popMatrix();
}
