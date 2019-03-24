//+------------------------------------------------------------------+
//|                                                         Sell.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <CandleSticks/Doji.mqh>
#include <ArrowCreate.mqh>


void Sell(
    double SMAmovingAvg5M,
    int stoplossVar,
    int lotSize,
    double &majorSwingHighPrices[],
    double &majorSwingHighBars[],
    double &minorSwingHighPrices[],
    double &minorSwingHighBars[],
    double &minorSwingLowPrices[],
    double &minorSwingLowBars[],
    double &majorSwingLowPrices[]

){
    double recentLow;

    if(minorSwingLowPrices[0]<majorSwingLowPrices[0]){ //Finding the lowest recent price
        recentLow = Low[iLowest(NULL, 5, MODE_LOW, minorSwingLowBars[0]+1, 0)];
        //Print("recentLow: ",recentLow);
    } else {
        recentLow = Low[iLowest(NULL, 5, MODE_LOW, majorSwingLowBars[0]+1, 0)];
        //Print("recentLow: ",recentLow);
    }

    //Must be making Lower Highs
    bool highCondition_1 = minorSwingHighPrices[0] <  minorSwingHighPrices[1];
    bool highCondition_2 = minorSwingHighPrices[0] <  majorSwingHighPrices[1];
    bool highCondition_3 = minorSwingHighPrices[0] <= majorSwingHighPrices[0];


    if (Close[0] > recentLow) { //Are we starting to retrace?
        if (highCondition_1 || highCondition_2 || highCondition_3){	//Making sure we have Lower Highs

            if (recentLow <= minorSwingLowPrices[0] && recentLow <= majorSwingLowPrices[0]) { //Making sure recentLow is lower than prev minor and major lows

                int recentLowBar_1 = iLowest(NULL, 5, MODE_LOW, minorSwingLowBars[0]+1, 0);	//Finds bar index/location of the recentLow (from 0 to minorSwingLowBars[0]+1)
                int recentLowBar_2 = iLowest(NULL, 5, MODE_LOW, majorSwingLowBars[0]+1, 0);	//Finds bar index/location of the recentLow (from 0 to majorSwingLowBars[0]+1)

                if (recentLowBar_1 != 0 && recentLowBar_2 != 0) { //Making sure calc is not run on the bar that is currently making the Lowest Low
                    if (minorSwingHighBars[0] > recentLowBar_1 && minorSwingHighBars[0] > recentLowBar_2) { //Making sure calc is run on a BASE HIGH that is BEHIND the recentLow bar


                        double swing = minorSwingHighPrices[0] - recentLow;

                        if (High[0]>(minorSwingHighPrices[0] - 0.8*swing) && High[0]<(minorSwingHighPrices[0] - 0.2*swing)){

                            //DO THE MAGIC THING!!!
                            bool isDoji = Doji(1);
                            int orders = OrdersTotal();

                            if (isDoji) {
                                if (High[0] < SMAmovingAvg5M) { //Must be below the SMA
                                    if (Low[0] < Low[1]) {

                                        string dojiArrow = StringConcatenate("dojiArrow",High[1]);
                                        datetime time = Time[1];
                                        double price2 = High[1];
                                        color clr = clrRed;
                                        int size = 1;
                                        int type = 226;
                                        ArrowCreate(dojiArrow, time, price2, clr, size, type); //This function is defined in ArrowCreate.mqh

                                        if(orders == 0) { //Making sure only 1 order is open at a time
                                            double minstoplevel = MarketInfo(0,MODE_STOPLEVEL);
                                            double risk = (minstoplevel + stoplossVar)*Point(); //Turning pips into point size i.e 2 pips = 0.0002 on price axis
                                            double reward = risk*3;
                                            double stoploss = NormalizeDouble(Ask + risk, Digits());
                                            double takeprofit = NormalizeDouble(Bid - reward, Digits());

                                            //Print("Current High:", High[0]," ","Ask:", Ask," ", "Buy:",Bid);
                                            //Print("Risk=",risk,"; ","Reward=",reward,"; ","SL=",stoploss,"; ","TP=",takeprofit, "; ","Lots=",lotSize);

                                            int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stoploss, takeprofit,"Another one",0, 0, clrGreen);

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

                    } else {/*Print("minorSwingHighBars[0] !> recentLowBar_1 or _2");*/}
                } else {/*Print("recentLowBar_1 or _2 == 0 ");*/}
            }

        } else {/*Print("Not making lower highs");*/}
    } else {/*Print("Close !> recentLow");*/}
}
