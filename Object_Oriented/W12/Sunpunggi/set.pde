Sunpung [] a;
Sunpung_guard [] b;
Sunpung_plug [] c;
void setup() {
  size(1500, 1000);
  a = new Sunpung[2];
  b = new Sunpung_guard[2];
  c = new Sunpung_plug[2];
  for (int i = 0; i < 2; i++){
    a[i] = new Sunpung(750, 200 + 350 * i, 20, 5);
    b[i] = new Sunpung_guard(250, 400 + 350 * i, 20, 5, i*2+10);
    c[i] = new Sunpung_plug(1250, 400 + 350 * i, 20, 5, 60+240*i);
    a[i].sun_shape();
    b[i].sun_shape();
    b[i].draw_guard();
    c[i].draw_plug(); 
    c[i].sun_shape();
  }
}
