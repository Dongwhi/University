class Sunpung_plug extends Sunpung{
  Sunpung_plug(float a, float b, float c, int d, float e){
    super(a, b, c, d);
    plug_angle = radians(e);
  }
  float plug_angle;
  void draw_plug(){
    fill(50);
    quad(x-s*sin(plug_angle)/4, y+3*s+s*cos(plug_angle)/4,
    x+s*sin(plug_angle)/4, y+3*s-s*cos(plug_angle)/4,
    x+10*s*sin(plug_angle)+s*sin(plug_angle)/4, y+3*s+10*s*cos(plug_angle)-s*cos(plug_angle)/4,
    x+10*s*sin(plug_angle)-s*sin(plug_angle)/4, y+3*s+10*s*cos(plug_angle)+s*cos(plug_angle)/4);
    quad(x+10*s*sin(plug_angle)-s*sin(plug_angle)/4, y+3*s+10*s*cos(plug_angle)+s*cos(plug_angle)/4,
    x+10*s*sin(plug_angle)+s*sin(plug_angle)/4, y+3*s+10*s*cos(plug_angle)-s*cos(plug_angle)/4,
    x+11*s*sin(plug_angle)+s*sin(plug_angle), y+3*s+11*s*cos(plug_angle)-s*cos(plug_angle),
    x+11*s*sin(plug_angle)-s*sin(plug_angle), y+3*s+11*s*cos(plug_angle)+s*cos(plug_angle));
    quad(x+11*s*sin(plug_angle)+s*sin(plug_angle), y+3*s+11*s*cos(plug_angle)-s*cos(plug_angle),
    x+11*s*sin(plug_angle)-s*sin(plug_angle), y+3*s+11*s*cos(plug_angle)+s*cos(plug_angle),
    x+12*s*sin(plug_angle)-s*sin(plug_angle), y+3*s+12*s*cos(plug_angle)+s*cos(plug_angle),
    x+12*s*sin(plug_angle)+s*sin(plug_angle), y+3*s+12*s*cos(plug_angle)-s*cos(plug_angle));
  }
};
