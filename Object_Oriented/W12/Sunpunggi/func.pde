// 선풍기 그릴때 사용하는 함수
void draw_button(float x, float y, float s){
  rect(x-0.25*s, y+5*s, 0.5*s, 0.3*s);
  ellipse(x, y+5*s, 0.5*s, 0.3*s);
  arc(x, y+5.3*s, 0.5*s, 0.3*s, 0, radians(360./2));
}
void draw_fan(float x, float y, float s, int n, float fan_angle){
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
