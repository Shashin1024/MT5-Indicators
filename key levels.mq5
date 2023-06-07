//+------------------------------------------------------------------+
//|                                                   key levels.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                                        by DaemonX|
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input int past_days = 14;
input int change = 100;

input bool OpenLines = false;
input color           OpenColor=clrRed;     // Open Line color
input int HighLines = false;
input color           HighColor=clrRed;     // High Line color
input bool LowLines = false;
input color           LowColor=clrRed;     // Low Line color
input bool CloseLines = false;
input color           CloseColor=clrRed;     // Close Line color
input ENUM_LINE_STYLE InpStyle=STYLE_SOLID; // Line style
input int             InpWidth=1;          // Line width

input bool ZoneA=true; //A Zones
input color ZoneAColor=clrRed;     // Zone A color

input bool ZoneB=true; //B Zones
input color ZoneBColor=clrRed;     // Zone B color


input bool ZoneC=true; //C Zones
input color ZoneCColor=clrRed;     // Zone C color


input bool ZoneD=false; //D Zones
input color ZoneDColor=clrRed;     // Zone D color


input bool ZoneE=true; //E Zones
input color ZoneEColor=clrRed;     // Zone E color


input bool ZoneF=true; //F Zones
input color ZoneFColor=clrRed;     // Zone F color


input bool ZoneG=true; //G Zones
input color ZoneGColor=clrRed;     // Zone G color


input bool ZoneH=true; //H Zones
input color ZoneHColor=clrRed;     // Zone H color

input bool ZoneI=true; //I Zones
input color ZoneIColor=clrRed;     // Zone I color

input bool ZoneJ=true; //I Zones
input color ZoneJColor=clrRed;     // Zone J color


input bool ZoneK=true; //I Zones
input color ZoneKColor=clrRed;     // Zone J color

input bool ZoneL=true; //I Zones
input color ZoneLColor=clrRed;     // Zone J color

input bool ZoneM=true; //I Zones
input color ZoneMColor=clrRed;     // Zone J color

input bool ZoneN=true; //I Zones
input color ZoneNColor=clrRed;     // Zone J color

input bool ZoneO=true; //I Zones
input color ZoneOColor=clrRed;     // Zone J color

input bool Fillzones = true;

input int zone_size =3;  //Zone witdth in Pips 
input ENUM_LINE_STYLE style=STYLE_DASH; // Style of zone lines
extern int MoveBoxRight = 5;


double openq[1000];
double openq1[1000];
double openq2[1000];
double openq3[1000];


double level1[1000];
double level2[1000];
double level3[1000];
double level4[1000];
double level5[1000];



int OnInit()
  {

    MqlRates rates[];
    ArraySetAsSeries(rates,true);
     ArraySetAsSeries(openq,true);
      ArraySetAsSeries(openq1,true);
       ArraySetAsSeries(openq2,true);
        ArraySetAsSeries(openq3,true);
       
   if(CopyRates(Symbol(),PERIOD_D1,0,past_days*2,rates))
    {
    for(int i=0;i<=past_days;i++)
      {
       
      openq[i] = rates[i].high;
      openq1[i] = rates[i].low;
      openq2[i] = rates[i].open;
      openq3[i] = rates[i].close;
      
      
      level1[i] = rates[i].open+(((rates[i].close)-(rates[i].open))/2);
      level2[i] = rates[i].open+(((rates[i].close)-(rates[i].open))*(79/100));
      level3[i] = rates[i].open+(((rates[i].close)-(rates[i].open))*(23/100));
      level4[i] = rates[i].close+(((rates[i].close)-(rates[i].open))*(79/100));
      level5[i] = rates[i].close+(((rates[i].close)-(rates[i].open))*(23/100));
       
       if(change_to_pips(MathAbs(rates[i].close)-(rates[i].open))>=change ){
        
     //  ObjectCreate(0,"DailyLine"+i,OBJ_HLINE,0,0,rates[i].open+(((rates[i].close)-(rates[i].open))/2));
       
       
       if((rates[i].close)-(rates[i].open)>0)
         {
      //   ObjectCreate(0,"DailyLineA"+i,OBJ_HLINE,0,0,rates[i].open+(((rates[i].close)-(rates[i].open))*(79/100)));
       
     //    ObjectCreate(0,"DailyLineB"+i,OBJ_HLINE,0,0,rates[i].open+(((rates[i].close)-(rates[i].open))*(23/100)));
         }
       
       
        if((rates[i].open)-(rates[i].close)<0)
         {
       //  ObjectCreate(0,"DailyLineC"+i,OBJ_HLINE,0,0,rates[i].close+(((rates[i].close)-(rates[i].open))*(79/100)));
       
       //  ObjectCreate(0,"DailyLineD"+i,OBJ_HLINE,0,0,rates[i].close+(((rates[i].close)-(rates[i].open))*(23/100)));
         }
      
     
       
       } 
       
       
 
       
     }
      }
   
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
   
//--- return value of prev_calculated for next call


         
         
   for(int j=0; j<=past_days; j++)
     {
      double p1 = level1[j];
      double p3 = level2[j];

      double p5 = level3[j];
      double p7 = level4[j];
      
      double p9 = level5[j];

      for(int k=0; k<=past_days; k++)
        {
         double p2 = level1[k];

         double p4 = level2[k];

         double p6 = level3[k];

         double p8 = level4[k];
         double p10 = level5[j];
         

         
       if(ZoneA)
           {
            if(change_to_pips(MathAbs(p1-p2))<=zone_size && (p1!= p2) && (p1 !=0 && p2!=0))
              {
          
                  ObjectCreate(0, "ZoneA"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p1, iTime(NULL, 0, 500), p2);
               ObjectSetInteger(0,"ZoneA"+k,OBJPROP_COLOR,ZoneAColor);

               ObjectSetInteger(0,"ZoneA",OBJPROP_STYLE,style);
                ObjectSetInteger(0,"ZoneA"+k,OBJPROP_FILL,true); 
              }
           }

         if(ZoneB)
           {
            if(change_to_pips(MathAbs(p3-p2))<=zone_size && (p3!= p2) && (p3 !=0 && p2!=0))
              {
               ObjectCreate(0, "ZoneB"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p2, iTime(NULL, 0, 500), p3);
               ObjectSetInteger(0,"ZoneB"+k,OBJPROP_COLOR,ZoneBColor);

               ObjectSetInteger(0,"ZoneB",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneB"+k,OBJPROP_FILL,true);
              }
           }

         if(ZoneC)
           {
            if(change_to_pips(MathAbs(p1-p4))<=zone_size && (p1!= p4) && (p1 !=0 && p4!=0))
              {
               ObjectCreate(0, "ZoneC"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p1, iTime(NULL, 0, 500), p4);
               ObjectSetInteger(0,"ZoneC"+k,OBJPROP_COLOR,ZoneCColor);

               ObjectSetInteger(0,"ZoneC",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneC"+k,OBJPROP_FILL,true);
              }
           }


         if(ZoneD)
           {
            if(change_to_pips(MathAbs(p2-p5))<=zone_size && (p2!= p5) && (p2 !=0 && p5!=0))
              {
               ObjectCreate(0, "ZoneD"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p2, iTime(NULL, 0, 500), p5);
               ObjectSetInteger(0,"ZoneD"+k,OBJPROP_COLOR,ZoneDColor);

               ObjectSetInteger(0,"ZoneD",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneD"+k,OBJPROP_FILL,true);
              }
           }


         if(ZoneE)
           {
            if(change_to_pips(MathAbs(p5-p4))<=zone_size && (p5!= p4) && (p5 !=0 && p4!=0))
              {
               ObjectCreate(0, "ZoneE"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p5, iTime(NULL, 0, 500), p4);
               ObjectSetInteger(0,"ZoneE"+k,OBJPROP_COLOR,ZoneEColor);

               ObjectSetInteger(0,"ZoneE",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneE"+k,OBJPROP_FILL,true);
              }
           }

         if(ZoneF)
           {
            if(change_to_pips(MathAbs(p5-p6))<=zone_size && (p5!= p6) && (p5 !=0 && p6!=0))
              {
               ObjectCreate(0, "ZoneF"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p5, iTime(NULL, 0, 500), p6);
               ObjectSetInteger(0,"ZoneF"+k,OBJPROP_COLOR,ZoneFColor);

               ObjectSetInteger(0,"ZoneF",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneF"+k,OBJPROP_FILL,true);
              }
           }




         if(ZoneG)
           {
            if(change_to_pips(MathAbs(p7-p2))<=zone_size && (p7!= p2) && (p7 !=0 && p2!=0))
              {
               ObjectCreate(0, "ZoneG"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p2, iTime(NULL, 0, 500), p7);
               ObjectSetInteger(0,"ZoneG"+k,OBJPROP_COLOR,ZoneGColor);

               ObjectSetInteger(0,"ZoneG",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneG"+k,OBJPROP_FILL,true);
              }
           }

         if(ZoneH)
           {
            if(change_to_pips(MathAbs(p7-p4))<=zone_size && (p7!= p4) && (p7 !=0 && p4!=0))
              {
               ObjectCreate(0, "ZoneH"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p4, iTime(NULL, 0, 500), p7);
               ObjectSetInteger(0,"ZoneH"+k,OBJPROP_COLOR,ZoneHColor);

               ObjectSetInteger(0,"ZoneH",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneH"+k,OBJPROP_FILL,true);
              }
           }


         if(ZoneI)
           {
            if(change_to_pips(MathAbs(p7-p6))<=zone_size && (p7!= p6) && (p7 !=0 && p6!=0))
              {
               ObjectCreate(0, "ZoneI"+k, OBJ_RECTANGLE, 0, iTime(NULL, 0, 0), p6, iTime(NULL, 0, 500), p7);
               ObjectSetInteger(0,"ZoneI"+k,OBJPROP_COLOR,ZoneIColor);

               ObjectSetInteger(0,"ZoneI",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneI"+k,OBJPROP_FILL,true);
              }
           }


         if(ZoneJ)
           {
            if(change_to_pips(MathAbs(p7-p6))<=zone_size && (p7!= p8) && (p7 !=0 && p8!=0))
              {
               ObjectCreate("ZoneJ"+k, OBJ_RECTANGLE, 0, iTime(_Symbol,_Period,0), p7, iTime(_Symbol,_Period,5000), p8);
               ObjectSetInteger(0,"ZoneJ"+k,OBJPROP_COLOR,ZoneJColor);

               ObjectSetInteger(0,"ZoneJ",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneJ"+k,OBJPROP_FILL,Fillzones);
              }
           }
           
           
           
            if(ZoneK)
           {
            if(change_to_pips(MathAbs(p9-p2))<=zone_size && (p9= p2) && (p9 !=0 && p2!=0))
              {
               ObjectCreate("ZoneK"+k, OBJ_RECTANGLE, 0, iTime(_Symbol,_Period,0), p9, iTime(_Symbol,_Period,5000), p2);
               ObjectSetInteger(0,"ZoneK"+k,OBJPROP_COLOR,ZoneJColor);

               ObjectSetInteger(0,"ZoneK",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneK"+k,OBJPROP_FILL,Fillzones);
              }
           }
           
           
               if(ZoneL)
           {
            if(change_to_pips(MathAbs(p9-p4))<=zone_size && (p9= p4) && (p9 !=0 && p4!=0))
              {
               ObjectCreate("ZoneL"+k, OBJ_RECTANGLE, 0, iTime(_Symbol,_Period,0), p9, iTime(_Symbol,_Period,5000), p4);
               ObjectSetInteger(0,"ZoneL"+k,OBJPROP_COLOR,ZoneJColor);

               ObjectSetInteger(0,"ZoneL",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneL"+k,OBJPROP_FILL,Fillzones);
              }
           }
           
           
               if(ZoneM)
           {
            if(change_to_pips(MathAbs(p9-p6))<=zone_size && (p9= p6) && (p9 !=0 && p6!=0))
              {
               ObjectCreate("ZoneM"+k, OBJ_RECTANGLE, 0, iTime(_Symbol,_Period,0), p9, iTime(_Symbol,_Period,5000), p6);
               ObjectSetInteger(0,"ZoneM"+k,OBJPROP_COLOR,ZoneJColor);

               ObjectSetInteger(0,"ZoneM",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneM"+k,OBJPROP_FILL,Fillzones);
              }
           }
           
           
                  if(ZoneN)
           {
            if(change_to_pips(MathAbs(p9-p8))<=zone_size && (p9= p8) && (p9 !=0 && p8!=0))
              {
               ObjectCreate("ZoneN"+k, OBJ_RECTANGLE, 0, iTime(_Symbol,_Period,0), p9, iTime(_Symbol,_Period,5000), p8);
               ObjectSetInteger(0,"ZZoneNoneM"+k,OBJPROP_COLOR,ZoneJColor);

               ObjectSetInteger(0,"ZoneN",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneN"+k,OBJPROP_FILL,Fillzones);
              }
           }
      
      
           
                  if(ZoneO)
           {
            if(change_to_pips(MathAbs(p9-p10))<=zone_size && (p9= p10) && (p9 !=0 && p10!=0))
              {
               ObjectCreate("ZoneO"+k, OBJ_RECTANGLE, 0, iTime(_Symbol,_Period,0), p9, iTime(_Symbol,_Period,5000), p10);
               ObjectSetInteger(0,"ZoneO"+k,OBJPROP_COLOR,ZoneJColor);

               ObjectSetInteger(0,"ZoneO",OBJPROP_STYLE,style);
               ObjectSetInteger(0,"ZoneO"+k,OBJPROP_FILL,Fillzones);
              }
           }
      
      








        }

     }

   return(rates_total);
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
   
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  HLineDelete(0,"DailyLine");
  ObjectsDeleteAll(
   0,           // chart identifier
   0,      // window index
   OBJ_HLINE             // object type
   );
   
    for(int iObj=ObjectsTotal(0,0,OBJ_RECTANGLE)-1; iObj >= 0; iObj--)
     {
      string on = ObjectName(0,iObj,0,OBJ_RECTANGLE);
      if(StringFind(on, "high") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "low") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "Zone") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneA") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneB") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneC") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneD") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneE") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneF") == 0)
         ObjectDelete(0,on);
      if(StringFind(on, "ZoneG") == 0)
         ObjectDelete(0,on);

      if(StringFind(on, "ZoneH") == 0)
         ObjectDelete(0,on);

      if(StringFind(on, "ZoneI") == 0)
         ObjectDelete(0,on);

      if(StringFind(on, "ZoneJ") == 0)
         ObjectDelete(0,on);




     }
   ObjectDelete(0,
                "high"  // object name
               );
   ObjectDelete(0,
                "low"
               );
   ObjectDelete(0,
      "ZoneA"  // object name
   );
   ObjectDelete(0,
                "ZoneB"
               );
   ObjectDelete(0,
                "ZoneC"  // object name
               );
   ObjectDelete(0,
                "ZoneD"
               );

   ObjectDelete(0,
                "ZoneE"
               );

   ObjectDelete(0,
                "ZoneF"
               );

   ObjectDelete(0,
                "ZoneG"
               );

   ObjectDelete(0,
                "ZoneH"
               );

   ObjectDelete(0,
                "ZoneI"
               );

   ObjectDelete(0,
                "ZoneJ"
               );


  }
  
  
  
  bool HLineDelete(const long   chart_ID=0,   // chart's ID
                 const string name="DailyLine") // line name
  {
//--- reset the error value
   ResetLastError();
//--- delete a horizontal line
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
  
  
  
double points_to_change(int n) { return n * _Point; }

int change_to_points(double c) { return int(c / _Point + 0.5); }

double pips_to_change(double n) { return points_to_change(pips_to_points(n)); }

double change_to_pips(double c) { return points_to_pips(change_to_points(c)); }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int pips_to_points(double n)
  {
   if((Digits() & 1) == 1)
      n *= 10.0;
   return int(n);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double points_to_pips(int n)
  {
   double p = NormalizeDouble(n, Digits());
   if((Digits() & 1) == 1)
     {
      p /= 10.0;
     }
   return p;
  }
  
  
  
// Extends all rectangles to the right
void ExtendRec()
   {
      string Obj_Name;
      long Obj_Type;
      int Tel,NrRect;

      NrRect=ObjectsTotal(0,0,-1);
      for (Tel=0;Tel<NrRect;Tel++)
         {
            Obj_Name=ObjectName(0,Tel,0,-1);
            Obj_Type=ObjectGetInteger(0,Obj_Name,OBJPROP_TYPE);
            if (Obj_Type==OBJ_RECTANGLE)
                ObjectSetInteger(0,Obj_Name,OBJPROP_TIME,1,TimeCurrent());
         }
      return;
   } 

// Check for newbar, returns true if found 
bool isNewBar(int BarNumber)
   {
      static int LastBarNumber;
      if (BarNumber>LastBarNumber)
         return true;
      else
         return false;
   }