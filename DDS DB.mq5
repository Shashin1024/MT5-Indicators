//+------------------------------------------------------------------+
//|                                                      DDS_DB.mq5 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property description   "Converted to Mt5 by DaemonX"
#property version   "1.00"
#property strict
//#property indicator_separate_window

#property indicator_buffers 9
#property indicator_minimum -12.5
#property indicator_maximum 112.5

enum ENUM_PRICE_TYPE
  {
   PRICE_TYPE_CLOSE,      // Close / Закрытие   

  };
  
  
sinput string text_01 = "====== Layout settings ======";             // layout settings
sinput int           xAnchor                       = 1200;           // Panel X anchor point
sinput int           yAnchor                       = 10;             // Panel Y anchor point
sinput int           panelWindow                   = 0;              // Panel window


sinput string        objectPreamble                = "_DDS_mtf_"; // Objects unique id
sinput int           updateFrequency               = 2;              // Update frequency in seconds

sinput color         panelBgColor                  = clrLightGray;   // Panel background color
sinput color         panelBorderColor              = clrWhiteSmoke;  // Panel border color
sinput int           panelBorderWidth              = 2;              // Panel border width
sinput int           panelColumnWidth              = 15;             // Panel column width
sinput int           panelRowHeight                = 15;             // Panel row height
sinput int           panelSpacing                  = 3;              // Panel row/column spacing

sinput color         textColor                     = clrBlack;       // Text color
sinput int           fontSize                      = 8;              // Text font size

sinput color         bullColor                     = clrGreen;       // Bull color
sinput color         bearColor                     = clrRed;         // Bear color


sinput string text_03 = "====== DDS settings ======";                // DDS settings
sinput double        Slw = 5;
sinput double        Pds = 10;
sinput double        Slwsignal = 7;
int                  Barcount = 200;





double ExtMapBuffer1_Tf1[];
double ExtMapBuffer1_Tf2[];
double ExtMapBuffer1_Tf3[];
double ExtMapBuffer1_Tf4[];
double ExtMapBuffer1_Tf5[];
double ExtMapBuffer1_Tf6[];
double ExtMapBuffer1_Tf7[];
double ExtMapBuffer1_Tf8[];
double ExtMapBuffer1_Tf9[];

int xPnlCorrection = 3;
int yPnlCorrection = 4;


int chartWindow;

int panelCounter;
int multiplier_1 = 4;

bool doCalculation;
string _symbol;

int xOffset_M1, xOffset_M5, xOffset_M15, xOffset_M30, xOffset_H1, xOffset_H4, xOffset_D1,xOffset_W1, xOffset_MN1;
int yOffset_0, yOffset_1, yOffset_2, yOffset_3, yOffset_4, yOffset_5;

int t1,t2,t3,t4,t5,t6;


int rsioma_m1,rsioma_m5, rsioma_m15,rsioma_m30, rsioma_h1, rsioma_h4, rsioma_d1, rsioma_w1, rsioma_mn1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   
    rsioma_m1 = iCustom(Symbol(),PERIOD_M1,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_m1==INVALID_HANDLE)
     {
   
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_M1),
                  GetLastError());
    
      return(INIT_FAILED);
     }
     
     
       rsioma_m5 = iCustom(Symbol(),PERIOD_M5,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_m5==INVALID_HANDLE)
     {

      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_M5),
                  GetLastError());
      return(INIT_FAILED);
     }

 
   
     rsioma_m15 = iCustom(Symbol(),PERIOD_M15,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_m15==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_M15),
                  GetLastError());
      return(INIT_FAILED);
     }
 
 
     rsioma_m30 = iCustom(Symbol(),PERIOD_M30,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_m30==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_M30),
                  GetLastError());
      return(INIT_FAILED);
     }
 
 
 
 
     rsioma_h1 = iCustom(Symbol(),PERIOD_H1,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_h1==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_H1),
                  GetLastError());
      return(INIT_FAILED);
     }
     
     
       rsioma_h4 = iCustom(Symbol(),PERIOD_H4,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_h4==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_H4),
                  GetLastError());
      return(INIT_FAILED);
     }


   rsioma_d1 = iCustom(Symbol(),PERIOD_D1,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_d1==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_D1),
                  GetLastError());
      return(INIT_FAILED);
     }
     
     
     rsioma_w1 = iCustom(Symbol(),PERIOD_W1,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_w1==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_W1),
                  GetLastError());
      return(INIT_FAILED);
     }


  rsioma_mn1 = iCustom(Symbol(),PERIOD_MN1,"JFDS",Slw,Pds,Slwsignal,1000);
   if(rsioma_mn1==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the JFDS indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(PERIOD_MN1),
                  GetLastError());
      return(INIT_FAILED);
     }




   int xOffset, yOffset;
   
   deleteObjects();
   EventSetTimer(5);
   
   _symbol = Symbol();
   
//--- indicator buffers mapping
   
   //_symbol = Symbol();
   
   chartWindow = panelWindow;
   panelCounter = 9;
   int panelWidth = (panelCounter + 2) *(panelColumnWidth+panelSpacing) + 7 * panelColumnWidth;
   int panelHeight = 10*(panelRowHeight+panelSpacing) + panelSpacing;
   
   // display panel
   SetPanel(chartWindow, objectPreamble + "mainPanel", xAnchor, yAnchor, panelWidth, panelHeight, panelBgColor, panelBorderColor, panelBorderWidth);
   
   // display header
   SetText(objectPreamble+"_Symbol",_symbol + " / DDS", chartWindow,xAnchor+2*panelSpacing, yAnchor + panelSpacing, textColor, fontSize+1);
   
   // display time frames
   multiplier_1 = 5;
   yOffset = yAnchor + 10 * panelSpacing;
   xOffset = xAnchor + 5 * panelSpacing;
   SetText(objectPreamble+"_M1","M1", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_M5","M5", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_M15","15", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_M30","30", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_H1","H1", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_H4","H4", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_D1","D1", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_W1","W1", chartWindow, xOffset, yOffset, textColor, fontSize);
   xOffset = xOffset + panelColumnWidth + multiplier_1*panelSpacing;
   SetText(objectPreamble+"_MN","MN", chartWindow, xOffset, yOffset, textColor, fontSize);
   
   int multiplier_2 = 3;
   multiplier_1 = 5;
   xOffset_M1 = xAnchor + 6*panelSpacing;
   xOffset_M5 = xOffset_M1 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_M15 = xOffset_M5 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_M30 = xOffset_M15 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_H1 = xOffset_M30 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_H4 = xOffset_H1 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_D1 = xOffset_H4 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_W1 = xOffset_D1 + panelColumnWidth + multiplier_1*panelSpacing;
   xOffset_MN1 = xOffset_W1 + panelColumnWidth + multiplier_1*panelSpacing;
   
   yOffset_0 = yAnchor + 17 * panelSpacing;
   yOffset_1 = yOffset_0 + panelRowHeight + multiplier_2*panelSpacing;
   yOffset_2 = yOffset_1 + panelRowHeight + multiplier_2*panelSpacing;
   yOffset_3 = yOffset_2 + panelRowHeight + multiplier_2*panelSpacing;
   yOffset_4 = yOffset_3 + panelRowHeight + multiplier_2*panelSpacing;
   
   yOffset_5 = yOffset_4 + panelRowHeight + multiplier_2*panelSpacing;
   
   EventSetTimer(updateFrequency);
   
   rsiomaCalculate();
   
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
   if (doCalculation)
   {
      rsiomaCalculate();
      doCalculation = false; 
   } 
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();
   
   deleteObjects();
      
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---
 
      rsiomaCalculate();
   
   
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---


   if (id == CHARTEVENT_OBJECT_CLICK)
   {
      
      
   }
   
   
}
//+------------------------------------------------------------------+



void rsiomaCalculate()
{         

   double   rsi_m1[];
   double   rsi_m5[];
   double   rsi_m15[];
   double   rsi_m30[];
   double   rsi_h1[];
   double   rsi_h4[];
   double   rsi_d1[];
   double   rsi_w1[];
   double   rsi_mn1[];



    ArraySetAsSeries(rsi_m1,true);
    ArraySetAsSeries(rsi_m5,true);
    ArraySetAsSeries(rsi_m15,true);
    ArraySetAsSeries(rsi_m30,true);
    ArraySetAsSeries(rsi_h1,true);
    ArraySetAsSeries(rsi_h4,true);
    ArraySetAsSeries(rsi_d1,true);
    ArraySetAsSeries(rsi_w1,true);
    ArraySetAsSeries(rsi_mn1,true);
   
   
    int buffer=0,start_pos=0,count=700;
    iGetArray(rsioma_m1,buffer,start_pos,count,rsi_m1);
    iGetArray(rsioma_m5,buffer,start_pos,count,rsi_m5);
    iGetArray(rsioma_m15,buffer,start_pos,count,rsi_m15);
    iGetArray(rsioma_m30,buffer,start_pos,count,rsi_m30);
    iGetArray(rsioma_h1,buffer,start_pos,count,rsi_h1);
    iGetArray(rsioma_h4,buffer,start_pos,count,rsi_h4);
    iGetArray(rsioma_d1,buffer,start_pos,count,rsi_d1);
    iGetArray(rsioma_w1,buffer,start_pos,count,rsi_w1);
    iGetArray(rsioma_mn1,buffer,start_pos,count,rsi_mn1);

/*

     double  med_m15_0 = (iCustom(_symbol, PERIOD_M15, "Rsioma Light", rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE, 0, 0)+iCustom(_symbol, PERIOD_M15, "Drake Delay Stochastic",
                        Slw,Pds, Slwsignal, Barcount, 0, 0))/2;


  double  med_m15_1 = (iCustom(_symbol, PERIOD_M15, "Rsioma Light", rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE, 0, 1)+iCustom(_symbol, PERIOD_M15, "Drake Delay Stochastic",
                        Slw,Pds, Slwsignal, Barcount, 0, 1))/2;




  double  med_h1_0 = (iCustom(_symbol, PERIOD_H1, "Rsioma Light", rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE, 0, 0)+iCustom(_symbol, PERIOD_H1, "Drake Delay Stochastic",
                        Slw,Pds, Slwsignal, Barcount, 0, 0))/2;


  double  med_h1_1 = (iCustom(_symbol, PERIOD_H1, "Rsioma Light", rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE, 0, 1)+iCustom(_symbol, PERIOD_H1, "Drake Delay Stochastic",
                        Slw,Pds, Slwsignal, Barcount, 0, 1))/2;




  double  med_h4_0 = (iCustom(_symbol, PERIOD_H4, "Rsioma Light", rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE, 0, 0)+iCustom(_symbol, PERIOD_H1, "Drake Delay Stochastic",
                        Slw,Pds, Slwsignal, Barcount, 0, 0))/2;


  double  med_h4_1 = (iCustom(_symbol, PERIOD_H4, "Rsioma Light", rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE, 0, 1)+iCustom(_symbol, PERIOD_H4, "Drake Delay Stochastic",
                        Slw,Pds, Slwsignal, Barcount, 0, 1))/2;
  
   

  double dx_m15_0 = (iCustom(_symbol, PERIOD_M15, "DDSRSI Derivative",i_slowing,i_price,i_indBarsCount,  rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE,Slw,Pds,Slwsignal,Barcount,  0, 0));

  double dx_m15_1 = (iCustom(_symbol, PERIOD_M15, "DDSRSI Derivative",i_slowing,i_price,i_indBarsCount,  rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE,Slw,Pds,Slwsignal,Barcount,  0, 1));
   
   
  double dx_h1_0 = (iCustom(_symbol, PERIOD_H1, "DDSRSI Derivative",i_slowing,i_price,i_indBarsCount,  rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE,Slw,Pds,Slwsignal,Barcount,  0, 0));

  double dx_h1_1 = (iCustom(_symbol, PERIOD_H1, "DDSRSI Derivative",i_slowing,i_price,i_indBarsCount,  rsiomaPeriod, RSIOMA_MODE, RSIOMA_PRICE, 
                           Ma_RSIOMA, Ma_RSIOMA_MODE,Slw,Pds,Slwsignal,Barcount,  0, 1));
   
    
   



if(med_m15_0>=90 &&  med_m15_1>=90 && dx_m15_0<=25 && dx_m15_1<=25 && t1 !=1 && dx_m15_0 != 0.0 && med_m15_0 !=0.0)
  {
   t1 =1;
   Alert("x SELL M15 @",_symbol, " DX = ", NormalizeDouble(dx_m15_0,1), "  DDSRSI = ",  NormalizeDouble(med_m15_0,1));
  }



if(med_m15_0<=10 &&  med_m15_1<=10 && dx_m15_0>=-25 && dx_m15_1>=-25 && t2 !=1 && dx_m15_0 != 0.0 && med_m15_0 !=0.0)
  {
   t2 =1;
   Alert("x BUY M15 @",_symbol, " DX = ", NormalizeDouble(dx_m15_0,1), "  DDSRSI = ",  NormalizeDouble(med_m15_0,1));
  }





if(med_h1_0>=90 &&  med_h1_1>=90 && dx_h1_0<=25 && dx_h1_1<=25 && t3 !=1  && dx_h1_0 != 0.0 && med_h1_0 !=0.0)
  {
   t3 =1;
   Alert("x SELL H1 @",_symbol, " DX = ",  NormalizeDouble(dx_h1_0,2), "  DDSRSI = ",  NormalizeDouble(med_h1_0,2));
  }



if(med_h1_0<=10 &&  med_h1_1<=10 && dx_h1_0>=-25 && dx_h1_1>=-25 && t4 !=1 && dx_h1_0 != 0.0 && med_h1_0 !=0.0)
  {
   t4 =1;
   Alert("x BUY H1 @",_symbol, " DX = ",  NormalizeDouble(dx_h1_0,2), "  DDSRSI = ",  NormalizeDouble(med_h1_0,2));
  }


  

*/




            
  if (rsi_m1[0] >= rsi_m1[1] && (rsi_m1[0] - rsi_m1[1]) >= 1.0)
   {
      SetText(objectPreamble + "M1_0", IntegerToString((int)rsi_m1[0]), chartWindow, xOffset_M1, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_0", xOffset_M1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m1[0] >= rsi_m1[1] && (rsi_m1[0] - rsi_m1[1]) < 1.0)
   {
      SetText(objectPreamble + "M1_0", IntegerToString((int)rsi_m1[0]), chartWindow, xOffset_M1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_0", xOffset_M1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m1[0] < rsi_m1[1] && (rsi_m1[1] - rsi_m1[0]) < 1.0)
   {
      SetText(objectPreamble + "M1_0", IntegerToString((int)rsi_m1[0]), chartWindow, xOffset_M1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_0", xOffset_M1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M1_0", IntegerToString((int)rsi_m1[0]), chartWindow, xOffset_M1, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_0", xOffset_M1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m1[1] >= rsi_m1[2] && (rsi_m1[1] - rsi_m1[2]) >= 1.0)
   {
      SetText(objectPreamble + "M1_1", IntegerToString((int)rsi_m1[1]), chartWindow, xOffset_M1, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_1", xOffset_M1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m1[1] >= rsi_m1[2] && (rsi_m1[1] - rsi_m1[2]) < 1.0)
   {
      SetText(objectPreamble + "M1_1", IntegerToString((int)rsi_m1[1]), chartWindow, xOffset_M1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_1", xOffset_M1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m1[1] < rsi_m1[2] && (rsi_m1[2] - rsi_m1[1]) < 1.0)
   {
      SetText(objectPreamble + "M1_1", IntegerToString((int)rsi_m1[1]), chartWindow, xOffset_M1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_1", xOffset_M1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M1_1", IntegerToString((int)rsi_m1[1]), chartWindow, xOffset_M1, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_1", xOffset_M1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m1[2] >= rsi_m1[3] && (rsi_m1[2] - rsi_m1[3]) >= 1.0)
   {
      SetText(objectPreamble + "M1_2", IntegerToString((int)rsi_m1[2]), chartWindow, xOffset_M1, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_2", xOffset_M1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m1[2] >= rsi_m1[3] && (rsi_m1[2] - rsi_m1[3]) < 1.0)
   {
      SetText(objectPreamble + "M1_2", IntegerToString((int)rsi_m1[2]), chartWindow, xOffset_M1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_2", xOffset_M1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m1[2] < rsi_m1[3] && (rsi_m1[3] - rsi_m1[2]) < 1.0)
   {
      SetText(objectPreamble + "M1_2", IntegerToString((int)rsi_m1[2]), chartWindow, xOffset_M1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_2", xOffset_M1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M1_2", IntegerToString((int)rsi_m1[2]), chartWindow, xOffset_M1, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_2", xOffset_M1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m1[3] >= rsi_m1[4] && (rsi_m1[3] - rsi_m1[4]) >= 1.0)
   {
      SetText(objectPreamble + "M1_3", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_3", xOffset_M1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m1[3] >= rsi_m1[4] && (rsi_m1[3] - rsi_m1[4]) < 1.0)
   {
      SetText(objectPreamble + "M1_3", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_3", xOffset_M1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m1[3] < rsi_m1[4] && (rsi_m1[4] - rsi_m1[3]) < 1.0)
   {
      SetText(objectPreamble + "M1_3", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_3", xOffset_M1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M1_3", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_3", xOffset_M1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m1[4] >= rsi_m1[5] && (rsi_m1[4] - rsi_m1[5]) >= 1.0)
   {
      SetText(objectPreamble + "M1_4", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_4", xOffset_M1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m1[4] >= rsi_m1[5] && (rsi_m1[4] - rsi_m1[5]) < 1.0)
   {
      SetText(objectPreamble + "M1_4", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_4", xOffset_M1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m1[4] < rsi_m1[5] && (rsi_m1[5] - rsi_m1[4]) < 1.0)
   {
      SetText(objectPreamble + "M1_4", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_4", xOffset_M1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M1_4", IntegerToString((int)rsi_m1[3]), chartWindow, xOffset_M1, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM1_4", xOffset_M1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
 
 
 
 
 /*------------------------------------------------*/
 
 
            
   if (rsi_m5[0] >= rsi_m5[1] && (rsi_m5[0] - rsi_m5[1]) >= 1.0)
   {
      SetText(objectPreamble + "M5_0", IntegerToString((int)rsi_m5[0]), chartWindow, xOffset_M5, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_0", xOffset_M5 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m5[0] >= rsi_m5[1] && (rsi_m5[0] - rsi_m5[1]) < 1.0)
   {
      SetText(objectPreamble + "M5_0", IntegerToString((int)rsi_m5[0]), chartWindow, xOffset_M5, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_0", xOffset_M5 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m5[0] < rsi_m5[1] && (rsi_m5[1] - rsi_m5[0]) < 1.0)
   {
      SetText(objectPreamble + "M5_0", IntegerToString((int)rsi_m5[0]), chartWindow, xOffset_M5, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_0", xOffset_M5 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M5_0", IntegerToString((int)rsi_m5[0]), chartWindow, xOffset_M5, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_0", xOffset_M5 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m5[1] >= rsi_m5[2] && (rsi_m5[1] - rsi_m5[2]) >= 1.0)
   {
      SetText(objectPreamble + "M5_1", IntegerToString((int)rsi_m5[1]), chartWindow, xOffset_M5, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_1", xOffset_M5 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m5[1] >= rsi_m5[2] && (rsi_m5[1] - rsi_m5[2]) < 1.0)
   {
      SetText(objectPreamble + "M5_1", IntegerToString((int)rsi_m5[1]), chartWindow, xOffset_M5, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_1", xOffset_M5 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m5[1] < rsi_m5[2] && (rsi_m5[2] - rsi_m5[1]) < 1.0)
   {
      SetText(objectPreamble + "M5_1", IntegerToString((int)rsi_m5[1]), chartWindow, xOffset_M5, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_1", xOffset_M5 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M5_1", IntegerToString((int)rsi_m5[1]), chartWindow, xOffset_M5, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_1", xOffset_M5 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m5[2] >= rsi_m5[3] && (rsi_m5[2] - rsi_m5[3]) >= 1.0)
   {
      SetText(objectPreamble + "M5_2", IntegerToString((int)rsi_m5[2]), chartWindow, xOffset_M5, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_2", xOffset_M5 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m5[2] >= rsi_m5[3] && (rsi_m5[2] - rsi_m5[3]) < 1.0)
   {
      SetText(objectPreamble + "M5_2", IntegerToString((int)rsi_m5[2]), chartWindow, xOffset_M5, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_2", xOffset_M5 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m5[2] < rsi_m5[3] && (rsi_m5[3] - rsi_m5[2]) < 1.0)
   {
      SetText(objectPreamble + "M5_2", IntegerToString((int)rsi_m5[2]), chartWindow, xOffset_M5, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_2", xOffset_M5 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M5_2", IntegerToString((int)rsi_m5[2]), chartWindow, xOffset_M5, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_2", xOffset_M5 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m5[3] >= rsi_m5[4] && (rsi_m5[3] - rsi_m5[4]) >= 1.0)
   {
      SetText(objectPreamble + "M5_3", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_3", xOffset_M5 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m5[3] >= rsi_m5[4] && (rsi_m5[3] - rsi_m5[4]) < 1.0)
   {
      SetText(objectPreamble + "M5_3", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_3", xOffset_M5 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m5[3] < rsi_m5[4] && (rsi_m5[4] - rsi_m5[3]) < 1.0)
   {
      SetText(objectPreamble + "M5_3", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_3", xOffset_M5 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M5_3", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_3", xOffset_M5 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m5[4] >= rsi_m5[5] && (rsi_m5[4] - rsi_m5[5]) >= 1.0)
   {
      SetText(objectPreamble + "M5_4", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_4", xOffset_M5 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m5[4] >= rsi_m5[5] && (rsi_m5[4] - rsi_m5[5]) < 1.0)
   {
      SetText(objectPreamble + "M5_4", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_4", xOffset_M5 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m5[4] < rsi_m5[5] && (rsi_m5[5] - rsi_m5[4]) < 1.0)
   {
      SetText(objectPreamble + "M5_4", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_4", xOffset_M5 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M5_4", IntegerToString((int)rsi_m5[3]), chartWindow, xOffset_M5, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM5_4", xOffset_M5 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
   
   
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 

                        
                        
                        
                        
                        
            
    if (rsi_m15[0] >= rsi_m15[1] && (rsi_m15[0] - rsi_m15[1]) >= 1.0)
   {
      SetText(objectPreamble + "M15_0", IntegerToString((int)rsi_m15[0]), chartWindow, xOffset_M15, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_0", xOffset_M15 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m15[0] >= rsi_m15[1] && (rsi_m15[0] - rsi_m15[1]) < 1.0)
   {
      SetText(objectPreamble + "M15_0", IntegerToString((int)rsi_m15[0]), chartWindow, xOffset_M15, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_0", xOffset_M15 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m15[0] < rsi_m15[1] && (rsi_m15[1] - rsi_m15[0]) < 1.0)
   {
      SetText(objectPreamble + "M15_0", IntegerToString((int)rsi_m15[0]), chartWindow, xOffset_M15, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_0", xOffset_M15 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M15_0", IntegerToString((int)rsi_m15[0]), chartWindow, xOffset_M15, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_0", xOffset_M15 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m15[1] >= rsi_m15[2] && (rsi_m15[1] - rsi_m15[2]) >= 1.0)
   {
      SetText(objectPreamble + "M15_1", IntegerToString((int)rsi_m15[1]), chartWindow, xOffset_M15, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_1", xOffset_M15 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m15[1] >= rsi_m15[2] && (rsi_m15[1] - rsi_m15[2]) < 1.0)
   {
      SetText(objectPreamble + "M15_1", IntegerToString((int)rsi_m15[1]), chartWindow, xOffset_M15, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_1", xOffset_M15 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m15[1] < rsi_m15[2] && (rsi_m15[2] - rsi_m15[1]) < 1.0)
   {
      SetText(objectPreamble + "M15_1", IntegerToString((int)rsi_m15[1]), chartWindow, xOffset_M15, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_1", xOffset_M15 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M15_1", IntegerToString((int)rsi_m15[1]), chartWindow, xOffset_M15, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_1", xOffset_M15 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m15[2] >= rsi_m15[3] && (rsi_m15[2] - rsi_m15[3]) >= 1.0)
   {
      SetText(objectPreamble + "M15_2", IntegerToString((int)rsi_m15[2]), chartWindow, xOffset_M15, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_2", xOffset_M15 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m15[2] >= rsi_m15[3] && (rsi_m15[2] - rsi_m15[3]) < 1.0)
   {
      SetText(objectPreamble + "M15_2", IntegerToString((int)rsi_m15[2]), chartWindow, xOffset_M15, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_2", xOffset_M15 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m15[2] < rsi_m15[3] && (rsi_m15[3] - rsi_m15[2]) < 1.0)
   {
      SetText(objectPreamble + "M15_2", IntegerToString((int)rsi_m15[2]), chartWindow, xOffset_M15, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_2", xOffset_M15 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M15_2", IntegerToString((int)rsi_m15[2]), chartWindow, xOffset_M15, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_2", xOffset_M15 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m15[3] >= rsi_m15[4] && (rsi_m15[3] - rsi_m15[4]) >= 1.0)
   {
      SetText(objectPreamble + "M15_3", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_3", xOffset_M15 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m15[3] >= rsi_m15[4] && (rsi_m15[3] - rsi_m15[4]) < 1.0)
   {
      SetText(objectPreamble + "M15_3", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_3", xOffset_M15 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m15[3] < rsi_m15[4] && (rsi_m15[4] - rsi_m15[3]) < 1.0)
   {
      SetText(objectPreamble + "M15_3", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_3", xOffset_M15 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M15_3", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_3", xOffset_M15 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m15[4] >= rsi_m15[5] && (rsi_m15[4] - rsi_m15[5]) >= 1.0)
   {
      SetText(objectPreamble + "M15_4", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_4", xOffset_M15 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m15[4] >= rsi_m15[5] && (rsi_m15[4] - rsi_m15[5]) < 1.0)
   {
      SetText(objectPreamble + "M15_4", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_4", xOffset_M15 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m15[4] < rsi_m15[5] && (rsi_m15[5] - rsi_m15[4]) < 1.0)
   {
      SetText(objectPreamble + "M15_4", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_4", xOffset_M15 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M15_4", IntegerToString((int)rsi_m15[3]), chartWindow, xOffset_M15, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM15_4", xOffset_M15 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
   
   
   
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 

       
       
       
       
       
       
            
   if (rsi_m30[0] >= rsi_m30[1] && (rsi_m30[0] - rsi_m30[1]) >= 1.0)
   {
      SetText(objectPreamble + "M30_0", IntegerToString((int)rsi_m30[0]), chartWindow, xOffset_M30, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_0", xOffset_M30 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m30[0] >= rsi_m30[1] && (rsi_m30[0] - rsi_m30[1]) < 1.0)
   {
      SetText(objectPreamble + "M30_0", IntegerToString((int)rsi_m30[0]), chartWindow, xOffset_M30, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_0", xOffset_M30 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m30[0] < rsi_m30[1] && (rsi_m30[1] - rsi_m30[0]) < 1.0)
   {
      SetText(objectPreamble + "M30_0", IntegerToString((int)rsi_m30[0]), chartWindow, xOffset_M30, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_0", xOffset_M30 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M30_0", IntegerToString((int)rsi_m30[0]), chartWindow, xOffset_M30, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_0", xOffset_M30 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m30[1] >= rsi_m30[2] && (rsi_m30[1] - rsi_m30[2]) >= 1.0)
   {
      SetText(objectPreamble + "M30_1", IntegerToString((int)rsi_m30[1]), chartWindow, xOffset_M30, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_1", xOffset_M30 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m30[1] >= rsi_m30[2] && (rsi_m30[1] - rsi_m30[2]) < 1.0)
   {
      SetText(objectPreamble + "M30_1", IntegerToString((int)rsi_m30[1]), chartWindow, xOffset_M30, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_1", xOffset_M30 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m30[1] < rsi_m30[2] && (rsi_m30[2] - rsi_m30[1]) < 1.0)
   {
      SetText(objectPreamble + "M30_1", IntegerToString((int)rsi_m30[1]), chartWindow, xOffset_M30, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_1", xOffset_M30 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M30_1", IntegerToString((int)rsi_m30[1]), chartWindow, xOffset_M30, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_1", xOffset_M30 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m30[2] >= rsi_m30[3] && (rsi_m30[2] - rsi_m30[3]) >= 1.0)
   {
      SetText(objectPreamble + "M30_2", IntegerToString((int)rsi_m30[2]), chartWindow, xOffset_M30, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_2", xOffset_M30 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m30[2] >= rsi_m30[3] && (rsi_m30[2] - rsi_m30[3]) < 1.0)
   {
      SetText(objectPreamble + "M30_2", IntegerToString((int)rsi_m30[2]), chartWindow, xOffset_M30, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_2", xOffset_M30 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m30[2] < rsi_m30[3] && (rsi_m30[3] - rsi_m30[2]) < 1.0)
   {
      SetText(objectPreamble + "M30_2", IntegerToString((int)rsi_m30[2]), chartWindow, xOffset_M30, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_2", xOffset_M30 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M30_2", IntegerToString((int)rsi_m30[2]), chartWindow, xOffset_M30, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_2", xOffset_M30 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m30[3] >= rsi_m30[4] && (rsi_m30[3] - rsi_m30[4]) >= 1.0)
   {
      SetText(objectPreamble + "M30_3", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_3", xOffset_M30 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m30[3] >= rsi_m30[4] && (rsi_m30[3] - rsi_m30[4]) < 1.0)
   {
      SetText(objectPreamble + "M30_3", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_3", xOffset_M30 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m30[3] < rsi_m30[4] && (rsi_m30[4] - rsi_m30[3]) < 1.0)
   {
      SetText(objectPreamble + "M30_3", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_3", xOffset_M30 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M30_3", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_3", xOffset_M30 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_m30[4] >= rsi_m30[5] && (rsi_m30[4] - rsi_m30[5]) >= 1.0)
   {
      SetText(objectPreamble + "M30_4", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_4", xOffset_M30 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_m30[4] >= rsi_m30[5] && (rsi_m30[4] - rsi_m30[5]) < 1.0)
   {
      SetText(objectPreamble + "M30_4", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_4", xOffset_M30 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_m30[4] < rsi_m30[5] && (rsi_m30[5] - rsi_m30[4]) < 1.0)
   {
      SetText(objectPreamble + "M30_4", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_4", xOffset_M30 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "M30_4", IntegerToString((int)rsi_m30[3]), chartWindow, xOffset_M30, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PM30_4", xOffset_M30 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
            
   if (rsi_h1[0] >= rsi_h1[1] && (rsi_h1[0] - rsi_h1[1]) >= 1.0)
   {
      SetText(objectPreamble + "H1_0", IntegerToString((int)rsi_h1[0]), chartWindow, xOffset_H1, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_0", xOffset_H1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h1[0] >= rsi_h1[1] && (rsi_h1[0] - rsi_h1[1]) < 1.0)
   {
      SetText(objectPreamble + "H1_0", IntegerToString((int)rsi_h1[0]), chartWindow, xOffset_H1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_0", xOffset_H1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h1[0] < rsi_h1[1] && (rsi_h1[1] - rsi_h1[0]) < 1.0)
   {
      SetText(objectPreamble + "H1_0", IntegerToString((int)rsi_h1[0]), chartWindow, xOffset_H1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_0", xOffset_H1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H1_0", IntegerToString((int)rsi_h1[0]), chartWindow, xOffset_H1, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_0", xOffset_H1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h1[1] >= rsi_h1[2] && (rsi_h1[1] - rsi_h1[2]) >= 1.0)
   {
      SetText(objectPreamble + "H1_1", IntegerToString((int)rsi_h1[1]), chartWindow, xOffset_H1, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_1", xOffset_H1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h1[1] >= rsi_h1[2] && (rsi_h1[1] - rsi_h1[2]) < 1.0)
   {
      SetText(objectPreamble + "H1_1", IntegerToString((int)rsi_h1[1]), chartWindow, xOffset_H1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_1", xOffset_H1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h1[1] < rsi_h1[2] && (rsi_h1[2] - rsi_h1[1]) < 1.0)
   {
      SetText(objectPreamble + "H1_1", IntegerToString((int)rsi_h1[1]), chartWindow, xOffset_H1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_1", xOffset_H1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H1_1", IntegerToString((int)rsi_h1[1]), chartWindow, xOffset_H1, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_1", xOffset_H1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h1[2] >= rsi_h1[3] && (rsi_h1[2] - rsi_h1[3]) >= 1.0)
   {
      SetText(objectPreamble + "H1_2", IntegerToString((int)rsi_h1[2]), chartWindow, xOffset_H1, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_2", xOffset_H1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h1[2] >= rsi_h1[3] && (rsi_h1[2] - rsi_h1[3]) < 1.0)
   {
      SetText(objectPreamble + "H1_2", IntegerToString((int)rsi_h1[2]), chartWindow, xOffset_H1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_2", xOffset_H1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h1[2] < rsi_h1[3] && (rsi_h1[3] - rsi_h1[2]) < 1.0)
   {
      SetText(objectPreamble + "H1_2", IntegerToString((int)rsi_h1[2]), chartWindow, xOffset_H1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_2", xOffset_H1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H1_2", IntegerToString((int)rsi_h1[2]), chartWindow, xOffset_H1, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_2", xOffset_H1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h1[3] >= rsi_h1[4] && (rsi_h1[3] - rsi_h1[4]) >= 1.0)
   {
      SetText(objectPreamble + "H1_3", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_3", xOffset_H1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h1[3] >= rsi_h1[4] && (rsi_h1[3] - rsi_h1[4]) < 1.0)
   {
      SetText(objectPreamble + "H1_3", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_3", xOffset_H1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h1[3] < rsi_h1[4] && (rsi_h1[4] - rsi_h1[3]) < 1.0)
   {
      SetText(objectPreamble + "H1_3", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_3", xOffset_H1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H1_3", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_3", xOffset_H1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h1[4] >= rsi_h1[5] && (rsi_h1[4] - rsi_h1[5]) >= 1.0)
   {
      SetText(objectPreamble + "H1_4", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_4", xOffset_H1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h1[4] >= rsi_h1[5] && (rsi_h1[4] - rsi_h1[5]) < 1.0)
   {
      SetText(objectPreamble + "H1_4", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_4", xOffset_H1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h1[4] < rsi_h1[5] && (rsi_h1[5] - rsi_h1[4]) < 1.0)
   {
      SetText(objectPreamble + "H1_4", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_4", xOffset_H1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H1_4", IntegerToString((int)rsi_h1[3]), chartWindow, xOffset_H1, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH1_4", xOffset_H1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
   
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 
 
 
 
 
 
 
 
            
   if (rsi_h4[0] >= rsi_h4[1] && (rsi_h4[0] - rsi_h4[1]) >= 1.0)
   {
      SetText(objectPreamble + "H4_0", IntegerToString((int)rsi_h4[0]), chartWindow, xOffset_H4, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_0", xOffset_H4 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h4[0] >= rsi_h4[1] && (rsi_h4[0] - rsi_h4[1]) < 1.0)
   {
      SetText(objectPreamble + "H4_0", IntegerToString((int)rsi_h4[0]), chartWindow, xOffset_H4, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_0", xOffset_H4 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h4[0] < rsi_h4[1] && (rsi_h4[1] - rsi_h4[0]) < 1.0)
   {
      SetText(objectPreamble + "H4_0", IntegerToString((int)rsi_h4[0]), chartWindow, xOffset_H4, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_0", xOffset_H4 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H4_0", IntegerToString((int)rsi_h4[0]), chartWindow, xOffset_H4, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_0", xOffset_H4 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h4[1] >= rsi_h4[2] && (rsi_h4[1] - rsi_h4[2]) >= 1.0)
   {
      SetText(objectPreamble + "H4_1", IntegerToString((int)rsi_h4[1]), chartWindow, xOffset_H4, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_1", xOffset_H4 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h4[1] >= rsi_h4[2] && (rsi_h4[1] - rsi_h4[2]) < 1.0)
   {
      SetText(objectPreamble + "H4_1", IntegerToString((int)rsi_h4[1]), chartWindow, xOffset_H4, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_1", xOffset_H4 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h4[1] < rsi_h4[2] && (rsi_h4[2] - rsi_h4[1]) < 1.0)
   {
      SetText(objectPreamble + "H4_1", IntegerToString((int)rsi_h4[1]), chartWindow, xOffset_H4, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_1", xOffset_H4 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H4_1", IntegerToString((int)rsi_h4[1]), chartWindow, xOffset_H4, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_1", xOffset_H4 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h4[2] >= rsi_h4[3] && (rsi_h4[2] - rsi_h4[3]) >= 1.0)
   {
      SetText(objectPreamble + "H4_2", IntegerToString((int)rsi_h4[2]), chartWindow, xOffset_H4, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_2", xOffset_H4 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h4[2] >= rsi_h4[3] && (rsi_h4[2] - rsi_h4[3]) < 1.0)
   {
      SetText(objectPreamble + "H4_2", IntegerToString((int)rsi_h4[2]), chartWindow, xOffset_H4, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_2", xOffset_H4 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h4[2] < rsi_h4[3] && (rsi_h4[3] - rsi_h4[2]) < 1.0)
   {
      SetText(objectPreamble + "H4_2", IntegerToString((int)rsi_h4[2]), chartWindow, xOffset_H4, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_2", xOffset_H4 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H4_2", IntegerToString((int)rsi_h4[2]), chartWindow, xOffset_H4, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_2", xOffset_H4 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h4[3] >= rsi_h4[4] && (rsi_h4[3] - rsi_h4[4]) >= 1.0)
   {
      SetText(objectPreamble + "H4_3", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_3", xOffset_H4 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h4[3] >= rsi_h4[4] && (rsi_h4[3] - rsi_h4[4]) < 1.0)
   {
      SetText(objectPreamble + "H4_3", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_3", xOffset_H4 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h4[3] < rsi_h4[4] && (rsi_h4[4] - rsi_h4[3]) < 1.0)
   {
      SetText(objectPreamble + "H4_3", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_3", xOffset_H4 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H4_3", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_3", xOffset_H4 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_h4[4] >= rsi_h4[5] && (rsi_h4[4] - rsi_h4[5]) >= 1.0)
   {
      SetText(objectPreamble + "H4_4", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_4", xOffset_H4 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_h4[4] >= rsi_h4[5] && (rsi_h4[4] - rsi_h4[5]) < 1.0)
   {
      SetText(objectPreamble + "H4_4", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_4", xOffset_H4 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_h4[4] < rsi_h4[5] && (rsi_h4[5] - rsi_h4[4]) < 1.0)
   {
      SetText(objectPreamble + "H4_4", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_4", xOffset_H4 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "H4_4", IntegerToString((int)rsi_h4[3]), chartWindow, xOffset_H4, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PH4_4", xOffset_H4 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
   
   
   
   
   
  /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
            
   if (rsi_d1[0] >= rsi_d1[1] && (rsi_d1[0] - rsi_d1[1]) >= 1.0)
   {
      SetText(objectPreamble + "D1_0", IntegerToString((int)rsi_d1[0]), chartWindow, xOffset_D1, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_0", xOffset_D1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_d1[0] >= rsi_d1[1] && (rsi_d1[0] - rsi_d1[1]) < 1.0)
   {
      SetText(objectPreamble + "D1_0", IntegerToString((int)rsi_d1[0]), chartWindow, xOffset_D1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_0", xOffset_D1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_d1[0] < rsi_d1[1] && (rsi_d1[1] - rsi_d1[0]) < 1.0)
   {
      SetText(objectPreamble + "D1_0", IntegerToString((int)rsi_d1[0]), chartWindow, xOffset_D1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_0", xOffset_D1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "D1_0", IntegerToString((int)rsi_d1[0]), chartWindow, xOffset_D1, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_0", xOffset_D1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_d1[1] >= rsi_d1[2] && (rsi_d1[1] - rsi_d1[2]) >= 1.0)
   {
      SetText(objectPreamble + "D1_1", IntegerToString((int)rsi_d1[1]), chartWindow, xOffset_D1, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_1", xOffset_D1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_d1[1] >= rsi_d1[2] && (rsi_d1[1] - rsi_d1[2]) < 1.0)
   {
      SetText(objectPreamble + "D1_1", IntegerToString((int)rsi_d1[1]), chartWindow, xOffset_D1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_1", xOffset_D1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_d1[1] < rsi_d1[2] && (rsi_d1[2] - rsi_d1[1]) < 1.0)
   {
      SetText(objectPreamble + "D1_1", IntegerToString((int)rsi_d1[1]), chartWindow, xOffset_D1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_1", xOffset_D1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "D1_1", IntegerToString((int)rsi_d1[1]), chartWindow, xOffset_D1, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_1", xOffset_D1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_d1[2] >= rsi_d1[3] && (rsi_d1[2] - rsi_d1[3]) >= 1.0)
   {
      SetText(objectPreamble + "D1_2", IntegerToString((int)rsi_d1[2]), chartWindow, xOffset_D1, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_2", xOffset_D1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_d1[2] >= rsi_d1[3] && (rsi_d1[2] - rsi_d1[3]) < 1.0)
   {
      SetText(objectPreamble + "D1_2", IntegerToString((int)rsi_d1[2]), chartWindow, xOffset_D1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_2", xOffset_D1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_d1[2] < rsi_d1[3] && (rsi_d1[3] - rsi_d1[2]) < 1.0)
   {
      SetText(objectPreamble + "D1_2", IntegerToString((int)rsi_d1[2]), chartWindow, xOffset_D1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_2", xOffset_D1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "D1_2", IntegerToString((int)rsi_d1[2]), chartWindow, xOffset_D1, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_2", xOffset_D1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_d1[3] >= rsi_d1[4] && (rsi_d1[3] - rsi_d1[4]) >= 1.0)
   {
      SetText(objectPreamble + "D1_3", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_3", xOffset_D1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_d1[3] >= rsi_d1[4] && (rsi_d1[3] - rsi_d1[4]) < 1.0)
   {
      SetText(objectPreamble + "D1_3", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_3", xOffset_D1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_d1[3] < rsi_d1[4] && (rsi_d1[4] - rsi_d1[3]) < 1.0)
   {
      SetText(objectPreamble + "D1_3", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_3", xOffset_D1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "D1_3", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_3", xOffset_D1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_d1[4] >= rsi_d1[5] && (rsi_d1[4] - rsi_d1[5]) >= 1.0)
   {
      SetText(objectPreamble + "D1_4", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_4", xOffset_D1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_d1[4] >= rsi_d1[5] && (rsi_d1[4] - rsi_d1[5]) < 1.0)
   {
      SetText(objectPreamble + "D1_4", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_4", xOffset_D1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_d1[4] < rsi_d1[5] && (rsi_d1[5] - rsi_d1[4]) < 1.0)
   {
      SetText(objectPreamble + "D1_4", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_4", xOffset_D1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "D1_4", IntegerToString((int)rsi_d1[3]), chartWindow, xOffset_D1, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PD1_4", xOffset_D1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
   
   
   
   
   
    /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 
          
          
          
          
          
          
          
          
          
          
            
   if (rsi_w1[0] >= rsi_w1[1] && (rsi_w1[0] - rsi_w1[1]) >= 1.0)
   {
      SetText(objectPreamble + "W1_0", IntegerToString((int)rsi_w1[0]), chartWindow, xOffset_W1, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_0", xOffset_W1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_w1[0] >= rsi_w1[1] && (rsi_w1[0] - rsi_w1[1]) < 1.0)
   {
      SetText(objectPreamble + "W1_0", IntegerToString((int)rsi_w1[0]), chartWindow, xOffset_W1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_0", xOffset_W1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_w1[0] < rsi_w1[1] && (rsi_w1[1] - rsi_w1[0]) < 1.0)
   {
      SetText(objectPreamble + "W1_0", IntegerToString((int)rsi_w1[0]), chartWindow, xOffset_W1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_0", xOffset_W1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "W1_0", IntegerToString((int)rsi_w1[0]), chartWindow, xOffset_W1, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_0", xOffset_W1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_w1[1] >= rsi_w1[2] && (rsi_w1[1] - rsi_w1[2]) >= 1.0)
   {
      SetText(objectPreamble + "W1_1", IntegerToString((int)rsi_w1[1]), chartWindow, xOffset_W1, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_1", xOffset_W1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_w1[1] >= rsi_w1[2] && (rsi_w1[1] - rsi_w1[2]) < 1.0)
   {
      SetText(objectPreamble + "W1_1", IntegerToString((int)rsi_w1[1]), chartWindow, xOffset_W1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_1", xOffset_W1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_w1[1] < rsi_w1[2] && (rsi_w1[2] - rsi_w1[1]) < 1.0)
   {
      SetText(objectPreamble + "W1_1", IntegerToString((int)rsi_w1[1]), chartWindow, xOffset_W1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_1", xOffset_W1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "W1_1", IntegerToString((int)rsi_w1[1]), chartWindow, xOffset_W1, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_1", xOffset_W1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_w1[2] >= rsi_w1[3] && (rsi_w1[2] - rsi_w1[3]) >= 1.0)
   {
      SetText(objectPreamble + "W1_2", IntegerToString((int)rsi_w1[2]), chartWindow, xOffset_W1, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_2", xOffset_W1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_w1[2] >= rsi_w1[3] && (rsi_w1[2] - rsi_w1[3]) < 1.0)
   {
      SetText(objectPreamble + "W1_2", IntegerToString((int)rsi_w1[2]), chartWindow, xOffset_W1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_2", xOffset_W1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_w1[2] < rsi_w1[3] && (rsi_w1[3] - rsi_w1[2]) < 1.0)
   {
      SetText(objectPreamble + "W1_2", IntegerToString((int)rsi_w1[2]), chartWindow, xOffset_W1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_2", xOffset_W1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "W1_2", IntegerToString((int)rsi_w1[2]), chartWindow, xOffset_W1, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_2", xOffset_W1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_w1[3] >= rsi_w1[4] && (rsi_w1[3] - rsi_w1[4]) >= 1.0)
   {
      SetText(objectPreamble + "W1_3", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_3", xOffset_W1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_w1[3] >= rsi_w1[4] && (rsi_w1[3] - rsi_w1[4]) < 1.0)
   {
      SetText(objectPreamble + "W1_3", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_3", xOffset_W1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_w1[3] < rsi_w1[4] && (rsi_w1[4] - rsi_w1[3]) < 1.0)
   {
      SetText(objectPreamble + "W1_3", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_3", xOffset_W1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "W1_3", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_3", xOffset_W1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_w1[4] >= rsi_w1[5] && (rsi_w1[4] - rsi_w1[5]) >= 1.0)
   {
      SetText(objectPreamble + "W1_4", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_4", xOffset_W1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_w1[4] >= rsi_w1[5] && (rsi_w1[4] - rsi_w1[5]) < 1.0)
   {
      SetText(objectPreamble + "W1_4", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_4", xOffset_W1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_w1[4] < rsi_w1[5] && (rsi_w1[5] - rsi_w1[4]) < 1.0)
   {
      SetText(objectPreamble + "W1_4", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_4", xOffset_W1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "W1_4", IntegerToString((int)rsi_w1[3]), chartWindow, xOffset_W1, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PW1_4", xOffset_W1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
   
   
   
   
  /*------------------------------------------------*/
  
 /*------------------------------------------------*/
  
 /*------------------------------------------------*/ 
    
    
    
    
    
    
    
    
            
        
   if (rsi_mn1[0] >= rsi_mn1[1] && (rsi_mn1[0] - rsi_mn1[1]) >= 1.0)
   {
      SetText(objectPreamble + "MN1_0", IntegerToString((int)rsi_mn1[0]), chartWindow, xOffset_MN1, yOffset_0, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_0", xOffset_MN1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_mn1[0] >= rsi_mn1[1] && (rsi_mn1[0] - rsi_mn1[1]) < 1.0)
   {
      SetText(objectPreamble + "MN1_0", IntegerToString((int)rsi_mn1[0]), chartWindow, xOffset_MN1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_0", xOffset_MN1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_mn1[0] < rsi_mn1[1] && (rsi_mn1[1] - rsi_mn1[0]) < 1.0)
   {
      SetText(objectPreamble + "MN1_0", IntegerToString((int)rsi_mn1[0]), chartWindow, xOffset_MN1, yOffset_0, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_0", xOffset_MN1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "MN1_0", IntegerToString((int)rsi_mn1[0]), chartWindow, xOffset_MN1, yOffset_0, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_0", xOffset_MN1 - xPnlCorrection, yOffset_0 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_mn1[1] >= rsi_mn1[2] && (rsi_mn1[1] - rsi_mn1[2]) >= 1.0)
   {
      SetText(objectPreamble + "MN1_1", IntegerToString((int)rsi_mn1[1]), chartWindow, xOffset_MN1, yOffset_1, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_1", xOffset_MN1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_mn1[1] >= rsi_mn1[2] && (rsi_mn1[1] - rsi_mn1[2]) < 1.0)
   {
      SetText(objectPreamble + "MN1_1", IntegerToString((int)rsi_mn1[1]), chartWindow, xOffset_MN1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_1", xOffset_MN1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_mn1[1] < rsi_mn1[2] && (rsi_mn1[2] - rsi_mn1[1]) < 1.0)
   {
      SetText(objectPreamble + "MN1_1", IntegerToString((int)rsi_mn1[1]), chartWindow, xOffset_MN1, yOffset_1, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_1", xOffset_MN1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "MN1_1", IntegerToString((int)rsi_mn1[1]), chartWindow, xOffset_MN1, yOffset_1, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_1", xOffset_MN1 - xPnlCorrection, yOffset_1 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_mn1[2] >= rsi_mn1[3] && (rsi_mn1[2] - rsi_mn1[3]) >= 1.0)
   {
      SetText(objectPreamble + "MN1_2", IntegerToString((int)rsi_mn1[2]), chartWindow, xOffset_MN1, yOffset_2, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_2", xOffset_MN1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_mn1[2] >= rsi_mn1[3] && (rsi_mn1[2] - rsi_mn1[3]) < 1.0)
   {
      SetText(objectPreamble + "MN1_2", IntegerToString((int)rsi_mn1[2]), chartWindow, xOffset_MN1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_2", xOffset_MN1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_mn1[2] < rsi_mn1[3] && (rsi_mn1[3] - rsi_mn1[2]) < 1.0)
   {
      SetText(objectPreamble + "MN1_2", IntegerToString((int)rsi_mn1[2]), chartWindow, xOffset_MN1, yOffset_2, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_2", xOffset_MN1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "MN1_2", IntegerToString((int)rsi_mn1[2]), chartWindow, xOffset_MN1, yOffset_2, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_2", xOffset_MN1 - xPnlCorrection, yOffset_2 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_mn1[3] >= rsi_mn1[4] && (rsi_mn1[3] - rsi_mn1[4]) >= 1.0)
   {
      SetText(objectPreamble + "MN1_3", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_3, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_3", xOffset_MN1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_mn1[3] >= rsi_mn1[4] && (rsi_mn1[3] - rsi_mn1[4]) < 1.0)
   {
      SetText(objectPreamble + "MN1_3", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_3", xOffset_MN1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_mn1[3] < rsi_mn1[4] && (rsi_mn1[4] - rsi_mn1[3]) < 1.0)
   {
      SetText(objectPreamble + "MN1_3", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_3, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_3", xOffset_MN1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "MN1_3", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_3, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_3", xOffset_MN1 - xPnlCorrection, yOffset_3 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   if (rsi_mn1[4] >= rsi_mn1[5] && (rsi_mn1[4] - rsi_mn1[5]) >= 1.0)
   {
      SetText(objectPreamble + "MN1_4", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_4, bullColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_4", xOffset_MN1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   else if (rsi_mn1[4] >= rsi_mn1[5] && (rsi_mn1[4] - rsi_mn1[5]) < 1.0)
   {
      SetText(objectPreamble + "MN1_4", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_4", xOffset_MN1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bullColor, 1);
   } 
   else if (rsi_mn1[4] < rsi_mn1[5] && (rsi_mn1[5] - rsi_mn1[4]) < 1.0)
   {
      SetText(objectPreamble + "MN1_4", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_4, textColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_4", xOffset_MN1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, bearColor, 1);
   }
   else
   {
      SetText(objectPreamble + "MN1_4", IntegerToString((int)rsi_mn1[3]), chartWindow, xOffset_MN1, yOffset_4, bearColor, fontSize);
      SetPanel(chartWindow, objectPreamble + "PMN1_4", xOffset_MN1 - xPnlCorrection, yOffset_4 - yPnlCorrection, panelColumnWidth + 2*xPnlCorrection, panelRowHeight + 2*yPnlCorrection, 
                     panelBgColor, panelBgColor, 1);
   }
   
   
   
   
   
}



//+------------------------------------------------------------------+
void SetText(string name,string text, int window, int x,int y,color colour,int fontsize=12)
{
   if (ObjectFind(0,name)<0)
      ObjectCreate(0,name,OBJ_LABEL,window,0,0);

    ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
    ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
    ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
    ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
    ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_RIGHT);
    ObjectSetString(0,name,OBJPROP_TEXT,text);
}

void Create_Button(string but_name, string label, int window, int xsize, int ysize, 
                     int xdist, int ydist, int bgcolor, int fcolor, int bcolor, int _fontSize)
{
    
   if(ObjectFind(0,but_name)<0)
   {
      if(!ObjectCreate(0,but_name,OBJ_BUTTON, window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",GetLastError());
         return;
        }
      ObjectSetString(0,but_name,OBJPROP_TEXT,label);
      ObjectSetInteger(0,but_name,OBJPROP_XSIZE,xsize);
      ObjectSetInteger(0,but_name,OBJPROP_YSIZE,ysize);
      ObjectSetInteger(0,but_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);     
      ObjectSetInteger(0,but_name,OBJPROP_XDISTANCE,xdist);      
      ObjectSetInteger(0,but_name,OBJPROP_YDISTANCE,ydist);         
      ObjectSetInteger(0,but_name,OBJPROP_BGCOLOR,bgcolor);
      ObjectSetInteger(0,but_name,OBJPROP_COLOR,fcolor);
      ObjectSetInteger(0,but_name,OBJPROP_BORDER_COLOR,bcolor);
      ObjectSetInteger(0,but_name,OBJPROP_FONTSIZE,_fontSize);
      ObjectSetInteger(0,but_name,OBJPROP_HIDDEN,true);
      //ObjectSetInteger(0,but_name, OBJPROP_CORNER,4);
      //ObjectSetInteger(0,but_name,OBJPROP_BORDER_COLOR,ChartGetInteger(0,CHART_COLOR_FOREGROUND));
      ObjectSetInteger(0,but_name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      
      ChartRedraw();      
   }
}

void deleteObjects()
{
   string s;
   string name;
   s = objectPreamble; //_symbolPair;
   //s = Symbol();
   for (int i = 25000 - 1; i >= 0; i--)
   {
   /*  name = ObjectName(i);
     if (StringSubstr(name, 0, StringLen(s)) == s)
     {
         ObjectDelete(name);
     }
     */
   }
   ObjectsDeleteAll(0,
   objectPreamble,
    0,
    -1    // object type
   );
}

void SetObjText(long window, string name,string CharToStr,int x,int y,color colour,int fontsize=12)
{
   if(ObjectFind(0,name)<0)
      ObjectCreate(0,name,OBJ_LABEL,window,0,0);

   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);  
   ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,name,OBJPROP_TEXT,CharToStr);
   ObjectSetString(0,name,OBJPROP_FONT,"Wingdings");
} 
  
void SetPanel(int chart_id, string name, int x,int y,int width,int height,color bg_color,color border_clr,int border_width)
{
   if (ObjectFind(0, name) < 0) ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,chart_id,0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(0,name,OBJPROP_COLOR,border_clr);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,border_width);
   //ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg_color);
}


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
      //PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
     }
   return(result);
  }
