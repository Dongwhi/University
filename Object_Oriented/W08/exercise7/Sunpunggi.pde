class Sunpung{
  Sunpung(){};
  Sunpung(float a, float b, float c, int d){
    x = a;
    y = b;
    s = c; // 선풍기 크기
    n = d; // 날개 수
    fan_angle = radians(360./n);
    vx = random(-3,3); vy = random(-2,2);
  }
  float x, y, s, fan_angle, vx, vy;
  int n;
  void collide(Sunpung b){
    float dd;
    dd = sqrt((x-b.x)*(x-b.x) + (y-b.y)*(y-b.y));
    if(dd < 4*(s+b.s)){
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
  void sun_shape(){
    fill(247, 247, 223);
    quad(x-3*s, y+2*s, x+3*s, y+2*s, x+4*s, y+6*s, x-4*s, y+6*s);
    rect(x-4*s, y+6*s, 8*s, 2*s);
    rect(x-s, y-2*s, 2*s, 6*s);
    fill(83, 185, 230);
    draw_button(x-3*s, y, s);
    draw_button(x-2.3*s, y, s);
    draw_button(x-1.6*s, y, s);
    draw_button(x-0.9*s, y, s);
    fill(210);
    circle(x, y-4*s, 10*s);
    fill(83, 185, 230);
    circle(x, y-4*s, 2*s);
    fill(84, 127, 255, 120);
    for (int i = 0; i < n; i++){      
      draw_fan(x, y, s, i, fan_angle);
    }
  }
}
