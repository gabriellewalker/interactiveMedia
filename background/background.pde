color c1, c2;
color sky, leaves, ground, grass, cloud, cloudSun;
int hillR, hillG, hillB, x1, x2, y, speed, sunSpeed, opacity;
float d =10;

Timer timer;        // One timer object
Drop[] drops;       // An array of drop objects
int totalDrops = 0; // totalDrops
boolean ifRain = false;

//commenting for git commit

void setup() {
  size(800, 800);
  background(255);
  c1 = color(255, 255, 255);
  c2 = color(74, 229, 225);
  sky = #7cece9;
  leaves = #126F12;
  ground = #54E54A;
  grass = #4AC43F;
  cloud = 255;
  hillR = 61;
  hillG = 170;
  hillB = 52;
  x1 = 0;
  x2 = 300;
  y = 100;
  speed = 2;
  sunSpeed = 3;
  opacity = 100;
  drops = new Drop[10000];    
  timer = new Timer(10);    
  timer.start();             
}

void draw() {
  //Sky - Simple light blue box
  fill(sky);
  rect(0, 0, width, height); 
  sun(1);
  sunPulse();
  
  //rain
 if (ifRain == true){
  sky = (#9391A7);
  if (timer.isFinished()) {
    drops[totalDrops] = new Drop();
    totalDrops ++ ;
    if (totalDrops >= drops.length) {
      totalDrops = 0; // Start over
    }
    timer.start();
  }
 }

  // Move and display all drops
  for (int i = 0; i < totalDrops; i++ ) {
    drops[i].move();
    drops[i].display();
   
  }
  
  //Cloud - change parameters to shift x/y coordinates and the speed, the cloud will reset once it dissapears off the screen.
  cloud(100, 1);
  cloud(300, 2);
  
  //Background - Simple hills made by drawing quadratic curves with varying colours to give depth
  //far hill
  strokeWeight(0);
  stroke(0);
  fill(hillR - 30, hillG - 30, hillB - 30);
  beginShape();
  vertex(200, 700);
  quadraticVertex(500, 500, 700, 700);
  endShape();
  //Left close hill
  fill(hillR - 20, hillG - 20, hillB - 20);
  beginShape();
  vertex(0, 740);
  vertex(0, 550);
  quadraticVertex(300, 550, 500, 740);
  endShape();
  //Right close hill
  fill(hillR, hillG, hillB);
  beginShape();
  vertex(800, 740);
  vertex(800, 600);
  quadraticVertex(600, 500, 300, 740);
  endShape();
  
  //Foreground - Simple rectangle for ground
  fill(ground);
  rect(0, 740, 800, 60);
 
  //Treetrunk - Uses a custom shape with quadratic vertices to make a trunk shape
  fill(#90651F);
  beginShape();
  vertex(100 ,740);
  quadraticVertex(130, 400, 100, 300);
  vertex(160, 300);
  quadraticVertex(130, 400, 160, 740);
  endShape();
  
  //Tree leaves
  noStroke();
  fill(leaves);
  circle(170, 280, 115);
  circle(90, 310, 80);
  circle(70, 250, 120);
  circle(90, 200, 100);
  circle(140, 180, 80);
  circle(180, 220, 110);
  stroke(0);
 
  //Grass - basic loop to increase the x value each time the grass is drawn
  int grassX = 0;
  for (int i = 0; i < 54; i++) {
    fill(grass);
    beginShape();
    vertex(grassX, 740);
    vertex(grassX += 5, 720);
    vertex(grassX += 5, 740);
    grassX += 5;
    endShape();
 }
 println(frameRate);
}

void mousePressed() { // used to get the x and y coordinates where you click
  //println("X: " + mouseX + "Y: " + mouseY);
  if (ifRain == false){
   ifRain = true;
  }
   else if (ifRain == true){
     ifRain = false;
     sky = #7cece9;
  };
}

//the cloud will take a y coordinate and a speed at which it will move
void cloud(int y, int number) {
  pushMatrix();
  if (number == 1) { translate(x1, y);}
  else { translate(x2, y);}
  noStroke();
  fill(cloud);
  circle(0, 0, 70);
  circle(40, 10, 90);
  circle(30, -35, 70);
  circle(70, -50, 70);
  circle(100, -20, 80);
  circle(100, 10, 90);
  popMatrix();
  x1 += speed;
  x2 += speed;
  if (x1 == 1000) {x1 = -200;}
  if (x2 == 1000) {x2 = -200;}
}

//Used to create and determine what type of sun is in the sky, 1 for normal sun, 2 for cloudy sun and >3 for sun with grey clouds
void sun(int type) {
 if (type == 1) {
   fill(#F2F227);
   circle(650, 300, 100);
   
 } else if (type == 2) {
   fill(#F2F227);
   circle(650, 300, 100);
   cloudSun(255);
 } else {
   fill(#F2F227);
   circle(650, 300, 100);
   cloudSun(180);
 }
}
void sunPulse(){
   
  fill(#F2F227, opacity);
  noStroke();
  strokeWeight(10);
  ellipse(650, 300, d, d);
  
  d = d + sunSpeed;
  opacity--;
  if (d > 400) {
    d = 10;
    opacity = 100;
  } 
}



void cloudSun(color cloudSun) {
  pushMatrix();
  translate(600, 350);
  noStroke();
  fill(cloudSun);
  circle(0, 0, 70);
  circle(40, 10, 90);
  circle(100, -20, 60);
  circle(100, 10, 90);
  popMatrix();
}
//Leaf shape - currently unused
 //beginShape();
 //vertex(410, 740);
 //quadraticVertex(400, 730, 410, 710);
 //quadraticVertex(420, 730, 410, 740);
 //endShape();
