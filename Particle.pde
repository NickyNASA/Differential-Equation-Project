
public class Particle{
  PVector pos;
  PVector vel;
  int life;
  
  public Particle(int x, int y){
    this(x, y, 0, 0);
  }
  
  public Particle(int x, int y, int xVel, int yVel){
    this.pos = new PVector(x, y);
    this.vel = new PVector(xVel, yVel);
    
    this.life = 1000;
  }
  
  public void display(){
    noStroke();
    fill(0, 0, 0);
    ellipse(this.pos.x, this.pos.y, 5, 5);
  }
  
  public void update(){
    this.life--;
    
    if(this.life <= 0){
      particles.remove(this);
    }
    
    this.pos.add(this.vel);
    
    this.applyForce();
  }
  
  public void applyForce(){
    if(this.pos.x >= cellSize && this.pos.x <= fieldWidth + cellSize &&
       this.pos.y >= cellSize && this.pos.y <= fieldHeight + cellSize){
      int gridX = floor((this.pos.x + 1) / cellSize);
      int gridY = floor((this.pos.y + 1) / cellSize);
    
      PVector gridVel = new PVector(u[gridX][gridY], v[gridX][gridY]);
    
      this.vel.set(gridVel.mult(7));
      this.display();
    }else{
      particles.remove(this);
    }
  }
}
