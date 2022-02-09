//Name, Date, Description, Plan

//Sound Processing
import processing.sound.*;
SoundFile file;

//Image Processing
PImage[] fragment;
int number_images = 3; //Amount of images which will be loaded

//Creating variables which make interface variable based on screen resolution
float w = width/1440.0;
float h = height/900.0;

//Add variables
int slider = 0;
boolean within = false;
float xpos,ypos;
float xOffset, yOffset;
float wslider, hslider;

void setup(){
  fullScreen();
  background(255);
  noStroke();
  
  // A click sound will be used instead of a vibration to create visability
  file = new SoundFile(this, "click.wav");
 
  //Load all images numbers 0 and up
   fragment=new PImage[number_images];
   for(int i=0;i<fragment.length;i++){
     fragment[i]=loadImage(str(i) + ".png");
   }

  hslider=200*h;
  wslider=750*w;
  
  xpos=0;
  ypos=0;
}

void draw(){
  //file.play();
  image(fragment[0],xpos,ypos,wslider,hslider);
  
  print(h);
  
  if(mouseX > xpos-wslider && mouseX < xpos+wslider && 
      mouseY > ypos-hslider && mouseY < ypos+hslider){ //When there is overlap
   for (int i=0; i<20;i++){
     if (ypos<(60*h)){ //Max height slider
       ypos += h;
     }
   }
  }
}
