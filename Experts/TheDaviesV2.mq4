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
		double recentHigh;

		if(minorSwingHighPrices[0]>majorSwingHighPrices[0]){ //Finding the highest recent price
			recentHigh = High[iHighest(NULL, 5, MODE_HIGH, minorSwingHighBars[0]+1, 0)];
			Print("recentHigh: ",recentHigh);
		} else {
			recentHigh = High[iHighest(NULL, 5, MODE_HIGH, majorSwingHighBars[0]+1, 0)];
			Print("recentHigh: ",recentHigh);
		}

		bool lowCondition_1 = minorSwingLowPrices[0] > minorSwingLowPrices[1];
		bool lowCondition_2 = minorSwingLowPrices[0] > majorSwingLowPrices[1];
		bool lowCondition_3 = minorSwingLowPrices[0] > majorSwingLowPrices[0];


		if(Close[0] < recentHigh){
			if(lowCondition_1 || lowCondition_2 || lowCondition_3){	//Making sure we have higher lows

				if(recentHigh >= minorSwingHighPrices[0] && recentHigh >= majorSwingHighPrices[0]) { //Making sure recentHigh is higher than prev minor and major highs

					int recentHighBar_1 = iHighest(NULL, 5, MODE_HIGH, minorSwingHighBars[0]+1, 0);	//Finds bar index/location of the recentHigh (from 0 to minorSwingHighBars[0]+1)
					int recentHighBar_2 = iHighest(NULL, 5, MODE_HIGH, majorSwingHighBars[0]+1, 0);	//Finds bar index/location of the recentHigh (from 0 to majorSwingHighBars[0]+1)

					if (recentHighBar_1 != 0 && recentHighBar_2 != 0) { //Making sure calc is not run on the bar that is currently making the highest high
						if(minorSwingLowBars[0] > recentHighBar_1 && minorSwingLowBars[0] > recentHighBar_2) { //Making sure calc is based on a low that is BEHIND the recentHigh bar

							double swing = recentHigh - minorSwingLowPrices[0];

							if(Low[0]<(minorSwingLowPrices[0] + 0.8*swing) && Low[0]>(minorSwingLowPrices[0] + 0.2*swing)){

								//DO THE MAGIC THING!!!
								bool isDoji = Doji(1);
								int orders = OrdersTotal();

								if (isDoji) {
									if (High[0] > High[1]) {
                                        if(Low[0] > SMAmovingAvg5M) {

                                            string dojiArrow = StringConcatenate("dojiArrow",Low[1]);
                                            datetime time = Time[1];
                                            double price2 = Low[1];
                                            color clr = clrGreen;
                                            int size = 1;
                                            int type = 225;
                                            ArrowCreate(dojiArrow, time, price2, clr, size, type); //This function is defined in ArrowCreate.mqh


    										if(orders == 0) { //Making sure only 1 order is open at a time
    								            double minstoplevel = MarketInfo(0,MODE_STOPLEVEL);
    								            double risk = (minstoplevel + stoplossVar)*Point();
    								            double reward = risk*2;
    								            double stoploss = NormalizeDouble(Bid - risk, Digits()); //Turning pips into point size i.e 2 pips = 0.0002 on price axis
    	   										double takeprofit = NormalizeDouble(Ask + reward, Digits()); //Turning pips into point size i.e 2 pips = 0.0002 on price axis

                                                //Print("Current High:", High[0]," ","Ask:", Ask," ", "Buy:",Bid);
    	   										Print("Risk=",risk,"; ","Reward=",reward,"; ","SL=",stoploss,"; ","TP=",takeprofit, "; ","Lots=",lotSize);

    								            int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stoploss, takeprofit,"My first order",0, 0, clrGreen);

    											if(ticket < 0) {
    												Print("OrderSend failed with error #",GetLastError());
    											} else {
    												Print("OrderSend placed successfully");
    											}

    										} else {Print("Still in a position!");}
                                        }
							        }
								}


							}

						} else {/*Print("minorSwingLowBars[0] !> recentHighBar_1 or _2");*/}
					} else {/*Print("recentHighBar_1 or _2 == 0 ");*/}
				}

			} else {/*Print("minorSwingLowPrice !> Last");*/}
		} else {/*Print("Close !< recentHigh");*/}
	}





  }
//+------------------------------------------------------------------+
