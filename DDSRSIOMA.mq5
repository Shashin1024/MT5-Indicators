//+------------------------------------------------------------------+
//|                                                   DDSRSIOMA.mq5 |
//|                                      Copyright © 2023, DaemonX |
//|                                       |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2023, DaemonX"
#property link      ""

#property version   "1.01"

#property indicator_separate_window 

#property indicator_buffers 2 

#property indicator_plots   1

#property indicator_type1   DRAW_COLOR_LINE

#property indicator_color1 clrSlateBlue, clrRed

#property indicator_style1  STYLE_SOLID

#property indicator_width1  3

#property indicator_label1  "DDSRSIOMA"

#property indicator_level1 10
#property indicator_level2 50
#property indicator_level3 90

#define RESET 0 




enum ENUM_PRICE_TYPE //òèï êîíñòàíòû
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

//---- input parameters
input  int RSIOMA          = 14;
input uint  i_slowing = 34;                     // Slowing 
input ENUM_PRICE_TYPE i_price = PRICE_WEIGHTED; // Applied price 
//+-----------------------------------+

double ExtBuffer[];
double BufferColour[];

int  min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

     rsioma = iCustom(Symbol(),PERIOD_CURRENT,"JFRSIOMA",RSIOMA,MODE_EMA,PRICE_CLOSE,21,10000);
   if(rsioma==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the JFRSIOMA indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_CURRENT),
                  GetLastError());
      //--- the indicator is stopped early
      return(INIT_FAILED);
     }


 dds = iCustom(Symbol(),PERIOD_CURRENT,"JFDS",5,10,7,10000);
   if(dds==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_CURRENT),
                  GetLastError());
      //--- the indicator is stopped early
      return(INIT_FAILED);
     }



   min_rates_total=int(i_slowing);

   SetIndexBuffer(0,ExtBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,BufferColour,INDICATOR_COLOR_INDEX);

   ArraySetAsSeries(ExtBuffer,true);
   ArraySetAsSeries(BufferColour,true);
   
   
   

   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);

   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);

   IndicatorSetString(INDICATOR_SHORTNAME,"DDSRSIOMA Median");

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
    double   drk[];
    ArraySetAsSeries(rsi,true);
    ArraySetAsSeries(drk,true);
    
    
    int buffer=0,start_pos=0,count=8000;
    iGetArray(rsioma,buffer,start_pos,count,rsi);
    iGetArray(dds,buffer,start_pos,count,drk);
   
   

   if(prev_calculated>rates_total || prev_calculated<=0)
     {
      limit=7000; 
     }
   else limit=rates_total-prev_calculated; 

   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      ExtBuffer[bar]=(PriceSeries(bar,rsi)+PriceSeries(bar,drk))/2;
      
      if(MathAbs(ExtBuffer[bar]-ExtBuffer[bar+1])<=1)
        {
         BufferColour[bar]=1;
        }else
           {
            BufferColour[bar]=0;
           }
     }
      }
//----    
   return(rates_total);
   
  
   
  }

double PriceSeries(
                   uint   bar,      
                   const double &Close[])
  {

     return(Close[bar]);
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

   ResetLastError();

   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count)

      PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      return(false);
     }
 

void OnDeinit(const int reason)
  {
  
   IndicatorRelease(rsioma);
   IndicatorRelease(dds);

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