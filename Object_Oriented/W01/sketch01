int x, y, s, n, degree;
float fan_angle;
void setup(){
  size(1000, 1000);
  background(150);
  x = 500;
  y = 500;
  s = 50;
  n = 5;
  degree = 360;
  fan_angle = radians(degree/n);
  fill(247, 247, 223);
  quad(x-3*s, y+2*s, x+3*s, y+2*s, x+4*s, y+6*s, x-4*s, y+6*s);
  rect(x-4*s, y+6*s, 8*s, 2*s);
  rect(x-s, y-2*s, 2*s, 6*s);
  fill(83, 185, 230);
  draw_button(x-3*s);
  draw_button(x-2.3*s);
  draw_button(x-1.6*s);
  draw_button(x-0.9*s);
  fill(210);
  circle(x, y-4*s, 10*s);
  fill(83, 185, 230);
  circle(x, y-4*s, 2*s);
  fill(84, 127, 255, 120);
  draw_fan(0);
  draw_fan(1);
  draw_fan(2);
  draw_fan(3);
  draw_fan(4);
  
}
void draw_button(float n){
  rect(n-0.25*s, y+5*s, 0.5*s, 0.3*s);
  ellipse(n, y+5*s, 0.5*s, 0.3*s);
  arc(n, y+5.3*s, 0.5*s, 0.3*s, 0, radians(degree/2));
}
void draw_fan(int n){
  curve(x+s*cos(fan_angle*(n+0.5)),y+s*sin(fan_angle*(n+0.5))-4*s,
  x+s*cos(fan_angle*n),y+s*sin(fan_angle*n)-4*s,
  x+4*s*cos(fan_angle*n),y+4*s*sin(fan_angle*n)-4*s,
  x+4*s*cos(fan_angle*(n+0.5)),y+4*s*sin(fan_angle*(n+0.5))-4*s);
  arc(x+1.5*s*cos(fan_angle*n),y+1.5*s*sin(fan_angle*n)-4*s,5*s,5*s,fan_angle*n,fan_angle*(n+1));
  curve(x+s*cos(fan_angle*(n+1)),y+s*sin(fan_angle*(n+1))-4*s,
  x+s*cos(fan_angle*(n+0.5)),y+s*sin(fan_angle*(n+0.5))-4*s,
  x+3.3*s*cos(fan_angle*(n+0.65)),y+3.3*s*sin(fan_angle*(n+0.65))-4*s,
  x+3.3*s*cos(fan_angle*(n+1)),y+3.3*s*sin(fan_angle*(n+1))-4*s);
}
