class Siha {
  Siha() {   };
  Siha(float p, float q, float r) {
    x = p;     y = q;     d = r;
    vx = random(-3,3); vy = random(-2,2);
  }
  float x, y, d, vx, vy;
  void Life() {
    ellipse(x, y, d, d/3*2);
    circle(x-d/5, y-d/6, d/5);
    arc(x+d/5, y-d/6, d/5, d/5, PI, 2*PI);
    arc(x, y, d*2/3, d/5, 0, PI);
  }
}
