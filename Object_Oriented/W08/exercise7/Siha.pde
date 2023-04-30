class Siha {
  Siha() {   };
  Siha(float p, float q, float r) {
    x = p;     y = q;     d = r;
    vx = random(-3,3); vy = random(-2,2);
  }
  float x, y, d, vx, vy;
  void collide(Siha b){
    float dd;
    dd = sqrt((x-b.x)*(x-b.x) + (y-b.y)*(y-b.y));
    if(dd < (d+b.d)/4){
      float vx1 = vx, vy1 = vy;
      vx = b.vx;
      vy = b.vy;
      b.vx = vx1;
      b.vy = vy1;
    }
  }
  void act(){
    x += vx;  y += vy;
   if(x<0 || x>width) vx = - vx;
   if(y<0 || y>height) vy = - vy;
  }
  void Life() {
    ellipse(x, y, d, d/3*2);
    circle(x-d/5, y-d/6, d/5);
    arc(x+d/5, y-d/6, d/5, d/5, PI, 2*PI);
    arc(x, y, d*2/3, d/5, 0, PI);
  }
}
