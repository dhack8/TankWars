class Maze {
  Cell[][] maze;
  int widthM;
  int heightM;
  int left = 60;
  int top = 100;
  int widthC = 45;
  int count = (int) random(5, 15);
  int time = second();
  Maze(int w, int h) { //Creates new cells then calls for the maze to be generated
    widthM = w;
    heightM = h;
    maze = new Cell[widthM][heightM];
    for (int i = 0; i < widthM; i++) {
      for (int j = 0; j < heightM; j++) {
        maze[i][j] = new Cell(i, j, left, top, widthC);
      }
    }
    this.generate();
  }

  void generate() { //Generates the maze using sidewinder algorithm
    this.setEdges(); //Bc of how sidewinder works, the top row is always clear
    //Code for sidewinder
    for (int j = 0; j < heightM; j++) {
      int runStart = 0;
      for (int i = 0; i < widthM; i++) {
        if (j+1<heightM) maze[i][j].setBottom(maze[i][j+1]);
        if (j > 0 && (i+1 == widthM || (int) (random(2)) == 0)) {
          if (i+1<widthM) maze[i][j].setRight(maze[i+1][j]);
          int cell =  (runStart + (int) random(i - runStart + 1));
          maze[cell][j].deleteTop(maze[cell][j-1]);
          runStart = i+1;
        }
      }
    }
    this.makeLoops();
    this.setNearCells();
  }

  void makeLoops() { //Deletes a few walls fairly randomly from ever second row and column
    for (int i = 1; i < widthM; i += 2) {
      for (int j = 1; j < heightM; j += 2) {
        if ((int) random(4) == 1) {
          if (((int) random(2) == 1)) {
            maze[i][j].deleteTop(maze[i][j-1]);
          } else {
            maze[i][j].deleteLeft(maze[i-1][j]);
          }
        }
      }
    }
  }

  void setEdges() { //Sets the bounding edges of the maze
    for (int i = 0; i < widthM; i++) {
      maze[i][0].setWalls(false, false, true, false);
      maze[i][heightM-1].setWalls(false, false, false, true);
    }
    for (int j = 0; j < heightM; j++) {
      maze[0][j].setWalls(true, false, false, false);
      maze[widthM-1][j].setWalls(false, true, false, false);
    }
  }

  void setNearCells() {
    for (int i = 0; i < widthM; i++) {
      for (int j = 0; j < heightM; j++) {
        Cell c = maze[i][j];
        if (i-1 >= 0) c.leftC = maze[i-1][j];
        if (i+1 < widthM) c.rightC = maze[i+1][j];
        if (j-1 >= 0) c.topC = maze[i][j-1];
        if (j+1 < heightM) c.bottomC = maze[i][j+1];
      }
    }
  }

  void drawMaze(int wd) { //Simply draws each cell
    for (int i = 0; i < widthM; i++) {
      for (int j = 0; j < heightM; j++) {
        maze[i][j].drawCell();
      }
    }
    if (time != (int) second()) { //decides to spawn a crate or not
      time = second();
      count--;
      if (count == 0) {
        spawnSupplies(wd);
        count = (int) random(5, 20);
      }
    }
    text("Supply Drop In: " + count, left, top+(widthC*heightM)+23);
  }

  Cell randomCell() { //returns a random cell for things to spawn on
    int x = (int) random(0, widthM);
    int y = (int) random(0, heightM);
    return maze[x][y];
  }

  void spawnSupplies(int wd) { //spawns either 1 or 2 random weapons
    int random = (int) random(1, 11);
    int i;
    if (random > 8) {
      i = 2;
    } else {
      i = 1;
    }
    for (int o = 0; o<i; o++) {
      int weapon = (int) random(1, 4);
      if (weapon == 1) {       
        randomCell().crate = new Bomb(wd);
      } else if (weapon == 2) {
        randomCell().crate = new Minigun(wd);
      } else if (weapon == 3){
        randomCell().crate = new Splitshot(wd);
      }
    }
  }
}