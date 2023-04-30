Siha [] aa;
punleu [] bb;
Sunpung [] cc;
void setup() {
  size(1000, 1000);
  aa = new Siha[3];
  bb = new punleu[3];
  cc = new Sunpung[3];
  for (int i=0; i<3; i++) {
    aa[i] = new Siha(random(width),random(height), random(150, 200));
    bb[i] = new punleu(random(width),random(height));
    cc[i] = new Sunpung(random(width),random(height), random(15, 20), 5);
  }
}
void draw(){
  background(0,255,255);
  for (int i=0; i<3; i++) {
    if (i!=2){
      for(int j=i+1;j<3;j++){
        aa[i].collide(aa[j]);
        bb[i].collide(bb[j]);
        cc[i].collide(cc[j]);
      }
    }
    aa[i].act();
    aa[i].Life();
    bb[i].update();
    bb[i].punleuShow();
    cc[i].act();
    cc[i].sun_shape();
  }  
}
