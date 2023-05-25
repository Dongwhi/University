class Sunpung_guard extends Sunpung{
  Sunpung_guard(float a, float b, float c, int d, int g){
    super(a, b, c, d);
    guard_angle = 360/g;
  }
  float guard_angle;
  void draw_guard(){
    for (int i = 0; i < 360; i++){
      point(x+s*sin(radians(i))/2, y-4*s+s*cos(radians(i))/2);
    }
    for (int j = 0; j < 360; j += guard_angle){
      line(x+s*sin(radians(j))/2, y-4*s+s*cos(radians(j))/2, x+10*s*sin(radians(j))/2, y-4*s+10*s*cos(radians(j))/2);
    }
  }
};
