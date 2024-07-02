ArrayList<Ball> balls;
PImage[] textures;
Ball ball;
void setup() {
  
  //frameRate(100);
  size(500,500, P3D);
  smooth();
  noStroke();
  balls = new ArrayList<Ball>();
 
  textures = new PImage[5];
  textures[0] = loadImage("OIP.jpg");
  textures[1] = loadImage("14.jpg");
  textures[2] = loadImage("R.jpg");
  textures[3] = loadImage("download.jpg");
  textures[4] = loadImage("triangle.jpg");
}

void draw() {
  background(0);
  drawCube();
  
  for (int i = 0; i < balls.size(); i++){
    balls.get(i).bounce();
    balls.get(i).display();
    balls.get(i).isTouching();
    
  }
  
  balls.removeIf(b -> b.bounce() == true);
  
}
void mouseClicked(){
    if ((mouseX > 0 && mouseX < height) && (mouseY > 0 && mouseY < height)){ 
      Ball b = new Ball(mouseX, mouseY, 0);
      balls.add(b);
    }
    
    
}
void drawCube(){
  
  pushMatrix();
  noStroke();
  beginShape(QUAD_STRIP);
  
  //left
  fill(#6841E6); //purple
  vertex(0,0,0);
  vertex(0,0,-height);
  vertex(0,height,0);
  vertex(0,height,-height);
  
  //right
  fill(#65FAEC); //cyan
  vertex(height,0,0);
  vertex(height,0,-height);
  vertex(height,height,0);
  vertex(height,height,-height);
  
  //ceiling
  fill(#E02740); //red
  vertex(0,0,0);
  vertex(0,0,-height);
  vertex(height,0,0);
  vertex(height,0,-height);
  
  //floor
  fill(#6BF7A5); //green
  vertex(0,height,0);
  vertex(0,height,-height);
  vertex(height,height,0);
  vertex(height,height,-height);
  
  //back
  fill(#FFF46C); //yellow
  vertex(0,0,-height);
  vertex(height,0,-height);
  vertex(0,height,-height);
  vertex(height,height,-height);
  
  endShape();
  popMatrix();  
}
public class Ball{
  float x;
  float y;
  float z;
  int bounces = 0;
  boolean isSpinning = true;
  float angle;
  float x_velocity = random(-4,10);
  float y_velocity = random(-5,13);
  float z_velocity = random(-5);
  float decay = 0.8;
  float energy_loss;
  PShape ball;
  PImage texture;
  float g = 0.2;
  int d = 20;
  IntList positions;
  PVector point;
  PVector velocity;
  public Ball(int xpos,int ypos, int zpos){
    
    x = xpos;
    y = ypos;
    z = zpos;
    positions = new IntList(x-d/2,x+d/2,y-d/2,y+d/2,z-d/2,z+d/2); 
    angle = degrees(atan2(y,x));
    ball = createShape(SPHERE,20);
    texture = textures[int(random(0,textures.length))];
    ball.setTexture(texture);
    ball.setStroke(false);
    point = new PVector(x,y,z);
    velocity = new PVector(x_velocity,y_velocity,z_velocity);
  }
  
  void display() {
    pushMatrix();      
    translate(x, y, z);
    if (isSpinning == true){
      rotateX(((angle)+HALF_PI) *(bounces));
      rotateY(((angle)+HALF_PI) *(bounces));  
    }
    shape(ball);
    popMatrix();
 }
   
  boolean bounce(){
    energy_loss = pow(decay,bounces);
    x += x_velocity * energy_loss;
 
    y += y_velocity;
    y_velocity += g;
    z += z_velocity * energy_loss;
    //z_velocity += g;
    if (x <= d){ // left wall
      x = d;
      isSpinning = true;
      x -= x_velocity* energy_loss;
      x_velocity = x_velocity * -1; 
      bounces++;
      
      //println("x < 0",x);
    }
    else if (x >= height - d){ //right wall
      x = height-d;
      isSpinning = true;
      x -= x_velocity* energy_loss;
      x_velocity = x_velocity * -1; 
      bounces++;
      
      
      //println("x > height",x);
    }
    else if (y >= height - d){ //floor
      //println(y,"\n",y_velocity);
      
      isSpinning = false;
      if (y_velocity <= 0.20952383){
        y = height - d;
      }
      else{
         y -= y_velocity * energy_loss;
         y_velocity = y_velocity/-1.1;
         y_velocity += g;
         bounces++;
      }
      //println("y > height",y);
    }
    else if (y <= d){//ceiling
      
      y = d;
      isSpinning = true;
      y -= y_velocity* energy_loss;
      y_velocity = y_velocity * -1; 
      bounces++;
      //println("y < 0",y);
    }
    else if (z >= height - d){//the sixth wall
      
      //z = height;
      //println("z > height",z);
      return true;    
    }
    else if (z <= -height + d){//back wall
      
      isSpinning = true;
      z -= z_velocity* energy_loss; 
      z_velocity = z_velocity * -1;
      bounces++;
      
      //println("z < -height",z);
    }
    
     
    return false;
  }
  float distance_between(float x1, float x2, float y1,  float y2, float z1, float z2) {

    float xDist = x1-x2;                                 
    float yDist = y1-y2;                               
    float zDist = z1-z2;                                   
    float distance = sqrt((xDist*xDist) + (yDist*yDist) + (zDist*zDist)); 
    return distance;
}
  void isTouching(){
    float dist;
    Ball b;
    float s = d+d/2;
    for(int i = 0; i < balls.size(); i++){
      if (balls.get(i) != this){
          b = balls.get(i);
          dist =  distance_between(this.x, b.x, this.y, b.y, this.z, b.z);
          if (dist <= (this.d + b.d)/2 ) {
            //update x
            if (this.x_velocity * b.x_velocity < 0) {
               // swap speeds between two balls
              float swapSpeeds = this.x_velocity;
              this.x_velocity = b.x_velocity;
              b.x_velocity = swapSpeeds;
              if ( this.x_velocity  < 0) {
                this.x -= int((s-dist)/2) + 1;
                b.x += int((s-dist)/2) + 1;
               } 
              else{
                this.x  += int((s-dist)/2) + 1;
                b.x -= int((s-dist)/2) + 1;
              }
              
             bounces++; 
             isSpinning = true;
          }
          else {
          //both balls moving in the same direction
          if (this.x_velocity  > b.x_velocity ){
            //this ball hits other ball
            this.x_velocity  -= b.x_velocity ;
            b.x_velocity  += this.x_velocity +  b.x_velocity ;
          if (this.x_velocity  < 0) {
            b.x  -= int(s-dist) + 1;
          } 
          else {
            b.x  += int(s-dist) + 1;
          }
          } 
        else {
          // other ball hits this ball
          b.x_velocity  -= this.x_velocity ;
          this.x_velocity  += b.x_velocity  + this.x_velocity ;
          if (b.x_velocity  < 0) {
            this.x -= int(s-dist) + 1;
          } 
          else {
            this.x += int(s-dist) + 1;
          }
        }
        bounces++;
        isSpinning = true;
      }
      
            //update y
            if (this.y_velocity * b.y_velocity < 0) {
               // swaps speeds between two balls
              float swapSpeeds = this.y_velocity;
              this.x_velocity = b.y_velocity;
              b.y_velocity = swapSpeeds;
              if ( this.y_velocity  < 0) {
                this.y -= int((s-dist)/2) + 1;
                b.y += int((s-dist)/2) + 1;
               } 
              else{
                this.y  += int((s-dist)/2) + 1;
                b.y -= int((s-dist)/2) + 1;
              }
              
              bounces++;
              isSpinning = true;
          }
          else {
          //both balls moving in the same direction
          if (this.y_velocity  > b.y_velocity ){
            //this ball hits other ball
            this.y_velocity  -= b.y_velocity ;
            b.y_velocity  += this.y_velocity +  b.y_velocity ;
          if (this.y_velocity  < 0) {
            b.y  -= int(s-dist) + 1;
            isSpinning = true;
          } 
          else {
            b.y  += int(s-dist) + 1;
            isSpinning = true;
          }
          } 
        else {
          // other ball hits this ball
          b.y_velocity  -= this.y_velocity ;
          this.y_velocity  += b.y_velocity  + this.y_velocity ;
          if (b.y_velocity  < 0) {
            this.y -= int(s-dist) + 1;
          } 
          else {
            this.y += int(s-dist) + 1;
          }
        }
        bounces++;
        isSpinning = true;
      }
      
            //update z
            if (this.z_velocity * b.z_velocity < 0) {
               // swaps speeds between two balls
              float swapSpeeds = this.z_velocity;
              this.z_velocity = b.z_velocity;
              b.x_velocity = swapSpeeds;
              if ( this.z_velocity  < 0) {
                this.z -= int((s-dist)/2) + 1;
                b.z += int((s-dist)/2) + 1;
               } 
              else{
                this.z  += int((s-dist)/2) + 1;
                b.z -= int((s-dist)/2) + 1;
              }
              
              bounces++;
              isSpinning = true;
          }
          else {
          //both balls moving in the same direction
          if (this.z_velocity  > b.z_velocity ){
            //this ball hits other ball
            this.z_velocity  -= b.z_velocity ;
            b.z_velocity  += this.z_velocity +  b.z_velocity ;
          if (this.z_velocity  < 0) {
            b.z  -= int(s-dist) + 1;
          } 
          else {
            b.z  += int(s-dist) + 1;
          }
          } 
        else {
          // other ball hits this ball
          b.z_velocity  -= this.z_velocity ;
          this.z_velocity  += b.z_velocity  + this.z_velocity;
          if (b.z_velocity  < 0) {
            this.z -= int(s-dist) + 1;
          } 
          else {
            this.z += int(s-dist) + 1;
          }
        }
        bounces++;
        isSpinning = true;
      }
          }
          
         
        }
     }
    
  }
  
}
  
  
    
   
