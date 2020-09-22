class Drop {
  float x, y1;   
  float moveSpeed; 
  color c;
  float rad; 

  Drop() {
    rad = 4;                   
    x = random(width);      
    y1 = -rad*4;              
    moveSpeed = random(1, 5);   
    c = color(50, 100, 150); 
  }
 
  void move() {
  
    y1 += moveSpeed;
  }

  boolean reachedBottom() {
       if (y1 > height + rad*4) { 
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(c);
    noStroke();
    for (int i = 2; i < rad; i++ ) {
      ellipse(x, y1 + i*4, i*2, i*2);
    }
  }

}
