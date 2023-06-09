//+------------------------------------------------------------------+
//|                                                     iRSISign.mq5 |
//|                               Copyright © 2016, Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+
#property copyright "Copyright © 2016, Nikolay Kositsin"
#property link "farria@mail.redcom.ru"
//--- íîìåð âåðñèè èíäèêàòîðà
#property version   "1.00"
//--- îòðèñîâêà èíäèêàòîðà â ãëàâíîì îêíå
#property indicator_chart_window 
//--- äëÿ ðàñ÷åòà è îòðèñîâêè èíäèêàòîðà èñïîëüçîâàíî äâà áóôåðà
#property indicator_buffers 6
//--- èñïîëüçîâàíî âñåãî äâà ãðàôè÷åñêèõ ïîñòðîåíèÿ
#property indicator_plots   2
//+----------------------------------------------+
//|  Ïàðàìåòðû îòðèñîâêè ìåäâåæüåãî èíäèêàòîðà   |
//+----------------------------------------------+
//--- îòðèñîâêà èíäèêàòîðà 1 â âèäå ñèìâîëà
#property indicator_type1   DRAW_ARROW
//--- â êà÷åñòâå öâåòà ìåäâåæüåãî èíäèêàòîðà èñïîëüçîâàí DeepPink öâåò
#property indicator_color1  clrAqua
//--- òîëùèíà ëèíèè èíäèêàòîðà 1 ðàâíà 4
#property indicator_width1  4
//--- îòîáðàæåíèå áû÷åé ìåòêè èíäèêàòîðà
#property indicator_label1  "iRSISign Sell"
//+----------------------------------------------+
//|  Ïàðàìåòðû îòðèñîâêè áû÷üãî èíäèêàòîðà       |
//+----------------------------------------------+
//--- îòðèñîâêà èíäèêàòîðà 2 â âèäå ñèìâîëà
#property indicator_type2   DRAW_ARROW
//--- â êà÷åñòâå öâåòà áû÷üåãî èíäèêàòîðà èñïîëüçîâàí Aqua öâåò
#property indicator_color2  clrAqua
//--- òîëùèíà ëèíèè èíäèêàòîðà 2 ðàâíà 4
#property indicator_width2  4
//--- îòîáðàæåíèå ìåäâåæüåé ìåòêè èíäèêàòîðà
#property indicator_label2 "iRSISign Buy"
//+----------------------------------------------+
//|  îáúÿâëåíèå êîíñòàíò                         |
//+----------------------------------------------+
#define RESET  0 // Êîíñòàíòà äëÿ âîçâðàòà òåðìèíàëó êîìàíäû íà ïåðåñ÷¸ò èíäèêàòîðà
//+----------------------------------------------+
//| Âõîäíûå ïàðàìåòðû èíäèêàòîðà                 |
//+----------------------------------------------+
input group           "RSIOMA" 
input uint ATR_Period=14;
input uint                 RSIPeriod=14;
input ENUM_APPLIED_PRICE   RSIPrice=PRICE_CLOSE;
input uint UpLevel=90; //Upper Level
input uint DnLevel=10; //LowerLevel

input group           "Choppy Market Index"
input bool Choppy = 0;
input int chop = 200; // Period
//+----------------------------------------------+
//--- îáúÿâëåíèå äèíàìè÷åñêèõ ìàññèâîâ, êîòîðûå â äàëüíåéøåì
//--- áóäóò èñïîëüçîâàíû â êà÷åñòâå èíäèêàòîðíûõ áóôåðîâ

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
uint  i_slowing = 18;                     // Slowing / Çàïàçäûâàíèå
ENUM_PRICE_TYPE i_price = PRICE_WEIGHTED; 
int OnInit()
  {
//--- èíèöèàëèçàöèÿ ãëîáàëüíûõ ïåðåìåííûõ 
   min_rates_total=int(MathMax(RSIPeriod+1,ATR_Period))+1;
//--- ïîëó÷åíèå õåíäëà èíäèêàòîðà RSIPeriod
   RSI_Handle=iCustom(Symbol(),0,"DDSRSIOMA",RSIPeriod,i_price);;
   if(RSI_Handle==INVALID_HANDLE)
     {
      Print("Íå óäàëîñü ïîëó÷èòü õåíäë èíäèêàòîðà RSIPeriod");
      return(INIT_FAILED);
     }
//--- ïîëó÷åíèå õåíäëà èíäèêàòîðà ATR
   ATR_Handle=iATR(NULL,0,ATR_Period);
   if(ATR_Handle==INVALID_HANDLE)
     {
      Print(" Íå óäàëîñü ïîëó÷èòü õåíäë èíäèêàòîðà ATR");
      return(INIT_FAILED);
     }
     
     
     
     derivative = iCustom(Symbol(),0,"DDSRSI Derivative",18,i_price);
   if(derivative==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the Rsi indicator for the symbol %s/%s, error code %d",
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

     
//--- ïðåâðàùåíèå äèíàìè÷åñêîãî ìàññèâà â èíäèêàòîðíûé áóôåð
   SetIndexBuffer(0,SellBuffer,INDICATOR_DATA);
//--- îñóùåñòâëåíèå ñäâèãà íà÷àëà îòñ÷åòà îòðèñîâêè èíäèêàòîðà 1
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);
//--- ñèìâîë äëÿ èíäèêàòîðà
   PlotIndexSetInteger(0,PLOT_ARROW,226);
//--- èíäåêñàöèÿ ýëåìåíòîâ â áóôåðå êàê â òàéìñåðèè
   ArraySetAsSeries(SellBuffer,true);
//--- ïðåâðàùåíèå äèíàìè÷åñêîãî ìàññèâà â èíäèêàòîðíûé áóôåð
   SetIndexBuffer(1,BuyBuffer,INDICATOR_DATA);
//--- îñóùåñòâëåíèå ñäâèãà íà÷àëà îòñ÷åòà îòðèñîâêè èíäèêàòîðà 2
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,min_rates_total);
//--- ñèìâîë äëÿ èíäèêàòîðà
   PlotIndexSetInteger(1,PLOT_ARROW,225);
//--- èíäåêñàöèÿ ýëåìåíòîâ â áóôåðå êàê â òàéìñåðèè
   ArraySetAsSeries(BuyBuffer,true);
//--- Óñòàíîâêà ôîðìàòà òî÷íîñòè îòîáðàæåíèÿ èíäèêàòîðà
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- èìÿ äëÿ îêîí äàííûõ è ìåòêà äëÿ ïîäîêîí 
   string short_name="iRSISign";
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
//--- ïðîâåðêà êîëè÷åñòâà áàðîâ íà äîñòàòî÷íîñòü äëÿ ðàñ÷åòà
   if(BarsCalculated(RSI_Handle)<rates_total
      || BarsCalculated(ATR_Handle)<rates_total
      || BarsCalculated(derivative)<rates_total
      || BarsCalculated(cmi_m15)<rates_total
      || rates_total<min_rates_total)
      return(RESET);

//--- îáúÿâëåíèÿ ëîêàëüíûõ ïåðåìåííûõ 
   int to_copy,limit,bar;
   double RSI[],ATR[], DER[], CMI[], CMI_MA[];

//--- ðàñ÷åòû íåîáõîäèìîãî êîëè÷åñòâà êîïèðóåìûõ äàííûõ è
//ñòàðòîâîãî íîìåðà limit äëÿ öèêëà ïåðåñ÷åòà áàðîâ
   if(prev_calculated>rates_total || prev_calculated<=0)// ïðîâåðêà íà ïåðâûé ñòàðò ðàñ÷åòà èíäèêàòîðà
     {
      limit=rates_total-min_rates_total; // ñòàðòîâûé íîìåð äëÿ ðàñ÷åòà âñåõ áàðîâ
     }
   else
     {
      limit=rates_total-prev_calculated; // ñòàðòîâûé íîìåð äëÿ ðàñ÷åòà íîâûõ áàðîâ
     }
   to_copy=limit+1;
//--- êîïèðóåì âíîâü ïîÿâèâøèåñÿ äàííûå â ìàññèâû
   if(CopyBuffer(RSI_Handle,0,MAIN_LINE,to_copy,RSI)<=0) return(RESET);
   if(CopyBuffer(ATR_Handle,0,0,to_copy,ATR)<=0) return(RESET);
   if(CopyBuffer(derivative,0,0,to_copy,DER)<=0) return(RESET);
   if(CopyBuffer(cmi_m15,0,0,to_copy,CMI)<=0) return(RESET);
   if(CopyBuffer(cmi_m15,1,0,to_copy,CMI_MA)<=0) return(RESET);
//--- èíäåêñàöèÿ ýëåìåíòîâ â ìàññèâàõ êàê â òàéìñåðèÿõ  
   ArraySetAsSeries(RSI,true);
   ArraySetAsSeries(ATR,true);
   ArraySetAsSeries(DER,true);
   ArraySetAsSeries(CMI,true);
   ArraySetAsSeries(CMI_MA,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
//--- îñíîâíîé öèêë ðàñ÷åòà èíäèêàòîðà
   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      BuyBuffer[bar]=NULL;
      SellBuffer[bar]=NULL;
      RsiBuffer[bar]= RSI[bar];
      DerivativeBuffer[bar]=DER[bar];
      
      if(Choppy == 1){  if(RSI[bar] <= DnLevel && DER[bar]>-25 && CMI[bar]<CMI_MA[bar] && CMI[bar]<40) BuyBuffer[bar] = low[bar] - ATR[bar]*3/8;
		    if( RSI[bar] >= UpLevel && DER[bar]<25 && CMI[bar]<CMI_MA[bar] && CMI[bar]<33) SellBuffer[bar] = high[bar] + ATR[bar]*3/8;  
		    } else{
		    
		      if(RSI[bar] <= DnLevel && DER[bar]>=-20 ) BuyBuffer[bar] = low[bar] - ATR[bar]*3/8;
		    if( RSI[bar] >= UpLevel && DER[bar]<=20 ) SellBuffer[bar] = high[bar] + ATR[bar]*3/8;  
		    }
           
     }
//---     
   return(rates_total);
  }
//+------------------------------------------------------------------+
