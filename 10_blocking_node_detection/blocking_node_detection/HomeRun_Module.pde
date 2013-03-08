/*
 * Call this function to achieve navigation to home location
 * Takes to input parameters as: current node count and orientation of the Bot
 * Returns void
 * Dependencies:
 * -->  change_Dir (int my_Dir, int next_dir);
 * -->  line_following ();
 * -->  MotorControl (int driveL, int driveR);
*/
void homeRun(int nodeCount, int currentDir)
{
    int count = nodeCount;
    int column = count/4;
    int row = count%4;
    
	if ( (count>3) && (column%2) )	// for odd column // modify row traverse logic
	{
		row = 3-row;
	}
	count = column+row;	// count of nodes to be traversed for home_run
	
	while (count)	// while all nodes are not traversed
	{
		if (column)	// if column to be spanned are 1 or more
		{
			currentDir = change_Dir (currentDir, west);		//change dir to west
			
			while(column && count)
			{
			      digitalWrite(13,HIGH);    // indicate start line following
            	      	      while( (!digitalRead(A4)) || (!digitalRead(A0)) )
			      {  line_following();  }
			      MotorControl(0,0);    //when the last sensors are on white stop
			      digitalWrite(13,LOW);    // indicate stop line following
			      column--;	count--;       // subtract the column node covered from column & total node count
			      
			      while ( (digitalRead(A4)) || (digitalRead(A0)) )	{  MotorControl(1,1);  }	// skip current node	
			      delay(150);    MotorControl(0,0);	    delay(350);    // Stop bot and pause
			}
		}
		currentDir = change_Dir (currentDir, south);		//change dir from west to south
		
		while(row && count)
		{
			      digitalWrite(13,HIGH);    // indicate start line following
            	      	      while( (!digitalRead(A4)) || (!digitalRead(A0)) )
			      {  line_following();  }
			      MotorControl(0,0);    //when the last sensors are on white stop
			      digitalWrite(13,LOW);    // indicate stop line following
			      row--;	count--;       // subtract the row node covered from row & total node count
			      
			      while ( (digitalRead(A4)) || (digitalRead(A0)) )	{  MotorControl(1,1);  }		// skip current node	
			      delay(50);  MotorControl(0,0);	    delay(350);    // Stop bot and pause
		}
	}
        // Code execution beyond this indicates that the bot has reached 0,0 (i.e., home location)
	MotorControl(1,1);    delay(250);    MotorControl(0,0);
	delay(100);
	
        digitalWrite(13,HIGH);    // indicate start line following
	while( (!digitalRead(A4)) || (!digitalRead(A0)) )
	{  line_following();  }
	MotorControl(0,0);    delay(350);    //when the last sensors are on white stop
        digitalWrite(13,LOW);    // indicate start line following
	
	MotorControl(2,1);
	delay(700);
        while(!digitalRead(A4));   		//while middle pin is not on white...turn right
	while(!digitalRead(A2) );
	delay(15);  MotorControl(0,0);    delay(100);
	
	myDir = north;       // update robot's current direction
	homeStart = true;
}

