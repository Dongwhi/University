void cloud_design(float x, float y, float size){ //구름 디자인
  ellipse(x,y,size,size*0.5);
}
void cloud_move(){ //구름 움직임
  fill(220,240,240);
  for(int i=0;i<3;i++){
    cloud_design(cloud_x[i],cloud_y[i],cloud_size[i]);
    cloud_x[i] = cloud_x[i] + cloud_speed[i];
    if(cloud_x[i]>width){
      cloud_x[i] = 0;
    }
  }
  fill(250);
}
