//+------------------------------------------------------------------+
//|                                                 MA_Crossover.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
//--- input parameters
input int      biggerMAPeriod = 50;
input int      smallerMAPeriod = 35;
input int      lotSize = 1;
input int      TP = 20;
input int      SL = 30;
int BarsCount = 0;
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
   	double smallerMA	= iMA(NULL, PERIOD_H4, smallerMAPeriod, 0, MODE_SMA,PRICE_CLOSE, 0);
	   double biggerMA	= iMA(NULL, PERIOD_H4, biggerMAPeriod, 0, MODE_SMA,PRICE_CLOSE, 0);	   	  
	   double MADiff     = MathAbs(NormalizeDouble(biggerMA - smallerMA, Digits()));
	   
	   int recentHighBarIndex = iHighest(NULL, PERIOD_H4, MODE_HIGH, 3, 0);	//Finds bar index/location of the recent hgih
	   int recentLowBarIndex = iLowest(NULL, PERIOD_H4, MODE_LOW, 3, 0);	//Finds bar index/location of the recent low
	   
	   bool buyCondition = Low[recentLowBarIndex] < smallerMA && Low[recentLowBarIndex] < biggerMA;
	   bool sellCondition = High[recentHighBarIndex] > smallerMA && High[recentHighBarIndex] > biggerMA;
	   
	   int orders = OrdersTotal();
	  
	   Print("Bars: ",Bars);	   
	   
	   if (Bars > BarsCount) {   
   	   //BUY
   	   if (buyCondition) {
   	   	      	      
            double minStopLevel = MarketInfo(0, MODE_STOPLEVEL); //Getting min SL & TP values
            double risk = (minStopLevel + SL)*Point(); 
            double reward = (minStopLevel + TP)*Point();
            double stopLoss = NormalizeDouble(Bid - risk, Digits()); //Turning pips into point size 
            double takeProfit = NormalizeDouble(Ask + reward, Digits()); //Turning pips into point size         
   	      
   	      
   	      if (orders <= 2) { 	        
      	      if(Close[1] > smallerMA) {	    	            	         
         	      int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, takeProfit, "My massive order", 0, 0, clrGreen);            
                  if(ticket < 0) {
                     Alert("OrderSend failed with error #", GetLastError());
                  } else {Print("OrderSend placed successfully");}               
               }              
            
               if(Close[1] > biggerMA) {	               
         	      int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, takeProfit, "My massive order", 0, 0, clrGreen);            
                  if(ticket < 0) {
                     Alert("OrderSend failed with error #", GetLastError());
                  } else {Print("OrderSend placed successfully");}               
               }            
            }
   	   }
   	   
   	   //SELL
   	   if (sellCondition) {
   	   
            double minStopLevel = MarketInfo(0,MODE_STOPLEVEL);
            double risk = (minStopLevel + SL)*Point(); 
            double reward = (minStopLevel + TP)*Point();
            double stopLoss = NormalizeDouble(Ask + risk, Digits());
            double takeProfit = NormalizeDouble(Ask - reward, Digits());
            int sellOrders = OrdersTotal();
            
            if (orders <= 2) { 
      	      if(Close[1] < smallerMA) {	       	         
         	      int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLoss, takeProfit,"My massive order", 0, 0, clrRed);           
                  if(ticket < 0) {
                     Alert("OrderSend failed with error #", GetLastError());
                  } else {Print("OrderSend placed successfully");}
               }               
               
               if(Close[1] < biggerMA) {	      	   	                        
         	      int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLoss, takeProfit,"My massive order", 0, 0, clrRed);          
                  if(ticket < 0) {
                     Alert("OrderSend failed with error #", GetLastError());
                  } else {Print("OrderSend placed successfully");}               
               }               
            }         
         }	   
      
   	   BarsCount = Bars;
   	   Print("BarsCount: ",BarsCount);
       }
    }
     
//+------------------------------------------------------------------+
