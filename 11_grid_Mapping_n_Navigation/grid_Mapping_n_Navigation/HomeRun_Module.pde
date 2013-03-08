/*
 * Call this function to achieve navigation to home location
 * Takes to input parameters as: current node count and orientation of the Bot
 * Returns void
 * Dependencies:
 * -->  change_Dir (int my_Dir, int next_dir);
 * -->  line_following ();
 * -->  MotorControl (int driveL, int driveR);
*/
void homeRun(int currentDir)
{
    int homeCount = 3;
    MotorControl(1,1);	delay(150);
    MotorControl(0,0);	delay(100);
    
    currentDir = change_Dir(currentDir, west);
    
        while(homeCount)
        {
            currentDir = change_Dir(currentDir, west);
            
            digitalWrite(ledPin,HIGH);    // indicate start line following
            while( (!digitalRead(ELs)) || (!digitalRead(ERs)) )
            {  line_following();  }
            MotorControl(0,0);    //when the last sensors are on white stop
            digitalWrite(ledPin,LOW);    // indicate stop line following
            
            while ( (digitalRead(ELs)) || (digitalRead(ERs)) )	{  MotorControl(1,1);  }		// skip current node
            delay(50);  MotorControl(0,0);	    delay(350);    // Stop bot and pause
            
            homeCount--;    // next node
        }
    
    // Code execution beyond this indicates that the bot has reached 0,0 (i.e., home location)
    MotorControl(1,1);    delay(150);
    MotorControl(0,0);    delay(100);
    currentDir = change_Dir(currentDir, south);
        
    digitalWrite(ledPin,HIGH);    // indicate start line following
    while( (!digitalRead(ELs)) || (!digitalRead(ERs)) )
    {  line_following();  }
    MotorControl(0,0);    delay(350);    //when the last sensors are on white stop
    digitalWrite(ledPin,LOW);    // indicate start line following
    	
    MotorControl(2,1);
    delay(700);
    while(!digitalRead(ELs));   		//while Extreme Left pin is not on white...turn right
    while(!digitalRead(Ms) );   		//while middle pin is not on white...turn right
    delay(15);  MotorControl(0,0);    delay(100);
    
    myDir = north;       // update robot's current direction
    homeStart = true;
}

/*
 * Call this function to achieve navigation to rescue zone after for block deposition
 * Takes to input parameters as: rescue location and orientation of the Bot
 * Returns void
 * Dependencies:
 * -->  change_Dir (int my_Dir, int next_dir);
 * -->  line_following ();
 * -->  MotorControl (int driveL, int driveR);
*/
int rescueRun(int res_col, int res_row, int orient)
{
  // navigation parameter initialization
    int col=0, ro=0, counter=0;
    int destCol=res_col, destRow=res_row;
    
    byte gridNavigation[4][4] = {  0, 0, 0, 0,
                                   0, 0, 0, 0,
                                   0, 0, 0, 0,
                                   0, 0, 0, 0  };    // navigation Map grid Bot
    
    int previousTurn = 0;
    
    byte navigate[16] = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255};    // path planning and trajectory
    // reading Grid navigation Map from EEPROM
    
    for (int i=3; i>=0; i--)
    {
        for (int j=3; j>=0; j--)
        {
            gridNavigation[i][j] = EEPROM.read(i*4+j);
        }
    }
    
    Serial.println();
    // navigation Map display on Serial port
    for (int i=0; i<=3; i++)
    {
        for (int j=0; j<=3; j++)
        {
            Serial.print(gridNavigation[i][j], DEC);
        }
        Serial.println();
    }
    Serial.println();
  
    while( (ro != destRow) || (col != destCol) )
    {
      Serial.println("I am in");
        if(ro<destRow)
        {
            if ( (gridNavigation[col][ro+1] == 1) && (ro+1<4) )
            {
                navigate[counter] = north;
                previousTurn = navigate[counter];
                ro++;  counter++;
                Serial.print("ro+");  Serial.print(ro,DEC);    Serial.print("  ");
            }
            else
            {
                if (col>destCol)
                {  
                    if ( (gridNavigation[col-1][ro] == 1) && (col-1>=0) && (previousTurn != east) )
                    {
                        navigate[counter] = west;
                        previousTurn = navigate[counter];
                        col--;  counter++;
                        Serial.print("col-");  Serial.print(col,DEC);    Serial.print("  ");
                    }
                    else
                    {
                        navigate[counter] = east;
                        previousTurn = navigate[counter];
                        col++;  counter++;
                        Serial.print("col+");  Serial.print(col,DEC);    Serial.print("  ");
                    }  
                }
                else
                {
                  if ( (gridNavigation[col+1][ro] == 1) && (col+1<4) )
                    {
                        navigate[counter] = east;
                        previousTurn = navigate[counter];
                        col++;  counter++;
                        Serial.print("col+");  Serial.print(col,DEC);    Serial.print("  ");
                    }
                }
            }
        }
        
        else
        {
            if (col>destCol)
            {
                if ( (gridNavigation[col-1][ro] == 1) && (col-1>=0) && (previousTurn != east) )
                {
                    navigate[counter] = west;
                    previousTurn = navigate[counter];
                    col--;  counter++;
                    Serial.print("col-");  Serial.print(col,DEC);    Serial.print("  ");
                }
                else
                {
                    navigate[counter] = east;
                    previousTurn = navigate[counter];
                    col++;  counter++;
                    Serial.print("col+");  Serial.print(col,DEC);    Serial.print("  ");
                }  
            }
            else
            {
                if ( (gridNavigation[col+1][ro] == 1) && (col+1<4) )
                {
                    navigate[counter] = east;
                    previousTurn = navigate[counter];
                    col++;  counter++;
                    Serial.print("col+");  Serial.print(col,DEC);    Serial.print("  ");
                }
            }
        }
        
    }

    Serial.println();
    for(int i=0;i<16;i++)
    {
        Serial.print(navigate[i],DEC);    Serial.println();
    }
    //temp
    //while(1);
    //
    // approach home node (0,0)
    digitalWrite(ledPin,HIGH);    // indicate start line following
    while( (!digitalRead(ERs)) || (!digitalRead(ELs)) )
    {  line_following();  }
    MotorControl(0,0);    //when the last sensors are on white stop
    digitalWrite(ledPin,LOW);    // indicate stop line following
    
    while ( (digitalRead(ELs)) || (digitalRead(ERs)) )	{  line_following();  }		// skip current node	
    delay(150);  MotorControl(0,0);	    delay(350);    // Stop bot and pause
    // home node reached
    
    counter =0;
    while(navigate[counter] < 255)
    {
        orient = change_Dir(orient, navigate[counter]);
        
        digitalWrite(ledPin,HIGH);    // indicate start line following
        while( (!digitalRead(ELs)) || (!digitalRead(ERs)) )
        {  line_following();  }
        MotorControl(0,0);    //when the last sensors are on white stop
        digitalWrite(ledPin,LOW);    // indicate stop line following
        
        while ( (digitalRead(ELs)) || (digitalRead(ERs)) )	{  line_following();  }		// skip current node	
        delay(50);  MotorControl(0,0);	    delay(350);    // Stop bot and pause
        
        counter++;    // next node
    }
return orient;
}


