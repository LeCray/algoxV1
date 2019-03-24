//+------------------------------------------------------------------+
//|                                                          Buy.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <CandleSticks/Doji.mqh>
#include <ArrowCreate.mqh>


void Buy(
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
    double recentHigh;

    if(minorSwingHighPrices[0]>majorSwingHighPrices[0]){ //Finding the highest recent price
        recentHigh = High[iHighest(NULL, 5, MODE_HIGH, minorSwingHighBars[0]+1, 0)];
        //Print("recentHigh: ",recentHigh);
    } else {
        recentHigh = High[iHighest(NULL, 5, MODE_HIGH, majorSwingHighBars[0]+1, 0)];
        //Print("recentHigh: ",recentHigh);
    }

    //Must be making Higher Lows
    bool lowCondition_1 = minorSwingLowPrices[0] > minorSwingLowPrices[1];
    bool lowCondition_2 = minorSwingLowPrices[0] > majorSwingLowPrices[1];
    bool lowCondition_3 = minorSwingLowPrices[0] > majorSwingLowPrices[0];


    if(Close[0] < recentHigh){
        if(lowCondition_1 || lowCondition_2 || lowCondition_3){	//Making sure we have higher lows

            if(recentHigh >= minorSwingHighPrices[0] && recentHigh >= majorSwingHighPrices[0]) { //Making sure recentHigh is higher than prev minor and major highs

                int recentHighBar_1 = iHighest(NULL, 5, MODE_HIGH, minorSwingHighBars[0]+1, 0);	//Finds bar index/location of the recentHigh (from 0 to minorSwingHighBars[0]+1)
                int recentHighBar_2 = iHighest(NULL, 5, MODE_HIGH, majorSwingHighBars[0]+1, 0);	//Finds bar index/location of the recentHigh (from 0 to majorSwingHighBars[0]+1)

                if (recentHighBar_1 != 0 && recentHighBar_2 != 0) { //Making sure calc is not run on the bar that is currently making the highest high
                    if(minorSwingLowBars[0] > recentHighBar_1 && minorSwingLowBars[0] > recentHighBar_2) { //Making sure calc is run on a BASE LOW that is BEHIND the recentHigh bar

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
                                            double reward = risk*3;
                                            double stoploss = NormalizeDouble(Bid - risk, Digits()); //Turning pips into point size i.e 2 pips = 0.0002 on price axis
                                            double takeprofit = NormalizeDouble(Ask + reward, Digits()); //Turning pips into point size i.e 2 pips = 0.0002 on price axis

                                            //Print("Current High:", High[0]," ","Ask:", Ask," ", "Buy:",Bid);
                                            //Print("Risk=",risk,"; ","Reward=",reward,"; ","SL=",stoploss,"; ","TP=",takeprofit, "; ","Lots=",lotSize);

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
