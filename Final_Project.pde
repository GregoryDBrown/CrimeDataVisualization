// Author: Gregory Brown
// SDSU - GEOG 581 - Skupin
// USA CRIME MAPPING: 1960 - 2000 (SINGLE VARIABLE) v1.0

// KNOWN BUGS:
// 1. IF 2 STATES HAVE EQUAL VALUES & ARE ALPHABETICALLY NEXT TO EACH OTHER BUT 
//    SWITCHED COMPARED TO FULL NAME AND ABBREVIATION, THEY WILL SWITCH NAMES IN MAP. 
//    (EXAMPLE: NORTH DAKOTA / NEW HAMPSHIRE.
// 2. SORTED DATA (ASCENDING/DESCENDING) DOES NOT CHANGGE COLOR CORRECTLY ON THE MAP
//-----------------------------------------------------------------------------------------


int CurrentYearInt = 1960;
int CurrentYearIntNew = 0;
int CurrentCrime = 0;
int CurrentCrimeNew;
int CurrentColor = 0;
int CurrentColorNew;
int CurrentAnimate = 0;
int CurrentAnimateNew;
int MiniBoxMouseN;
int StateMouseOver = 0;
int DataCrimeBoxOverlay, ColorBoxOverlay, SortBoxOverlay, AnimateBoxOverlay, BLACKCOLOR, WHITECOLOR, GRAYCOLOR;
int z;
String CurrentState, CurrentStateString, CurrentStateAbbr, CurrentStateMouseOver;

// CSV Table
Table crime;

// Store table values into a list.
StringList State, CrimeValX, CRIMEVALUE, AnimateStrings, SortStrings;

FloatList Population, Index_offense_rate, Violent_crime_rate, Murder_and_nonnegligent_manslaughter_rate,
  Forcible_rape_rate, Robbery_rate, Aggravated_assault_rate, Property_crime_rate, Burglary_rate, Larceny_theft_rate,
  Motor_vehicle_theft_rate;

FloatDict SortedData, SortedNames;

// USA SVG
String [] StateString = {"AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", 
  "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", 
  "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"};

PShape States, USA, StateShape;

PGraphics Basemap;

// Amount of bars
int BARAMOUNT = 51;

// Pixel Distance from left to right
float DISTANCE = 100;

// Distance between bars
int SPREADOUT = 2;

// Bar Width
float BARWIDTH;

// Animation Speed (60 = 1 second)
int ANIMATIONSPEED = 30;

float x1, y1, x2, y2, x3, y3, x4, DATAVALUE, ADDVALUE, DATAVALUE2, DATADIVIDE, CrimeValue1, ColorBall1, ColorBall2, ColorBall3, MaxValue;
float DATADIVIDE2 = 1;

FloatList DATA, DATA2, DATACHECK, CURRENTCOLOR, CURRENTCOLOR2, COLORCHECK;

FloatList MouseXLeft, MouseXRight, MouseYUp, MouseYDown;

int DELAY = 0;
int DELAY1 = 0;
int DELAY2 = 0;
int DELAY3 = 0;
int DELAY4 = 0;
int SORT = 0;
int count = 0;

float MainColor1, MainColor2, MainColor3, ColorA, ColorB, ColorC, ColorD, ColorE, ColorF, ColorG, ColorH, ColorI, ColorJ, ColorK, ColorL;

float MouseWindowX1, MouseWindowX2, MouseWindowY1, MouseWindowY2;

// Color Scheme Boxes
color ColorScheme1, ColorScheme2, ColorScheme3, ColorScheme4, BasemapColor;

boolean MINIBOX = false;
float Right, Left, Up, Down;

boolean YEARCHANGE = false;
int YEARTRACK = 1960;

int OverDataBox, OverColorBox, OverSortBox;

boolean REDRAW = true;
boolean SORTING = false;
boolean DATAOVER = false;
boolean COLORSCHEMEOVER = false;
boolean SORTDATAOVER = false;
boolean ANIMATEDATAOVER = false;
boolean DATABOXES = false;
boolean COLORBOXES = false;
boolean SORTBOXES = false;
boolean ANIMATEBOXES = false;
boolean DATABOXESOVER = false;
boolean COLORBOXESOVER = false;
boolean SORTBOXESOVER = false;
boolean ANIMATEBOXESOVER = false;
boolean ChangeSpeed = false;
boolean TOGGLENAMES = false;
boolean TOGGLENUMBERS = false;
boolean INVERTCOLOR = false;

boolean REVERSE = false;
boolean PLAY = false;

//boolean sketchFullScreen() 
//  {
//  return false;
//  }
//-----------------------------------------------------------------------------------------


void setup()
  {
  //size(displayWidth, displayHeight);
  size(1350, 900);
  frame.setTitle("Animated Data Analysis");
  smooth();
  if(frame != null)
    {  
    frame.setResizable(true);
    }
    
  background(255);

  USA = loadShape("data/usa.svg");
  
  State = new StringList();
  CrimeValX = new StringList();
  SortStrings = new StringList();
  AnimateStrings = new StringList();
  Population = new FloatList();
  Index_offense_rate = new FloatList();
  Violent_crime_rate = new FloatList();
  Murder_and_nonnegligent_manslaughter_rate = new FloatList();
  Forcible_rape_rate = new FloatList();
  Robbery_rate = new FloatList();
  Aggravated_assault_rate = new FloatList();
  Property_crime_rate = new FloatList();
  Burglary_rate = new FloatList();
  Larceny_theft_rate = new FloatList();
  Motor_vehicle_theft_rate = new FloatList();
  
  CrimeValX.append("Index Offense Rate");
  CrimeValX.append("Violent Crime Rate");
  CrimeValX.append("Murder Rate");
  CrimeValX.append("Forcible Rape Rate");
  CrimeValX.append("Robbery Rate");
  CrimeValX.append("Aggravated Assault Rate");
  CrimeValX.append("Property Crime Rate");
  CrimeValX.append("Burglary Rate");
  CrimeValX.append("Larceny Theft Rate");
  CrimeValX.append("Motor Vehicle Theft Rate");
  CrimeValX.append("Population");
  
  SortStrings.append("Sort: Alphabetical");
  SortStrings.append("Sort: Ascending");
  SortStrings.append("Sort: Descending");
  SortStrings.append("Toggle Bar Graph Names");
  SortStrings.append("Toggle Bar Graph Numbers");
  SortStrings.append("Invert Background Color");
  
  AnimateStrings.append("Play");
  AnimateStrings.append("Stop");
  AnimateStrings.append("Reverse");
  AnimateStrings.append("Slow");
  AnimateStrings.append("Medium");
  AnimateStrings.append("Fast");
  
  crime = loadTable("data/crime.csv", "header");
  
  for (TableRow row : crime.rows())
    {
    
    String state = row.getString("State");
    int population = row.getInt("Population");
      
    float IOR = row.getInt("Index offense rate");
    float VCR = row.getInt("Violent Crime rate");
    float MANMR = row.getInt("Murder and nonnegligent manslaughter rate");
    float FRR = row.getInt("Forcible rape rate");
    float RR = row.getInt("Robbery rate");
    float AAR = row.getInt("Aggravated assault rate");
    float PCR = row.getInt("Property crime rate");
    float BR = row.getInt("Burglary rate");
    float LTR = row.getInt("Larceny-theft rate");
    float MVTR = row.getInt("Motor vehicle theft rate");
    
    State.append(state);
    Population.append(population);
      
    Index_offense_rate.append(IOR);
    Violent_crime_rate.append(VCR);
    Murder_and_nonnegligent_manslaughter_rate.append(MANMR);
    Forcible_rape_rate.append(FRR);
    Robbery_rate.append(RR);
    Aggravated_assault_rate.append(AAR);
    Property_crime_rate.append(PCR);
    Burglary_rate.append(BR);
    Larceny_theft_rate.append(LTR);
    Motor_vehicle_theft_rate.append(MVTR);
    }
    
  SortedNames = new FloatDict();
  SortedData = new FloatDict();    
  DATA = new FloatList();
  DATA2 = new FloatList();
  DATACHECK = new FloatList(); 
  CURRENTCOLOR = new FloatList();
  CURRENTCOLOR2 = new FloatList();
  COLORCHECK = new FloatList();
  
  MouseXRight = new FloatList();
  MouseXLeft = new FloatList();
  MouseYUp = new FloatList();
  MouseYDown = new FloatList();  
    
  for (int n = 0; n < BARAMOUNT; n++)
    {
    DATA2.append(height);
    CURRENTCOLOR2.append(0);
    CURRENTCOLOR2.append(0);
    CURRENTCOLOR2.append(0);
    }  
  }
//-----------------------------------------------------------------------------------------  


void draw()
  {
  update(mouseX, mouseY);
  
  if (INVERTCOLOR == true)
    {
    if (BLACKCOLOR < 255)
      {
      BLACKCOLOR = BLACKCOLOR + 255/ANIMATIONSPEED;
      }
    if (BLACKCOLOR >= 255)
      {
      BLACKCOLOR = 255;
      }
    if (WHITECOLOR > 0)
      {
      WHITECOLOR = WHITECOLOR - 255/ANIMATIONSPEED;
      }
    if (WHITECOLOR <= 0)
      {
      WHITECOLOR = 0;
      }
    if (GRAYCOLOR < 205)
      {
      GRAYCOLOR = GRAYCOLOR + 155/ANIMATIONSPEED;
      }
    if (GRAYCOLOR >= 205)
      {
      GRAYCOLOR = 205;
      }
    }
  else
    {
    if (BLACKCOLOR > 0)
      {
      BLACKCOLOR = BLACKCOLOR - 255/ANIMATIONSPEED;
      }
    if (BLACKCOLOR <= 0)
      {
      BLACKCOLOR = 0;
      }
    if (WHITECOLOR < 255)
      {
      WHITECOLOR = WHITECOLOR + 255/ANIMATIONSPEED;
      }
    if (WHITECOLOR >= 255)
      {
      WHITECOLOR = 255;
      }
    if (GRAYCOLOR > 50)
      {
      GRAYCOLOR = GRAYCOLOR - 155/ANIMATIONSPEED;
      }
    if (GRAYCOLOR <= 50)
      {
      GRAYCOLOR = 50;
      }
    }
  
  smooth();
  background(BLACKCOLOR);
  
  if (PLAY == true)
    {
    DELAY++;
    if (REVERSE == false)
      {
      if (DELAY == ANIMATIONSPEED)
        {
        if (CurrentYearInt == 2000)
          {
          CurrentYearInt = 1959;
          }        
        CurrentYearInt++;
        DELAY = 0;
        }
      }
    if (REVERSE == true)
      {
      if (DELAY == ANIMATIONSPEED)
        {
        if (CurrentYearInt == 1960)
          {
          CurrentYearInt = 2001;
          }        
        CurrentYearInt--;
        DELAY = 0;
        }
      }
    }
  
  textAlign(CENTER, CENTER);
  fill(WHITECOLOR, WHITECOLOR, WHITECOLOR, 25);
  if (height >= width)
    {
    textSize(width*.5);
    }
  if (width > height)
    {
    textSize(height*.5);
    }
  text(CurrentYearInt, width/2, 3*height/5);
  
  
  // Calculate New Data
  if (CurrentYearInt != CurrentYearIntNew || CurrentCrime != CurrentCrimeNew || CurrentColor != CurrentColorNew 
    || ChangeSpeed == true || REDRAW == true)
    {      
    CurrentYearIntNew = CurrentYearInt;
    CurrentCrimeNew = CurrentCrime;
    CurrentColorNew = CurrentColor;
    ChangeSpeed = false;
    REDRAW = false;
    
    DATA = new FloatList();
    DATACHECK = new FloatList();
    CURRENTCOLOR = new FloatList();
    COLORCHECK = new FloatList();
    SortedNames = new FloatDict();
    SortedData = new FloatDict();    
    
    // Color Scheme
    if (CurrentColor == 0)
      {
      ColorA = 255; 
      ColorB = 255;
      ColorC = 204; 
      ColorD = 161; 
      ColorE = 218; 
      ColorF = 180; 
      ColorG = 65; 
      ColorH = 182;
      ColorI = 196;
      ColorJ = 34;
      ColorK = 94;
      ColorL = 168;
      }
    if (CurrentColor == 1)
      {
      ColorA = 255; 
      ColorB = 255;
      ColorC = 204; 
      ColorD = 194; 
      ColorE = 230; 
      ColorF = 153; 
      ColorG = 120; 
      ColorH = 198;
      ColorI = 121;
      ColorJ = 35;
      ColorK = 132;
      ColorL = 67;
      }
    if (CurrentColor == 2)
      {
      ColorA = 255; 
      ColorB = 255;
      ColorC = 212; 
      ColorD = 254; 
      ColorE = 217; 
      ColorF = 142; 
      ColorG = 254; 
      ColorH = 153;
      ColorI = 41;
      ColorJ = 204;
      ColorK = 76;
      ColorL = 2;
      }
    if (CurrentColor == 3)
      {
      ColorA = 254; 
      ColorB = 235;
      ColorC = 226; 
      ColorD = 251; 
      ColorE = 180; 
      ColorF = 185; 
      ColorG = 247; 
      ColorH = 104;
      ColorI = 161;
      ColorJ = 174;
      ColorK = 1;
      ColorL = 126;
      }
    if (CurrentColor == 4)
      {
      ColorA = 247; 
      ColorB = 247;
      ColorC = 247; 
      ColorD = 204; 
      ColorE = 204; 
      ColorF = 204; 
      ColorG = 150; 
      ColorH = 150;
      ColorI = 150;
      ColorJ = 82;
      ColorK = 82;
      ColorL = 82;
      }
    
    z = ((CurrentYearInt - 1960) * 51);
    
    for (int n = 0; n < 51; n++)
      {
      if (CurrentCrime == 0)
        {
        MaxValue = Index_offense_rate.max();
        ADDVALUE = height - ((Index_offense_rate.get(n + z)*(height/4))/Index_offense_rate.max());
        }
      else if (CurrentCrime == 1)
        {
        MaxValue = Violent_crime_rate.max();
        ADDVALUE = height - ((Violent_crime_rate.get(n + z)*(height/4))/Violent_crime_rate.max());
        }
      else if (CurrentCrime == 2)
        {
        MaxValue = Murder_and_nonnegligent_manslaughter_rate.max();
        ADDVALUE = height - ((Murder_and_nonnegligent_manslaughter_rate.get(n + z)*(height/4))/Murder_and_nonnegligent_manslaughter_rate.max());
        }
      else if (CurrentCrime == 3)
        {
        MaxValue = Forcible_rape_rate.max();
        ADDVALUE = height - ((Forcible_rape_rate.get(n + z)*(height/4))/Forcible_rape_rate.max());
        }
      else if (CurrentCrime == 4)
        {
        MaxValue = Robbery_rate.max();
        ADDVALUE = height - ((Robbery_rate.get(n + z)*(height/4))/Robbery_rate.max());
        }
      else if (CurrentCrime == 5)
        {
        MaxValue = Aggravated_assault_rate.max();
        ADDVALUE = height - ((Aggravated_assault_rate.get(n + z)*(height/4))/Aggravated_assault_rate.max());
        } 
      else if (CurrentCrime == 6)
        {
        MaxValue = Property_crime_rate.max();
        ADDVALUE = height - ((Property_crime_rate.get(n + z)*(height/4))/Property_crime_rate.max());
        }
      else if (CurrentCrime == 7)
        {
        MaxValue = Burglary_rate.max();
        ADDVALUE = height - ((Burglary_rate.get(n + z)*(height/4))/Burglary_rate.max());
        }
      else if (CurrentCrime == 8)
        {
        MaxValue = Larceny_theft_rate.max();
        ADDVALUE = height - ((Larceny_theft_rate.get(n + z)*(height/4))/Larceny_theft_rate.max());
        }
      else if (CurrentCrime == 9)
        {
        MaxValue = Motor_vehicle_theft_rate.max();
        ADDVALUE = height - ((Motor_vehicle_theft_rate.get(n + z)*(height/4))/Motor_vehicle_theft_rate.max());
        }
      else if (CurrentCrime == 10)
        {
        MaxValue = Population.max();
        ADDVALUE = height - ((Population.get(n + z)*(height/4))/Population.max());
        }
      DATA.append(ADDVALUE);      
      DATADIVIDE = height;
      }
    
    for (int n = 0; n < DATA.size(); n++)
      {
      SortedData.set(StateString[n], DATA.get(n));
      SortedNames.set(State.get(n), DATA.get(n));
      }
    
    if (SORT == 1)
      {
      DATA.sortReverse();
      SortedData.sortValuesReverse();
      SortedNames.sortValuesReverse();
      }
    else if (SORT == 2)
      {
      DATA.sort();
      SortedData.sortValues();
      SortedNames.sortValues();
      }
    else
      {
      } 

    for (int n = 0; n < DATA.size(); n++)
      {
      // Lighter -- > Darker
      if (DATA.get(n)/height > (1 - (.25/4)))
        {
        MainColor1 = ColorA;
        MainColor2 = ColorB;
        MainColor3 = ColorC;
        }
      else if (DATA.get(n)/height > (1 - (.5/4)))
        {
        MainColor1 = ColorD;
        MainColor2 = ColorE;
        MainColor3 = ColorF;
        }
      else if (DATA.get(n)/height > (1 - (.75/4)))
        {
        MainColor1 = ColorG;
        MainColor2 = ColorH;
        MainColor3 = ColorI;
        }
      else if (DATA.get(n)/height >= 0)
        {
        MainColor1 = ColorJ;
        MainColor2 = ColorK;
        MainColor3 = ColorL;
        }
        
      CURRENTCOLOR.append(MainColor1);
      CURRENTCOLOR.append(MainColor2);
      CURRENTCOLOR.append(MainColor3);

      if (CURRENTCOLOR.get(3*n) > CURRENTCOLOR2.get(3*n))
        {
        COLORCHECK.append((CURRENTCOLOR.get(3*n) - CURRENTCOLOR2.get(3*n))/ANIMATIONSPEED);
        }
      if (CURRENTCOLOR.get(3*n) < CURRENTCOLOR2.get(3*n))
        {
        COLORCHECK.append((CURRENTCOLOR2.get(3*n) - CURRENTCOLOR.get(3*n))/ANIMATIONSPEED);
        }  
      if (CURRENTCOLOR.get(3*n) == CURRENTCOLOR2.get(3*n))
        {
        COLORCHECK.append(0);
        } 
        
      if (CURRENTCOLOR.get(3*n + 1) > CURRENTCOLOR2.get(3*n + 1))
        {
        COLORCHECK.append((CURRENTCOLOR.get(3*n + 1) - CURRENTCOLOR2.get(3*n + 1))/ANIMATIONSPEED);
        }
      if (CURRENTCOLOR.get(3*n + 1) < CURRENTCOLOR2.get(3*n + 1))
        {
        COLORCHECK.append((CURRENTCOLOR2.get(3*n + 1) - CURRENTCOLOR.get(3*n + 1))/ANIMATIONSPEED);
        }
      if (CURRENTCOLOR.get(3*n + 1) == CURRENTCOLOR2.get(3*n + 1))
        {
        COLORCHECK.append(0);
        } 
        
      if (CURRENTCOLOR.get(3*n + 2) > CURRENTCOLOR2.get(3*n + 2))
        {
        COLORCHECK.append((CURRENTCOLOR.get(3*n + 2) - CURRENTCOLOR2.get(3*n + 2))/ANIMATIONSPEED);
        }
      if (CURRENTCOLOR.get(3*n + 2) < CURRENTCOLOR2.get(3*n + 2))
        {
        COLORCHECK.append((CURRENTCOLOR2.get(3*n + 2) - CURRENTCOLOR.get(3*n + 2))/ANIMATIONSPEED);
        }
      if (CURRENTCOLOR.get(3*n + 2) == CURRENTCOLOR2.get(3*n + 2))
        {
        COLORCHECK.append(0);
        } 
      
      // Animation speed
      if (DATA.get(n) > DATA2.get(n))
        {    
        DATACHECK.append((DATA.get(n) - DATA2.get(n))/ANIMATIONSPEED);
        }
      if (DATA2.get(n) > DATA.get(n))
        {    
        DATACHECK.append((DATA2.get(n) - DATA.get(n))/ANIMATIONSPEED);
        }
      if (DATA.get(n) == DATA2.get(n))
        {    
        DATACHECK.append(0);
        }
      }
    }

  textAlign(CENTER, CENTER);
    
  DISTANCE = width*.1;  
  float BARWIDTH = (((width-(DISTANCE*2))  /  BARAMOUNT));
  float BARBETWEEN = (((width-(DISTANCE*2)) - (BARWIDTH + BARWIDTH*(DATA.size()-1))));
  
  x1 = DISTANCE;
  y1 = height-(height/16);
  x2 = BARWIDTH+DISTANCE;
  y2 = height-(height/16);
  x3 = BARWIDTH+DISTANCE;
  x4 = DISTANCE;  
      
  noStroke();    
      
  for (int n = 0; n < DATA.size(); n++)
    {
    // Redraw Functions.  Establishes size and bar-growth rate.
    DATADIVIDE2 = height/DATADIVIDE;
    
    if (DATADIVIDE != height)
      {
      DATA2.set(n, DATA.get(n)*DATADIVIDE2);
      }
    
    if (DATA.get(n)*DATADIVIDE2 > DATA2.get(n))
      {
      DATA2.set(n, DATA2.get(n) + DATACHECK.get(n));
      }
    if (DATA2.get(n) > DATA.get(n)*DATADIVIDE2)
      {
      DATA2.set(n, DATA2.get(n) - DATACHECK.get(n));
      }
      
    // Pulls colors out of color array.
    if (CURRENTCOLOR.get(3*n) > CURRENTCOLOR2.get(3*n))
      {
      CURRENTCOLOR2.set((3*n), CURRENTCOLOR2.get(3*n) + COLORCHECK.get(3*n));
      }
    if (CURRENTCOLOR.get(3*n) < CURRENTCOLOR2.get(3*n))
      {
      CURRENTCOLOR2.set((3*n), CURRENTCOLOR2.get(3*n) - COLORCHECK.get(3*n));
      }
    if (CURRENTCOLOR.get(3*n) == CURRENTCOLOR2.get(3*n))
      {
      CURRENTCOLOR2.set((3*n), CURRENTCOLOR2.get(3*n) - COLORCHECK.get(3*n));
      } 
      
    if (CURRENTCOLOR.get(3*n + 1) > CURRENTCOLOR2.get(3*n + 1))
      {
      CURRENTCOLOR2.set((3*n + 1), CURRENTCOLOR2.get(3*n + 1) + COLORCHECK.get(3*n + 1));
      }
    if (CURRENTCOLOR.get(3*n + 1) < CURRENTCOLOR2.get(3*n + 1))
      {
      CURRENTCOLOR2.set((3*n + 1), CURRENTCOLOR2.get(3*n + 1) - COLORCHECK.get(3*n + 1));
      }
    if (CURRENTCOLOR.get(3*n + 1) == CURRENTCOLOR2.get(3*n + 1))
      {
      CURRENTCOLOR2.set((3*n + 1), CURRENTCOLOR2.get(3*n + 1) - COLORCHECK.get(3*n + 1));
      } 
      
    if (CURRENTCOLOR.get(3*n + 2) > CURRENTCOLOR2.get(3*n + 2))
      {
      CURRENTCOLOR2.set((3*n + 2), CURRENTCOLOR2.get(3*n + 2) + COLORCHECK.get(3*n + 2));
      }
    if (CURRENTCOLOR.get(3*n + 2) < CURRENTCOLOR2.get(3*n + 2))
      {
      CURRENTCOLOR2.set((3*n + 2), CURRENTCOLOR2.get(3*n + 2) - COLORCHECK.get(3*n + 2));
      }
    if (CURRENTCOLOR.get(3*n + 2) == CURRENTCOLOR2.get(3*n + 2))
      {
      CURRENTCOLOR2.set((3*n + 2), CURRENTCOLOR2.get(3*n + 2) - COLORCHECK.get(3*n + 2));
      } 
     
    // Variable
    y3 = DATA2.get(n)-(height/16);
    
    String[] NewValues = SortedData.keyArray();
    CurrentStateAbbr = NewValues[n];
    
    stroke(0);
    strokeWeight(SPREADOUT);

    fill(CURRENTCOLOR2.get(3*n), CURRENTCOLOR2.get(3*n + 1), CURRENTCOLOR2.get(3*n + 2));
      
    // Bars
    quad(x1 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n, y2, x2 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n, y2, x3 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n, 
      y3, x4 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n, y3);
    
    if (CurrentYearInt <= 1964 && CurrentStateAbbr == "NY")
      {
      stroke(BLACKCOLOR);
      fill(BLACKCOLOR);
      }
    
    PShape States = USA.getChild(CurrentStateAbbr);
    States.disableStyle();
    
    if(height >= width)
      {
      shape(States, ((width/2) - ((933*((width-100)*.001))/2)), 50, 933*((width-100)*.001), 600*((width-100)*.001));
      }
    else if (width > height && height >= 100)
      {
      shape(States, ((width/2) - ((933*((height-100)*.001))/2)), 50, 933*((height-100)*.001), 600*((height-100)*.001));
      }
    else if (height <= 100)
      {
      }
      
    if (n == 0)
      {
      MouseXRight = new FloatList();
      MouseXLeft = new FloatList();
      MouseYUp = new FloatList();
      MouseYDown = new FloatList();   
      }
      
    MouseXLeft.append(x1 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n);
    MouseXRight.append(x2 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n);
    MouseYUp.append(y3);
    MouseYDown.append(y1);
    
    if (TOGGLENAMES == true)
      {
      if (CurrentYearInt <= 1964 && CurrentStateAbbr == "NY")
        {
        }   
      else
        {
        fill(WHITECOLOR);
        textSize(width*.008);
        text(CurrentStateAbbr, x1 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n + 
          (x2 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n - (x1 + (BARWIDTH + BARBETWEEN/BARAMOUNT)*n))/2, height - (height/18));
        }
      }
    }
  
  if(MINIBOX == true)
    {
    // Highlight
    stroke(0, 0, 0, 100);
    fill(0, 0, 0, 100);    
    rect(Left, (height - (1)*(height/16)), Right - Left, Up - (height - (1)*(height/16)));
    
    PShape States = USA.getChild(CurrentStateString);
    States.disableStyle();
    
    if(height >= width)
      {
      shape(States, ((width/2) - ((933*((width-100)*.001))/2)), 50, 933*((width-100)*.001), 600*((width-100)*.001));
      }
    else if (width > height && height >= 100)
      {
      shape(States, ((width/2) - ((933*((height-100)*.001))/2)), 50, 933*((height-100)*.001), 600*((height-100)*.001));
      }
    else if (height <= 100)
      {
      }
    }
 
  // Bar graph lines and number text
  for (int n = 0; n < 5; n++)
    {
    fill(WHITECOLOR);
    textAlign(RIGHT, CENTER);
    textSize(width*.01);
    if (TOGGLENUMBERS == true)
      {
      text(int((MaxValue/4)*n), (width*.1) - width*.01, height - (n+1)*(height/16));
      }
    strokeWeight(2);
    stroke(WHITECOLOR); 
    if (n >= 1)
      {
      strokeWeight(1);
      stroke(GRAYCOLOR);
      }
    line((width*.1 - 5), height - (n+1)*(height/16), (width + 5 - width*.1), height - (n+1)*(height/16));
    }
  
  // Year Select
  fill(200, 200, 200, 200);
  rectMode(CENTER);
  rect(width/2, 15, (width - width*.17), 25, 15);
  rectMode(CORNER);
  
  stroke(BLACKCOLOR);
  line((width*.1), 15, (width - width*.1), 15);
  
  for (int n = 0; n < 41; n++)
    {
    if (YEARTRACK - 1960 == n && YEARCHANGE == true)
      {
      strokeWeight(2);
      stroke(ColorG, ColorH, ColorI);
      fill(255, 255, 255, 220);
      rect((width*.1) + width*.02*n - 30, 44, 60, 20, 7);
      fill(ColorG, ColorH, ColorI);
      triangle((width*.1) + width*.02*n, 38, (width*.1) + width*.02*n - 5,  43, (width*.1) + width*.02*n + 5, 43);
      textAlign(CENTER, CENTER);
      textSize(12);
      fill(0);
      text(YEARTRACK, (width*.1) + width*.02*n, 53);
      }
    
    if (width < 900)
      {
      if (CurrentYearInt - 1960 == n)
        {
        fill(BLACKCOLOR);
        strokeWeight(2);
        stroke(0);
        ellipse((width*.1) + width*.02*n, 15, width*.017, width*.017);    
        }
      else
        {
        strokeWeight(2);
        if (YEARTRACK - 1960 == n && YEARCHANGE == true)
          {
          strokeWeight(3);
          }
        fill(ColorG, ColorH, ColorI);
        stroke(0);
        ellipse((width*.1) + width*.02*n, 15, width*.017, width*.017);
        }
      }
    else if (width >= 900)
      {      
      if (CurrentYearInt - 1960 == n)
        {
        fill(BLACKCOLOR);
        strokeWeight(2);
        stroke(0);
        ellipse((width*.1) + width*.02*n, 15, 15, 15);       
        }
      else
        {
        strokeWeight(2);
        if (YEARTRACK - 1960 == n && YEARCHANGE == true)
          {
          strokeWeight(3);
          }
        fill(ColorG, ColorH, ColorI);
        stroke(0);
        ellipse((width*.1) + width*.02*n, 15, 15, 15);
        }
      }
    }
  
  // Text
  textAlign(CENTER, CENTER);
  textSize(width*.02);
  fill(WHITECOLOR);
  text("1960", (width*.1) - width*.05, 12);
  text("2000", width - (width*.1) + width*.05, 12);
  
  
  if (width >= height)
    {
    textSize(height*.035); 
    }
  if (height > width)
    {
    textSize(width*.035);
    }
  text(CrimeValX.get(CurrentCrime), width/2, height - height*.029);
  
  // Data Select
  strokeWeight(2);
  stroke(0);
  if (width >= height)
    {
    textSize(height*.013);
    }
  if (height > width)
    {
    textSize(width*.013);
    }
  textAlign(CENTER, CENTER);
  
  fill(200, 200, 200, 200);
  if (DATAOVER == true)
    {
    fill(240, 240, 240, 200);
    }
  rect(width*.1, (height - ((height*5)/16) - height*.001), (width - width*.2)/4, -height*.025);
  fill(0);
  text("DATA", (width*.2 + (width - width*.2)/4)/2, (height - ((height*5)/16) - height*.015));
  
  fill(200, 200, 200, 200);
  if (COLORSCHEMEOVER == true)
    {
    fill(240, 240, 240, 200);
    }     
  rect(width*.1 + (width - width*.2)/4, (height - ((height*5)/16) - height*.001), (width - width*.2)/4, -height*.025);
  fill(0);
  text("COLOR SCHEME", (width*.2 + 3*(width - width*.2)/4)/2, (height - ((height*5)/16) - height*.015));
  
  fill(200, 200, 200, 200);
  if (SORTDATAOVER == true)
    {
    fill(240, 240, 240, 200);
    }   
  rect(width*.1 + 2*(width - width*.2)/4, (height - ((height*5)/16) - height*.001), (width - width*.2)/4, -height*.025);
  fill(0);
  text("OPTIONS", (width*.2 + 5*(width - width*.2)/4)/2, (height - ((height*5)/16) - height*.015));
  
  fill(200, 200, 200, 200);
  if (ANIMATEDATAOVER == true)
    {
    fill(240, 240, 240, 200);
    }   
  rect(width*.1 + 3*(width - width*.2)/4, (height - ((height*5)/16) - height*.001), (width - width*.2)/4, -height*.025);
  fill(0);
  text("ANIMATE", (width*.2 + 7*(width - width*.2)/4)/2, (height - ((height*5)/16) - height*.015));
   
  textAlign(LEFT, CENTER);
  if (DATABOXES == true)
    {
    for (int n = 0; n < CrimeValX.size(); n++)
      {
      strokeWeight(1);
      stroke(0);
      fill(200, 200, 200, 200);
      rect(width*.1, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
      if (DataCrimeBoxOverlay == n)
        {
        noStroke();
        fill(0, 0, 0, 100);
        rect(width*.1, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
        }
      fill(0);
      text(CrimeValX.get(n), width*.1 + 2, (height - ((height*5)/16) - height*.015) - height*.025*n - height*.025);
      }
    }
  if (COLORBOXES == true)
    {
    for (int n = 0; n < 5; n++)
      {
      strokeWeight(1);
      stroke(0);
      fill(200, 200, 200, 200);
      rect(width*.1 + (width - width*.2)/4, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
      if (ColorBoxOverlay == n)
        {
        noStroke();
        fill(0, 0, 0, 100);
        rect(width*.1 + (width - width*.2)/4, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
        }
        fill(0);
      if (n == 0)
        {
        ColorScheme1 = color(34, 94, 168);
        ColorScheme2 = color(65, 182, 196);
        ColorScheme3 = color(161, 218, 180);
        ColorScheme4 = color(255, 255, 204);
        }
      if (n == 1)
        {
        ColorScheme1 = color(35, 132, 67);
        ColorScheme2 = color(120, 198, 121);
        ColorScheme3 = color(194, 230, 153);
        ColorScheme4 = color(255, 255, 204);
        }
      if (n == 2)
        {
        ColorScheme1 = color(207, 76, 2);
        ColorScheme2 = color(254, 153, 41);
        ColorScheme3 = color(254, 217, 142);
        ColorScheme4 = color(255, 255, 212);
        }
      if (n == 3)
        {
        ColorScheme1 = color(174, 1, 126);
        ColorScheme2 = color(247, 104, 161);
        ColorScheme3 = color(251, 180, 185);
        ColorScheme4 = color(254, 235, 226);
        }
      if (n == 4)
        {
        ColorScheme1 = color(82, 82, 82);
        ColorScheme2 = color(150, 150, 150);
        ColorScheme3 = color(204, 204, 204);
        ColorScheme4 = color(247, 247, 247);
        }
      stroke(0);
      rectMode(CENTER);
      fill(ColorScheme4);
      rect(width/4 + width*.075, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.037, width*.04, height*.019);
      fill(ColorScheme3);
      rect(width/4 + width*.125, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.037, width*.04, height*.019); 
      fill(ColorScheme2);
      rect(width/4 + width*.175, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.037, width*.04, height*.019); 
      fill(ColorScheme1);
      rect(width/4 + width*.225, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.037, width*.04, height*.019); 
      rectMode(CORNER);              
      }
    }

  if (SORTBOXES == true)
    {
    for (int n = 0; n < SortStrings.size(); n++)
      {
      strokeWeight(1);
      stroke(0);
      fill(200, 200, 200, 200);
      rect(width*.1 + 2*(width - width*.2)/4, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
      if (SortBoxOverlay == n)
        {
        noStroke();
        fill(0, 0, 0, 100);
        rect(width*.1 + 2*(width - width*.2)/4, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
        }
      fill(0); 
      text(SortStrings.get(n), (width*.1 + 2*(width - width*.2)/4) + 2, (height - ((height*5)/16) - height*.015) - height*.025*n - height*.025);
      }
    }

  if (ANIMATEBOXES == true)
    {
    for (int n = 0; n < AnimateStrings.size(); n++)
      {
      strokeWeight(1);
      stroke(0);
      fill(200, 200, 200, 200);
      rect(width*.1 + 3*(width - width*.2)/4, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
      if (AnimateBoxOverlay == n)
        {
        noStroke();
        fill(0, 0, 0, 100);
        rect(width*.1 + 3*(width - width*.2)/4, (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025, (width - width*.2)/4, -height*.025);
        }
      fill(0); 
      text(AnimateStrings.get(n), (width*.1 + 3*(width - width*.2)/4) + 2, (height - ((height*5)/16) - height*.015) - height*.025*n - height*.025);
      }
    }
    
  // Minibox!
  if(MINIBOX == true)
    {
    strokeWeight(2);
    stroke(ColorG, ColorH, ColorI);
    fill(WHITECOLOR, WHITECOLOR, WHITECOLOR, 220);
    rect((Left + (BARWIDTH/2)) - 65, Up - 55, 130, 40, 7);
    fill(ColorG, ColorH, ColorI);
    stroke(ColorG, ColorH, ColorI);
    triangle((Left + (BARWIDTH/2)), Up - 7, (Left + (BARWIDTH/2))-5, Up - 14, (Left + (BARWIDTH/2))+5, Up - 14);
    fill(BLACKCOLOR);
    textAlign(LEFT, CENTER);
    textSize(11);
    if (CurrentStateString == "NY" && CurrentYearInt <= 1964)
      {
      text(CurrentState, (Left + (BARWIDTH/2)) - 60, Up - 48);
      text("NO DATA", (Left + (BARWIDTH/2)) - 60, Up - 35);
      }
    else
      {
      text(CurrentState, (Left + (BARWIDTH/2)) - 60, Up - 48);
      text("  " + int(((DATA.get(MiniBoxMouseN) - DATADIVIDE)*(-1)*MaxValue)/(DATADIVIDE/4)), (Left + (BARWIDTH/2)) - 60, Up - 35);
      }
    }
    
  Basemap = createGraphics(width, height);
  Basemap.beginDraw();
  Basemap.background(0);
  Basemap.noSmooth();
  for (int n = 0; n < StateString.length; n++) 
    {
    String[] NewValues = SortedData.keyArray();
    CurrentStateMouseOver = NewValues[n];
      
    PShape StateShape = USA.getChild(CurrentStateMouseOver);
    StateShape.disableStyle();
    Basemap.fill(n + 10, 0, 0);
    Basemap.noStroke();
    if(height >= width)
      {
      Basemap.shape(StateShape, ((width/2) - ((933*((width-100)*.001))/2)), 50, 933*((width-100)*.001), 600*((width-100)*.001));
      }
    else if (width > height && height >= 100)
      {
      Basemap.shape(StateShape, ((width/2) - ((933*((height-100)*.001))/2)), 50, 933*((height-100)*.001), 600*((height-100)*.001));
      }
    else if (height <= 100)
      {
      }
    }
  Basemap.endDraw();
  
  StateMouseOver = int(red(Basemap.get(mouseX, mouseY))) - 10;

  if (StateMouseOver >= 0 && StateMouseOver <= 50)
    {
    String[] NewValues2 = SortedNames.keyArray();
    String[] NewValues = SortedData.keyArray();

    if (NewValues[StateMouseOver]== "NY" && CurrentYearInt <= 1964 && DATAOVER == false && COLORSCHEMEOVER == false 
      && SORTDATAOVER == false && ANIMATEDATAOVER == false && DATABOXESOVER == false && COLORBOXESOVER == false 
      && SORTBOXESOVER == false && ANIMATEBOXESOVER == false && YEARCHANGE == false)
      {
      strokeWeight(2);
      stroke(ColorG, ColorH, ColorI);
      fill(WHITECOLOR, WHITECOLOR, WHITECOLOR, 235);
      rect(mouseX + 20, mouseY + 20, 130, 40, 7);
      fill(BLACKCOLOR);
      textAlign(LEFT, CENTER);
      textSize(11); 
      text(NewValues2[StateMouseOver], mouseX + 25, mouseY + 27);
      text("NO DATA", mouseX + 25, mouseY + 40);
      }
    else if (DATAOVER == false && COLORSCHEMEOVER == false && SORTDATAOVER == false && ANIMATEDATAOVER == false && DATABOXESOVER == false 
      && COLORBOXESOVER == false && SORTBOXESOVER == false && ANIMATEBOXESOVER == false && YEARCHANGE == false)
      {
      stroke(0, 0, 0, 100);
      fill(0, 0, 0, 100);    
      rect(MouseXLeft.get(StateMouseOver), (height - (1)*(height/16)), MouseXRight.get(StateMouseOver) - MouseXLeft.get(StateMouseOver), 
        MouseYUp.get(StateMouseOver) - (height - (1)*(height/16)));
      
      PShape States = USA.getChild(NewValues[StateMouseOver]);
      States.disableStyle();
      
      if(height >= width)
        {
        shape(States, ((width/2) - ((933*((width-100)*.001))/2)), 50, 933*((width-100)*.001), 600*((width-100)*.001));
        }
      else if (width > height && height >= 100)
        {
        shape(States, ((width/2) - ((933*((height-100)*.001))/2)), 50, 933*((height-100)*.001), 600*((height-100)*.001));
        }
      else if (height <= 100)
        {
        } 
      strokeWeight(2);
      stroke(ColorG, ColorH, ColorI);
      fill(WHITECOLOR, WHITECOLOR, WHITECOLOR, 235);
      rect(mouseX + 20, mouseY + 20, 130, 40, 0, 7, 7, 7);
      fill(BLACKCOLOR);
      textAlign(LEFT, CENTER);
      textSize(11); 
      text(NewValues2[StateMouseOver], mouseX + 25, mouseY + 27);
      text("  " + int(((DATA.get(StateMouseOver) - DATADIVIDE)*(-1)*MaxValue)/(DATADIVIDE/4)), mouseX + 25, mouseY + 40);   
      }
    }
  }
//-----------------------------------------------------------------------------------------


void keyPressed()
  {
  if (keyCode == LEFT)
    {
    if (CurrentYearInt == 1960)
      {
      CurrentYearInt = 2001;
      }        
    CurrentYearInt = CurrentYearInt - 1;
    }
  if (keyCode == RIGHT)
    {
    if (CurrentYearInt == 2000)
      {
      CurrentYearInt = 1959;
      }   
    CurrentYearInt = CurrentYearInt + 1;
    } 
  }
//-----------------------------------------------------------------------------------------


void mousePressed()
  {
  if (mouseButton == LEFT)
    {
    if (YEARCHANGE == true)
      {
      CurrentYearInt = YEARTRACK; 
      }
      
    if (DATAOVER == true)
      {
      DATABOXES = true;
      }      
    if (DATABOXESOVER == true)
      {
      CurrentCrime = OverDataBox;
      DATABOXES = false;
      }
      
    if (COLORSCHEMEOVER == true)
      {
      COLORBOXES = true; 
      }      
    if (COLORBOXESOVER == true)
      {      
      CurrentColor = OverColorBox;
      COLORBOXES = false;
      }
      
    if (ANIMATEDATAOVER == true)
      {
      ANIMATEBOXES = true; 
      }      
    if (ANIMATEBOXESOVER == true)
      {
      if (AnimateBoxOverlay == 0)
        {
        PLAY = true;
        }
      if (AnimateBoxOverlay == 1)
        {
        PLAY = false;
        }
      if (AnimateBoxOverlay == 2)
        {
        if (REVERSE == true)
          {
          REVERSE = false;
          }
        else
          {
          REVERSE = true;
          }
        }
      if (AnimateBoxOverlay == 3)
        {
        ANIMATIONSPEED = 120;
        ChangeSpeed = true;
        }
      if (AnimateBoxOverlay == 4)
        {
        ANIMATIONSPEED = 60;
        ChangeSpeed = true;
        }
      if (AnimateBoxOverlay == 5)
        {
        ANIMATIONSPEED = 30;
        ChangeSpeed = true;
        }
      DELAY = 0;
      ANIMATEBOXES = false;
      }
    if (SORTDATAOVER == true)
      {
      SORTBOXES = true; 
      }    
      
    if (SORTBOXESOVER == true)
      {
      if (SortBoxOverlay == 0 && SORT != 0)
        {
        SORT = 0;
        REDRAW = true;
        }
      else if (SortBoxOverlay == 1 && SORT != 1)
        {
        SORT = 1;
        REDRAW = true;
        }
      else if (SortBoxOverlay == 2 && SORT != 2)
        {
        SORT = 2;
        REDRAW = true;
        }
      else if (SortBoxOverlay == 3 && TOGGLENAMES == true)
        {
        TOGGLENAMES = false;
        }
      else if (SortBoxOverlay == 3 && TOGGLENAMES == false)
        {
        TOGGLENAMES = true;
        }
      else if (SortBoxOverlay == 4 && TOGGLENUMBERS == true)
        {
        TOGGLENUMBERS = false;
        }
      else if (SortBoxOverlay == 4 && TOGGLENUMBERS == false)
        {
        TOGGLENUMBERS = true;
        }
      else if (SortBoxOverlay == 5 && INVERTCOLOR == true)
        {
        INVERTCOLOR = false;
        }
      else if (SortBoxOverlay == 5 && INVERTCOLOR == false)
        {
        INVERTCOLOR = true;
        }
      SORTBOXES = false;
      }
    }
  if (mouseButton == RIGHT)
    {
    YEARCHANGE = false;
    DATAOVER = false;
    COLORSCHEMEOVER = false;
    SORTDATAOVER = false;
    ANIMATEDATAOVER = false;
    MINIBOX = false;
    DATABOXESOVER = false;
    COLORBOXESOVER = false;
    SORTBOXESOVER = false;
    ANIMATEBOXESOVER = false;
    SORTING = false;
    DataCrimeBoxOverlay = -1;
    ColorBoxOverlay = -1;
    SortBoxOverlay = -1;
    AnimateBoxOverlay = -1;  
    }
  }
//-----------------------------------------------------------------------------------------
  

void update(float x, float y)
  {  
  YEARCHANGE = false;
  DATAOVER = false;
  COLORSCHEMEOVER = false;
  SORTDATAOVER = false;
  ANIMATEDATAOVER = false;
  MINIBOX = false;
  DATABOXESOVER = false;
  COLORBOXESOVER = false;
  SORTBOXESOVER = false;
  ANIMATEBOXESOVER = false;
  SORTING = false;
  DataCrimeBoxOverlay = -1;
  ColorBoxOverlay = -1;
  SortBoxOverlay = -1;
  AnimateBoxOverlay = -1;
    
  for(int i = 0;  i < MouseXRight.size(); i++)
    {
    if ((mouseX <= MouseXRight.get(i)) && (mouseX >= MouseXLeft.get(i)) && (mouseY >= MouseYUp.get(i)) && (mouseY <= MouseYDown.get(i)))
      {
      MINIBOX = true;
      String[] NewValues2 = SortedNames.keyArray();
      CurrentState = NewValues2[i];  
      String[] NewValues = SortedData.keyArray();
      CurrentStateString = NewValues[i];
      MiniBoxMouseN = i;
      Right = MouseXRight.get(i);
      Left = MouseXLeft.get(i);
      Up = MouseYUp.get(i);
      Down = MouseYDown.get(i);
      }
    }
  for (int n = 0; n < 41; n++)
    {
    if ((mouseX <= (width*.1) + width*.02*n + (width*.005)) && (mouseX >= (width*.1) + width*.02*n - (width*.005))  //<>//
      && (mouseY >= 7) && (mouseY <= (24)))
      {
      YEARCHANGE = true;
      YEARTRACK = 1960 + n;
      }
    }
  if ((mouseX <= width*.1 + (width - width*.2)/4) && (mouseX >= width*.1) && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025) 
    && (mouseY <= (height - ((height*5)/16) - height*.001)))
    {
    DATAOVER = true;
    DELAY1++;
    if (DELAY1 >= 30)
      {
      DATABOXES = true;
      }
    }
  if ((mouseX <= width*.1 + 2*(width - width*.2)/4) && (mouseX >= width*.1 + (width - width*.2)/4) 
    && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025) 
    && (mouseY <= (height - ((height*5)/16) - height*.001)))
    {
    COLORSCHEMEOVER = true;
    DELAY2++;
    if (DELAY2 >= 30)
      {
      COLORBOXES = true;
      }
    }  
  if ((mouseX <= width*.1 + 3*(width - width*.2)/4) && (mouseX >= width*.1 + 2*(width - width*.2)/4) && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025) 
    && (mouseY <= (height - ((height*5)/16) - height*.001)))
    {
    SORTDATAOVER = true;
    DELAY3++;
    if (DELAY3 >= 30)
      {
      SORTBOXES = true;
      }
    }
  if ((mouseX <= width*.1 + 4*(width - width*.2)/4) && (mouseX >= width*.1 + 3*(width - width*.2)/4) && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025) 
    && (mouseY <= (height - ((height*5)/16) - height*.001)))
    {
    ANIMATEDATAOVER = true;
    DELAY4++;
    if (DELAY4 >= 30)
      {
      ANIMATEBOXES = true;
      }
    }    
  if (DATABOXES == true)
    {
    for (int n = 0; n < CrimeValX.size(); n++)
      {
      if ((mouseX <= width*.1 + (width - width*.2)/4) && (mouseX >= width*.1) 
        && (mouseY <= (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025) 
        && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025*n - 2*height*.025))
        {
        DATABOXESOVER = true;
        OverDataBox = n;
        DataCrimeBoxOverlay = n;
        }
      }
    }
  if (DATAOVER == false && DATABOXESOVER == false)
    {
    DATABOXES = false;
    DELAY1 = 0;
    }   
  if (COLORBOXES == true)
    {
    for (int n = 0; n < 5; n++)
      {
      if ((mouseX <= width*.1 + 2*(width - width*.2)/4) && (mouseX >= width*.1 + (width - width*.2)/4) 
        && (mouseY <= (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025) 
        && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025*n - 2*height*.025))
        {
        COLORBOXESOVER = true;
        OverColorBox = n;
        ColorBoxOverlay = n;
        }
      }
    }
  if (COLORSCHEMEOVER == false && COLORBOXESOVER == false)
    {
    COLORBOXES = false;
    DELAY2 = 0;
    }
    
  if (SORTBOXES == true)
    {
    for (int n = 0; n < SortStrings.size(); n++)
      {
      if ((mouseX <= width*.1 + 3*(width - width*.2)/4) && (mouseX >= width*.1 + 2*(width - width*.2)/4) 
        && (mouseY <= (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025) 
        && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025*n - 2*height*.025))
        {
        SORTBOXESOVER = true;
        SortBoxOverlay = n;
        }
      }
    }
  if (SORTDATAOVER == false && SORTBOXESOVER == false)
    {
    SORTBOXES = false;
    DELAY3 = 0;
    }
  if (ANIMATEBOXES == true)
    {
    for (int n = 0; n < AnimateStrings.size(); n++)
      {
      if ((mouseX <= width*.1 + 4*(width - width*.2)/4) && (mouseX >= width*.1 + 3*(width - width*.2)/4) 
        && (mouseY <= (height - ((height*5)/16) - height*.001) - height*.025*n - height*.025) 
        && (mouseY >= (height - ((height*5)/16) - height*.001) - height*.025*n - 2*height*.025))
        {
        ANIMATEBOXESOVER = true;
        AnimateBoxOverlay = n;
        }
      }
    }
  if (ANIMATEDATAOVER == false && ANIMATEBOXESOVER == false)
    {
    ANIMATEBOXES = false;
    DELAY4 = 0;
    }  
  if (DATAOVER == true || COLORSCHEMEOVER == true || SORTDATAOVER == true || ANIMATEDATAOVER == true
    || DATABOXESOVER == true || COLORBOXESOVER == true || SORTBOXESOVER == true|| ANIMATEBOXESOVER == true 
    || YEARCHANGE == true)
    {
    cursor(HAND);
    }
  else if (DATAOVER == false && COLORSCHEMEOVER == false && SORTDATAOVER == false && ANIMATEDATAOVER == false && DATABOXESOVER == false 
    && COLORBOXESOVER == false && SORTBOXESOVER == false && ANIMATEBOXESOVER == false && YEARCHANGE == false)
    {
    cursor(ARROW);
    }
  }
//-----------------------------------------------------------------------------------------  