class Grid {
  int totalPoints;
  PVector[] pointsLocation;
  int[] pointsId;

  Grid() {
    totalPoints = gridX*gridY*gridZ;
    pointsLocation = new PVector[totalPoints];
    pointsId = new int[totalPoints];
    int num = 0;
    for (int i=0; i<gridX; i++) {
      for (int j=0; j<gridY; j++) {
        for (int k=0; k<gridZ; k++) {
          //pointsId[num] = i+j*100+k*10000;
          //pointsLocation[num] = id2pos(pointsId[num]);
          pointsLocation[num] = new PVector(i*spacing, -j*spacing, k*spacing);
          pointsId[num] = pos2id(pointsLocation[num]);
          num++;
        }
      }
    }
  }
  void show() {
    strokeWeight(1);
    stroke(0);
    int num = 0;
    for (int i=0; i<gridX; i++) {
      for (int j=0; j<gridY; j++) {
        for (int k=0; k<gridZ; k++) {
          point(pointsLocation[num].x, pointsLocation[num].y, pointsLocation[num].z);
          num++;
        }
      }
    }
  }
  void printAll() {
    int num = 0;
    for (int i=0; i<gridX; i++) {
      for (int j=0; j<gridY; j++) {
        for (int k=0; k<gridZ; k++) {
          //pointsLocation[i+j+k] = new PVector(i*spacing, j*spacing, k*spacing);
          print(pointsId[num]);
          print(" ");
          num++;
        }
      }
    }
    println("");
    num = 0;
    for (int i=0; i<gridX; i++) {
      for (int j=0; j<gridY; j++) {
        for (int k=0; k<gridZ; k++) {
          print(pointsLocation[num].x);
          print(" ");
          print(pointsLocation[num].y);
          print(" ");
          println(pointsLocation[num].z);
          num++;
        }
      }
    }
  }
}

int pos2id(PVector location) {
  return(int(location.x/spacing) - int(100*location.y/spacing) + int(10000*location.z/spacing));
}

PVector id2pos(int id) {
  int x = id%100;
  int y = id%10000;
  y = -int(y/100);
  int z = int(id/10000);
  return(new PVector(x*spacing, y*spacing, z*spacing));
}

IntList getNeighbors(int id) {
  PVector origin = id2pos(id);
  IntList neighbor = new IntList();
  neighbor.append(pos2id(new PVector(origin.x, origin.y, origin.z-spacing)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y, origin.z+spacing)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y-spacing, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y+spacing, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x-spacing, origin.y, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x+spacing, origin.y, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y-spacing, origin.z-spacing)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y+spacing, origin.z-spacing)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y-spacing, origin.z+spacing)));
  neighbor.append(pos2id(new PVector(origin.x, origin.y+spacing, origin.z+spacing)));
  neighbor.append(pos2id(new PVector(origin.x-spacing, origin.y, origin.z-spacing)));
  neighbor.append(pos2id(new PVector(origin.x+spacing, origin.y, origin.z-spacing)));
  neighbor.append(pos2id(new PVector(origin.x-spacing, origin.y, origin.z+spacing)));
  neighbor.append(pos2id(new PVector(origin.x+spacing, origin.y, origin.z+spacing)));
  neighbor.append(pos2id(new PVector(origin.x-spacing, origin.y-spacing, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x-spacing, origin.y+spacing, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x+spacing, origin.y-spacing, origin.z)));
  neighbor.append(pos2id(new PVector(origin.x+spacing, origin.y+spacing, origin.z)));

  for (int i = neighbor.size()-1; i>=0; i--) {
    PVector pos = id2pos(neighbor.get(i));
    if (pos.x<0 || pos.x>(gridX-1)*spacing || -pos.y<0 || -pos.y>(gridY-1)*spacing || pos.z<0 || pos.z>(gridZ-1)*spacing) {
      neighbor.remove(i);
    }
  }
  return(neighbor);
}
