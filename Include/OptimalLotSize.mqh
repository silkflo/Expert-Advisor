//+------------------------------------------------------------------+
//|                                               OptimalLotSize.mqh |
//|                                         Copyright 2020, Stufflow |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Stufflow"
#property link      "https://www.mql5.com"
#property strict


double OptimalLotSize(double maxRiskPrc, double  maxLossInPips)
{

  double accEquity = AccountEquity();
  //Print("accEquity: " , accEquity);
  
  double lotSize = MarketInfo(NULL,MODE_LOTSIZE);
  //Print("lotSize: " , lotSize);
  
  double tickValue = MarketInfo(NULL,MODE_TICKVALUE);
  
  if(Digits <= 3)
  {
   tickValue = tickValue /100;
  }
  
  //Print("tickValue: " , tickValue);
  
  double maxLossDollar = accEquity * maxRiskPrc;
  //Print("maxLossDollar: " , maxLossDollar);
  
  double maxLossInQuoteCurr = maxLossDollar / tickValue;
  //Print("maxLossInQuoteCurr: " , maxLossInQuoteCurr);
  
  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(MathAbs(maxLossInPips) * GetPipValue())/lotSize,2);
  if(optimalLotSize<0.01){optimalLotSize=0.01;}
  Print("The optimal lot size is : ", optimalLotSize);
  return optimalLotSize;
 
}


double GetPipValue()
{
   if(_Digits >=4)
   {
      return 0.0001;
   }
   else
   {
      return 0.01;
   }
}
