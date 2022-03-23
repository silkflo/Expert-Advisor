//+------------------------------------------------------------------+
//|                                                     GetError.mqh |
//|                                         Copyright 2020, Stufflow |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Stufflow"
#property link      "https://www.mql5.com"
#property strict


string GetError(int errorID)
{
      
      string errorDescription = "";
        
        
        switch(errorID)
        {
         case 0 :
         errorDescription = "ERR_NO_ERROR || No error returned" ;
         break;
         case 1 :
         errorDescription = "ERR_NO_RESULT || No error returned, but the result is unknown";
         break;
         case 2 :
         errorDescription = "ERR_COMMON_ERROR || Common error";
         break;
         case 3 : 
         errorDescription = "ERR_INVALID_TRADE_PARAMETERS || Invalid trade parameters";
         break;
         case 4 :
         errorDescription = "ERR_SERVER_BUSY || Trade server is busy";
         break;
         case 5 :
         errorDescription = "ERR_OLD_VERSION || Old version of the client terminal";
         break;
         case 6 :
         errorDescription = "ERR_NO_CONNECTION || No connection with trade server";
         break;
         case 7 :
         errorDescription = "ERR_NOT_ENOUGH_RIGHTS || Not enough rights";
         break; 
         case 8 :
         errorDescription = "ERR_TOO_FREQUENT_REQUESTS || Too frequent requests";
         break;
         case 9 :
         errorDescription ="ERR_MALFUNCTIONAL_TRADE || Malfunctional trade operation";
         break;
         case 64 :
         errorDescription = "ERR_ACCOUNT_DISABLED || Account disabled";
         break;
         case 65 :
         errorDescription = "ERR_INVALID_ACCOUNT || Invalid account";
         break;
         case 128 :
         errorDescription = "ERR_TRADE_TIMEOUT || Trade timeout";
         break;
         case 129 :
         errorDescription = "ERR_INVALID_PRICE || Invalid price";
         break;
         case 130 :
         errorDescription = "ERR_INVALID_STOPS || Invalid stops";
         break; 
         case 131 :
         errorDescription = "ERR_INVALID_TRADE_VOLUME || Invalid trade volume";
         break;
         case 132 :
         errorDescription = "ERR_MARKET_CLOSED || Market is closed";
         break;
         case 133 :
         errorDescription = "ERR_TRADE_DISABLED|| Trade is disabled";
         break;
         case 134 :
         errorDescription = "ERR_NOT_ENOUGH_MONEY || Not enough money";
         break;
         case 135 :
         errorDescription = "ERR_PRICE_CHANGED ||Price changed";
         break;
         case 136 :
         errorDescription = "ERR_OFF_QUOTES || Off quotes";
         break;
         case 137 :
         errorDescription = "ERR_BROKER_BUSY || Broker is busy";
         break;
         case 138 :
         errorDescription = "ERR_REQUOTE || Requote";
         break;
         case 139 :
         errorDescription = "ERR_ORDER_LOCKED || Order is locked";
         break;
         case 140 :
         errorDescription = "ERR_LONG_POSITIONS_ONLY_ALLOWED || Buy orders only allowed";
         break;
         case 141 :
         errorDescription = "ERR_TOO_MANY_REQUESTS || Too many requests";
         break;
         case 145 :
         errorDescription = "ERR_TRADE_MODIFY_DENIED || Modification denied because order is too close to market";
         break;
         case 146 :
         errorDescription = "ERR_TRADE_CONTEXT_BUSY || Trade context is busy"; 
         break;
         case 147 :
         errorDescription = "ERR_TRADE_EXPIRATION_DENIED || Expirations are denied by broker";
         break;
         case 148 :
         errorDescription = "ERR_TRADE_TOO_MANY_ORDERS || The amount of open and pending orders has reached the limit set by the broker";
         break;
         case 149 :
         errorDescription = "ERR_TRADE_HEDGE_PROHIBITED|| An attempt to open an order opposite to the existing one when hedging is disabled"; 
         break;
         case 150 :
         errorDescription = "ERR_TRADE_PROHIBITED_BY_FIFO || An attempt to close an order contravening the FIFO rule"; 
         break;
         case 4000 :
         errorDescription = "ERR_NO_MQLERROR || No error returned";
         break;
         case 4001 :
         errorDescription = "ERR_WRONG_FUNCTION_POINTER || Wrong function pointer";
         break;
         case 4002 :
         errorDescription = "ERR_ARRAY_INDEX_OUT_OF_RANGE || Array index is out of range";
         break;
         case 4003 :
         errorDescription = "ERR_NO_MEMORY_FOR_CALL_STACK || No memory for function call stack";
         break;
         case 4004 :
         errorDescription = "ERR_RECURSIVE_STACK_OVERFLOW || Recursive stack overflow";
         break;
         case 4005 :
         errorDescription = "ERR_NOT_ENOUGH_STACK_FOR_PARAM || Not enough stack for parameter";
         break;
         case 4006 :
         errorDescription = "ERR_NO_MEMORY_FOR_PARAM_STRING || No memory for parameter string";
         break;
         case 4007 :
         errorDescription = "ERR_NO_MEMORY_FOR_TEMP_STRING || No memory for temp string";
         break;
         case 4008 :
         errorDescription = "ERR_NOT_INITIALIZED_STRING || Not initialized string";
         break;
         case 4009 :
         errorDescription = "ERR_NOT_INITIALIZED_ARRAYSTRING || Not initialized string in array";
         break;
         case 4010 :
         errorDescription = "ERR_NO_MEMORY_FOR_ARRAYSTRING || No memory for array string";
         break;
         case 4011 :
         errorDescription = "ERR_TOO_LONG_STRING || Too long string";
         break;
         case 4012 :
         errorDescription = "ERR_REMAINDER_FROM_ZERO_DIVIDE || Remainder from zero divide";
         break;
         case 4013 :
         errorDescription = "ERR_ZERO_DIVIDE || Zero divide";
         break;
         case 4014 :
         errorDescription = "ERR_UNKNOWN_COMMAND|| Unknown command";
         break;
         case 4015 :
         errorDescription = "ERR_WRONG_JUMP || Wrong jump (never generated error)";
         break;
         case 4016 :
         errorDescription = "ERR_NOT_INITIALIZED_ARRAY || Not initialized array";
         break;
         case 4017 :
         errorDescription = "ERR_DLL_CALLS_NOT_ALLOWED|| DLL calls are not allowed";
         break;
         case 4018 :
         errorDescription = "ERR_CANNOT_LOAD_LIBRARY|| Cannot load library";
         break;
         case 4019 :
         errorDescription = "ERR_CANNOT_CALL_FUNCTION|| Cannot call function";
         break;
         case 4020 :
         errorDescription = "ERR_EXTERNAL_CALLS_NOT_ALLOWED|| Expert function calls are not allowed";
         break;
         case 4021 :
         errorDescription = "ERR_NO_MEMORY_FOR_RETURNED_STR || Not enough memory for temp string returned from function";
         break;
         case 4022 :
         errorDescription = "ERR_SYSTEM_BUSY || System is busy (never generated error)";
         break;
         case 4023 :
         errorDescription = "ERR_DLLFUNC_CRITICALERROR || DLL-function call critical error";
         break;
         case 4024 :
         errorDescription = "ERR_INTERNAL_ERROR || Internal error";
         break;
         case 4025 :
         errorDescription = "ERR_OUT_OF_MEMORY || Out of memory";
         break;
         case 4026 :
         errorDescription = "ERR_INVALID_POINTER || Invalid pointer";
         break;
         case 4027 :
         errorDescription = "ERR_FORMAT_TOO_MANY_FORMATTERS || Too many formatters in the format function";
         break;
         case 4028 :
         errorDescription = "ERR_FORMAT_TOO_MANY_PARAMETERS || Parameters count exceeds formatters count";
         break;
         case 4029 :
         errorDescription = "ERR_ARRAY_INVALID || Invalid array";
         break;
         case 4030 :
         errorDescription = "ERR_CHART_NOREPLY || No reply from chart";
         break;
         case 4050 :
         errorDescription = "ERR_INVALID_FUNCTION_PARAMSCNT || Invalid function parameters count";
         break;
         case 4051 :
         errorDescription = "ERR_INVALID_FUNCTION_PARAMVALUE || Invalid function parameter value";
         break;
         case 4052 :
         errorDescription = "ERR_STRING_FUNCTION_INTERNAL || String function internal error";
         break;
         case 4053 :
         errorDescription = "ERR_SOME_ARRAY_ERROR || Some array error";
         break;
         case 4054 :
         errorDescription = "ERR_INCORRECT_SERIESARRAY_USING || Incorrect series array using";
         break;
         case 4055 :
         errorDescription = "ERR_CUSTOM_INDICATOR_ERROR || Custom indicator error";
         break;
         case 4056 :
         errorDescription = "ERR_INCOMPATIBLE_ARRAYS || Arrays are incompatible";
         break;
         case 4057 :
         errorDescription = "ERR_GLOBAL_VARIABLES_PROCESSING || Global variables processing error";
         break;
         case 4058 :
         errorDescription = "ERR_GLOBAL_VARIABLE_NOT_FOUND || Global variable not found";
         break;
         case 4059 :
         errorDescription = "ERR_FUNC_NOT_ALLOWED_IN_TESTING || Function is not allowed in testing mode";
         break;
         case 4060 :
         errorDescription = "ERR_FUNCTION_NOT_CONFIRMED || Function is not allowed for call";
         break;
         case 4061 :
         errorDescription = "ERR_SEND_MAIL_ERROR || Send mail error";
         break;
         case 4062 :
         errorDescription = "ERR_STRING_PARAMETER_EXPECTED || String parameter expected";
         break;
         case 4063 :
         errorDescription = "ERR_INTEGER_PARAMETER_EXPECTED || Integer parameter expected";
         break;
         case 4064 :
         errorDescription = "ERR_DOUBLE_PARAMETER_EXPECTED || Double parameter expected";
         break;
         case 4065 :
         errorDescription = "ERR_ARRAY_AS_PARAMETER_EXPECTED || Array as parameter expected";
         break;
         case 4066 :
         errorDescription = "ERR_HISTORY_WILL_UPDATED || Requested history data is in updating state";
         break;
         case 4067 :
         errorDescription = "ERR_TRADE_ERROR || Internal trade error";
         break;
         case 4068 :
         errorDescription = "ERR_RESOURCE_NOT_FOUND || Resource not found";
         break;
         case 4069 :
         errorDescription = "ERR_RESOURCE_NOT_SUPPORTED || Resource not supported";
         break;
         case 4070 :
         errorDescription = "ERR_RESOURCE_DUPLICATED || Duplicate resource";
         break;
         case 4071 :
         errorDescription = "ERR_INDICATOR_CANNOT_INIT || Custom indicator cannot initialize";
         break;
         case 4072 :
         errorDescription = "ERR_INDICATOR_CANNOT_LOAD || Cannot load custom indicator";
         break;
         case 4073 :
         errorDescription = "ERR_NO_HISTORY_DATA || No history data";
         break;
         case 4074 :
         errorDescription = "ERR_NO_MEMORY_FOR_HISTORY || No memory for history data";
         break;
         case 4075 :
         errorDescription = "ERR_NO_MEMORY_FOR_INDICATOR || Not enough memory for indicator calculation";
         break;
         case 4099 :
         errorDescription = "ERR_END_OF_FILE || End of file";
         break;
         case 4100 :
         errorDescription = "ERR_SOME_FILE_ERROR || Some file error";
         break;
         case 4101 :
         errorDescription = "ERR_WRONG_FILE_NAME || Wrong file name";
         break;
         case 4102 :
         errorDescription = "ERR_TOO_MANY_OPENED_FILES || Too many opened files";
         break;
         case 4103 :
         errorDescription = "ERR_CANNOT_OPEN_FILE || Cannot open file";
         break;
         case 4104 :
         errorDescription = "ERR_INCOMPATIBLE_FILEACCESS || Incompatible access to a file";
         break;
         case 4105 :
         errorDescription = "ERR_NO_ORDER_SELECTED || No order selected";
         break;
         case 4106 :
         errorDescription = "ERR_UNKNOWN_SYMBOL || Unknown symbol";
         break;
         case 4107 :
         errorDescription = "ERR_INVALID_PRICE_PARAM || Invalid price";
         break;
         case 4108 :
         errorDescription = "ERR_INVALID_TICKET || Invalid ticket";
         break;
         case 4109 :
         errorDescription = "ERR_TRADE_NOT_ALLOWED || Trade is not allowed. Enable checkbox \"Allow live trading\" in the Expert Advisor properties";
         break;
         case 4110 :
         errorDescription = "ERR_LONGS_NOT_ALLOWED || Longs are not allowed. Check the Expert Advisor properties";
         break;
         case 4111 :
         errorDescription = "ERR_SHORTS_NOT_ALLOWED || Shorts are not allowed. Check the Expert Advisor properties";
         break;
         case 4112 :
         errorDescription = "ERR_TRADE_EXPERT_DISABLED_BY_SERVER || Automated trading by Expert Advisors/Scripts disabled by trade server";
         break;
         case 4200 :
         errorDescription = "ERR_OBJECT_ALREADY_EXISTS || Object already exists";
         break;
         case 4201 :
         errorDescription = "ERR_UNKNOWN_OBJECT_PROPERTY || Unknown object property";
         break;
         case 4202 :
         errorDescription = "ERR_OBJECT_DOES_NOT_EXIST || Object does not exist";
         break;
         case 4203 :
         errorDescription = "ERR_UNKNOWN_OBJECT_TYPE || Unknown object type";
         break;
         case 4204 :
         errorDescription = "ERR_NO_OBJECT_NAME || No object name";
         break;
         case 4205 :
         errorDescription = "ERR_OBJECT_COORDINATES_ERROR || Object coordinates error";
         break;
         case 4206 :
         errorDescription = "ERR_NO_SPECIFIED_SUBWINDOW || No specified subwindow";
         break;
         case 4207 :
         errorDescription = "ERR_SOME_OBJECT_ERROR || Graphical object error";
         break;
         case 4210 :
         errorDescription = "ERR_CHART_PROP_INVALID || Unknown chart property";
         break;
         case 4211 :
         errorDescription = "ERR_CHART_NOT_FOUND || Chart not found";
         break;
         case 4212 :
         errorDescription = "ERR_CHARTWINDOW_NOT_FOUND || Chart subwindow not found";
         break;
         case 4213 :
         errorDescription = "ERR_CHARTINDICATOR_NOT_FOUND || Chart indicator not found";
         break;
         case 4220 :
         errorDescription = "ERR_SYMBOL_SELECT || Symbol select error";
         break;
         case 4250 :
         errorDescription = "ERR_NOTIFICATION_ERROR || Notification error";
         break;
         case 4251 :
         errorDescription = "ERR_NOTIFICATION_PARAMETER || Notification parameter error";
         break;
         case 4252 :
         errorDescription = "ERR_NOTIFICATION_SETTINGS || Notifications disabled";
         break;
         case 4253 :
         errorDescription = "ERR_NOTIFICATION_TOO_FREQUENT || Notification send too frequent";
         break;
         case 4260 :
         errorDescription = "ERR_FTP_NOSERVER || FTP server is not specified";
         break;
         case 4261 :
         errorDescription = "ERR_FTP_NOLOGIN || FTP login is not specified";
         break;
         case 4262 :
         errorDescription = "ERR_FTP_CONNECT_FAILED || FTP connection failed";
         break;
         case 4263 :
         errorDescription = "ERR_FTP_CLOSED || FTP connection closed";
         break;
         case 4264 :
         errorDescription = "ERR_FTP_CHANGEDIR || FTP path not found on server";
         break;
         case 4265 :
         errorDescription = "ERR_FTP_FILE_ERROR || File not found in the MQL4/Files directory to send on FTP server";
         break;
         case 4266 :
         errorDescription = "ERR_FTP_ERROR || Common error during FTP data transmission";
         break;
         case 5001 :
         errorDescription = "ERR_FILE_TOO_MANY_OPENED || Too many opened files";
         break;
         case 5002 :
         errorDescription = "ERR_FILE_WRONG_FILENAME || Wrong file name";
         break;
         case 5003 :
         errorDescription = "ERR_FILE_TOO_LONG_FILENAME || Too long file name"; 
         break;
         case 5004 :
         errorDescription = "ERR_FILE_CANNOT_OPEN || Cannot open file"; 
         break;
         case 5005 :
         errorDescription = "ERR_FILE_BUFFER_ALLOCATION_ERROR || Text file buffer allocation error";
         break;
         case 5006 :
         errorDescription = "ERR_FILE_CANNOT_DELETE || Cannot delete file";
         break;
         case 5007 :
         errorDescription = "ERR_FILE_INVALID_HANDLE || Invalid file handle (file closed or was not opened)";
         break;
         case 5008 :
         errorDescription = "ERR_FILE_WRONG_HANDLE || Wrong file handle (handle index is out of handle table)";
         break;
         case 5009 :
         errorDescription = "ERR_FILE_NOT_TOWRITE || File must be opened with FILE_WRITE flag";
         break;
         case 5010 :
         errorDescription = "ERR_FILE_NOT_TOREAD || File must be opened with FILE_READ flag";
         break;
         case 5011 :
         errorDescription = "ERR_FILE_NOT_BIN || File must be opened with FILE_BIN flag";
         break;
         case 5012 :
         errorDescription = "ERR_FILE_NOT_TXT || File must be opened with FILE_TXT flag";
         break;
         case 5013 :
         errorDescription = "ERR_FILE_NOT_TXTORCSV || File must be opened with FILE_TXT or FILE_CSV flag";
         break;
         case 5014 :
         errorDescription = "ERR_FILE_NOT_CSV || File must be opened with FILE_CSV flag";
         break;
         case 5015 :
         errorDescription = "ERR_FILE_READ_ERROR || File read error";
         break;
         case 5016 :
         errorDescription = "ERR_FILE_WRITE_ERROR || File write error";
         break;
         case 5017 :
         errorDescription = "ERR_FILE_BIN_STRINGSIZE || String size must be specified for binary file";
         break;
         case 5018 :
         errorDescription = "ERR_FILE_INCOMPATIBLE || Incompatible file (for string arrays-TXT, for others-BIN)";
         break;
         case 5019 :
         errorDescription = "ERR_FILE_IS_DIRECTORY || File is directory not file";
         break;
         case 5020 :
         errorDescription = "ERR_FILE_NOT_EXIST || File does not exist";
         break;
         case 5021 :
         errorDescription = "ERR_FILE_CANNOT_REWRITE || File cannot be rewritten";
         break;
         case 5022 :
         errorDescription = "ERR_FILE_WRONG_DIRECTORYNAME || Wrong directory name";
         break;
         case 5023 :
         errorDescription = "ERR_FILE_DIRECTORY_NOT_EXIST || Directory does not exist";
         break;
         case 5024 :
         errorDescription = "ERR_FILE_NOT_DIRECTORY || Specified file is not directory";
         break;
         case 5025 :
         errorDescription = "ERR_FILE_CANNOT_DELETE_DIRECTORY || Cannot delete directory";
         break;
         case 5026 :
         errorDescription = "ERR_FILE_CANNOT_CLEAN_DIRECTORY || Cannot clean directory";
         break;
         case 5027 :
         errorDescription = "ERR_FILE_ARRAYRESIZE_ERROR || Array resize error";
         break;
         case 5028 :
         errorDescription = "ERR_FILE_STRINGRESIZE_ERROR || String resize error";
         break;
         case 5029 :
         errorDescription = "ERR_FILE_STRUCT_WITH_OBJECTS || Structure contains strings or dynamic arrays";
         break;
         case 5200 :
         errorDescription = "ERR_WEBREQUEST_INVALID_ADDRESS || Invalid URL";
         break;
         case 5201 :
         errorDescription = "ERR_WEBREQUEST_CONNECT_FAILED || Failed to connect to specified URL";
         break;
         case 5202 :
         errorDescription = "ERR_WEBREQUEST_TIMEOUT || Timeout exceeded"; 
         break;
         case 5203 :
         errorDescription = "ERR_WEBREQUEST_REQUEST_FAILED || HTTP request failed";
         break;
         case 65536 :
         errorDescription = "ERR_USER_ERROR_FIRST || User defined errors start with this code";
         break;
         
         
                  
         
         
      }    

      return(errorDescription);
}