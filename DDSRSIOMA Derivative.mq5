//+------------------------------------------------------------------+
//|                                         DDSRSIOMA Derivative.mq5 |
//|                                      Copyright © 2015, DaemonX |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2023, DaemonX"
#property link      ""
#property version   "1.01"
#property indicator_separate_window 
#property indicator_buffers 1 
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1 clrCoral
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

#property indicator_minimum -100
#property indicator_maximum 100

//#property indicator_level1 0.0
//#property indicator_level2 30
//#property indicator_level3 -30


#property indicator_label1  "derivative"
#define RESET 0 
enum ENUM_PRICE_TYPE 
  {
   PRICE_CLOSE_ = 1,     //Close
   PRICE_OPEN_,          //Open
   PRICE_HIGH_,          //High
   PRICE_LOW_,           //Low
   PRICE_MEDIAN_,        //Median Price (HL/2)
   PRICE_TYPICAL_,       //Typical Price (HLC/3)
   PRICE_WEIGHTED_,      //Weighted Close (HLCC/4)
   PRICE_SIMPL_,         //Simpl Price (OC/2)
   PRICE_QUARTER_,       //Quarted Price (HLOC/4) 
   PRICE_TRENDFOLLOW0_,  //TrendFollow_1 Price 
   PRICE_TRENDFOLLOW1_,  // TrendFollow_2 Price 
   PRICE_DEMARK_         // Demark Price
  };
  
  
  int rsioma;
  int dds;
input  int RSIOMA          = 14;
input uint  i_slowing = 34;                     // Slowing 
input ENUM_PRICE_TYPE i_price = PRICE_WEIGHTED; // Applied price 
//+-----------------------------------+

double ExtBuffer[];
int  min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  
     rsioma = iCustom(Symbol(),PERIOD_CURRENT,"DDSRSIOMA",RSIOMA,i_slowing,i_price);
   if(rsioma==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the DDSRSIOMA indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_CURRENT),
                  GetLastError());
      return(INIT_FAILED);
     }
   min_rates_total=int(i_slowing);
   SetIndexBuffer(0,ExtBuffer,INDICATOR_DATA);
   ArraySetAsSeries(ExtBuffer,true);
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   IndicatorSetString(INDICATOR_SHORTNAME,"DDSRSIOMA derivative");
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+  
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+  
int OnCalculate(const int rates_total,   
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  if(newbar()){
   if(rates_total<min_rates_total) return(RESET);
   int limit,bar; 
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
    double   rsi[]; 
ArraySetAsSeries(rsi,true);
    int buffer=0,start_pos=0,count=10000;
    iGetArray(rsioma,buffer,start_pos,count,rsi);
  
   if(prev_calculated>rates_total || prev_calculated<=0)
     {
      limit=7000; 
     }
   else limit=rates_total-prev_calculated; 

   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
     if(i_slowing>19){
      ExtBuffer[bar]=33.33333 *(PriceSeries(i_price,bar,(rsi))-PriceSeries(i_price,bar+i_slowing,(rsi)))/i_slowing;
      }else
         {
           ExtBuffer[bar]=18 *(PriceSeries(i_price,bar,(rsi))-PriceSeries(i_price,bar+i_slowing,(rsi)))/i_slowing;
         }
      //Comment((PriceSeries(i_price,limit,(rsi))));
     }
    } 
//----    
   return(rates_total);
  }

double PriceSeries(uint applied_price,
                   uint   bar,        
                   const double &Close[]
                  )
  {
//----
   switch(applied_price)
     {
      case  PRICE_CLOSE: return(Close[bar]);

      //----
      default: return(Close[bar]);
     }
//----
//return(0);
  }
//+------------------------------------------------------------------+

double iGetArray(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
  {
   bool result=true;
   if(!ArrayIsDynamic(arr_buffer))
     {
      Print("This a no dynamic array!");
      return(false);
     }
   ArrayFree(arr_buffer);
//--- reset error code
   ResetLastError();
//--- fill a part of the iBands array with values from the indicator buffer
   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count)
     {
      //--- if the copying fails, tell the error code
      PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
     }
   return(result);
  }

void OnDeinit(const int reason)
  {
  
   IndicatorRelease(rsioma);
  

  }
  
  
  bool newbar()
  {
   bool x;
   static datetime prevTime=0;
   datetime lastTime[1];
   if(CopyTime(_Symbol,PERIOD_CURRENT,0,1,lastTime)==1 && prevTime!=lastTime[0])
     {
      prevTime=lastTime[0];

      x=true;
     }
   return x;
  }