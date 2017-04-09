import java.awt.Shape; //Imported for java objects used for polygon collection
import java.awt.Rectangle;
import java.awt.Polygon;
import java.awt.geom.Area;
import java.awt.geom.Ellipse2D;
import java.util.*;

int widthMaze = (int) random(3, 20); //Randomly decides size of maze
int heightMaze = (int) random(3, 20);
Maze maze;
Tank tank1;
Tank tank2;
boolean keys[] = new boolean[5]; //Bollean array to store key inputs
boolean keys2[] = new boolean[5];
//Aditional fields used by main
boolean gameEnding = false;
int timer;
static ArrayList<Bullet> allBullets;
PImage logo;
boolean playing = false;
float centerX;
float centerY;
float scale;

void setup() {
  logo = loadImage("tankwars.png");
  maze = new Maze(widthMaze, heightMaze); //Making tanks and maze
  tank1 = new Tank(maze.randomCell(), color(255, 0, 0));
  tank2 = new Tank(maze.randomCell(), color(0, 255, 0));
  size(1000, 1000);
  centerX = width/2 - 280;
  centerY = height/2 - 120;
}

void draw() {
  if(!playing) translate(centerX, centerY); //Shift things to center for home screen
  
  background(230, 230, 230); //these things occur regardless of playing
  image(logo, 50, 0);

  if (!playing) { //draw additional assets for home screen
    noStroke();
    fill(100);
    rect(150, 150, 250, 50);
    text("By David Hack", 172, 130);
    textSize(30);
    fill(230, 0, 0);
    if ((mouseX > 150 + centerX && mouseX < 400 + centerX) && (mouseY > 150 + centerY && mouseY < 200 + centerY)) fill(0, 230, 0);
    text("Play Game", 198, 185);
  } else { //Run the game 

    //PLAYER 1
    controlTank(keys, tank1);

    //PLAYER 2
    controlTank(keys2, tank2);

    //BULLETS IN TANKS CHECK
    allBullets = new ArrayList<Bullet>();
    allBullets.addAll(tank1.getBullets());
    allBullets.addAll(tank2.getBullets());
    Bullet b1 = tank1.checkBullets(allBullets); //If tanks were hit, they report which bullet it was
    Bullet b2 = tank2.checkBullets(allBullets);
    if (b1 != null) { //If a tank was hit by a bullet ends the game and finds which tank to delete the bullet from
      tank1.deleteBullet(b1);
      tank2.deleteBullet(b1);    
      if (tank1.alive) tank2.score++;
      tank1.alive = false;
      if (!gameEnding) timer = second();
      gameEnding = true;
    }
    if (b2 != null) {
      tank1.deleteBullet(b2);
      tank2.deleteBullet(b2);
      if (tank2.alive) tank1.score++;
      tank2.alive = false;
      if (!gameEnding) timer = second();
      gameEnding = true;
    }

    if (gameEnding) { //game ending with a 4 second timmer
      int time;
      if (second() < timer) {
        time = 60 + second();
      } else {
        time = second();
      }
      if (time - timer >= 4) { //soft resets the game
        gameEnding = false;
        widthMaze = (int) random(3, 20);
        heightMaze = (int) random(3, 20);
        maze = new Maze(widthMaze, heightMaze);
        tank1.reset(maze.randomCell());
        tank2.reset(maze.randomCell());
      }
    }
    
    maze.drawMaze(tank1.widthT); //draw maze and tanks
    tank1.updateTank(120);
    tank2.updateTank(190);
    
    //reset button
    rect(4, 250, 50, 50);
    textSize(12);
    fill(230, 0, 0);
    if ((mouseX > 4 && mouseX < 54) && (mouseY > 250 && mouseY < 300)) fill(0, 230, 0);
    text("RESET", 12, 280);
  }
}

void keyPressed() {
  //Boolean array is required to handle multiple inputs
  if (!playing) return;
  //PLAYER 1
  if (key == 'w') keys[0] = true;
  if (key == 's') keys[1] = true;
  if (key == 'a') keys[2] = true;
  if (key == 'd') keys[3] = true;
  if (key == ' ') keys[4] = true;

  //PLAYER 2
  if (keyCode == UP) keys2[0] = true;
  if (keyCode == DOWN) keys2[1] = true;
  if (keyCode == LEFT) keys2[2] = true;
  if (keyCode == RIGHT) keys2[3] = true;
  if (key == '/') keys2[4] = true;
}

void keyReleased() {
  if (!playing) return;
  //PLAYER 1
  if (key == 'w') keys[0] = false;
  if (key == 's') keys[1] = false;
  if (key == 'a') keys[2] = false;
  if (key == 'd') keys[3] = false;
  if (key == ' ') {
    tank1.triggerUp();
    keys[4] = false;
  }

  //PLAYER 2
  if (keyCode == UP) keys2[0] = false;
  if (keyCode == DOWN) keys2[1] = false;
  if (keyCode == LEFT) keys2[2] = false;
  if (keyCode == RIGHT) keys2[3] = false;
  if (key == '/') {
    tank2.triggerUp();
    keys2[4] = false;
  }
}

void mouseClicked() {
  if (!playing) { //clicked on play button
    if ((mouseX > 150 + centerX && mouseX < 400 + centerX) && (mouseY > 150 + centerY && mouseY < 200 + centerY)) playing = true;
  } else {
    if ((mouseX > 4 && mouseX < 54) && (mouseY > 250 && mouseY < 300)) { //clicked on reset
      widthMaze = (int) random(3, 20);
      heightMaze = (int) random(3, 20);
      maze = new Maze(widthMaze, heightMaze);
      tank1 = new Tank(maze.randomCell(), color(255, 0, 0));
      tank2 = new Tank(maze.randomCell(), color(0, 255, 0));
    }
  }
}

void controlTank(boolean[] keys, Tank tank) { //takes keys and a tank and controlls it accordingly
  if (!tank.alive) return;
  if (keys[0]) { //player wishes to move forwards
    if (tank.checkMove(1.2)) { //looks forwards a little ahead of the tank
      tank.forward();
      tank.updateCell();
    }
  }
  if (keys[1]) { //player wishes to move backwards
    if (tank.checkMove(-1.2)) { //looks back a bit behind the tank
      tank.backward();
      tank.updateCell();
    }
  }
  if (keys[2]) { //player wishes to rotate anti
    tank.checkRotate(-4.5); //shifts tank if it hits a wall on the next rotate
    tank.antiClock();
  }
  if (keys[3]) { //player wishes to rotate wise
    tank.checkRotate(4.5); //shifts tank if it hits a wall on the next rotate
    tank.clockWise();
  }
  if (keys[4]) { //player wishes to shoot
    tank.triggerDown(); //SHOOTS
  }
}