import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import peasy.*;
import processing.serial.*;
import cc.arduino.*;
import java.util.Iterator;

PeasyCam cam;

VerletPhysics3D physics;
ToxiclibsSupport gfx;
BoxConstraint ground;

Grid g;
int population = 16;
DNA[] d;
int flock = 4;
int flockX = 1;
int flockY = flock/flockX;
int spacingX = 250;
int spacingY = 250;
int shiftX = 400;
int shiftY = 200;

PVector mouse;
boolean mouseClicked = false;
boolean up = false;
boolean down = false;
boolean moveOn = false;

int timer = 20000;
long lastReset = timer;
int currentFlock;
int generation = 0;

Creature[] c;
int gridX = 2;
int gridY = 6;
int gridZ = 2;
byte repeat = 6;
int spacing = 20;
int neighbors = 18;

float percentRod = 35;
float percentMsine = 5;
float percentMcos = percentMsine;
byte mutationRate = 5;
byte reductionRate = 1;

int muscleFactor = 5;
boolean keyFall = false;

IntList roundDist;
IntList totalDist;
IntList maxDist;
IntList minDist;
Table data;

void setup() {
  size(1200, 600, P3D);
  cam = new PeasyCam (this, 100, -200, 0, -100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
  cam.setSuppressRollRotationMode();
  resetPhysics();

  maxDist = new IntList();
  minDist = new IntList();
  roundDist = new IntList();
  data = new Table();
  data.addColumn("Generation");
  data.addColumn("Max Distance");
  data.addColumn("Min Distance");
  data.addColumn("Total Distance");

  g = new Grid();
  d = new DNA[population];
  for (int i=0; i<population; i++) {
    d[i] = new DNA();
    d[i].patternCreate();
  }
  c = new Creature[flock];
  for (int i=0; i<flock; i++) {
    c[i] = new Creature();
    c[i].cookFromDNAN(d[i]);
  }
  currentFlock = 0;
}


void draw() {
  if (millis() - lastReset > timer || moveOn == true) {
    int currentBase = currentFlock*flock;
    println(currentBase);
    lastReset = millis();
    moveOn = false;
    for (int i=0; i<flock; i++) {
      d[currentBase + i].displacement = c[i].getDisplacement();
      d[currentBase + i].user_like = c[i].liked;
      
      print("Creature = ");
      println(currentBase + i);
      //print("Distance Travelled = ");
      //println(d[currentBase + i].displacement);
      print("Liked = ");
      println(d[currentBase + i].user_like);
      
      roundDist.append(int(d[currentBase + i].displacement));
    }

    currentFlock++;
    currentBase = currentFlock*flock;
    
    if (currentBase >= population) {
      updateData();
      generation++;
      println("Generation = " + generation);
      float totalDistance = 0;
      for (int i=0; i<population; i++) {
        totalDistance += d[i].displacement;
      }
      for (int i=0; i<population; i++) {
        d[i].calculateFitness(totalDistance);
      }
      ArrayList<DNA> matingPool = new ArrayList<DNA>();
      for (int i=0; i<population; i++) {
        for (int j=0; j<d[i].fitness*10; j++) {
          matingPool.add(d[i]);
        }
      }

      for (int i=0; i<population; i++) {
        DNA parent1 = matingPool.get(int(random(matingPool.size())));
        DNA parent2 = matingPool.get(int(random(matingPool.size())));
        d[i] = crossover_pattern(parent1, parent2);
        d[i].mutatePattern();
        //d[i].reduce();
      }
      currentFlock = 0;
      currentBase = 0;
    }

    resetPhysics();
    for (int i=0; i<flock; i++) {
      c[i] = new Creature();
      c[i].cookFromDNAN(d[i+currentBase]);
    }
  }

  basicRoutine();
  int k=0;
  for (int i=0; i<flockX; i++) {
    for (int j=0; j<flockY; j++) {
      c[k].update();
      pushMatrix();
      translate((j*-spacingX + shiftX), 0, (i*-spacingY + shiftY));
      c[k].interact();
      c[k].display();
      popMatrix();
      k++;
    }
  }
}

void basicRoutine() {
  noStroke();
  background(255);
  noStroke();
  fill(255, 100);
  physics.update();
  lights();
  tex();
  //VerletPhysics3D.addConstraintToAll(ground, physics.particles);
  mouse = new PVector(mouseX,mouseY);
}

void resetPhysics() {
  //gfx = new ToxiclibsSupport(this);
  //ground=new BoxConstraint(new AABB(new Vec3D(0, baseHeight, 0), new Vec3D(baseSize, gridY*spacing, baseSize)));
  //ground.setRestitution(0);
  physics=new VerletPhysics3D();
  physics.addBehavior(new GravityBehavior3D(new Vec3D(0, 0.1, 0)));
}

void updateData() {
  int totalDistance = 0;
  int maxDistance = 0;
  int minDistance = 10000;
  for (int i=0; i<roundDist.size(); i++) {
    int d = roundDist.get(i);
    totalDistance += d;
    if (d > maxDistance) maxDistance = d;
    if (d < minDistance) minDistance = d;
  }
  TableRow newRow = data.addRow();
  newRow.setInt("Generation", generation);
  newRow.setInt("Max Distance", maxDistance);
  newRow.setInt("Min Distance", minDistance);
  newRow.setInt("Total Distance", totalDistance);
  saveTable(data, "data.csv");
}

void keyPressed() {
  if (key == 'x')
    keyFall = true;
  if( key == 'n')
    moveOn = true;
  if(key == CODED) {
    if(keyCode == UP)
      up = true;
    if(keyCode == DOWN)
      down = true;
  }
}

void mouseClicked() {
  mouseClicked = true;
}
