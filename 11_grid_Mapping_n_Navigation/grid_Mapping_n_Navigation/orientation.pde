/*
 * Call this function to change column
 * Takes to input parameters as: current column count and orientation of the Bot
 * Returns void
 * Dependencies:
 * -->  change_Dir (int my_Dir, int next_dir);
 * -->  updateGridInfo();
 * -->  line_following ();
 * -->  MotorControl (int driveL, int driveR);
*/

void changeColumn(int column_count, int dir)
{
    
    MotorControl(1,1);	delay(200);		// blind forward movement
    int r = (column_count%2);
    
    if(r==0)	 				// i.e column is even
    {
	///FIRST TURN
        dir = change_Dir (dir, east);		//change dir from south to east
        myDir = dir;                            // update mydir
	///FIRST TURN COMPLETE	
	
	digitalWrite(ledPin,HIGH);    // indicate start line following
        while( (!digitalRead(ELs)) || (!digitalRead(ERs)) )
        {  line_following();  }
        MotorControl(0,0);    //when the last sensors are on white stop
        digitalWrite(ledPin,LOW);    // indicate stop line following
        
        if( (digitalRead(ELs)) && (!digitalRead(Ms)) && (digitalRead(ERs)) )
        {
            digitalWrite(ledPin,HIGH);    // indicate start line following
            blockingNode = true;		// condition indicates a blocking node
            updateGridInfo();
            while( (digitalRead(ELs)) || (digitalRead(ERs)) )    {  MotorControl(1,1);  }
            delay(50);    MotorControl(0,0);
            digitalWrite(ledPin,LOW);    // indicate start line following
        }
        else  
        {
            updateGridInfo();
            while( (digitalRead(ELs)) || (digitalRead(ERs)) )    {  line_following();  }
        }
	MotorControl(1,1);	delay(250);	// blind forward movement // 300 here works correct 
						// 200 causes the bot to not cross the node and reach a sufficient distance so as to take a proper turn
        
	///SECON TURN
        dir = change_Dir (dir, north);		//change dir from east to north
        myDir = dir;                            // update mydir
	///SECON TURN COMPLETE
    }
	
    else	 			// i.e column is odd
    {
	///FIRST TURN
        dir = change_Dir (dir, east);		//change dir from south to east
        myDir = dir;                            // update mydir
	///FIRST TURN COMPLETE	

	digitalWrite(ledPin,HIGH);    // indicate start line following
        while( (!digitalRead(ELs)) || (!digitalRead(ERs)) )
        {  line_following();  }
        MotorControl(0,0);    //when the last sensors are on white stop
        digitalWrite(ledPin,LOW);    // indicate stop line following
        
        if( (digitalRead(ELs)) && (!digitalRead(Ms)) && (digitalRead(ERs)) )
        {
            delay(30);
            digitalWrite(ledPin,HIGH);    // indicate start line following
            blockingNode = true;		// condition indicates a blocking node
            updateGridInfo();
            while( (digitalRead(ELs)) || (digitalRead(ERs)) )    {  MotorControl(1,1);  }
            delay(50);    MotorControl(0,0);
            digitalWrite(ledPin,LOW);    // indicate start line following
        }
        else  
        {
            updateGridInfo();
            while( (digitalRead(ELs)) || (digitalRead(ERs)) )    {  line_following();  }
        }
	MotorControl(1,1);	delay(250);	// blind forward movement // 300 here works correct 
						// 200 causes the bot to not cross the node and reach a sufficient distance so as to take a proper turn
        
	///SECON TURN
        dir = change_Dir (dir, south);		//change dir from east to south
        myDir = dir;                            // update mydir
	///SECON TURN COMPLETE
    }
	
}

/*
 * Call this function to change the orientation of the robot
 * takes 2 input paremeters, current_direction & next_direction
 * returns changed direction
 * Dependencies:
 * -->  MotorControl (int driveL, int driveR);
*/
int change_Dir (int my_Dir, int next_dir)
{
	if (my_Dir == north)
	{
////////////////////////////
			switch (next_dir)
			{
				case (east):
					MotorControl(1,2);	////delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
					
				case (south):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
					
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
					
				case (west):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(!digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
					
				default: break;
			}
	}
////////////////////////////
	if (my_Dir == east)
	{
			switch (next_dir)
			{
				case (south):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;

				case (west):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
                                        
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (north):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(!digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				default: break;
			}
	}
////////////////////////////
	if (my_Dir == south)
	{
			switch (next_dir)
			{
				case (west):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (north):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
                                        
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (east):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(!digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;	
                                        
				default: break;
			}
	}
////////////////////////////
	if (my_Dir == west)
	{
			switch (next_dir)
			{
				case (north):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (east):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
                                        
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(!digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;

				case (south):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(!digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(digitalRead(Ms));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;	
	
				default: break;
			}
	}
        
	return (my_Dir); // return updated direction to calling function
}

