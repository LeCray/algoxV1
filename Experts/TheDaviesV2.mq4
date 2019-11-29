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
#include <Orders/Sell.mqh>


#property indicator_buffers 4
#property indicator_chart_window


int MajorSwingSize=3;
int PeriodsInMajorSwing = 13;
int PeriodsInMinorSwing = 5;
double stoplossVar = 10;
double lotSize = 1;
int majorSwingHighArraySize=0;

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
    double minstoplevel = MarketInfo(0,MODE_STOPLEVEL);
    double mS = NormalizeDouble(minstoplevel*Point(), Digits());
    Print("Bolinger Bands: ", iBands(NULL,0,15,2,0,PRICE_CLOSE,MODE_LOWER,0));
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
void OnTick() {

	int shift = iBarShift(NULL,0,Today); //This will find the number of bars from 0 to start of current day

	double SMAmovingAvg5M	= iMA(NULL,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,0);
	double LWMAmovingAvg5M	= iMA(NULL,PERIOD_M5,50,0,MODE_LWMA,PRICE_CLOSE,0);
	double SMAmovingAvg15M	= iMA(NULL,15,50,0,MODE_SMA,PRICE_CLOSE,0);
	double LWMAmovingAvg15M	= iMA(NULL,15,50,0,MODE_LWMA,PRICE_CLOSE,0);
	double SMAmovingAvg30M	= iMA(NULL,30,50,0,MODE_SMA,PRICE_CLOSE,0);
	double LWMAmovingAvg30M	= iMA(NULL,30,50,0,MODE_LWMA,PRICE_CLOSE,0);

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

    //Sell or Buy states
    bool selling;
    bool buying;

    if (Hour()>=9 && Hour()<=18) { //Can only trade between 9:00 and 18:00

        //SEEING WHERE THE MARKET IS TRENDING
    	if (LWMAmovingAvg30M > SMAmovingAvg30M) {
    		if(LWMAmovingAvg15M > SMAmovingAvg15M){

                double iMA_5M_recent   = iMA(NULL,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,10);
                double iMA_5M_current  = iMA(NULL,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,0);
                double gradient_5M     = NormalizeDouble(iMA_5M_current/iMA_5M_recent, Digits());

                if(gradient_5M >= 1+10*Point()) { //Making sure gradient of MA's are positive
        			buying = true;
                    //Print("Buying,"," ","MA Gradient:",gradient_5M);
                } else {/*Print("Trying to BUY but Gradient !> 10");*/}

    		} else {
    			buying = false;
    		}
    	}
        if (LWMAmovingAvg30M < SMAmovingAvg30M) {
            if(LWMAmovingAvg15M < SMAmovingAvg15M){

                double iMA_5M_recent   = iMA(NULL,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,10);
                double iMA_5M_current  = iMA(NULL,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,0);
                double gradient_5M     = NormalizeDouble(iMA_5M_recent/iMA_5M_current, Digits());

                if(gradient_5M >= 1+10*Point()) { //Making sure gradient of MA's are negative
                    selling = true;
                    //Print("Selling,"," ","MA Gradient:",gradient_5M);
                } else {/*Print("Trying to SELL but Gradient !> 10");*/}
            } else {
                selling = false;
            }
        }
    } else {buying = false; selling = false;}

	if(buying && size_1 && size_2 && size_3 && size_4){ //Making sure we have elements to access
        Buy( //This function is defined inside Orders/Buy.mqh
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

    if(selling && size_1 && size_2 && size_3 && size_4){ //Making sure we have elements to access
        Sell( //This function is defined inside Orders/Sell.mqh
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
