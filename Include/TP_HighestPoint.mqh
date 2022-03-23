//+------------------------------------------------------------------+
//|                                              SL_HighestPoint.mqh |
//|                                         Copyright 2020, Stufflow |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Stufflow"
#property link      "https://www.mql5.com"
#property strict


double takeProfitValue;
int minTPIndex;
int maxTPIndex;
double highestTPPoint[];
double takeProfitHighestPoint;
int loop_h = 8;      
      
double BuyTakeProfit(double TPMargin, int TPNoHighestPoint, int TPCandleQty, bool TPnoHighestPoint)
{
      
      ArrayResize(highestTPPoint,TPCandleQty);
      //Print ("highestPoint : " , highestPoint[SLCandleQty-1]);
      
      for(int i = 0 ;i< TPCandleQty; i++)
      {
         highestTPPoint[i] = High[i];
        // Print("Lowest point[",i,"] = ",highestTPPoint[i]);
         
      }
      maxTPIndex = ArrayMaximum(highestTPPoint,WHOLE_ARRAY,1);
      
      Print("Buy take profit highest point = ",highestTPPoint[maxTPIndex]," at the ", maxTPIndex, "th candle"); 
      takeProfitHighestPoint = highestTPPoint[maxTPIndex] + TPMargin * Point; 
      //Print(highestTPPoint[maxTPIndex], "- " ,TPMargin * Point, " = " , takeProfitHighestPoint);
     
      if(TPnoHighestPoint == false)
      {     
            if(takeProfitHighestPoint > Ask)
            {
               takeProfitValue =  takeProfitHighestPoint;
               //Print("Buy takeProfiValue = ", takeProfitValue,"/",takeProfitHighestPoint);
            }
            else
            {
               takeProfitValue =   Ask+TPNoHighestPoint*Point;
            }
      }
      
      
          if(TPnoHighestPoint == true)
          {
                  if(takeProfitHighestPoint > Ask)
                  {
                     takeProfitValue =  takeProfitHighestPoint;
                     //Print("Buy takeProfitValue = ", takeProfitValue);
                  }
                  else
                   {
                        for(int h = 2; h < loop_h; h++)
                        {     
                              //128  --> 
                             ArrayResize(highestTPPoint,TPCandleQty*h);
                             //Print("ArrayResize : ",  ArrayResize(highestTPPoint,TPCandleQty*h));
                             for(int i = 1 ;i< TPCandleQty * h; i++)
                              {
                                    //if use EA, array out of range if no history available
                                    highestTPPoint[i] = High[i];
                                   // Print("highestTPPoint[",i,"] = ",highestTPPoint[i]);
                              }
                              
                              minTPIndex = ArrayMaximum(highestTPPoint,WHOLE_ARRAY,0);
                              takeProfitHighestPoint = highestTPPoint[minTPIndex] + TPMargin * Point; 
                             // Print("takeProfitHighestPoint = ", takeProfitHighestPoint, " > " ,Ask, " at the ", minTPIndex, " th candle");
                             
                             
                              if(takeProfitHighestPoint > Ask)
                              {
                                  takeProfitValue =  takeProfitHighestPoint;
                                  Print("break at h = ",h);
                                  break;
                              }
                              else if(h == loop_h - 1)
                              {
                                  highestTPPoint[0] =  Ask+TPNoHighestPoint*Point; 
                                  takeProfitValue =  highestTPPoint[0];
                                  Print("There is no highest point from a while, TP = ", takeProfitValue, "h = ", h);
                                  break;
                              }
                              //Print("h= ",h);
                            
                       }
                     }   
            
            }
      
      Print("The buy take profit is : ", takeProfitValue);
      return takeProfitValue;
}

double SellTakeProfit(double TPMargin, int TPNoHighestPoint, int TPCandleQty, bool TPnoHighestPoint)
{
      Print("searching for sell take profit within ", TPCandleQty, " candles or more...");
      ArrayResize(highestTPPoint,TPCandleQty);
     
      for(int i = 0 ;i< TPCandleQty; i++)
      {
         highestTPPoint[i] = Low[i];
        // Print("Lowest point[",i+1,"] = ",highestTPPoint[i]);
         
      }
      minTPIndex = ArrayMinimum(highestTPPoint,WHOLE_ARRAY,1);
      
      
      takeProfitHighestPoint = highestTPPoint[minTPIndex] - TPMargin * Point; 
      Print("Sell take profit lowest point = ",highestTPPoint[minTPIndex]," at the ", minTPIndex,"th candles"); 
      
      if(TPnoHighestPoint == false)
      {
            if(takeProfitHighestPoint < Bid)
            {
               takeProfitValue =  takeProfitHighestPoint;
               Print("Sell takeProfitValue = ", takeProfitValue);
            }
            else
            {
               takeProfitValue =   Bid - TPNoHighestPoint *Point;
            }
      }
  
      if(TPnoHighestPoint == true)
      {
                  if(takeProfitHighestPoint < Bid)
                  {
                     takeProfitValue =  takeProfitHighestPoint;
                     //Print("Buy takeProfitValue = ", takeProfitValue);
                  }
                  else
                   {
                        Print("Search a further TP or  sell order");
                        for(int h = 2; h < loop_h; h++)
                        {     
                             ArrayResize(highestTPPoint,TPCandleQty * h);
                             for(int i = 1 ;i< TPCandleQty * h; i++)
                              {
                                 highestTPPoint[i] = Low[i];
                              }
                              minTPIndex = ArrayMinimum(highestTPPoint,WHOLE_ARRAY,0);
                              takeProfitHighestPoint = highestTPPoint[minTPIndex] - TPMargin * Point; 
                             //Print("takeProfitHighestPoint = ", takeProfitHighestPoint, " > " ,Ask, "  h = ", h);
                             
                             Print("takeProfitHighestPoint = ", takeProfitHighestPoint," Bid is ",Bid, " at h = ", h);
                              if(takeProfitHighestPoint < Bid)
                              {
                                  takeProfitValue =  takeProfitHighestPoint;
                                 Print("take profit of ", takeProfitValue," taken at the , ",minTPIndex, " th candle");
                                  break;
                              }
                               else if (h == loop_h - 1)
                              {
                                   highestTPPoint[0] =  Bid - TPNoHighestPoint *Point;; 
                                  takeProfitValue =  highestTPPoint[0];
                                  Print("There is no lowest point from a while, TP = ", takeProfitValue);
                                  break;
                              }
                             // Print("h= ",h);
                       }
                     }   
            
            }
  
  
  
  
      Print("The buy take profit is : ", takeProfitValue);
      return takeProfitValue;
}
//--