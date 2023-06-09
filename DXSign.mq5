//+------------------------------------------------------------------+
//|                                                       DXSign.mq5 |
//|                                        Copyright © 2023, DaemonX | 
//|                                                                  | 
//+------------------------------------------------------------------+
#property copyright "Copyright © 2023, DaemonX"
#property link ""

#property version   "1.00"

#property indicator_chart_window 

#property indicator_buffers 6

#property indicator_plots   2

#property indicator_type1   DRAW_ARROW

#property indicator_color1  clrWheat

#property indicator_width1  4

#property indicator_label1  "DXSign Sell"

#property indicator_type2   DRAW_ARROW

#property indicator_color2  clrWheat

#property indicator_width2  4

#property indicator_label2 "DXSign Buy"

#define RESET  0

input group           "RSIOMA" 
input uint ATR_Period=14;
input uint                 RSIPeriod=14;
input ENUM_APPLIED_PRICE   RSIPrice=PRICE_CLOSE;
input uint UpLevel=90; //Upper Level
input uint DnLevel=10; //LowerLevel

input group           "Choppy Market Index"
input bool Choppy = 0;
input int chop = 200; // Period


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

enum enMaTypes
  {
   ma_sma,    // Simple moving average
   ma_ema,    // Exponential moving average
   ma_smma,   // Smoothed MA
   ma_lwma    // Linear weighted MA
  };



double SellBuffer[];
double BuyBuffer[];

double RsiBuffer[];
double DerivativeBuffer[];
//---
int RSI_Handle,ATR_Handle,min_rates_total,derivative,cmi_m15;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
uint  i_slowing = 18;                     // Slowing
ENUM_PRICE_TYPE i_price = PRICE_WEIGHTED; 
int OnInit()
  {

   min_rates_total=int(MathMax(RSIPeriod+1,ATR_Period))+1;

   RSI_Handle=iCustom(Symbol(),0,"DDSRSIOMA",RSIPeriod,i_price);;
   if(RSI_Handle==INVALID_HANDLE)
     {
      Print("Unable to Create DDSRSIOMA handle");
      return(INIT_FAILED);
     }

   ATR_Handle=iATR(NULL,0,ATR_Period);
   if(ATR_Handle==INVALID_HANDLE)
     {
      Print(" Unable to Create ATR handle");
      return(INIT_FAILED);
     }
     
     
     
     derivative = iCustom(Symbol(),0,"DDSRSI Derivative",34,i_price);
   if(derivative==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the DDSRSI Derivative indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_CURRENT),
                  GetLastError());
      //--- the indicator is stopped early

     }
     
     
        cmi_m15 = iCustom(Symbol(),0,"Choppy Market index",chop,10, ma_sma);
   if(cmi_m15==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the CMI indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_CURRENT),
                  GetLastError());
      //--- the indicator is stopped early

     }

     

   SetIndexBuffer(0,SellBuffer,INDICATOR_DATA);

   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);

   PlotIndexSetInteger(0,PLOT_ARROW,226);

   ArraySetAsSeries(SellBuffer,true);

   SetIndexBuffer(1,BuyBuffer,INDICATOR_DATA);

   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,min_rates_total);

   PlotIndexSetInteger(1,PLOT_ARROW,225);

   ArraySetAsSeries(BuyBuffer,true);

   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);

   string short_name="DXSign";
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
   
    SetIndexBuffer(2,RsiBuffer,INDICATOR_DATA);
    SetIndexBuffer(3,DerivativeBuffer,INDICATOR_DATA);
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

   if(BarsCalculated(RSI_Handle)<rates_total
      || BarsCalculated(ATR_Handle)<rates_total
      || BarsCalculated(derivative)<rates_total
      || BarsCalculated(cmi_m15)<rates_total
      || rates_total<min_rates_total)
      return(RESET);


   int to_copy,limit,bar;
   double RSI[],ATR[], DER[], CMI[], CMI_MA[];

   if(prev_calculated>rates_total || prev_calculated<=0)
     {
      limit=rates_total-min_rates_total; 
     }
   else
     {
      limit=rates_total-prev_calculated; 
     }
   to_copy=limit+1;

   if(CopyBuffer(RSI_Handle,0,MAIN_LINE,to_copy,RSI)<=0) return(RESET);
   if(CopyBuffer(ATR_Handle,0,0,to_copy,ATR)<=0) return(RESET);
   if(CopyBuffer(derivative,0,0,to_copy,DER)<=0) return(RESET);
   if(CopyBuffer(cmi_m15,0,0,to_copy,CMI)<=0) return(RESET);
   if(CopyBuffer(cmi_m15,1,0,to_copy,CMI_MA)<=0) return(RESET);

   ArraySetAsSeries(RSI,true);
   ArraySetAsSeries(ATR,true);
   ArraySetAsSeries(DER,true);
   ArraySetAsSeries(CMI,true);
   ArraySetAsSeries(CMI_MA,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);

   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      BuyBuffer[bar]=NULL;
      SellBuffer[bar]=NULL;
      RsiBuffer[bar]= RSI[bar];
      DerivativeBuffer[bar]=DER[bar];
      
      if(Choppy == 1){  if(RSI[bar] <= DnLevel && DER[bar]>-25 && CMI[bar]<CMI_MA[bar] && CMI[bar]<40) BuyBuffer[bar] = low[bar] - ATR[bar]*3/8;
		    if( RSI[bar] >= UpLevel && DER[bar]<25 && CMI[bar]<CMI_MA[bar] && CMI[bar]<40) SellBuffer[bar] = high[bar] + ATR[bar]*3/8;  
		    } else{
		    
		      if(RSI[bar] <= DnLevel && DER[bar]>-25 ) BuyBuffer[bar] = low[bar] - ATR[bar]*3/8;
		    if( RSI[bar] >= UpLevel && DER[bar]<25 ) SellBuffer[bar] = high[bar] + ATR[bar]*3/8;  
		    }
           
     }
//---     
   return(rates_total);
  }
//+------------------------------------------------------------------+
