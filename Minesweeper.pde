

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private final static int  NUM_ROWS = 5;
private final static int  NUM_COLS = 5;
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
    for(int c=0;c<((int)(Math.random()*10))+NUM_COLS;c++)
    {
        setBombs();
    }
}
public void setBombs()
{   
    int randomRow = (int)(Math.random()*5);
    int randomColumn = (int)(Math.random()*5);
    if(!bombs.contains(buttons[randomRow][randomColumn]))
    {
        bombs.add(buttons[randomRow][randomColumn]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
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
        clicked = true;
        if(mouseButton == RIGHT)
        {
            marked = !marked;
        }
        else if(bombs.contains(this))
        {
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
        //your code here
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
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
        return (r>=0 && r<NUM_ROWS) && (c>=0 && c<NUM_COLS);
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int a =-1;a<=1;a++)
        {
            for(int b=-1;b<=1;b++)
            {
                if(bombs.contains(buttons[row+a][col+b]) && isValid(row,col))
                {
                    numBombs++;
                }
            }
        }
        if(bombs.contains(buttons[row][col]))
        {
            numBombs--;
        }
        return numBombs;
    }
}



