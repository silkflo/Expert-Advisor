//+------------------------------------------------------------------+
//|                                                       MALCOM.mq4 |
//|                                         Copyright 2020, Stufflow |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Stufflow"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


#include <19_AssignMagicNumber.mqh>
#include <10_isNewBar.mqh>
#include <SL_HighestPoint.mqh>
#include <TP_HighestPoint.mqh>
#include <OptimalLotSize.mqh>
#include <GetError.mqh>
#include <MarketClose.mqh>
#include <03_ReadCommandFromCSV.mqh>
#include <02_OrderProfitToCSV.mqh>
#include <096_ReadMarketTypeFromCsv.mqh>
#include <12_ReadDataFromDSS.mqh>
#include <17_CheckIfMarketTypePolicyIsOn.mqh>
#include <GetTradeFlagCondition.mqh>
#include <01_GetHistoryOrder.mqh>
#include <16_LogMarketType.mqh>
#include <TerminalNumber.mqh>



//=====Extern variable======
extern string  Header1="---------------------------------------------------------------------TRADING RULES----------------------------------------------------------------------";
extern int candleTrigger = 4 ;               //candleTrigger --> Candles (MAX 9) on the correct side of the MA20
extern int tradeIntervalCandle = 2;          //tradeIntervalCandle --> candle qty min to allow new trade 
extern bool absolutHighestPoint = true;      //absolutHighestPoint --> if no highest point will search further
extern int higherPointCandleQty = 64;        //higherPointCandleQty --> Search for highest point to define SL/TP 
extern int candleAmountMoveTPToZero = 64;    //candleAmountMoveTPToZero -->modify TP 0 after this amount of candles
extern int MAPeriod = 30;                //MAPeriod --> use higher period to validate the trend on MA20&200
extern bool use_market_type = true;       //use_market_type --> take market type in consideration to allow or not the trade
extern bool R_Management = false;
extern bool opt_selflearning = false;              //opt_selflearning --> flagBuy & flagSell = true
extern int fridayCloseTime = 22;
extern int mondayOpenTime = 01;


extern string  Header2="---------------------------------------------------------------------MONEY MANAGEMENT----------------------------------------------------------------------";
extern double maxRiskPercent = 0.02 ;        //maxRiskPercent --> Adjust lot size according the risk percent
extern int stopLossMargin = 20;              //stopLossMargin --> point added to the SL 
extern int stopLossNoHighestPoint = 400;     //stopLossNoHighestPoint --> SL if no highest point
extern int takeProfitMargin = -20;           //takeProfitMargin --> Add points to the take profit
extern int takeProfitNoHighestPoint = 200;   //takeProfitNoHighestPoint --> TP if no highest point
extern int minimumTakeProfit = 70;            //minimumTakeProfit --> minimmum TP to allow trade 

//=====Variables======
static int countCandle = 0;


//General variable
int error;
string errorDesc;
int ticket;
int ticketNo[];
bool resSelect;
bool resHistorySelect;
bool resClose;
bool resModify;
bool pairTradeAllow = true;
bool marketClose;
datetime timeClose;
int orderClosedTimeGone;

//Indicators variable
double MA[4,10];
double HA[4,10];
double ST[2,10];
int MA20_bullish;    // 0 = undefined , 1 = bullish , 2 = bearish
int MA200_bullish;    // 0 = undefined , 1 = bullish , 2 = bearish
int MA20M30_bullish;    // 0 = undefined , 1 = bullish , 2 = bearish
int MA200M30_bullish;    // 0 = undefined , 1 = bullish , 2 = bearish
int MA20_trigger;    // 0 = trigger not valid -  1 = x candles over MA - 2 = under MA20
double ADX;

//Money Management variable
double optimalLot;
double stopLoss;
double takeProfit;
double maxLossPips;
bool minTPTradeAllow;

//-----------R MANAGEMENT--------------------
datetime ReferenceTime; 
bool tradeAllowed = true;
int MyMarketType;
int MagicNumber;
string strategy = "02";
int terminal;
int terminalType; //0 mean slave, 1 mean master
bool isMarketTypePolicyON = true;
double AIPriceChange, AItrigger, AItimehold, AImaxperf, AIminperf, MyMarketTypeConf;
int sytemControl;
bool flagBuy = true;
bool flagSell = true;



int OnInit()
{
   ReferenceTime = TimeCurrent();
   terminal = T_Num();
   Print("Terminal number : ",terminal);
   //Magic Number Creation
   MagicNumber = AssignMagicNumber(Symbol(), strategy, terminal);
   Print("Magic Number : ", MagicNumber);
   
   
   if(R_Management == true)
   {
       tradeAllowed = ReadCommandFromCSV(MagicNumber);
   } 
   else
   {
       tradeAllowed = true;
   }
   Print("tradeAllowed = ",tradeAllowed);
      
   sytemControl=FileOpen("SystemControl"+string(MagicNumber)+".csv",FILE_READ);
   if(tradeAllowed == false)
   {
          Print("Trade is not allowed");
   }
   else if (sytemControl==-1)   // or file does not exist, create a new file
   {
               Print("System Control Creation");
                string fileName = "SystemControl"+string(MagicNumber)+".csv";//create the name of the file same for all symbols...
               // open file handle
               int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE); FileSeek(handle,0,SEEK_END);
               string data = string(MagicNumber)+","+string(terminalType);
               FileWrite(handle,data);  FileClose(handle);
               //end of writing to file
               Print("Trade is allowed");
   }
   
   
      //0 mean slave, 1 mean master
      if(terminal == 2)
      {
            terminalType = 1 ;
      }
      else
      {
            terminalType = 0 ;
      }
      
         
       
   return(INIT_SUCCEEDED);
}
  
 
void OnDeinit(const int reason)
  {
  }


void OnTick()
  {
         
       if(IsNewCandle()== true)
       { 
              Print("the terminal number is : ", terminal);
              OrderProfitToCSV(terminal);                      //write previous orders profit results for auto analysis in R
                
               //INDICATORS
               MA[0,0] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,0) ,5);
               MA[0,1] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,1) ,5);
               MA[0,2] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,2) ,5);
               MA[0,3] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,3) ,5);
               MA[0,4] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,4) ,5);
               MA[0,5] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,5) ,5);
               MA[0,6] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,6) ,5);
               MA[0,7] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,7) ,5);
               MA[0,8] = NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,8) ,5);
               MA[1,0] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,0),5);
               MA[1,1] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,1),5);
               MA[1,2] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,2),5);
               MA[1,3] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,3),5);
               MA[1,4] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,4),5);
               MA[1,5] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,5),5);
               MA[1,6] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,6),5);
               MA[1,7] = NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,7),5);
               MA[2,0] = NormalizeDouble(iMA(Symbol(),MAPeriod,20,0,MODE_EMA,PRICE_CLOSE,0) ,5);
               MA[2,1] = NormalizeDouble(iMA(Symbol(),MAPeriod,20,0,MODE_EMA,PRICE_CLOSE,1) ,5);
               MA[2,2] = NormalizeDouble(iMA(Symbol(),MAPeriod,20,0,MODE_EMA,PRICE_CLOSE,2) ,5);
               MA[2,3] = NormalizeDouble(iMA(Symbol(),MAPeriod,20,0,MODE_EMA,PRICE_CLOSE,3) ,5);
               MA[2,4] = NormalizeDouble(iMA(Symbol(),MAPeriod,20,0,MODE_EMA,PRICE_CLOSE,4) ,5);
               MA[3,0] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,0) ,5);
               MA[3,1] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,1) ,5);
               MA[3,2] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,2) ,5);
               MA[3,3] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,3) ,5);
               MA[3,4] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,4) ,5);
               MA[3,5] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,5) ,5);
               MA[3,6] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,6) ,5);
               MA[3,7] = NormalizeDouble(iMA(Symbol(),MAPeriod,200,0,MODE_EMA,PRICE_CLOSE,7) ,5);
               ADX=NormalizeDouble(iADX(Symbol(),Period(),14,0,MODE_MAIN,1),4);
     
    tradeAllowed = ReadCommandFromCSV(MagicNumber);              //read command from R checking RL and/or economic event
    Print("Trade allowed = " , tradeAllowed);
                      
  if(R_Management == true){
         
         Print("========R MANAGEMENT=========");
         MyMarketType = ReadMarketFromCSV(Symbol(), Period());     //read analytical output from the Decision Support System
         Print("My market type is : " , MyMarketType);
         MyMarketTypeConf = ReadDataFromDSS(Symbol(), Period(), "read_mt_conf");
         Print("My market type confidence is : ", MyMarketTypeConf);
         //get the Reinforcement Learning policy for specific Market Type
         if(terminalType == 0 && use_market_type == true)
           {
            isMarketTypePolicyON = CheckIfMarketTypePolicyIsOn(MagicNumber, MyMarketType);
           } 
         else
          {
            isMarketTypePolicyON = true;
          }
         
         
         //predicted price change on H1 Timeframe
         AIPriceChange = ReadDataFromDSS(Symbol(),Period(), "read_change");
         Print("AIPriceChange = ", AIPriceChange);
         
         //derived trigger level
         AItrigger = ReadDataFromDSS(Symbol(),Period(), "read_trigger");
         Print("AItrigger =",AItrigger);
         
         //if(AItrigger > 10) entryTriggerM60 = (int)AItrigger;
         //derived time to hold the order
         AItimehold = ReadDataFromDSS(Symbol(),Period(), "read_timehold");
         Print("AItimehold = ", AItimehold);
         
         //derived model performance
         AImaxperf = ReadDataFromDSS(Symbol(),Period(), "read_maxperf");  
         Print("AImaxperf = ", AImaxperf);
         
         //derived minimum value of model performance 'min_quantile'
         AIminperf = ReadDataFromDSS(Symbol(),Period(), "read_quantile"); 
         Print("AIminperf = ",AIminperf);
         
         //do not trade when something is wrong...
         if(AIPriceChange == -1 || AItrigger == -1 || AItimehold == -1 || AImaxperf == -1)
           {
             flagBuy = False;
             flagSell= False;
           }
      
        if(opt_selflearning == false)
        { 
         flagBuy   = GetTradeFlagCondition(AIPriceChange, //predicted change from DSS
                                           AItrigger, //absolute value to enter trade
                                           AImaxperf,
                                           AIminperf,
                                           MyMarketType,
                                           MyMarketTypeConf,
                                           "buy"); //which direction to check "buy" "sell"
             
         flagSell = GetTradeFlagCondition(AIPriceChange, //predicted change from DSS
                                          AItrigger, //absolute value to enter trade
                                          AImaxperf,
                                          AIminperf,
                                          MyMarketType,
                                          MyMarketTypeConf,
                                         "sell"); //which direction to check "buy" "sell"
         } else
         {
            flagBuy = true;
            flagSell = true;
         }   
                        
         
         
         //TradeAllowed is checking Macroeconomic events (derived from Decision Support System)          
         
         Print("FLAG BUY is ", flagBuy,", FLAG SELL IS : ",flagSell);
    
  }
        
         //set countcandle to 0 when an order reach TP or SL      
      
         
         for(int n = 0;  n < OrdersHistoryTotal(); n++) // give the id of all open tickets
         {
            resHistorySelect = OrderSelect(n,SELECT_BY_POS,MODE_HISTORY);
            if(resHistorySelect == false)
            {
                 error = GetLastError();
                 errorDesc = GetError(error);
                 Print("Error selecting history order : ", errorDesc);
            }
            else
            {
                 timeClose = OrderCloseTime();
                 orderClosedTimeGone = ((int)iTime(OrderSymbol(),Period(),0) - (int)timeClose)/60;
                //Print(iTime(OrderSymbol(),Period(),0)," - ", timeClose);
                 //Print("time elapsed from the last order = ", orderClosedTimeGone," min  on " ,OrderSymbol());
                
                 if(OrderSymbol()==Symbol() && orderClosedTimeGone <= Period())
                 {
                     countCandle =0;
                     
                     Print("time elapsed from the last order = ", orderClosedTimeGone," min  on " ,OrderSymbol(), "candle set to 0");
                 }
            }
         }
        
          marketClose=MarketClose(fridayCloseTime,mondayOpenTime);
          Print("Market close : ",marketClose);
          //Print("super Trend =",ST[0,1]," / " , ST[1,1]);
               
            if(marketClose == false)
            {    
               
               if(OrdersTotal()>0)
               {
                     for(int m = 0;  m < OrdersTotal(); m++) // give the id of all open tickets
                     {
                        resSelect = OrderSelect(m,SELECT_BY_POS,MODE_TRADES);
                        if(resSelect == false)
                        {
                             error = GetLastError();
                             errorDesc = GetError(error);
                             Print("Error selecting order number on for loop: ", errorDesc);
                        }
                        else
                        {
                             if(Symbol() == OrderSymbol())
                             {
                                pairTradeAllow = false;
                                break;
                             }
                             else
                             {
                                 pairTradeAllow = true;
                             }                              
                        }
                      }
               }
               else
               {
                  pairTradeAllow = true;
               }
               
               Print( "Pair : ",Symbol(), "Trade allow = ", pairTradeAllow);
               
               MA20_bullish = MA20Trend();   // 0 = undefined , 1 = bullish , 2 = bearish
               MA200_bullish = MA200Trend(); // 0 = undefined , 1 = bullish , 2 = bearish
               MA20_trigger = MA20Trigger(); // 0 = trigger not valid -  1 = x candles over MA - 2 = under MA20
               MA20M30_bullish = MA20M30Trend();   // 0 = undefined , 1 = bullish , 2 = bearish
               MA200M30_bullish = MA200M30Trend(); // 0 = undefined , 1 = bullish , 2 = bearish
              
               
               Print("MA20_bullish = ",MA20_bullish," - MA20M30_bullish = ", MA20M30_bullish," - MA200_bullish = ",MA200_bullish," - MA200M30_bullish = ", MA200M30_bullish);
               Print("MA20_trigger = ",MA20_trigger," - PairTradeAllow = ", pairTradeAllow, " - " , tradeIntervalCandle , " < " , countCandle," - ADX = ", ADX);
               Print("Flag Buy = ", flagBuy," - Flag Sell = ",flagSell, " - isMarketTypePolicyON : ",isMarketTypePolicyON);    
               //BUY
               if(MA20_bullish == 1 &&
                  MA20M30_bullish == 1 &&
                  MA200_bullish == 1 &&
                  MA200M30_bullish == 1 &&
                  MA20_trigger == 1 && 
                  (Open[1]<Close[1] && Open[2]<Close[2]) &&
                  pairTradeAllow == true &&
                  //ADX > 25 &&
                  MA[0,1]>MA[1,1] &&
                  tradeIntervalCandle < countCandle &&
                  tradeAllowed == true &&
                  flagBuy == true &&
                  isMarketTypePolicyON == true)
                 {
                      
                      stopLoss = BuyStopLoss(stopLossMargin,stopLossNoHighestPoint,higherPointCandleQty,absolutHighestPoint);
                      takeProfit = BuyTakeProfit(takeProfitMargin,takeProfitNoHighestPoint,higherPointCandleQty,absolutHighestPoint);
                      maxLossPips = (Bid-stopLoss)/Point;
                      optimalLot = OptimalLotSize(maxRiskPercent,maxLossPips);
                      
                      
                      if(takeProfit-Bid < minimumTakeProfit*Point)
                      {
                        minTPTradeAllow = false;
                        Print("minTPTradeAllow passed to ", minTPTradeAllow);
                      }
                      else
                      {
                        minTPTradeAllow = true;
                      }
                      Print("minTPTradeAllow = ", minTPTradeAllow," takeProfit-Bid = ", takeProfit-Bid, "minimumTakeProfit*Point = ", minimumTakeProfit*Point);
                      
                      if(minTPTradeAllow == true)
                      {
                            ticket = OrderSend(Symbol(),OP_BUY,optimalLot,Ask,10,stopLoss,takeProfit,IntegerToString(MagicNumber),MagicNumber);
                              if(ticket <=0)
                              {
                                   error = GetLastError();
                                   errorDesc = GetError(error);
                                   Print("Error buying order : ", errorDesc);
                              }
                              else
                              {
                                   Print ("ticket #", ticket," buy Order confirmed at ",Bid,"  - Stop Loss = ", stopLoss, " on ", Symbol());
                                   Print("OrderTakeProfit1 = " , OrderTakeProfit());
                                   countCandle = 0;
                                   LogMarketType(MagicNumber, ticket, MyMarketType);
                              }
                     }
               }    
               
               
                 
                
               //==========================================================================================\\  
               //====================================SELL==================================================\\
               //==========================================================================================\\
                     
               if(MA20_bullish == 2 &&
                  MA20_bullish == 2 && 
                  MA20M30_bullish == 2 &&
                  MA200_bullish == 2 &&
                  MA200M30_bullish == 2 &&
                  pairTradeAllow == true &&
                  (Open[1]>Close[1] && Open[2]>Close[2]) &&
                  //ADX>25 &&
                  MA[0,1]<MA[1,1] &&
                  tradeIntervalCandle < countCandle &&
                  tradeAllowed == true &&
                  flagSell == true && 
                  isMarketTypePolicyON == true)
               {
                       
                       
                       Print("check ORDERTOTAL return value on multiple pair open = ",OrdersTotal());
                       stopLoss = SellStopLoss(stopLossMargin,stopLossNoHighestPoint,higherPointCandleQty, absolutHighestPoint);
                       takeProfit = SellTakeProfit(takeProfitMargin,takeProfitNoHighestPoint,higherPointCandleQty, absolutHighestPoint); 
                       maxLossPips = (Bid-stopLoss)/Point;
                       optimalLot = OptimalLotSize(maxRiskPercent,maxLossPips);
                       
                       if(Ask - takeProfit < minimumTakeProfit*Point)
                      {
                        minTPTradeAllow = false;
                        Print("minTPTradeAllow passed to ", minTPTradeAllow);
                      }
                      else
                      {
                        minTPTradeAllow = true;
                      }
                       
                       
                       Print("minTPTradeAllow = ", minTPTradeAllow," takeProfit-Bid = ", takeProfit-Bid, "minimumTakeProfit*Point = ", minimumTakeProfit*Point);
                      
                       if (minTPTradeAllow == true)
                       {
                              ticket = OrderSend(Symbol(),OP_SELL,optimalLot,Bid,10,stopLoss,takeProfit,IntegerToString(MagicNumber),MagicNumber);
                              if(ticket <=0)
                              {  
                                   error = GetLastError();
                                   errorDesc = GetError(error);
                                   Print("Error selling order : ", errorDesc);
                              }
                              else
                              {
                                   Print ("ticket #", ticket," selling Order confirmed at ",Ask,"  - Stop Loss = ", stopLoss," on " , Symbol());
                                   countCandle = 0;
                                   LogMarketType(MagicNumber, ticket, MyMarketType);
                              }
                        }
               }
            
            countCandle++;
            OrderManagement();
            StopLossManagement();
            Print("Symbol " , Symbol(), " candle #",countCandle);
            ShowDashboard("Magic Number ", MagicNumber,
                                            "Market Type ", MyMarketType,
                                            "AIPriceChange ", int(AIPriceChange),
                                            "AItrigger ", AItrigger,
                                            "AItimehold ", int(AItimehold),
                                            "AImaxperf ", AImaxperf,
                                            "AIminperf ", int(AIminperf),
                                            "MyMarketTypeConf ", MyMarketTypeConf); 
         }
        }
        
        

        
 }





            // close order hiting the MA200 -
            // ratio risk
            //distance of the trade trigger and MA20 to be not so far






/*
================================================================
   FUNCTION
================================================================
*/  
   
   
int MA20Trend(){

   int MA20bullish = 0; // 0 = undefined , 1 = bullish , 2 = bearish

   if(MA[0,1]>=MA[0,2] &&
      MA[0,2]>=MA[0,3] &&
      MA[0,3]>=MA[0,4])
   {
      MA20bullish = 1;
   }
   else if (MA[0,1]<=MA[0,2] &&
            MA[0,2]<=MA[0,3] &&
            MA[0,3]<=MA[0,4])
   {
      MA20bullish = 2;
   }
   else
   {
      MA20bullish = 0;
   }

   return (MA20bullish);
}

int MA200Trend(){
   int MA200bullish = 0; // 0 = undefined , 1 = bullish , 2 = bearish
   
   if(MA[1,1]>MA[1,2] &&
      MA[1,2]>MA[1,3] &&
      MA[1,3]>MA[1,4])
     // MA[1,4]>MA[1,5]&&
     // MA[1,5]>MA[1,6]&&
     // MA[1,6]>MA[1,7])
   {
      MA200bullish = 1;
    //  Print(MA[1,1],">",MA[1,2],">",MA[1,3],">",MA[1,4],">",MA[1,5],">",MA[1,6],">",MA[1,7]);
   }
   else if (MA[1,1]<MA[1,2] &&
            MA[1,2]<MA[1,3] &&
            MA[1,3]<MA[1,4] )
         //   MA[1,4]<MA[1,5] &&
         //   MA[1,5]<MA[1,6] &&
         //   MA[1,6]<MA[1,7])
   {
      MA200bullish = 2;
   }
   else
   {
      MA200bullish = 0;
   }
   
     return (MA200bullish);

}

int MA20M30Trend(){

   int MA20M30bullish = 0; // 0 = undefined , 1 = bullish , 2 = bearish
   Print("MA20_30 : ",MA[2,1],">",MA[2,2],">",MA[2,3]);
   
   if(MA[2,1]>=MA[2,2] &&
      MA[2,2]>=MA[2,3] &&
      MA[2,3]>=MA[2,4])
   {
      MA20M30bullish = 1;
   }
 
   else if (MA[2,1]<=MA[2,2] &&
            MA[2,2]<=MA[2,3] &&
            MA[2,3]<=MA[2,4])
   {
      MA20M30bullish = 2;
   }
   else
   {
      MA20M30bullish = 0;
   }

   return (MA20M30bullish);
}

int MA200M30Trend(){
   int MA200M30bullish = 0; // 0 = undefined , 1 = bullish , 2 = bearish
   Print("MA200_30 : ",MA[3,1],">",MA[3,2],">",MA[3,3],">",MA[3,4],">",MA[3,5],">",MA[3,6],">",MA[3,7]);
   
   if(MA[3,1]>=MA[3,2] &&
      MA[3,2]>=MA[3,3] &&
      MA[3,3]>=MA[3,4]&&
      MA[3,4]>=MA[3,5]&&
      MA[3,5]>=MA[3,6]&&
      MA[3,6]>=MA[3,7])
   {
      MA200M30bullish = 1;
      
   }
   else if (MA[3,1]<=MA[3,2] &&
            MA[3,2]<=MA[3,3] &&
            MA[3,3]<=MA[3,4] &&
            MA[3,4]<=MA[3,5] &&
            MA[3,5]<=MA[3,6] &&
            MA[3,6]<=MA[3,7])
   {
      MA200M30bullish = 2;
   }
   else
   {
      MA200M30bullish = 0;
   }
   
     return (MA200M30bullish);

}

int MA20Trigger(){

int MA20trigger = 0;
   
      int i = 1;
      int j = 1;
      int k = 1;
      int l = 1;
      int m = 1;
      int n = 1;
      int o = 1;
      int p = 1;
      int q = 1;
      int r = 1;
      int s = 1;
   
      for (i = 1 ; i <= candleTrigger; i++)
      {
            if(i== 2){k=2;}
            if(i== 3){l=3;}
            if(i== 4){m=4;}
            if(i== 5){n=5;}
            if(i== 6){o=6;}
            if(i== 7){p=7;}
            if(i== 8){q=8;}
            if(i== 9){r=9;}
            
            if( i == candleTrigger &&
                Close[j]>MA[0,j] &&
                Close[k]>MA[0,k] &&
                Close[l]>MA[0,l] &&
                Close[m]>MA[0,m] &&
                Close[n]>MA[0,n] &&
                Close[o]>MA[0,o] &&
                Close[p]>MA[0,p] &&
                Close[q]>MA[0,q] &&
                Close[r]>MA[0,r])
             {
                MA20trigger = 1;
             }
             else if (i == candleTrigger &&
                Close[j]<MA[0,j] &&
                Close[k]<MA[0,k] &&
                Close[l]<MA[0,l] &&
                Close[m]<MA[0,m] &&
                Close[n]<MA[0,n] &&
                Close[o]<MA[0,o] &&
                Close[p]<MA[0,p] &&
                Close[q]<MA[0,q] &&
                Close[r]<MA[0,r])
             {
                MA20trigger = 2;
             }
             else
             {
               MA20trigger = 0;
             }
      }
       
return (MA20trigger);

} 



 
   
   
void OrderManagement(){

         //list all open tickets
         ArrayResize(ticketNo,OrdersTotal());
         for(int m = 0;  m < OrdersTotal(); m++) // give the id of all open tickets
         {
            resSelect = OrderSelect(m,SELECT_BY_POS,MODE_TRADES);
            if(resSelect == false)
            {
                 error = GetLastError();
                 errorDesc = GetError(error);
                 Print("Error selecting order number on for loop: ", errorDesc);
            }
            else
            {
                 ticketNo[m] = OrderTicket();
            }
                    
            Print("The Ticket[",m,"] #",ticketNo[m], " is open on ",OrderSymbol()," and there is (are) ",OrdersTotal(), " order(s)");    
            Print(" Take Profit of  ", ticketNo[m], " is " ,OrderTakeProfit()); 
         }
         
       

         if(OrdersTotal()> 0)
         {
               for(int m = 0;  m< OrdersTotal(); m++)
               {
                  if(OrderCloseTime() ==0)
                  {
                     resSelect = OrderSelect(ticketNo[m],SELECT_BY_TICKET);
                     if(resSelect == false)
                     {
                     error = GetLastError();
                     errorDesc = GetError(error);
                     Print("Error selecting order number by ticket : ", errorDesc);
                     }
                     else
                     { 
                        
                   
                        if(OrderType() == 0 && 
                           MA20_bullish == 2 && 
                           MA200_bullish ==2 &&
                           //MA20M30_bullish == 2 && 
                          // MA200M30_bullish ==2 &&
                           //MA20_trigger == 2 && 
                           MA[0,1]<MA[1,1] &&
                           OrderSymbol()== Symbol() && 
                           OrderMagicNumber() == MagicNumber )
                        {
                           Print("close buy order, MA20 is bearish and candles on the wrong MA20 side");
                           resClose = OrderClose(OrderTicket(),OrderLots(),Bid,10);
                                          if(resClose == false)
                                          {
                                                  error = GetLastError();
                                                  errorDesc = GetError(error);
                                                  Print("Error closing buy  order : ", errorDesc);
                                          }
                                          else
                                          {
                                                  Print("Ticket #",OrderTicket() ," lot ", OrderLots() ," closed buy order with $",OrderProfit());
                                                  countCandle = 0;
                                          }
                        }
                        
                        
                        
                        
                        
                        if(OrderType() == 1 && 
                           MA20_bullish == 1 && 
                           MA200_bullish == 1 &&
                          // MA20M30_bullish == 1 && 
                          // MA200M30_bullish == 1 &&
                           //MA20_trigger == 1 &&
                           MA[0,1]>MA[1,1] &&
                           OrderSymbol()== Symbol() 
                           && OrderMagicNumber() == MagicNumber)
                        {
                           Print("close sell order, MA20 is bearish and candles on the wrong MA20 side");
                           resClose = OrderClose(OrderTicket(),OrderLots(),Ask,10);
                                          if(resClose == false)
                                          {
                                                  error = GetLastError();
                                                  errorDesc = GetError(error);
                                                  Print("Error closing sell  order : ", errorDesc);
                                          }
                                          else
                                          {
                                                  Print("Ticket #",OrderTicket() ," lot ", OrderLots() ," closed sell order with $",OrderProfit());
                                                  countCandle = 0;
                                          }
                        }
                      
                      
                    
                        
                     }// end else of orderselect
                     
                  }
               }// end for loop orderselect()
         }
   
}


void StopLossManagement()
{
   


         if(OrdersTotal()> 0)
         {
               for(int m = 0;  m< OrdersTotal(); m++)
               {
                  if(OrderCloseTime() ==0)
                  {
                     resSelect = OrderSelect(ticketNo[m],SELECT_BY_TICKET);
                     if(resSelect == false)
                     {
                     error = GetLastError();
                     errorDesc = GetError(error);
                     Print("Error selecting order number by ticket : ", errorDesc);
                     }
                     else
                     { 
   
   
                              //Set stop loss to 0
                              if(OrderSymbol() == Symbol() && OrderType() == 0)
                              {
                              Print(OrderSymbol(),"/",Symbol()," - ",OrderMagicNumber(),"/",MagicNumber,
                                    " - OrderProfit() = ",OrderProfit(), " - SL : ",OrderOpenPrice(),"/",stopLoss,
                                    " - OrderType = ",OrderType(), " - ", Close[1], "<", NormalizeDouble(MA[0,1],5));
                              }
                              if( OrderSymbol() == Symbol() &&
                                  OrderMagicNumber() == MagicNumber &&
                                  OrderProfit() > 0 &&
                                  OrderType() == 0 &&
                                  Close[1] < MA[0,1] &&
                                  stopLoss != OrderOpenPrice())
                                  {
                                    Print("Set Stop loss for a buy to 0");
                                    Print(OrderTakeProfit(),"/",takeProfit);
                                    stopLoss = OrderOpenPrice();
                                        resModify  = OrderModify(OrderTicket(),0,stopLoss,OrderTakeProfit(),0);
                                      if(resModify == false)
                                       {
                                             Print(OrderTicket()," - ", OrderOpenPrice()," - " ,OrderTakeProfit());
                                             error = GetLastError();
                                             errorDesc = GetError(error);
                                             
                                             Print("Error modify sell order number ", errorDesc);
                                       }
                                       else
                                       {
                                             Print("Ticket # : ",OrderTicket()," buy modify new Stop loss = ", OrderStopLoss()," Take profit = ",OrderTakeProfit(), " confirmed, Profit = ",OrderProfit());
                                       }   
                               
                                  
                                  } 
                                     if(OrderSymbol() == Symbol() && OrderType() == 1)
                              {
                              Print(OrderSymbol(),"/",Symbol()," - ",OrderMagicNumber(),"/",MagicNumber,
                                    " - OrderProfit() = ",OrderProfit(), " - SL : ",OrderOpenPrice(),"/",stopLoss,
                                    " - OrderType = ",OrderType(), " - ", Close[1], ">", NormalizeDouble(MA[0,1],5));
                              }  
                              
                                 if( OrderSymbol() == Symbol() &&
                                  OrderMagicNumber() == MagicNumber &&
                                  OrderProfit() > 0 &&
                                  OrderType() == 1 &&
                                  Close[1] > MA[0,1] &&
                                  stopLoss != OrderOpenPrice())
                                  {
                                    Print("Set Stop loss for a sell to 0");
                                       stopLoss = OrderOpenPrice();
                                       resModify  = OrderModify(OrderTicket(),0,stopLoss,OrderTakeProfit(),0);
                                       if(resModify == false)
                                       {
                                             error = GetLastError();
                                             errorDesc = GetError(error);
                                             
                                             Print("Error modify sell order number ", errorDesc);
                                       }
                                       else
                                       {
                                             Print("Ticket # : ",OrderTicket()," sell modify new Stop loss = ", OrderOpenPrice()," Take profit = " , OrderTakeProfit(), " confirmed, Profit = ",OrderProfit());
                                       }
                                 }
                                 
                                 if(OrderSymbol()==Symbol())
                                 {
                                      Print("Candle # edit take profit = ", (((int)iTime(OrderSymbol(),Period(),0) - (int)OrderOpenTime())/60)/5 ," candleAmountMoveTPToZero : ", candleAmountMoveTPToZero,
                                      " Order Profit = " , OrderProfit(),
                                      " Order TP : ", OrderTakeProfit(), " OP = ", OrderOpenPrice());
                                      Print((((int)iTime(OrderSymbol(),Period(),0) - (int)OrderOpenTime())/60)/5 > candleAmountMoveTPToZero," ", OrderProfit()< 0," ",OrderTakeProfit() != OrderOpenPrice(), " " , OrderSymbol() == Symbol());
                                 
                                 }
                                 if((((int)iTime(OrderSymbol(),Period(),0) - (int)OrderOpenTime())/60)/5 > candleAmountMoveTPToZero &&
                                      OrderProfit()< 0 &&
                                      OrderTakeProfit() != OrderOpenPrice() &&
                                      OrderSymbol() == Symbol())
                                 {
                                 
                                       Print("Set take profit to 0");
                                       takeProfit = OrderOpenPrice();
                                       resModify  = OrderModify(OrderTicket(),0,OrderStopLoss(),takeProfit,0);
                                       if(resModify == false)
                                       {
                                             error = GetLastError();
                                             errorDesc = GetError(error);
                                             
                                             Print("Error modify take profiy number :", errorDesc);
                                       }
                                       else
                                       {
                                             Print("Ticket # : ",OrderTicket(),"  modify new take profit = " , OrderTakeProfit(), " confirmed, Profit = ",OrderProfit());
                                       }
                                 
                                 
                                 }
                                 
                                  
                        }  
                  }
            }
      }
  }
  
  
  void ShowDashboard(string Descr0, int magic,
                   string Descr1, int my_market_type,
                   string Descr2, int Param1,
                   string Descr3, double Param2,
                   string Descr4, int Param3,
                   string Descr5, double Param4,
                   string Descr6, int Param5,
                   string Descr7, double Param6
                     ) 
  {
   Print("Show Dashboard on");
// Purpose: This function creates a dashboard showing information on your EA using comments function
// Type: Customisable 
// Modify this function to suit your trading robot
//----
/*
Conversion of Market Types
if(res == "0" || res == "-1") {marketType = MARKET_NONE; return(marketType); }
   if(res == "1" || res == "BUN"){marketType = MARKET_BUN;  return(marketType); }
   if(res == "2" || res == "BUV"){marketType = MARKET_BUV;  return(marketType); }
   if(res == "3" || res == "BEN"){marketType = MARKET_BEN;  return(marketType); }
   if(res == "4" || res == "BEV"){marketType = MARKET_BEV;  return(marketType); }
   if(res == "5" || res == "RAN"){marketType = MARKET_RAN;  return(marketType); }
   if(res == "6" || res == "RAV"){marketType = MARKET_RAV;  return(marketType); }
*/

string new_line = "\n\n"; // "\n" or "\n\n" will move the comment to new line
string space = ": ";    // generate space
string underscore = "________________________________";
string market_type;

//Convert Integer value of Market Type to String value
if(my_market_type == 0) market_type = "TESTING";
if(my_market_type == 1) market_type = "BUN";
if(my_market_type == 2) market_type = "BUV";
if(my_market_type == 3) market_type = "BEN";
if(my_market_type == 4) market_type = "BEV";
if(my_market_type == 5) market_type = "RAN";
if(my_market_type == 6) market_type = "RAV";


Comment(
        new_line 
      + Descr0 + space + IntegerToString(magic)
      + new_line
      + "Trade Allow"+space+ IntegerToString(tradeAllowed)
      + new_line
      + "Flag buy "+space+ IntegerToString(flagBuy)
      + " Flag sell"+space+ IntegerToString(flagSell) 
      + new_line     
      + Descr1 + space + market_type
      + new_line 
      + new_line
      + new_line
      + Descr2 + space + IntegerToString(Param1)
      + new_line
      + Descr3 + space + DoubleToString(Param2, 1)
      + new_line 
      + "AIPriceChange > (for sell) (-1*)AITrigger"
      + new_line        
      + underscore  
      + new_line 
      + new_line
      + Descr5 + space + DoubleToString(Param4, 1)
      + new_line 
      + Descr6 + space + IntegerToString(Param5)
      + new_line
      + "AImaxperf > AIminperf"
      + new_line        
      + underscore  
      + new_line 
      + new_line
      + Descr4 + space + IntegerToString(Param3)
      + new_line
      + Descr7 + space + DoubleToString(Param6, 1)
      + new_line
      + "MyMarketTypeConf > 0.97 "
      + new_line     
      + underscore  
      + "");
      
      
      
  }


