//+------------------------------------------------------------------+
//|                                        Fractals On DDSRSIOMA.mq5 |
//|                                        Copyright © 2023, DaemonX |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2023, DaemonX"
#property link      ""
#property version   "1.001"
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot DDSRSIOMA
#property indicator_label1  "DDSRSIOMA"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDarkOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Fractal Up
#property indicator_label2  "Fractal Up"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrWhite
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Fractal Down
#property indicator_label3  "Fractal Down"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrWhite
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- input parameters

input int Offset = 10;
//--- indicator buffers
double   DDSRSIOMABuffer[];
double   Fractal_Up_Buffer[];
double   Fractal_Down_Buffer[];
//---
int      handle_DDSRSIOMA;                           // variable for storing the handle of the iOBV indicator
int      bars_calculated            = 0;        // we will keep the number of values in the On Balance Volume indicator
bool     m_init_error               = false;    // error on InInit
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

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
  
  ENUM_PRICE_TYPE i_price = PRICE_WEIGHTED; 
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,DDSRSIOMABuffer,INDICATOR_DATA);
   SetIndexBuffer(1,Fractal_Up_Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,Fractal_Down_Buffer,INDICATOR_DATA);
//--- set indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,0);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(1,PLOT_ARROW,217);
   PlotIndexSetInteger(2,PLOT_ARROW,218);
//--- arrow shifts when drawing
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,10);
   PlotIndexSetInteger(2,PLOT_ARROW_SHIFT,-10);
//--- sets drawing line empty value
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
//--- create handle of the iOBV indicator
   handle_DDSRSIOMA=iCustom(Symbol(),0,"DDSRSIOMA",14,i_price);;
//--- if the handle is not created
   if(handle_DDSRSIOMA==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the DDSRSIOMA indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
      m_init_error=true;
      return(INIT_SUCCEEDED);
     }
//---
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
//---
   if(m_init_error)
      return(0);
   if(rates_total<5)
      return(0);
//--- number of values copied from the iOBV indicator
   int values_to_copy;
//--- determine the number of values calculated in the indicator
   int calculated=BarsCalculated(handle_DDSRSIOMA);
   if(calculated<=0)
     {
      PrintFormat("BarsCalculated() returned %d, error code %d",calculated,GetLastError());
      return(0);
     }
//--- if it is the first start of calculation of the indicator or if the number of values in the iOBV indicator changed
//---or if it is necessary to calculated the indicator for two or more bars (it means something has changed in the price history)
   if(prev_calculated==0 || calculated!=bars_calculated || rates_total>prev_calculated+1)
     {
      //--- if the iDDSRSIOMABuffer array is greater than the number of values in the iOBV indicator for symbol/period, then we don't copy everything
      //--- otherwise, we copy less than the size of indicator buffers
      if(calculated>rates_total)
         values_to_copy=rates_total;
      else
         values_to_copy=calculated;
     }
   else
     {
      //--- it means that it's not the first time of the indicator calculation, and since the last call of OnCalculate()
      //--- for calculation not more than one bar is added
      values_to_copy=(rates_total-prev_calculated)+1;
     }
//--- fill the arrays with values of the iOBV indicator
//--- if FillArrayFromBuffer returns false, it means the information is nor ready yet, quit operation
   if(!FillArrayFromBuffer(DDSRSIOMABuffer,handle_DDSRSIOMA,values_to_copy))
      return(0);
//--- memorize the number of values in the On Balance Volume indicator
   bars_calculated=calculated;
//--- Fractals
   int start;
//--- clean up arrays
   if(prev_calculated<7)
     {
      start=2;
      ArrayInitialize(Fractal_Up_Buffer,EMPTY_VALUE);
      ArrayInitialize(Fractal_Down_Buffer,EMPTY_VALUE);
     }
   else
      start=rates_total-5;
//--- main cycle of calculations
   for(int i=start; i<rates_total-3 && !IsStopped(); i++)
     {
      //--- Upper Fractal
      if(DDSRSIOMABuffer[i]>DDSRSIOMABuffer[i+1] && DDSRSIOMABuffer[i]>DDSRSIOMABuffer[i+2] && DDSRSIOMABuffer[i]>=DDSRSIOMABuffer[i-1] && DDSRSIOMABuffer[i]>=DDSRSIOMABuffer[i-2])
         Fractal_Up_Buffer[i]=DDSRSIOMABuffer[i]+ Offset;
      else
         Fractal_Up_Buffer[i]=EMPTY_VALUE;
      //--- Lower Fractal
      if(DDSRSIOMABuffer[i]<DDSRSIOMABuffer[i+1] && DDSRSIOMABuffer[i]<DDSRSIOMABuffer[i+2] && DDSRSIOMABuffer[i]<=DDSRSIOMABuffer[i-1] && DDSRSIOMABuffer[i]<=DDSRSIOMABuffer[i-2])
         Fractal_Down_Buffer[i]=DDSRSIOMABuffer[i]- Offset;
      else
         Fractal_Down_Buffer[i]=EMPTY_VALUE;
     }
//---
   for(int i=rates_total-3; i<rates_total; i++)
     {
      Fractal_Up_Buffer[i]=EMPTY_VALUE;
      Fractal_Down_Buffer[i]=EMPTY_VALUE;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Filling indicator buffers from the iOBV indicator                |
//+------------------------------------------------------------------+
bool FillArrayFromBuffer(double &ddsrsioma_buffer[],  // indicator buffer of OBV values
                         int ind_handle,        // handle of the iOBV indicator
                         int amount             // number of copied values
                        )
  {
//--- reset error code
   ResetLastError();
//--- fill a part of the iDDSRSIOMABuffer array with values from the indicator buffer that has 0 index
   if(CopyBuffer(ind_handle,0,0,amount,ddsrsioma_buffer)<0)
     {
      //--- if the copying fails, tell the error code
      PrintFormat("Failed to copy data from the DDSRSIOMA indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
     }
//--- everything is fine
   return(true);
  }
//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(handle_DDSRSIOMA!=INVALID_HANDLE)
      IndicatorRelease(handle_DDSRSIOMA);
  }
//+------------------------------------------------------------------+
