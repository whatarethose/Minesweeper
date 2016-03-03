import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private final static int  NUM_ROWS = 20;
private final static int  NUM_COLS = 20;
public boolean gameOver = false;
public boolean firstClick = true;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs= new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons=new MSButton[NUM_ROWS][NUM_COLS];
    for(int a =0;a < NUM_ROWS;a++)
    {
        for(int b= 0;b<NUM_COLS;b++)
        {
            buttons[a][b]=new MSButton(a,b);
        }
    }
    for(int c=0;c<((int)(Math.random()*50))+NUM_COLS+20;c++)
    {
        setBombs();
    }
}
public void setBombs()
{   
    int randomRow = (int)(Math.random()*NUM_ROWS);
    int randomColumn = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[randomRow][randomColumn]))
    {
        bombs.add(buttons[randomRow][randomColumn]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
    {
        displayWinningMessage();
        gameOver= true;
    }
}
public boolean isWon()
{
    for(int i = 0; i < NUM_ROWS; i++)
    {
        for(int j = 0; j < NUM_COLS; j++)
            if(!bombs.contains(buttons[i][j]) && !buttons[i][j].isClicked())
                return false;
    }
    return true;
}
public void displayLosingMessage()
{
    //your code here
    gameOver = true;
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel(" ");
    buttons[9][10].setLabel("L");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("S");
    buttons[9][13].setLabel("E");
    for (int i =0; i < bombs.size (); i++) 
    {
        bombs.get(i).marked = false;
        bombs.get(i).clicked = true;
  }
}
public void displayWinningMessage()
{
    //your code here
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel(" ");
    buttons[9][10].setLabel("W");
    buttons[9][11].setLabel("I");
    buttons[9][12].setLabel("N");
}
public void reset()
{
    gameOver = false;
    firstClick = true;
        for(int r=0; r<NUM_ROWS;r++)
        {
            for(int c=0; c<NUM_COLS;c++)
            {
                bombs.remove(buttons[r][c]);
                buttons[r][c].marked=false;
                buttons[r][c].clicked=false;
                buttons[r][c].unsure=false;
                buttons[r][c].setLabel(" ");
            }
        }
        for(int c=0;c<((int)(Math.random()*50))+NUM_COLS+20;c++)
        {
            setBombs();
        } 
}
public void keyPressed()
    {
        if(key == 'r')
        {
            reset();
        }
    }
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    private boolean unsure;
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        unsure = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if(gameOver)return;
            if(firstClick)
            {
                
                firstClick = false;
            }
            if(mouseButton == LEFT)
            clicked = true; 
            if (mouseButton == RIGHT){
                if(keyPressed)
                    unsure= !unsure;
                else
                {
                    marked= !marked;
                }
            }
            else if(bombs.contains(this))
            {
                gameOver = true;
                displayLosingMessage();
            }
            else if(countBombs(r,c)>0)
            {
                setLabel(str(countBombs(r,c)));
            }
            else
            {
                for(int row =-1;row <=1;row++)
               {
                    for(int col = -1; col<=1;col++)
                    {
                         if(isValid(r+row,c+col)&& buttons[r+row][c+col].isClicked() == false)
                        {
                            if(!(row==0&&col ==0))
                            buttons[r+row][c+col].mousePressed();
                        }
                    }   
               }       
            }
    }
    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else if(unsure)
            fill(0,0,255);
        else 
            fill( 100 );
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        return ((r>=0 && r<NUM_ROWS) && (c>=0 && c<NUM_COLS));
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int a =-1;a<=1;a++)
        {
            for(int b=-1;b<=1;b++)
            {
                if(isValid(r+a,c+b) && bombs.contains(buttons[r+a][c+b]))
                {
                    numBombs++;
                }
            }
        }
        if(bombs.contains(buttons[r][c]))
        {
            numBombs--;
        }
        return numBombs;
    }

}
//BUGS
//make it so you can't die on the first click
