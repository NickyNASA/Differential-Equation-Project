public class Button{
  int x, y, w, h;
  String txt;
  int type;
  boolean isActive;
  
  public Button(int x, int y, String txt, int type){
    this(x, y, 20, 20, txt, type);
  }
  
  public Button(int x, int y, int w, int h, String txt, int type){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.txt = txt;
    this.type = type;
    this.isActive = false;
  }
  
  public void display(){
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    
    fill(220);
    if(isMouseOver()){
      fill(175);
    }
    
    switch(this.type){
    case 0:
      rect(this.x, this.y, this.w, this.h, 5);
    
      fill(0);
      textAlign(CENTER, CENTER);
      text(this.txt, this.x + 2, this.y - 1);
      break;
    case 1:
      rect(this.x, this.y, this.w, this.h, 10);
      
      if(this.isActive){
        strokeWeight(2);
        stroke(0);
        line(this.x - 5, this.y + 1, this.x - 2, this.y + 4);
        line(this.x - 2, this.y + 4, this.x + 5, this.y - 4);
        
        noStroke();
      }
      fill(0);
      textAlign(LEFT, CENTER);
      text(this.txt, this.x + 15, this.y - 1);
    }
  }
  
  public boolean isMouseOver(){
    return mouseX >= this.x - this.w/2 && mouseX <= this.x + this.w/2 &&
           mouseY >= this.y - this.h/2 && mouseY <= this.y + this.h/2;
  }
  
  public void click(){
    if(isMouseOver()){
      this.isActive = !this.isActive;
      onClick();
    }
  }
  
  public void onClick(){
    
  }
}

public class Menu{
  int x, y, w, h;
  String txt;
  boolean isOpen;
  ArrayList<String> names;
  
  public Menu(int x, int y, String txt, ArrayList<String> names){
    this(x, y, 120, 30, txt, names);
  }
  
  public Menu(int x, int y, int w, int h, String txt, ArrayList<String> names){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.txt = txt;
    this.isOpen = false;
    this.names = names;
  }
  
  public void display(){
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    
    fill(220);
    if(isMouseOver() == 1){
      fill(175);
    }
    
    rect(this.x, this.y, this.w, this.h, 2);
    
    noStroke();
    fill(0);
    beginShape();
    vertex(this.x + 35, this.y - 5);
    vertex(this.x + 40, this.y + 5);
    vertex(this.x + 45, this.y - 5);
    vertex(this.x + 35, this.y - 5);
    endShape();
  
    textAlign(CENTER, CENTER);
    text(this.txt, this.x, this.y - 2);
    
    stroke(0);
    strokeWeight(2);
    if(this.isOpen){
      fill(220);
      rectMode(CORNER);
      rect(this.x - this.w/2, this.y + this.h/2, this.w, this.names.size() * 30);
      
      if(mouseX >= this.x - this.w/2 && mouseX <= this.x + this.w/2 &&
         mouseY >= this.y + this.h/2 && mouseY < this.y + this.h/2 + this.names.size()*30){
        fill(175);
        noStroke();
        rect(this.x - this.w/2 + 2, this.y - this.h/2 + round((mouseY - this.y) / 30.0) * 30 + 2, this.w - 3, 27);
      }
      
      for(int i = 0; i < this.names.size(); i++){
        String str = this.names.get(i);
        
        int x = this.x;
        int y = this.y + (i+1) * 30;
        
        fill(0);
        textAlign(CORNER, CENTER);
        text(str, x - this.w/2 + 10, y);
        textAlign(CENTER, CENTER);
      }
    }
  }
  
  public int isMouseOver(){
    if(mouseX >= this.x - this.w/2 && mouseX <= this.x + this.w/2 &&
       mouseY >= this.y - this.h/2 && mouseY <= this.y + this.h/2){
      return 1;
    }else
    if(mouseX >= this.x - this.w/2 && mouseX <= this.x + this.w/2 &&
       mouseY >= this.y + this.h/2 && mouseY <= this.y + this.h/2 + this.names.size() * 30){
      return 2;
    }else{
      return 0;
    }
  }
  
  public void click(){
    if(isMouseOver() == 1){
      this.isOpen = !this.isOpen;
    }else
    if(isMouseOver() == 0){
      this.isOpen = false;
    }
    
    if(isMouseOver() == 2 && this.isOpen){
      int i = round((mouseY - this.y) / 30.0);
      onSubClick(i);
    }
  }
  
  public void onSubClick(int i){}
}

public class Slider{
  int x, y, w, h;
  float min, max, value;
  String txt;
  boolean follow;
  
  public Slider(int x, int y, float min, float max, String txt){
    this.x = x;
    this.y = y;
    this.w = 250;
    this.h = 30;
    this.min = min;
    this.max = max;
    
    this.value = 1.5;
    this.txt = txt;
    
    this.follow = false;
  }
  
  public void display(){
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    
    fill(220);
    rect(this.x, this.y, this.w, 6, 10);
    
    float val = map(this.value, this.min, this.max, this.x - this.w/2, this.x + this.w/2);
    ellipse(val, this.y, 20, 20);
    
    fill(0);
    text(this.txt + " = " + this.value, this.x, this.y + 20);
  }
  
  public boolean isMouseOver(){
    return mouseX >= this.x - this.w/2 && mouseX <= this.x + this.w/2 &&
           mouseY >= this.y - this.h/2 && mouseY <= this.y + this.h/2;
  }
  
  public void release(){
    this.follow = false;
  }
  
  public void update(){
    if(isMouseOver() && this.follow == false){
      this.follow = true;
    }
    
    if(this.follow){
      this.value = map(mouseX, this.x - this.w/2, this.x + this.w/2, this.min, this.max);
      this.value = constrain(floor(this.value * 100.0) / 100.0, this.min, this.max);
    }
  }
}
