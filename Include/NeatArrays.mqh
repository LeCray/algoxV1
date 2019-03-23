//+------------------------------------------------------------------+
//|                                                   NeatArrays.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//Methods to create neat arrays of swing low and high prices where
//each swing point is accessible with index's starting from 0.
//i.e the first Major High Swing Point Price on the chart is majarSwingHighPrices[0]


void addToMajorSwingHigh(int iterationNumber, int majorSwingHighBarIndex, double price){
  
   ArrayResize(majorSwingHighPrices,iterationNumber + 1);   //Making the array bigger		
   majorSwingHighPrices[iterationNumber] = price;

   ArrayResize(majorSwingHighBars,iterationNumber + 1);   //Making the array bigger		
   majorSwingHighBars[iterationNumber] = majorSwingHighBarIndex;

};

void addToMinorSwingHigh(int iterationNumber, int minorSwingHighBarIndex, double price) {
	
	ArrayResize(minorSwingHighPrices,iterationNumber + 1);   //Making the array bigger		
	minorSwingHighPrices[iterationNumber] = price;	
	ArrayResize(minorSwingHighBars,iterationNumber + 1);   //Making the array bigger		
	minorSwingHighBars[iterationNumber] = minorSwingHighBarIndex;

};

void addToMajorSwingLow(int iterationNumber, int majorSwingLowBarIndex, double price){
  
   ArrayResize(majorSwingLowPrices, iterationNumber + 1);   //Making the array bigger		
   majorSwingLowPrices[iterationNumber] = price;

   ArrayResize(majorSwingLowBars,iterationNumber + 1);   //Making the array bigger		
   majorSwingLowBars[iterationNumber] = majorSwingLowBarIndex;

};

void addToMinorSwingLow(int iterationNumber, int minorSwingLowBarIndex, double price){
  
   ArrayResize(minorSwingLowPrices, iterationNumber + 1);   //Making the array bigger		
   minorSwingLowPrices[iterationNumber] = price;

   ArrayResize(minorSwingLowBars,iterationNumber + 1);   //Making the array bigger		
   minorSwingLowBars[iterationNumber] = minorSwingLowBarIndex;

};
