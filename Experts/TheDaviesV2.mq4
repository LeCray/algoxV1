//+------------------------------------------------------------------+
//|                                                  TheDaviesV2.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <ArrowCreate.mqh>
#include <AddSwingPoints.mqh>
#include <NeatArrays.mqh>
#include <CandleSticks/Doji.mqh>
#include <Orders/Buy.mqh>


#property indicator_buffers 4
#property indicator_chart_window

extern color MajorSwingColor=clrPurple;
extern int MajorSwingSize=3;

extern int PeriodsInMajorSwing = 13;
extern int PeriodsInMinorSwing = 5;

extern double stoplossVar = 10;
extern double lotSize = 1;



extern int majorSwingHighArraySize=0;

//Arrays for Highs
double majorSwingHighPrices[];
double majorSwingHighBars[];
double minorSwingHighPrices[];
double minorSwingHighBars[];

//Arrays for Lows
double majorSwingLowPrices[];
double majorSwingLowBars[];
double minorSwingLowPrices[];
double minorSwingLowBars[];

//Sell or Buy states
bool selling = false;
bool buying = false;

string newDownArrowName="first";

double majorSwingHighPair[];

double minorSwingHigh[];
double majorSwingLow[];
double minorSwingLow[];

datetime Today = StrToTime(StringConcatenate(Year(),".",Month(),".",Day()));

double currentHigh;
double recentSwingLow;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit()
  {

   //return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

	int shift = iBarShift(NULL,0,Today); //This will find the number of bars from 0 to start of current day

	double SMAmovingAvg5M	= iMA(NULL,5,50,0,MODE_SMMA,PRICE_CLOSE,0);
	double LWMAmovingAvg5M	= iMA(NULL,5,50,0,MODE_LWMA,PRICE_CLOSE,0);
	double SMAmovingAvg15M	= iMA(NULL,15,50,0,MODE_SMMA,PRICE_CLOSE,0);
	double LWMAmovingAvg15M	= iMA(NULL,15,50,0,MODE_LWMA,PRICE_CLOSE,0);
	double SMAmovingAvg30M	= iMA(NULL,30,50,0,MODE_SMMA,PRICE_CLOSE,0);
	double LWMAmovingAvg30M	= iMA(NULL,30,50,0,MODE_LWMA,PRICE_CLOSE,0);


	//SEEING WHERE THE MARKET IS TRENDING
	/*if(LWMAmovingAvg30M < SMAmovingAvg30M) {
		if(LWMAmovingAvg15M < SMAmovingAvg15M){
			selling = true;
		}
	} else if (LWMAmovingAvg30M > SMAmovingAvg30M) {
		if(LWMAmovingAvg15M > SMAmovingAvg15M){
			buying = true;
		}
	} else {
		Print("Market is neutral");
	};

	if(LWMAmovingAvg5M > SMAmovingAvg5M){
		buying = true;
	} else {
		buying = false;
	}*/

	if (LWMAmovingAvg30M > SMAmovingAvg30M) {
		if(LWMAmovingAvg15M > SMAmovingAvg15M){
			buying = true;
		} else {
			buying = false;
		}
	}
    Print("Buying? ",buying);

	AddToMajorSwingHigh(PeriodsInMajorSwing,shift); //This function is defined inside AddSwingPoints.mqh
	AddToMinorSwingHigh(PeriodsInMinorSwing,shift);	//This function is defined inside AddSwingPoints.mqh
	AddToMajorSwingLow(PeriodsInMajorSwing,shift);	//This function is defined inside AddSwingPoints.mqh
	AddToMinorSwingLow(PeriodsInMinorSwing,shift);	//This function is defined inside AddSwingPoints.mqh

	int size_minorSwingHighPrices 	= ArraySize(minorSwingHighPrices);
	int size_minorSwingLowPrices 	= ArraySize(minorSwingLowPrices);
	int size_majorSwingHighPrices 	= ArraySize(majorSwingHighPrices);
	int size_majorSwingLowPrices 	= ArraySize(majorSwingLowPrices);

	bool size_1 = size_minorSwingHighPrices > 1;
	bool size_2 = size_minorSwingLowPrices 	> 1;
	bool size_3 = size_majorSwingHighPrices > 1;
	bool size_4 = size_majorSwingLowPrices 	> 1;

	if(buying && size_1 && size_2 && size_3 && size_4){ //Making sure we have elements to access
        Buy(
            SMAmovingAvg5M,
            stoplossVar,
            lotSize,
            majorSwingHighPrices,
            majorSwingHighBars,
            minorSwingHighPrices,
            minorSwingHighBars,
            minorSwingLowPrices,
            minorSwingLowBars,
            majorSwingLowPrices
        );
	}





  }
//+------------------------------------------------------------------+
