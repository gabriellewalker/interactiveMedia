color c1, c2;
color sky, leaves, ground, grass, cloud, cloudSun;
int hillR, hillG, hillB, x1, x2, y, speed, sunSpeed, opacity;
float d =10;

//wind
float xpos1, xpos2, xpos3;
float ypos1, ypos2, ypos3;
int windSpeed = 1;
Animation windAnimation1, windAnimation2, spriteRainAnimation, spriteWindAnimation, spriteIdleAnimation; 

//day selector
boolean[] isSelected = new boolean[8];

int daySelected; //will determine which row in our tables we get the data from


Timer timer;        // One timer object
Drop[] drops;       // An array of drop objects
int totalDrops = 0; // totalDrops
boolean ifRain = false;

Table longRainTable; //table to load csv for weeks rainfall taken from research lab
Table totalDailyRainfallTable;//table to hold total daily rainfall values
Table longWindSpeedTable; //table to load csv for weeks windspeeds taken from research lab
Table averageDailyWindSpeedTable; //table to hold calculated daily windspeed average from longWindSpeedTable
Table longAirTempTable; //table to load csv for weeks air temp
Table averageDailyAirTempTable; //table to hold calculated daily airtemp average from longAirTempTable

float airTemp = 20; //default air temp

void setup() {
  size(800, 800);
  background(255);
  //load the weeks rainfall from eif-research
  longRainTable = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T10:59:25.685&rToDate=2020-09-22T10:59:25.685&rFamily=weather&rSensor=RG", "csv");
  for(int i =0; i<longRainTable.getRowCount(); i++){
     String dateTime = longRainTable.getString(i,0);
     //tempDateTime format is: YYYY-MM-DD HH:MM:SS - get date value using split -> tempDT[0] will give date, tempDT[1] will give time
     String[] DT = split(dateTime, ' ');
     String date = DT[0];

    longRainTable.setString(i, 0, date);     
  }
  
  //load the weeks windspeeds from eif-research
  longWindSpeedTable = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T17:15:37.216&rToDate=2020-09-22T17:15:37.216&rFamily=weather&rSensor=IWS", "csv");
  for(int i =0; i<longWindSpeedTable.getRowCount(); i++){
     String dateTime = longWindSpeedTable.getString(i,0);
     //tempDateTime format is: YYYY-MM-DD HH:MM:SS - get date value using split -> tempDT[0] will give date
     String[] DT = split(dateTime, ' ');
     String date = DT[0];

    longWindSpeedTable.setString(i, 0, date);     
  }
  
  //load the weeks air temp from eif-research
  longAirTempTable = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-09-15T20:02:55.757&rToDate=2020-09-22T20:02:55.757&rFamily=weather&rSensor=AT", "csv");
  for(int i =0; i<longAirTempTable.getRowCount(); i++){
     String dateTime = longAirTempTable.getString(i,0);
     //tempDateTime format is: YYYY-MM-DD HH:MM:SS - get date value using split -> tempDT[0] will give date
     String[] DT = split(dateTime, ' ');
     String date = DT[0];
     
    longAirTempTable.setString(i, 0, date);     
  }
  
  //create new columns in total hourly rainfall table
  totalDailyRainfallTable = new Table();
  totalDailyRainfallTable.addColumn("date");
  totalDailyRainfallTable.addColumn("rainfall");

  //create new columns in daily average windspeed table
  averageDailyWindSpeedTable = new Table();
  averageDailyWindSpeedTable.addColumn("date");
  averageDailyWindSpeedTable.addColumn("windspeed");

  //create new columns in daily average windspeed table
  averageDailyAirTempTable = new Table();
  averageDailyAirTempTable.addColumn("date");
  averageDailyAirTempTable.addColumn("airtemp");
  
  getTotalDailyRainfall();
  getAverageDailyWindspeed();
  getAverageDailyAirTemp();

  c1 = color(255, 255, 255);
  c2 = color(74, 229, 225);
  sky = #4D8EF5;
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
 // sunSpeed = 3;
  opacity = 100;
  drops = new Drop[10000];    
  timer = new Timer(10);    
  timer.start(); 
  windAnimation1 = new Animation("wind_frame_", 18);
  windAnimation2 = new Animation("leaves_frame_", 27);
  spriteRainAnimation = new Animation("spriteRAIN", 7);
  spriteIdleAnimation = new Animation ("spriteIDLE", 4);
  spriteWindAnimation = new Animation ("spriteWIND", 4);
  frameRate(30);
  textAlign(CENTER, CENTER);
  for (int i = 0; i < 7; i++) isSelected[i] = false;
}

void draw() {
  //Sky - Simple light blue box
  fill(sky);
  rect(0, 0, width, height); 
  sun(airTemp);
  sunPulse();
  
  //rain
 if (ifRain == true){
  sky = (#9391A7);
  spriteRainAnimation.display(300, 320);
  if (timer.isFinished()) {
    drops[totalDrops] = new Drop();
    totalDrops ++ ;
    if (totalDrops >= drops.length) {
      totalDrops = 0; // Start over
    }
    timer.start();
  }
  else spriteIdleAnimation.display(300, 320);
 }

  // Move and display all drops
  for (int i = 0; i < totalDrops; i++ ) {
    drops[i].move();
    drops[i].display();
   
  }
  
  //wind
  xpos1 = (height/4)-55;
  ypos1 = (height/4) +50;
  xpos2 = 0;
  ypos2 = (height/4) +50;
  xpos3 = width/2;
  ypos3 = (height/4) +50;
 
    if(windSpeed > 0){
      windAnimation2.display(xpos1, ypos1);
      windAnimation1.display(xpos2, ypos2);
      windAnimation1.display(xpos3, ypos3);
      if  (ifRain == false) {
        spriteWindAnimation.display(300, 320);
      }
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
 //button selectors at bottom of the screen
  button(1, totalDailyRainfallTable.getString(0, 0));
  button(2, totalDailyRainfallTable.getString(1, 0));
  button(3, totalDailyRainfallTable.getString(2, 0));
  button(4, totalDailyRainfallTable.getString(3, 0));
  button(5, totalDailyRainfallTable.getString(4, 0));
  button(6, totalDailyRainfallTable.getString(5, 0));
  button(7, totalDailyRainfallTable.getString(6, 0));
  button(8, "RESET");
  
}
void mousePressed() { 
  int daySelected=-1;
  //if mouse pressed over button 1
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 10 && mouseX < 90) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(0, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[0] = true;
        daySelected = 0;
      }
    }
     //if mouse pressed over button 2
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 100 && mouseX < 180) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(1, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[1] = true;
        daySelected = 1;
      }
    }
      //if mouse pressed over button 3
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 190 && mouseX < 270) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(2, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[2] = true;
        daySelected = 2;
      }
    }
      //if mouse pressed over button 4
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 280 && mouseX < 360) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(3, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[3] = true;
        daySelected = 3;
      }
    }
      //if mouse pressed over button 5
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 370 && mouseX < 450) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(4, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[4] = true;
        daySelected = 4;
      }
    }
      //if mouse pressed over button 6
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 460 && mouseX < 540) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(5, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[5] = true;
        daySelected = 5;
      }
    }
      //if mouse pressed over button 7
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 550 && mouseX < 630) {
        println("Showing value for day: " + totalDailyRainfallTable.getString(6, 0));
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[6] = true;
        daySelected = 6;
      }
    }
   
    
   //if mouse pressed over reset button
  if (mouseY > height-50 && mouseY < height-15) {
      if (mouseX > 640 && mouseX < 720) {
        println("RESET");
        for (int j = 0; j < 7; j++) isSelected[j] = false;
        isSelected[7] = true;
        daySelected = -1;
      }
    }
    
    
  if(daySelected > -1){
    float rainfall = totalDailyRainfallTable.getFloat(daySelected, 1);
    float windSpeed = averageDailyWindSpeedTable.getFloat(daySelected, 1);
    airTemp = averageDailyAirTempTable.getFloat(daySelected, 1);
    println("airTemp = " + airTemp);
    println("rainfall = " + rainfall);
    println("windspeed = " + windSpeed);
    float rate = windSpeed*10;
    //set frameRate to windspeed
    frameRate(rate);
    //if there is rainfall on that day make it rain
    if (rainfall >0.0){
        println("rainfall = " + rainfall);
       ifRain = true;
    }
     else if (ifRain == true){
       ifRain = false;
        sky = #4D8EF5;
       totalDrops = 0;
    }
  }
  else{
    frameRate(20);
    ifRain = false;
    totalDrops = 0;
    sky = #4D8EF5;
  }
  
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

//day selector
void button (int nr, String text) {  
  int buttonW = 80;
  int buttonH = 20;
  int buttonX = nr*(buttonW+10)-buttonW;
  int buttonY = height-(buttonH+30);

  if (isSelected[nr-1]) {
    fill(#97D3D2);
  }
  else{
    fill(#C9FFB7);
  } 
  rect(buttonX, buttonY, buttonW, buttonH);
  fill(0);
  text(text, buttonX+buttonW/2, buttonY+buttonH/2);
}
//Used to create and determine what type of sun is in the sky  based of values from eif lab: 0-15degrees = small sun, 16-20 = medium sum, 20-25 = fairly large sun, 25>= large sun  
void sun(float type) {
     fill(#F2F227);
 if (type > 0.0 && type <=15.0) {
   sunSpeed = 2;
   circle(650, 300, 25);
 } else if (type > 15.0 && type <=20.0) {
   circle(650, 300, 50);
   sunSpeed = 3;
 } else if (type > 21.0 && type <=25.0) {
   circle(650, 300, 75);
   sunSpeed = 4;
 }else if (type >25.0){
   circle(650, 300, 100);
   sunSpeed = 5;
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
 
 
void getTotalDailyRainfall() {
  //set temp Date variable to use for comparison
  String tempDate;
  //for each row
  for(int i =0; i<longRainTable.getRowCount(); i++){
    int count = 0;
    //set the tempdate as the first date of the row
    tempDate = longRainTable.getString(i,0);
    float totalDailyRainfall = 0; 
    //set a new new in the totalDailyRainfallTable to equal that date
    TableRow newRow = totalDailyRainfallTable.addRow();
    newRow.setString("date", tempDate);
    
    //count the rows in the table that have the same date
    for (TableRow row : longRainTable.matchRows(tempDate, 0)){
      count++;
      //add the amount of rainfall from each row that matches to the daily total
      totalDailyRainfall += row.getFloat(1);
    }
    //add the daily total to the row with the date set above
    newRow.setFloat("rainfall", totalDailyRainfall);
    //increase i to the next date
    i+=count;
  }
}

void getAverageDailyWindspeed(){
 //set temp Date and Time variable to use for comparison
  String tempDate;
  //for each row
  for(int i =0; i<longWindSpeedTable.getRowCount(); i++){
    int count = 0;
    //set the tempdate as the first date of the row
    tempDate = longWindSpeedTable.getString(i,0);
    float totalDailyWindSpeed = 0; 
    float averageDailyWindSpeed = 0;
    //set a new new in the averageDailyWindSpeedTable to equal that date
    TableRow newRow = averageDailyWindSpeedTable.addRow();
    newRow.setString("date", tempDate);
    
    //count the rows in the table that have the same date
    for (TableRow row : longWindSpeedTable.matchRows(tempDate, 0)){
      count++;
      //add the windspeed values to the total daily windspeed
      totalDailyWindSpeed += row.getFloat(1);
      //divide totalDailyWindSpeed by count to calculate the average daily windspeed
      averageDailyWindSpeed = totalDailyWindSpeed/count;
    }
    //add daily average to the row for that date
    newRow.setFloat("windspeed", averageDailyWindSpeed);
    //increase i to the next date
    i+=count;
  }
}

void getAverageDailyAirTemp() {
 //set temp Date and Time variable to use for comparison
  String tempDate;
  //for each row
  for(int i =0; i<longAirTempTable.getRowCount(); i++){
    int count = 0;
    //set the tempdate as the first date of the row
    tempDate = longAirTempTable.getString(i,0);
    float totalDailyTemp = 0; 
    float averageDailyTemp = 0;
    //set a new new in the averageDailyWindSpeedTable to equal that date
    TableRow newRow = averageDailyAirTempTable.addRow();
    newRow.setString("date", tempDate);
    
    //count the rows in the table that have the same date
    for (TableRow row : longAirTempTable.matchRows(tempDate, 0)){
      count++;
      //add the windspeed values to the total daily windspeed
      totalDailyTemp += row.getFloat(1);
      //divide totalDailyWindSpeed by count to calculate the average daily windspeed
      averageDailyTemp = totalDailyTemp/count;
    }
    //add daily average to the row for that date
    newRow.setFloat("airtemp", averageDailyTemp);
    //increase i to the next date
    i+=count;
  }  
}