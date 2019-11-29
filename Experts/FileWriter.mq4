//+------------------------------------------------------------------+
//|                                                   FileWriter.mq4 |
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

int handle;
//--- parameters for writing data to file
input string    InpFileName = "Data2.csv";      // File name
input string    InpDirectoryName = "Data";     // Folder name
input string    symbol = "EURUSD";
input int       timeFrame = 5;


int OnInit() {
//---
    datetime time_array[];
    double close_price[];
    double open_price[];
    double high_price[];
    double low_price[];
    double volume[];

    double stoch_array[];
    double rsi_array[];

    datetime start_time = "2019.07.01 06:00:00";
    datetime end_time = "2019.07.31 18:00:00";

    //Get prices and times
    int time_copier         = CopyTime(symbol, timeFrame, start_time, end_time, time_array);
    int close_price_copier  = CopyClose(symbol, timeFrame, start_time, end_time, close_price);
    int open_price_copier   = CopyOpen(symbol, timeFrame, start_time, end_time, open_price);
    int high_price_copier   = CopyHigh(symbol, timeFrame, start_time, end_time, high_price);
    int low_price_copier    = CopyLow(symbol, timeFrame, start_time, end_time, low_price);
    //int volume_copier       = CopyTickVolume(symbol, timeFrame, start_time, end_time, volume);

    //Get size
    int close_price_size = ArraySize(close_price);
    int d = 1;
    
    //Print("Low Price: ", low_price[4]);


    for (int i = 4; i < close_price_size; i++) {

        double low = low_price[i];
        for (i; i > i-4; i--) {
        
            Print("i: ", i);
            //if (low_price[i] < low) 
              //  low = low_price[i];                         
        }

        double high = high_price[i];
        for (i; i > i-4; i--) {
            //if (high_price[i] > high)
              //  high = high_price[i];
        }

        double stoch_calc = ((close_price[i] - low)/(high - low))*100;


        ArrayResize(stoch_array, d);   //Making the array bigger
        stoch_array[i] = stoch_calc;

    }

    Print(stoch_array[0]);

    //Open file
    int file_handle = FileOpen(InpDirectoryName+"//"+InpFileName,FILE_CSV|FILE_READ|FILE_WRITE,',');

    if (file_handle != INVALID_HANDLE) {
      PrintFormat("%s file is available for writing", InpFileName);
      //--- first, write the number of signals
      FileWrite(file_handle, "TIME", "PRICE", "STOCHASTICS");
      //--- write the time and prices to the file
      for (int i=0; i < close_price_size; i++)
        FileWrite(file_handle, time_array[i], close_price[i]);
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed", InpFileName);
    } else {
      PrintFormat("Failed to open %s file, Error code = %d", InpFileName, GetLastError());
    }

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

  }
//+------------------------------------------------------------------+
