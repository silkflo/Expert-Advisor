//+------------------------------------------------------------------+
//|                                              SL_HighestPoint.mqh |
//|                                         Copyright 2020, Stufflow |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Stufflow"
#property link      "https://www.mql5.com"
#property strict


double stopLossValue;
int minSLIndex;
int maxSLIndex;
double highestSLPoint[];
double stopLossHighestPoint;
int h_loop = 30;     
      
double BuyStopLoss(double SLMargin, int SLNoHighestPoint, int SLCandleQty,bool SLnoHighestPoint)
{
      
      ArrayResize(highestSLPoint,SLCandleQty);
      //Print ("highestPoint : " , highestPoint[SLCandleQty-1]);
      
      for(int i = 0 ;i< SLCandleQty; i++)
      {
         highestSLPoint[i] = Low[i];
        // Print("Lowest point[",i+1,"] = ",highestPoint[i]);
         
      }
      minSLIndex = ArrayMinimum(highestSLPoint,WHOLE_ARRAY,1);
      
      Print("Buy stopLossHighestPoint = ",highestSLPoint[minSLIndex]," at the ", minSLIndex, "th candles");
      stopLossHighestPoint = highestSLPoint[minSLIndex] - SLMargin * Point; 
     
     
         if(SLnoHighestPoint == false)
         {
                  if(stopLossHighestPoint < Bid)
                  {
                     
                     stopLossValue =  highestSLPoint[minSLIndex];
                     
                  }
                  else
                  {
                     stopLossValue =   Bid-SLNoHighestPoint * Point;
                  }
         }
         
         
       
         if(SLnoHighestPoint == true)
         {
            if(stopLossHighestPoint < Bid)
                  {
                     stopLossValue =  stopLossHighestPoint;
                     
                  }
            else
               {
                  for(int h = 2; h < h_loop; h++)
                  { 
                       ArrayResize(highestSLPoint,SLCandleQty * h);
                       for(int i = 1 ;i< SLCandleQty * h; i++)
                        {
                           highestSLPoint[i] = Low[i];
                        }
                        minSLIndex = ArrayMinimum(highestSLPoint,WHOLE_ARRAY,0);
                        stopLossHighestPoint = highestSLPoint[minSLIndex] - SLMargin * Point; 
                        if(stopLossHighestPoint < Bid)
                        {
                            stopLossValue =  stopLossHighestPoint;
                            break;
                        }
                        else if(h==h_loop - 1)
                        {
                           highestSLPoint[0] =   Bid-SLNoHighestPoint * Point;
                           stopLossValue = highestSLPoint[0];
                           Print("there is no lowest point from a while, SL =", stopLossValue);
                           break;
                        }
                 } 
              }   
          }
           
         
      Print("The buy stop loss 4 is : ", stopLossValue);
      return stopLossValue;
}

double SellStopLoss(double SLMargin, int SLNoHighestPoint, int SLCandleQty, bool SLnoHighestPoint)
{
      ArrayResize(highestSLPoint,SLCandleQty);
      for(int i = 0 ;i< SLCandleQty; i++)
      {
         highestSLPoint[i] = High[i];
        // Print("Lowest point[",i+1,"] = ",highestPoint[i]);
         
      }
      maxSLIndex = ArrayMaximum(highestSLPoint,WHOLE_ARRAY,1);
      
      
      stopLossHighestPoint = highestSLPoint[maxSLIndex] + SLMargin * Point; 
      Print("Sell stopLossHighestPoint = ",highestSLPoint[maxSLIndex]," at the ", maxSLIndex,"th candles"); 
      
      if(SLnoHighestPoint == false)
            if(stopLossHighestPoint > Ask)
            {
               stopLossValue =  stopLossHighestPoint;
            }
            else
            {
               stopLossValue =   Ask + SLNoHighestPoint *Point;
            }
      
  
      if(SLnoHighestPoint == true)
         {
            if(stopLossHighestPoint > Ask)
                  {
                     stopLossValue =  stopLossHighestPoint;
                  }
            else
               {
                  for(int h = 2; h < h_loop; h++)
                  { 
                       ArrayResize(highestSLPoint,SLCandleQty * h);
                       for(int i = 1 ;i< SLCandleQty * h; i++)
                        {
                           highestSLPoint[i] = High[i];
                        }
                        minSLIndex = ArrayMaximum(highestSLPoint,WHOLE_ARRAY,0);
                        stopLossHighestPoint = highestSLPoint[minSLIndex] + SLMargin * Point; 
                        if(stopLossHighestPoint > Ask)
                        {
                            stopLossValue =  stopLossHighestPoint;
                            break;
                        }
                          else if(h ==h_loop - 1)
                        {
                           highestSLPoint[0] =  Ask + SLNoHighestPoint *Point;
                           stopLossValue = highestSLPoint[0];
                           Print("there is no highest point from a while, SL =", stopLossValue);
                        
                        }
                 }
                }   
          }
  
      Print("The sell stop loss is : ", stopLossValue);
      return stopLossValue;
}
//--