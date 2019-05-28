
public class Barrier{
  PVector pos;
  int facing;
  
  public Barrier(int x, int y, int facing){
    this.pos = new PVector(x, y);
    this.facing = facing;
  }
  
  public void display(){
    float x = this.pos.x * cellSize;
    float y = this.pos.y * cellSize;
    fill(0);
    noStroke();
    rect(x, y, cellSize, cellSize);
    
    pushMatrix();
    translate(x + cellSize/2, y + cellSize/2);
    rotate(-HALF_PI * this.facing);
    stroke(255, 0, 0);
    strokeWeight(2);
    line(-cellSize/2, -cellSize/2, cellSize/2, -cellSize/2);
    
    popMatrix();
    
    rectMode(CORNER);
  }
  
  public void calcBoundaries(){
    int x = (int)this.pos.x;
    int y = (int)this.pos.y;
    
    switch(this.facing){
    case 0: // UP
      p[x][y] = p[x][y-1];
      
      v[x][y] = -v[x][y-1];
      break;
    case 1: // LEFT
      p[x][y] = p[x-1][y];
      
      u[x][y] = -u[x-1][y];
      break;
    case 2: // DOWN
      p[x][y] = p[x][y+1];
      
      v[x][y] = -v[x][y+1];
      break;
    case 3: // RIGHT
      p[x][y] = p[x+1][y];
      
      u[x][y] = -u[x+1][y];
      break;
    }
  }
}

public void attemptAddBarrier(int x, int y){
  for(Barrier b : barriers){
    if(b.pos.x == x && b.pos.y == y){
      return;
    }
    
    if(x <= 1 || x >= size + 1 || y <= 1 || y >= size + 1){
      return;
    }
  }
  
  barriers.add(new Barrier(x, y, barrierMode));
}

public void attemptRemoveBarrier(int x, int y){
  for(int i = 0; i < barriers.size(); i++){
    Barrier b = barriers.get(i);
    
    if(b.pos.x == x && b.pos.y == y){
      barriers.remove(i);
    }
  }
}
