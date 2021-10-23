class SmartBezier extends SmartObject{
  
  SmartPoint startPoint;
  SmartPoint endPoint;
  SmartPoint controlPointA;
  SmartPoint controlPointB;
  
  ArrayList<SmartPoint> points;
  
  boolean showControlPoints;
  
  SmartBezier(PVector start, PVector end){
    
    startPoint = new SmartPoint(start, SmartPointType.ANCHOR_POINT);
    endPoint = new SmartPoint(end, SmartPointType.ANCHOR_POINT);
   
    PVector a = PVector.add(PVector.lerp(start,end,0.25),new PVector(0,100));
    PVector b = PVector.add(PVector.lerp(start,end,0.75),new PVector(0,-100));
    
    controlPointA = new SmartPoint(a,SmartPointType.CONTROL_POINT);
    controlPointB = new SmartPoint(b,SmartPointType.CONTROL_POINT);
    
    points = new ArrayList<SmartPoint>();
    points.add(startPoint);
    points.add(endPoint);
    points.add(controlPointA);
    points.add(controlPointB);
    
    this.showControlPoints = true;
    
    startPoint.parent = this;
    endPoint.parent = this;
    controlPointA.parent = this;
    controlPointB.parent = this;
    
  }
  
  void display(){
   
    stroke(primaryColor);
    noFill();
    strokeWeight(2);
    bezier(startPoint.pos.x    ,  startPoint.pos.y,
           controlPointA.pos.x ,  controlPointA.pos.y,
           controlPointB.pos.x ,  controlPointB.pos.y,
           endPoint.pos.x      ,  endPoint.pos.y
           );
          
    stroke(secondaryColor);
    
    if(this.showControlPoints){
      line(startPoint.pos.x,startPoint.pos.y,controlPointA.pos.x, controlPointA.pos.y);
      line(endPoint.pos.x,endPoint.pos.y,controlPointB.pos.x, controlPointB.pos.y);
      for(SmartPoint p : points){
        p.display();  
      } 
    } else{
      for(SmartPoint p : points){
        if(p.type != SmartPointType.CONTROL_POINT){
          p.display();  
        }
      } 
    }
 
    
  } 
  
  // Recieves one end and returns the other one
  SmartPoint returnOtherEnd(SmartPoint oneEnd){
    if(oneEnd == this.startPoint){
      return this.endPoint; 
    } else if(oneEnd == this.endPoint){
     return this.startPoint; 
    } else {
     return null; 
    }
  }
  
  void toggleControlPoints(boolean show){
    this.showControlPoints = show;
  }

  
}
