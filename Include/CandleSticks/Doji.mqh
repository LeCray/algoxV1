//+------------------------------------------------------------------+
//|                                                         Doji.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

bool Doji(int i){

	bool isDoji;
	double wick = MathAbs(High[i] - Low[i]);
	double body = MathAbs(Open[i] - Close[i]);

	if (body <= 0.2*wick) {
		isDoji = true;
	} else {
		isDoji = false;
	}

	return(isDoji);
}
