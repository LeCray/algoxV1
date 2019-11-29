//+------------------------------------------------------------------+
//|                                                        Dummy.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
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
//---
    double LWMAmovingAvg5M	= iMA(NULL,PERIOD_M5,50,0,MODE_LWMA,PRICE_CLOSE,0);
    double SMAmovingAvg5M	= iMA(NULL,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,0);



   	double SMAmovingAvg15M	= iMA(NULL,15,50,0,MODE_SMA,PRICE_CLOSE,0);
   	double LWMAmovingAvg15M	= iMA(NULL,15,50,0,MODE_LWMA,PRICE_CLOSE,0);
   	double SMAmovingAvg30M	= iMA(NULL,30,50,0,MODE_SMA,PRICE_CLOSE,0);
   	double LWMAmovingAvg30M	= iMA(NULL,30,50,0,MODE_LWMA,PRICE_CLOSE,0);

    Print("============================");
   	Print("Simple_5M = ", NormalizeDouble(SMAmovingAvg5M, Digits));
   	Print("Linear_5M = ", NormalizeDouble(LWMAmovingAvg5M, Digits));

  }
//+------------------------------------------------------------------+
