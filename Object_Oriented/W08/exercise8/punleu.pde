class punleu {
  // constructor
  punleu(float a, float b) {
    x = a;
    y = b;
    vx = random(-3,3); vy = random(-2,2);
  }
  // member data
  float x, y, vx, vy;
  Siha [] bb;
  Sunpung cc;
  // member function
  void collide(punleu b){
    float dd;
    dd = sqrt((x-b.x)*(x-b.x) + (y-b.y)*(y-b.y));
    if(dd < 180){
      float vx1 = vx, vy1 = vy;
      vx = b.vx;
      vy = b.vy;
      b.vx = vx1;
      b.vy = vy1;
    }
  }
  void update(){
   x += vx;
   y += vy;
   if(x<0 || x>width) vx = - vx;
   if(y<0 || y>height) vy = - vy;
   bb = new Siha[2];
   for(int i=0;i<2;i++){
     bb[i] = new Siha(x+i*200-100,y,50);
   }
   cc = new Sunpung(x, y-130, 7, 5);
  }
  void punleuShow() {
    for (int i = 0; i < 2; i++){
      bb[i].Life();
    }
    cc.sun_shape();
    fill(0, 0, 255);
    ellipse(x, y+30, 200, 210);
    fill(255);
    // eye
    ellipse(x-40, y, 50, 50);
    ellipse(x+30, y, 50, 50);
    // black eye
    fill(0);
    ellipse(x-40, y, 20, 20);
    ellipse(x+30, y, 20, 20);
    fill(0, 255, 0);
    //mouth
    arc(x, y+75, 80, 50, 0, 3.14);
    fill(0, 255, 0);
  }
}
