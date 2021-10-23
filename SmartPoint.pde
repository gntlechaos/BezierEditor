class SmartPoint extends SmartObject {
  
  String id;
  PVector pos;
  int size;
  boolean isSelected;
  boolean isInspected;
  SmartPointType type;
  SmartBezier parent;
  
  ArrayList<SmartPoint> linkedPoints;
  
  SmartPoint(PVector initial_pos, SmartPointType t){ 
    pos = initial_pos;
    size = pointSize;
    isSelected = false;
    type = t;
    linkedPoints = new ArrayList<SmartPoint>();
    id = UUID.randomUUID().toString();
  }
  
  void display(){
    
    strokeWeight(0);
    if(isSelected){ 
      if(keyPressed && keyCode == CONTROL && type == SmartPointType.ANCHOR_POINT && isPointSelected){
        fill(selectedColorJoin);
      } else {
      fill(selectedColor);
      }
    } else if(isInspected){
      fill(inspectedColor);
    }
    else{   
     if(type == SmartPointType.ANCHOR_POINT){
       fill(255);
     } else if(type == SmartPointType.CONTROL_POINT){
       fill(secondaryColor);
     } else if(type == SmartPointType.CURSOR){
       fill(bezierToolColor);
     }
    }
    
    ellipseMode(CENTER);
    ellipse(pos.x,pos.y,size,size);  
  }
  
  void select(){
    isSelected = true;
  }
  
  void unselect(){
     isSelected = false; 
  }
  
  void link(SmartPoint other){
    
    if(!linkedPoints.contains(other)){
      other.pos = this.pos;
      other.linkedPoints.add(this);
      linkedPoints.add(other);
    }
  }
  
  void link(ArrayList<SmartPoint> others){
    for(SmartPoint other : others){
      other.pos = this.pos;
      other.linkedPoints.add(this);
    }
    linkedPoints.addAll(others);
  }
  
  void unlink(){
    linkedPoints.clear();
  }
  
  void selectedUpdate(){

     pos.x = mouseX;
     pos.y = mouseY;
     
     for(SmartPoint link : linkedPoints){
       link.pos.x = mouseX;
       link.pos.y = mouseY;
     }
    
  }
  
  boolean isInMouseRegion(){
    return dist(mouseX,mouseY,pos.x,pos.y) <= size/1.5;
  }
  
}
