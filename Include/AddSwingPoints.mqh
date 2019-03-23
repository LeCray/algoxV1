//+------------------------------------------------------------------+
//|                                               AddSwingPoints.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


void AddToMajorSwingHigh(int PeriodsInMajorSwing, int shift) {
	
	int iterationNumber=-1;
	for(int i=0; i<shift; i++) {
		
		//Major Swing High Logic
		if(iHighest(NULL,0,MODE_HIGH,PeriodsInMajorSwing*2,i) == i + PeriodsInMajorSwing) {
				
			iterationNumber++;
			double price = High[i + PeriodsInMajorSwing];
			int majorSwingHighBarIndex = i + PeriodsInMajorSwing;
			
			addToMajorSwingHigh(iterationNumber, majorSwingHighBarIndex, price); //This function is defined in NeatArrays
			
			//Placing arrows on top of majorSwingHigh bars			
			string downArrowName = StringConcatenate("DownArrow#",High[i + PeriodsInMajorSwing]); //Giving the downArrow a name that has the price added to it                
			datetime time = Time[i + PeriodsInMajorSwing];
			double price2 = High[i + PeriodsInMajorSwing];
			color clr = clrBlue;
			int size = 2;
			int type = 234;
				    				     	
			//ArrowCreate(downArrowName, time, price2, clr, size, type);				
		}
	}
}

void AddToMinorSwingHigh(int PeriodsInMinorSwing, int shift) {

	int iterationNumber=-1;
	for(int i=0; i<shift; i++) {
				
		//Minor Swing High Logic
		if(iHighest(NULL,0,MODE_HIGH,PeriodsInMinorSwing*2,i) == i+PeriodsInMinorSwing) {
	        	
			iterationNumber++;
			double price=High[i+PeriodsInMinorSwing];
			int minorSwingHighBarIndex = i+PeriodsInMinorSwing;
						
			addToMinorSwingHigh(iterationNumber, minorSwingHighBarIndex, price);	//This function is defined in NeatArrays
			
			//Placing arrows on top of majorSwingHigh bars
			string downArrowName = StringConcatenate("DownArrow",i+PeriodsInMinorSwing); //Giving the downArrow a name that has the price added to it                
			datetime time = Time[i+PeriodsInMinorSwing];
			double price2 = High[i+PeriodsInMinorSwing];
			color clr = clrRed;
			int size = 1;
			int type = 234;
			
			//ArrowCreate(downArrowName, time, price2, clr, size, type);

	    }
	}
}

void AddToMajorSwingLow(int PeriodsInMajorSwing, int shift) {

	int iterationNumber=-1;
	for(int i=0; i<shift; i++) {
		
		//Major Swing High Logic
		if(iLowest(NULL,0,MODE_LOW,PeriodsInMajorSwing*2,i) == i + PeriodsInMajorSwing) {
				
			iterationNumber++;
			double price = Low[i + PeriodsInMajorSwing];
			int majorSwingLowBarIndex = i + PeriodsInMajorSwing;
			
			addToMajorSwingLow(iterationNumber, majorSwingLowBarIndex, price); //This function is defined in NeatArrays
			
			//Placing arrows on top of majorSwingHigh bars			
			string upArrowName = StringConcatenate("UpArrow#",Low[i+PeriodsInMajorSwing]); //Giving the downArrow a name that has the price added to it                
			datetime time = Time[i+PeriodsInMajorSwing];
			double price2 = Low[i+PeriodsInMajorSwing];
			color clr = clrBlue;
			int size = 3;
			int type = 233;
				    				     	
			//ArrowCreate(upArrowName, time, price2, clr, size, type);				
		}
	}	
}

void AddToMinorSwingLow(int PeriodsInMinorSwing, int shift) {

	int iterationNumber=-1;
	for(int i=0; i<shift; i++) {
		
		//Major Swing High Logic
		if(iLowest(NULL,0,MODE_LOW,PeriodsInMinorSwing*2,i) == i + PeriodsInMinorSwing) {
				
			iterationNumber++;
			double price = Low[i + PeriodsInMinorSwing];
			int majorSwingLowBarIndex = i + PeriodsInMinorSwing;
			
			addToMinorSwingLow(iterationNumber, majorSwingLowBarIndex, price); //This function is defined in NeatArrays
			
			//Placing arrows below of minorSwingLow bars			
			string upArrowName = StringConcatenate("UpArrow#",Low[i + PeriodsInMinorSwing]); //Giving the downArrow a name that has the price added to it                
			datetime time = Time[i + PeriodsInMinorSwing];
			double price2 = Low[i + PeriodsInMinorSwing];
			color clr = clrGreen;
			int size = 1;
			int type = 233;
				    				     	
			//ArrowCreate(upArrowName, time, price2, clr, size, type);				
		}
	}
}