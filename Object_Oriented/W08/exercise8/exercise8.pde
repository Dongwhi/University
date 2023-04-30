punleu [] aa;
void setup() {
  size(1000, 1000);
  aa = new punleu[5];
  for (int i=0; i<5; i++) {
    aa[i] = new punleu(random(width), random(height));
  }
}
void draw(){
  background(0,255,255);  
  for (int i=0; i<5; i++) {
    if (i!=4){
      for (int j = i+1; j < 5; j++){
        aa[i].collide(aa[j]);
      }
    }
    aa[i].update();
    aa[i].punleuShow();
  }  
}
