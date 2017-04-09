class Wall { //Just a container object for the walls in the maze
  int x,y;
  int widthW = 49;
  int heightW = 4;
  boolean vertical;
  Wall(boolean vert, int ix, int iy){
    x = ix;
    y = iy;
    if(vert){
      widthW = 4;
      heightW = 48;
    }
    vertical = vert;
  }
  
  void drawWall(){
    noStroke();
    fill(64,64,64);
    rect(x,y,widthW,heightW);
  }
}