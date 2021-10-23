import java.lang.reflect.*; 

class InfoTab {
  
  PVector size;
  PVector position;
  
  int recursionCount;
  int loopinessFactor;
  ArrayList<SmartPoint> alreadyVisitedNodes;
  boolean shapeStudied;
  boolean shapeResult;
  
  
  SmartPoint studyObject;
  
  
  InfoTab(){
   
    position = new PVector(width-300,0);
    size = new PVector(300,200);
    
    
  }
  
  void display(){
    
    Field[] properties = SmartPoint.class.getDeclaredFields();
   
    
    pushMatrix();
    translate(position.x,position.y);
    noStroke();
    fill(255);
    rect(0,0,size.x,size.y);
    fill(0);
    
    
    text("ID: "+studyObject.id, 10, 10);
    text("X: "+studyObject.pos.x+" Y: "+studyObject.pos.y,10, 60);
    text("Number of Links: "+studyObject.linkedPoints.size(), 10, 110); 
    
    if(shapeStudied){
      text("Closed Shape: "+ shapeResult , 10, 160);
      text("Steps: "+recursionCount, 10, 180);
    }
    //text(studyObject.id, 10, 160);
    //text(studyObject.id, 10, 210);
  
    popMatrix();
    
  }
  
  void updateStudyObject(SmartPoint newObject){
    if(studyObject != null){
      studyObject.isInspected = false; 
    }
    studyObject = newObject;
    newObject.isInspected = true;
    shapeStudied = false;

  }
  
  void studyShape(){
    
    alreadyVisitedNodes = new ArrayList<SmartPoint>();
    recursionCount = 0;
    loopinessFactor = 0;
    
    try{
     shapeResult = closedShape(studyObject.parent.returnOtherEnd(studyObject),studyObject.id);
    } catch (Exception e){
      
    }
    shapeStudied = true;
    
    
  }
  
  boolean closedShape(SmartPoint node, String targetId){
    
  for(SmartPoint p : alreadyVisitedNodes){
   if(node.id == p.id) loopinessFactor++; 
  }
  if(loopinessFactor> 100) return false;
  alreadyVisitedNodes.add(node);
  recursionCount++;
  if (node.linkedPoints.size()==0) return false;
  if (node.id == targetId) return true;
  int direction = int(random(0,node.linkedPoints.size()));
  println(direction);
  if (node.linkedPoints.get(direction).id == targetId) return true;
  else return closedShape(node.linkedPoints.get(0).parent.returnOtherEnd(node.linkedPoints.get(0)),targetId);
}
  
  
}
