import java.util.UUID;

enum SmartPointType{
 ANCHOR_POINT,
 CONTROL_POINT,
 CURSOR
}

enum BezierToolStatus{
 INACTIVE,
 FIRST_ANCHOR,
 SECOND_ANCHOR
}

int pointSize = 15;

color primaryColor = color(255,255,255);
color secondaryColor = color (255,198,25);
color inspectedColor = color(247,139,231);
color selectedColor = color(219,21,41);
color selectedColorJoin = color(23,214,150);
color bezierToolColor = color(106,73,227);

InfoTab infoTab;

ArrayList<SmartBezier> beziers;

SmartPoint selectedPoint;
boolean isPointSelected;

boolean showControlPoints;

boolean showInfoTab;

boolean bezierToolActive;
BezierToolStatus bezierCurrentStatus;
SmartPoint bezierToolCursor;
SmartPoint bezierFirstAnchor;

void setup(){
 
  size(1000,1000);
  pixelDensity(displayDensity());
  
  beziers = new ArrayList<SmartBezier>();
  
  SmartBezier bezier = new SmartBezier(new PVector(300,height/2), new PVector(width-300,height/2));
  beziers.add(bezier);
  
  infoTab = new InfoTab();
  infoTab.updateStudyObject(bezier.startPoint);
  
  isPointSelected = false;
      
  showControlPoints = true;
  
  showInfoTab = false;
  
  bezierToolActive = false;
  bezierToolCursor = new SmartPoint(new PVector(0,0), SmartPointType.CURSOR);
  bezierCurrentStatus = BezierToolStatus.INACTIVE;
  bezierFirstAnchor = new SmartPoint(new PVector(0,0), SmartPointType.CURSOR);
}

void draw(){
  
  background(0);

  for(SmartBezier b : beziers){
     b.display();
  }
  
  
 

  

 for(SmartBezier b : beziers){
     for(SmartPoint p : b.points){
       if(p.type == SmartPointType.ANCHOR_POINT){
        
       }
     }
  }
  
  if(bezierToolActive){
    
    bezierToolCursor.pos = new PVector(mouseX,mouseY);
    bezierToolCursor.display();
    
    if(bezierCurrentStatus == BezierToolStatus.SECOND_ANCHOR){
      
      bezierFirstAnchor.display();
      
      PVector controlPreviewA = PVector.add(PVector.lerp(bezierFirstAnchor.pos,bezierToolCursor.pos,0.25),new PVector(0,100));
      PVector controlPreviewB = PVector.add(PVector.lerp(bezierFirstAnchor.pos,bezierToolCursor.pos,0.75),new PVector(0,-100));
      
      stroke(bezierToolColor);
      noFill();
      strokeWeight(2);
      
      bezier(bezierFirstAnchor.pos.x , bezierFirstAnchor.pos.y,
             controlPreviewA.x       , controlPreviewA.y,
             controlPreviewB.x       , controlPreviewB.y,
             bezierToolCursor.pos.x  , bezierToolCursor.pos.y);
      
    }
    
    
    
  }
  
  if(showInfoTab){
    infoTab.display();
  }
  
  
  if(isPointSelected && selectedPoint != null){
    selectedPoint.selectedUpdate(); 
   }

  
}



void mouseClicked(){
  
  // Handles right click interactions (to explode links between multiple SmartPoints)  
  if(mouseButton == RIGHT && !isPointSelected && !bezierToolActive){
    ArrayList<SmartPoint> stackedPoints = new ArrayList<SmartPoint>();
    for(SmartBezier b : beziers){
     for(SmartPoint p : b.points){
       if(p.type == SmartPointType.ANCHOR_POINT){
         if(p.isInMouseRegion() && p.linkedPoints.size() > 0){
           stackedPoints.add(p);
         }
       }
     }
    }
    int stackedSize = stackedPoints.size();
    if(stackedSize>1){
      for(int i = 0; i < stackedSize; i++){
        PVector spreader = PVector.fromAngle(TWO_PI*(i/float(stackedSize)),new PVector(0,1)).mult(pointSize*0.7);
        SmartPoint target = stackedPoints.get(i);
        target.pos = PVector.add(target.pos,spreader);
        target.unlink();
      }
    }
  }
  
  if(mouseButton == CENTER){
   
    ArrayList<SmartPoint> stackedPoints = new ArrayList<SmartPoint>();
    for(SmartBezier b : beziers){
     for(SmartPoint p : b.points){
       if(p.type == SmartPointType.ANCHOR_POINT){
         if(p.isInMouseRegion()){
           stackedPoints.add(p);
         }
       }
     }
    }
    if(stackedPoints.size()>0){
      infoTab.updateStudyObject(stackedPoints.get(0));
      showInfoTab = true; 
    } else {
     showInfoTab = false; 
    }
    
  }
  
}

void mousePressed(){
  
  if(mouseButton == LEFT && !isPointSelected){

    // Controls mouse interactions of add bezier tool
    if(bezierToolActive){
      if(bezierCurrentStatus == BezierToolStatus.FIRST_ANCHOR){
        bezierFirstAnchor.pos = new PVector(mouseX,mouseY);
        bezierCurrentStatus = BezierToolStatus.SECOND_ANCHOR;
      } 
      else if(bezierCurrentStatus == BezierToolStatus.SECOND_ANCHOR){
       
       SmartBezier newBezier = new SmartBezier(bezierFirstAnchor.pos, new PVector(mouseX,mouseY));
       newBezier.toggleControlPoints(showControlPoints);
       beziers.add(newBezier);
       bezierCurrentStatus = BezierToolStatus.FIRST_ANCHOR;        
      }      
    }
    
    // Selects points so that they can be dragged arround (if they are visible).
    else {
      ArrayList<SmartPoint> stackedPoints = new ArrayList<SmartPoint>();
      for(SmartBezier b : beziers){
       for(SmartPoint p : b.points){
        if(p.type == SmartPointType.ANCHOR_POINT || (p.type == SmartPointType.CONTROL_POINT && showControlPoints)){
          if(p.isInMouseRegion()){
            stackedPoints.add(p);
          }
        }
       }
      }
      int stackedSize = stackedPoints.size(); 
      if(stackedSize>0){
         SmartPoint selected = stackedPoints.get(0);
         selected.select();
         isPointSelected = true;
         selectedPoint = selected; 
      } 

    }
  } 

}

void mouseReleased(){
  
  // Link two or more nodes if CONTROL key is being held
  if(keyPressed && keyCode == CONTROL && !bezierToolActive && isPointSelected){
    ArrayList<SmartPoint> stackedPoints = new ArrayList<SmartPoint>();
    for(SmartBezier b : beziers){
     for(SmartPoint p : b.points){
       if(p.type == SmartPointType.ANCHOR_POINT){
         if(p.isInMouseRegion()){
           if(p != selectedPoint){
             stackedPoints.add(p);
           }
         }
       }
     }
    }
    int stackedSize = stackedPoints.size();
    if(stackedSize>0){
     for(SmartPoint link : stackedPoints){
       selectedPoint.link(link);
     }
    }
  }
  
  // Unselects current selected point
  if(isPointSelected){
    isPointSelected = false;
    selectedPoint.unselect();   
  }


  
}


void keyPressed(){
  
  if(key == 's'){
     infoTab.studyShape();
  }
  
// Shows/hides control points of bezier curves.
 if(key == 'r'){
   showControlPoints = !showControlPoints;
  for(SmartBezier b : beziers){
    b.toggleControlPoints(showControlPoints);
  } 
 }
 
// Toggles the bezier tool. 
 if(key == 't'){
  if(bezierToolActive){
    bezierToolActive = false;
    bezierCurrentStatus = BezierToolStatus.INACTIVE;
  } else {
    bezierToolActive = true;
    bezierCurrentStatus = BezierToolStatus.FIRST_ANCHOR;
  }
 }
}
