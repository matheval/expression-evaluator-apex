public class Afe_FunctionDefinition {
    //function name
    public String name;
    
    //param type holder
    public System.Type[] params;
    
    //param count
    public Integer paramCount;
    
    //return type holder
    public System.Type returnType;
    
    /**
     * Function executer interface
     */ 
    public interface IFunction{
        /**
         * Get function define info, used to validate function in expression
         */ 
        List<Afe_FunctionDefinition> getInfo();
        /**
         * Execute interface
         * @param args Function params
         * @dc Decimal context(rounding mode, scale...)
         */ 
        Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec);
    }
    
    /**
     * Function def constructor
     * @param name Function name
     * @param params Param type
     * @param returnType return datatype
     * @param paramCount param count
     */ 
    public Afe_FunctionDefinition(String name, System.Type[] params, System.Type returnType,Integer paramCount){
        this.name = name.toLowerCase();
        this.params = params;
        this.returnType = returnType;
        this.paramCount = paramCount;
    }  
    /**
     * Creates a valid date from individual year, month, and day components
     * Example:
     * DATE(2021,10,21)
     */
    public class dateFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('date', new System.Type[]{Object.class, Object.class, Object.class}, Datetime.class, 3)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return toDate(args.get('1'),args.get('2'),args.get('3'));
        }        
    } 
    
    /**
     * Converts a date represented as text into a date instance
     * Example:
     * DATEVALUE("2021-10-21")
     */
    public class datevalueFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('datevalue', new System.Type[]{String.class}, /*Date*/Datetime.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return stringToDate((String)args.get('1'));
        }        
    } 
    
    /**
     * Creates a valid datetime from individual 
     * year, month, day, hour, min, second components
     * Example:
     * DATETIME(2021,10,21, 18, 20, 0)
     */    
    public class datetimeFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
           				new Afe_FunctionDefinition(
                                        'datetime', 
                                        new System.Type[]{Object.class, Object.class, Object.class,Object.class, Object.class, Object.class},
                                        DateTime.class, 6
                                    )
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return toDateTime(args.get('1'),args.get('2'),args.get('3'),args.get('4'),args.get('5'),args.get('6'));
        }        
    } 
    
    /**
     * Converts a datetime represented as text into a datetime instance
     * Example:
     * DATETIMEVALUE("2021-10-21 18:20:00")
     */ 
    public class datetimevalueFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('datetimevalue', new System.Type[]{String.class}, DateTime.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return stringToDateTime((String)args.get('1'));
        }        
    } 
    
    /**
     * Creates a valid time from individual hour, min, second components
     * Example:
     * TIME(18, 20, 0)
     */    
    public class timeFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('time', new System.Type[]{Object.class, Object.class, Object.class}, Time.class, 3)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return toTime(args.get('1'),args.get('2'),args.get('3'));
        }        
    } 
     
    /**
     * Returns the second component of a Time, Datetime
     * SECOND(TIME(12,21,10)) -> 10
     * SECOND(DATETIME(2021,03,11,12,21,13)) -> 13
     * SECOND(DATE(2021,03,11)) -> 0
     */     
    public class secondFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
           				new Afe_FunctionDefinition('second', new System.Type[]{DateTime.class}, Decimal.class, 1),
                        new Afe_FunctionDefinition('second', new System.Type[]{Time.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.get('1') instanceof Date){
               return 0; 
            }else if(args.get('1') instanceof Datetime){
               return ((DateTime)args.get('1')).second(); 
            }else return ((Time)args.get('1')).second(); 
        }        
    }    
    
    /**
     * Returns the minute component of a Time, Datetime
     * MINUTE(TIME(12,21,10)) -> 21
     * MINUTE(DATETIME(2021,03,11,12,21,10)) -> 21
     * MINUTE(DATE(2021,03,11)) -> 0
     */       
    public class minuteFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
           				new Afe_FunctionDefinition('minute', new System.Type[]{DateTime.class}, Decimal.class, 1),
                        new Afe_FunctionDefinition('minute', new System.Type[]{Time.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.get('1') instanceof Date){
               return 0; 
            }else if(args.get('1') instanceof Datetime){
               return ((DateTime)args.get('1')).minute(); 
            }else return ((Time)args.get('1')).minute(); 
        }        
    }      
    
    /**
     * Returns the hour component of a Time, Datetime
     * HOUR(TIME(12,21,10)) -> 12
     * HOUR(DATETIME(2021,03,11,12,21,10)) -> 12
     * HOUR(DATE(2021,03,11)) -> 0
     */    
    public class hourFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
           				new Afe_FunctionDefinition('hour', new System.Type[]{DateTime.class}, Decimal.class, 1),
                        new Afe_FunctionDefinition('hour', new System.Type[]{Time.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.get('1') instanceof Date){
               return 0; 
            }else if(args.get('1') instanceof Datetime){
               return ((DateTime)args.get('1')).hour(); 
            }else return ((Time)args.get('1')).hour(); 
        }        
    }    
    
    /**
     * Returns the day-of-month component of a Datetime
     * DAY(DATEVALUE("2021-10-17")) -> 17
     */
    public class dayFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
           				new Afe_FunctionDefinition('DAY', new System.Type[]{DateTime.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((DateTime)args.get('1')).dayGmt();
        }        
    }

    /**
     * Returns the month-of-year component of a Datetime
     * MONTH(DATEVALUE("2021-10-17")) -> 10
     */
    public class monthFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('MONTH', new System.Type[]{DateTime.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((DateTime)args.get('1')).monthGmt();
        }        
    }
    
    /**
     * Returns the year component of a Datetime
     * YEAR(DATEVALUE("2021-10-17")) -> 2021
     */    
    public class yearFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('YEAR', new System.Type[]{DateTime.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((DateTime)args.get('1')).yearGmt();
        }        
    }

    /**
     * Returns the current Datetime based on a GMT calendar
     */
    public class nowFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('NOW', null, Datetime.class, 0)
                    };
        }   
        
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            return Datetime.now();           
        }        
    }
    
    /**
     * Returns the current date in the current user's time zone.
     * TODAY()
     */
    public class todayFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('TODAY', null, Datetime.class, 0)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            return Date.today();
        }        
    }
    
    /**
     * Add month to Date, Datime
     * EDATE(DATEVALUE("2008-07-13"),2) -> 2008-09-13
     * EDATE(DATEVALUE("2008-07-13")+TIME(13,20,0),2) -> 2008-09-13 04:20:00 (GMT)
     */ 
    public class edateFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('edate', new System.Type[]{Datetime.class,Decimal.class}, Datetime.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Decimal additionalMonths = (Decimal)args.get('2');
            if(args.get('1') instanceof Date){
                Date dtDate = (Date) args.get('1');
                return dtDate.addMonths(additionalMonths.intValue());
            }else{
                Datetime dtDatetime = (Datetime) args.get('1');
                return dtDatetime.addMonths(additionalMonths.intValue());            
            }
        }        
    }    
    
    /**
     * Returns the day of the week corresponding to a date. 
     * The day is given as an integer, ranging from 1 (Sunday) to 7 (Saturday)
     * WEEKDAY(DATEVALUE("2008-02-14")) -> 5
     */
    public class weekdayFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('WEEKDAY', new System.Type[]{Datetime.class}, Decimal.class, 1)
                    //new Afe_FunctionDefinition('WEEKDAY', new System.Type[]{Datetime.class, Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Date target = ((Datetime)args.get('1')).date();
			return Math.mod(Date.newInstance(1900, 1, 7).daysBetween(target),7)+1;
        }        
    }
  
    /**
     * Returns the week number of a specific date. For example, 
     * the week containing January 1 is the first week of the year, 
     * and is numbered week 1
     * WEEKNUM(DATEVALUE("2008-02-14")) -> 7
     */
    public class weeknumFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('weeknum', new System.Type[]{Datetime.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Datetime target = (Datetime)args.get('1');
			return Decimal.valueOf(target.format('w'));
        }        
    }    
    
    /**
     * Returns a number that represents a date that is the indicated number 
     * of working days before or after a date (the starting date).
     * Example:
     * WORKDAY(DATEVALUE("2021-03-30"),61) -> 2021-06-23 00:00:00
     * WORKDAY(DATEVALUE("2021-03-30"),-3.01) -> 2021-03-24 00:00:00
     */
    public class workdayFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                		new Afe_FunctionDefinition('workday', new System.Type[]{Datetime.class, Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			Date startDate = ((Datetime)args.get('1')).date();
            Integer daysAdd = (Decimal)args.get('2') >= 0 ? ((Decimal)args.get('2')).intValue() 
                : Math.Floor((Decimal)args.get('2')).intValue();
            Integer dayT = 0;
            while(dayT < Math.abs(daysAdd)){
                startDate = startDate + (daysAdd < 0 ? -1 : 1);
                DateTime currDate = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day());  
                String todayDay = currDate.format('EEEE');  
                if(                    
                    (
                    	(ec.weekends!=null && !ec.weekends.contains(todayDay.toLowerCase()))
                        || (ec.weekends ==null && todayDay.toLowerCase() != 'saturday' && todayDay !='sunday')
                    )
                   && 
                    (ec.holidays==null || (ec.holidays!=null && !ec.holidays.contains(startDate)))
                  )  
                    {  
                        dayT++;
                    }                  
            }
            return startDate;
        }        
    } 
    
    /**
     * Returns the number of whole workdays between two dates
     * NETWORKDAYS(DATEVALUE("2021-03-30"),DATEVALUE("2022-05-16")) -> 295
     */ 
    public class networkdaysFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                		new Afe_FunctionDefinition('networkdays', new System.Type[]{Datetime.class, Datetime.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Date startDate = ((Datetime)args.get('1')).date();
            Date endDate = ((Datetime)args.get('2')).date();             
            Integer workingDays = 0;  
             
            for(integer i=0; i <= startDate.daysBetween(endDate); i++)  
            {  
                Date dt = startDate + i;  
                DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
                String todayDay = currDate.format('EEEE');  
                if(
                    (
                        (ec.weekends!=null && !ec.weekends.contains(todayDay.toLowerCase()))|| 
                        (ec.weekends ==null && todayDay.toLowerCase() != 'saturday' && todayDay.toLowerCase() !='sunday')
                    )
                    &&
                    (ec.holidays==null || (ec.holidays!=null && !ec.holidays.contains(dt)))
                  )  
                    {  
                        workingDays = workingDays + 1;  
                    }     
                   
            }   
            return workingDays; 
        }        
    }    
    
    /**
     * Calculates the last day of the month after adding 
     * a specified number of months to a date, datetime
     * EOMONTH(DATE(2021,01,01),3) -> 2021-04-30
     * EOMONTH(DATETIME(2021,01,01,12,0,0),3) -> 2021-04-30
     */
    public class eomonthFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('eomonth', new System.Type[]{DateTime.class,Decimal.class}, DateTime.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Datetime dt = (Datetime) args.get('1');
            dt = dt.addMonths(((Decimal) args.get('2')).intValue());
			Integer numberOfDays = Date.daysInMonth(dt.year(), dt.month());
			return Date.newInstance(dt.year(), dt.month(), numberOfDays);	
        }        
    }   
    
    /**
     * Calculates the number of days, months, or years between two dates.
     * DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"Y") -> 8
     * DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"M") -> 102
     * DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"D") -> 3132
     * DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"YM") -> 6
	 * DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"MD") -> 29
     */
    public class datedifFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('DATEDIF', new System.Type[]{Datetime.class,Datetime.class,String.class}, Decimal.class, 3)  
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.get('1') instanceof Datetime && args.get('2') instanceof Datetime){
                return datedif(((Datetime)args.get('1')).date(),((Datetime)args.get('2')).date(),(String)args.get('3'));
            }else if (args.get('1') instanceof Date && args.get('2') instanceof Date){
                return datedif((Date)args.get('1'),(Date)args.get('2'),(String)args.get('3'));
            }
            throw new Afe_Exception();   
        }        
    } 
    
    /**
     * Returns the number of days between two dates
     * DAYS(DATEVALUE("2021-01-05"),DATEVALUE("2021-01-03")) -> 2
     */ 
    public class daysFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('days', new System.Type[]{Datetime.class,Datetime.class}, Decimal.class, 2)  
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.get('1') instanceof Datetime && args.get('2') instanceof Datetime){
                return datedif(((Datetime)args.get('2')).date(),((Datetime)args.get('1')).date(),'d');
            }else if (args.get('1') instanceof Date && args.get('2') instanceof Date){
                return datedif((Date)args.get('2'),(Date)args.get('1'),'d');
            }
            throw new Afe_Exception();   
        }        
    }     
   
    /**
     * Extracts a given number of characters from 
     * the left side of a supplied text string
     * Example:
     * LEFT("abcd",3) -> abc
     */ 
    public class leftFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('left', new System.Type[]{String.class, Decimal.class}, String.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return left((String)args.get('1'),(Decimal)args.get('2'));
        }        
    } 

    /**
     * Extracts a given number of characters from 
     * the right side of a supplied text string
     * Example:
     * RIGHT("abcd",3) -> bcd
     */     
    public class rightFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('right', new System.Type[]{String.class, Decimal.class}, String.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return right((String)args.get('1'),(Decimal)args.get('2'));
        }        
    }    

    /**
     * Extracts a given number of characters 
     * from the middle of a supplied text string
     * MID("abcd",1,2) -> ab
     */ 
    public class midFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('mid', new System.Type[]{String.class, Decimal.class, Decimal.class}, String.class, 3)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return mid((String)args.get('1'),(Decimal)args.get('2'),(Decimal)args.get('3'));
        }        
    }
    
    public class lpadFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('lpad', new System.Type[]{String.class, Decimal.class, String.class}, String.class, 3)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return leftpad((String)args.get('1'),(Decimal)args.get('2'),(String)args.get('3'));
        }        
    }    

    public class rpadFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('rpad', new System.Type[]{String.class, Decimal.class, String.class}, String.class, 3)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return rightpad((String)args.get('1'),(Decimal)args.get('2'),(String)args.get('3'));
        }        
    } 
    
    /**
     * Reverse a string
     * REVERSE("abcd") -> dcba
     */ 
    public class reverseFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('reverse', new System.Type[]{String.class}, String.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return reverse((String)args.get('1'));
        }        
    }
    
    /**
     * Check if a value is a number.
     * ISNUMBER("0.23") -> true
     * ISNUMBER("abc") -> false
     */ 
    public class isnumberFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('isnumber', new System.Type[]{Object.class}, Boolean.class, 1) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return isNumeric(args.get('1'));
        }        
    }
 	
    /**
     * Converts all letters in the specified string to lowercase
     * LOWER("aBc") -> abc
     */ 
    public class lowerFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('lower', new System.Type[]{String.class}, String.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return lower((String)args.get('1'));
        }        
    }
    
    /**
     * Converts all letters in the specified string to uppercase
     * UPPER("aBc") -> ABC
     */     
    public class upperFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('upper', new System.Type[]{String.class}, String.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return upper((String)args.get('1'));
        }        
    }
    
    /**
     * Capitalizes words given text string
     * PROPER("capitalize the first letter in each word") -> Capitalize The First Letter In Each Word
     */ 
    public class properFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('proper', new System.Type[]{String.class}, String.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return toTitleCase((String)args.get('1'));
        }        
    }    
    
    public class trimFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('trim', new System.Type[]{String.class}, String.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return trim((String)args.get('1'));
        }        
    }
    
    
    public class lenFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('len', new System.Type[]{String.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return length((String)args.get('1'));
        }        
    }
    
    /**
     * Convert a numeric value, datetime value into a text string
     * TEXT(123) -> 123 (string)
     * TEXT(DATEVALUE("2021-01-23"),"dd-MM-yyyy") -> 23-01-2021 (string)
     * TEXT(2.61,"hh:mm") -> 14:38 (string)
     * TEXT(2.61,"[hh]") -> 62 (string)
     * TEXT(0.1,"h") -> 2 (string)
     * TEXT(2.61,"[mm]") -> 3758 (string)
     * TEXT(2.61,"hh-mm-ss") -> 14-38-24 (string)
     * TEXT(DATEVALUE("2021-01-o3")-DATEVALUE("2021-01-o1"),"[h]") -> 48 (string)
     * TEXT(TIME(12,00,00)-TIME(10,30,10),"hh hours and mm minutes and ss seconds") -> "01 hours and 29 minutes and 50 seconds"
     */ 
    public class textFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('text', new System.Type[]{Object.class}, String.class, 1),
                    new Afe_FunctionDefinition('text', new System.Type[]{Object.class,String.class}, String.class, 2)    
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.size()==2){
                String pattern = (String)args.get('2');
                if(args.get('1') instanceof Time){
                    Time t = (Time)args.get('1');
                    args.put('1', Decimal.valueOf(t.hour()*60*60+t.minute()*60+t.second())/Decimal.valueOf(60*60*24));
                    return execute(args,ec);
                }else if(args.get('1') instanceof Datetime){
                    Datetime t = (Datetime)args.get('1');
                    return t.format(pattern);
                }else if(args.get('1') instanceof Decimal){
                    String ret = pattern;
                    Decimal t = (Decimal)args.get('1');
                    //hour
                    if(pattern.toLowerCase().contains('[hh]')){
                        Decimal hh = t*24;
                        ret = ret.replaceAll('\\[[hH]{2,2}\\]', String.valueOf(hh.intValue()).leftpad(2,'0'));
                    }else if(pattern.toLowerCase().contains('hh')){
                        Decimal hh = (t-t.intValue())*24;
                        ret = ret.replaceAll('[hH]{2,2}', String.valueOf(hh.intValue()).leftpad(2,'0'));
                    }else if(pattern.toLowerCase().contains('[h]')){
                        Decimal hh = t*24;
                        ret = ret.replaceAll('\\[[hH]{1,1}\\]', String.valueOf(hh.intValue()));
                    }else if(pattern.toLowerCase().contains('h')){
                        Decimal hh = (t-t.intValue())*24;
                        ret = ret.replaceAll('[hH]{1,1}', String.valueOf(hh.intValue()));
                    }
                    //minute
                    if(pattern.contains('[mm]')){
                        Decimal hh = t*24*60;
                        ret = ret.replaceAll('\\[[m]{2,2}\\]', String.valueOf(hh.intValue()).leftpad(2,'0'));
                    }else if(pattern.contains('mm')){
                        Decimal hh = ((t*24)-(t*24).intValue())*60;
                        ret = ret.replaceAll('[m]{2,2}', String.valueOf(hh.intValue()).leftpad(2,'0'));
                    }else if(pattern.contains('[m]')){
                        Decimal hh = t*24*60;
                        ret = ret.replaceAll('\\[[m]{1,1}\\]', String.valueOf(hh.intValue()));
                    }else if(pattern.contains('m')){
                        Decimal hh = ((t*24)-(t*24).intValue())*60;
                        ret = ret.replaceAll('[m]{1,1}', String.valueOf(hh.intValue()));
                    }
                    //sec
                    if(pattern.toLowerCase().contains('[ss]')){
                        Decimal hh = t*24*60*60;
                        ret = ret.replaceAll('\\[[s]{2,2}\\]', String.valueOf(hh.intValue()).leftpad(2,'0'));
                    }else if(pattern.toLowerCase().contains('ss')){
                        Decimal hh = ((t*24*60)-(t*24*60).intValue())*60;
                        ret = ret.replaceAll('[s]{2,2}', String.valueOf(hh.intValue()).leftpad(2,'0'));
                    }else if(pattern.toLowerCase().contains('[s]')){
                        Decimal hh = t*24*60*60;
                        ret = ret.replaceAll('\\[[s]{1,1}\\]', String.valueOf(hh.intValue()));
                    }else if(pattern.toLowerCase().contains('s')){
                        Decimal hh = ((t*24*60)-(t*24*60).intValue())*60;
                        ret = ret.replaceAll('[sS]{1,1}', String.valueOf(hh.intValue()));
                    }                     
                    return ret;
                }
            }
			return toString(args.get('1'));
        }        
    } 
    
    /**
     * Replaces characters specified by location 
     * in a given text string with another text string
     * REPLACE("ABC123",4,3,"456") -> ABC456
     * REPLACE("ABC123",1,3,"45") -> 45123
     * REPLACE("123-455-3321","-","") -> 1234553321
     */ 
    public class replaceFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('replace', new System.Type[]{String.class, String.class, String.class}, String.class, 3),
                    new Afe_FunctionDefinition('replace', new System.Type[]{String.class, Decimal.class, Decimal.class, String.class}, String.class, 4) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            if(args.size()==3){
            	return String.valueOf(args.get('1')).replace(String.valueOf(args.get('2')),String.valueOf(args.get('3')));  
            }else{
                String text = String.valueOf(args.get('1'));
                String left = text.substring(0, ((Decimal)args.get('2')).intValue()-1);
                String right = text.substring(((Decimal)args.get('2')).intValue() - 1 + ((Decimal)args.get('3')).intValue());
                return left+String.valueOf(args.get('4'))+right;
            }
        }        
    } 
    
    /**
     * Replaces text in a given string by matching
     * SUBSTITUTE("123-455-3321","-","") -> 1234553321
     */ 
    public class substituteFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('substitute', new System.Type[]{String.class, String.class, String.class}, String.class, 3) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            return String.valueOf(args.get('1')).replace(String.valueOf(args.get('2')),String.valueOf(args.get('3')));
        }        
    }     
    
    /**
     * Return the position of a specific character or substring within a text string (case sensitive)
     * FIND("a","ABCDabcABCabc") -> 5
     * FIND("ab","ABCDabcABCabc",6) -> 11
     */ 
    public class findFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('find', new System.Type[]{String.class, String.class, Decimal.class}, Decimal.class, 3),
                       new Afe_FunctionDefinition('find', new System.Type[]{String.class, String.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			Integer pos = find(args);
            return pos >=0 ? pos+1 : pos;            
        }        
    }
    
    /**
     * Returns the location of one text string inside another (case insensitive)
     * SEARCH("A","ABC") -> 1
     * SEARCH("A","AEHABC",4) -> 4
     */ 
    public class searchFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('search', new System.Type[]{String.class, String.class, Decimal.class}, Decimal.class, 3),
                       new Afe_FunctionDefinition('search', new System.Type[]{String.class, String.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			Integer pos = searchFunc(args);
            return pos >=0 ? pos+1 : pos;
        }        
    }         
    
    /**
     * Combines the text from multiple strings
     * CONCAT("A","B","C") -> ABC
     */ 
    public class concatFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('concat', new System.Type[]{Object.class}, String.class, -1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){   
           String value = '';
           for(Object obj:args.values()){
               value += String.valueOf(obj);
           }
           return value;
        }        
    }
    
    /**
     * Returns TRUE when a given string is null or empty, otherwise return FALSE
     * ISBLANK("") -> TRUE
     */ 
    public class isblankFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('isblank', new System.Type[]{Object.class}, Boolean.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){   
           return args.get('1') == null || String.valueOf(args.get('1')).equals('');
        }        
    }
    
    /**
     * Repeats characters a given number of times
     * REPT("x",5) -> xxxxx
     */ 
    public class reptFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('rept', new System.Type[]{String.class, Decimal.class}, String.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){ 
            String temp='';
            for(Integer i = 1; i <= ((Decimal)args.get('2')).intValue() ; i++ ){
                temp += String.valueOf(args.get('1'));
            }
            return temp;
        }        
    }
    
    /**
     * Return character from ascii code
     * CHAR(97) -> a
     */ 
    public class charFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('char', new System.Type[]{Decimal.class}, String.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){ 
              return String.fromCharArray( 
                new List<integer> {((Decimal)args.get('1')).intValue()}
              );
        }        
    }    
    
    /**
     * Returns a ascii code for a  character
     * CODE("a") -> 97
     */ 
    public class codeFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('code', new System.Type[]{String.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){ 
            return String.valueOf(args.get('1')).charAt(0);
        }        
    }      
    
    /**
     * BITAND(13,25) -> 9
     */ 
    public class bitandFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bitand', new System.Type[]{Decimal.class,Decimal.class}, Boolean.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((Decimal)args.get('1')).intValue() & ((Decimal)args.get('2')).intValue();
        }        
    }    

    /**
     * BITOR(23,10) -> 31
     */ 
    public class bitorFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bitor', new System.Type[]{Decimal.class,Decimal.class}, Boolean.class, 2) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((Decimal)args.get('1')).intValue() | ((Decimal)args.get('2')).intValue();
        }        
    }
    
    /**
     * BITXOR(5,3) -> 6
     */ 
    public class bitxorFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bitxor', new System.Type[]{Decimal.class,Decimal.class}, Boolean.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((Decimal)args.get('1')).intValue() ^ ((Decimal)args.get('2')).intValue();
        }        
    }
    
    /**
     * BITNOT(6)
     */    
    public class bitnotFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bitnot', new System.Type[]{Decimal.class}, Boolean.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ~((Decimal)args.get('1')).intValue();
        }        
    }
    
    /**
     * BITLSHIFT(4,2) -> 16
     */
    public class bitlshiftFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bitlshift', new System.Type[]{Decimal.class,Decimal.class}, Boolean.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((Decimal)args.get('1')).intValue() << ((Decimal)args.get('2')).intValue();
        }        
    }
    
    /**
     * BITRSHIFT(13,2) -> 3
     */ 
    public class bitrshiftFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bitrshift', new System.Type[]{Decimal.class,Decimal.class}, Boolean.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return ((Decimal)args.get('1')).intValue() >> ((Decimal)args.get('2')).intValue();
        }        
    }
    
    /**
     * Convert text to a numeric value
     * VALUE("123") -> 123
     * VALUE(123) -> 123
     */ 
    public class valueFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('value', new System.Type[]{Object.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Decimal.valueOf(String.valueOf(args.get('1'))),ec);
        }        
    }
    
    public class boolFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('bool', new System.Type[]{String.class}, Boolean.class, 1),
                    new Afe_FunctionDefinition('bool', new System.Type[]{Decimal.class}, Boolean.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return toBool(args.get('1'));
        }        
    }
    
    /**
     * Logical and function
     * AND(2>1,3<9/2) -> true
     * IF(AND(2>1,3<9/2),1,2) -> 1
     */ 
    public class andFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('and', new System.Type[]{Boolean.class}, Boolean.class, -1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return logicalAnd(args);
        }        
    }
    
    /**
     * Logical or function
     * OR(2>1,3>9/2) -> true
     * IF(OR(2>1,3>9/2),1,2) -> 1
     */     
    public class orFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('or', new System.Type[]{Boolean.class}, Boolean.class, -1) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return logicalOr(args);
        }        
    }
    
    /**
     * Logical xor function
     * XOR(2>1,3<9/2) -> false
     * XOR(2>1,3<9/2,6<10) -> true
     * XOR(2>1,3<9/2,6<10,100<200) -> false
     */    
    public class xorFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('xor', new System.Type[]{Boolean.class}, Boolean.class, -1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return logicalXor(args);
        }        
    }
    
    /**
     * Logical not function
     * NOT(true) -> false
     */    
    public class notFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('not', new System.Type[]{Boolean.class}, Boolean.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            return !((Boolean)args.get('1'));
        }        
    }
    
    /**
     * SUM(1,2,3) -> 6
     * new Afe_Evaluator('SUM(abc)').bind('abc',new List<Decimal>{1,2,3}).eval() -> 6
     */ 
    public class sumFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('sum', new System.Type[]{Decimal.class}, Decimal.class, -1),
                       new Afe_FunctionDefinition('sum', new System.Type[]{Object.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
             if(
                args.size()== 1 
                && args.get('1') instanceof List<Object>
               ){
                return round(sum((List<Object>)args.get('1')),ec); 
             }         
             return round(sum(args),ec);
        }        
    }
    
    /**
     * MIN(1,2,3) -> 1
     * new Afe_Evaluator('MIN(abc)').bind('abc',new List<Decimal>{1,2,3}).eval() -> 1
     */     
    public class minFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('min', new System.Type[]{Decimal.class}, Decimal.class, -1),
                       new Afe_FunctionDefinition('min', new System.Type[]{Object.class}, Decimal.class, 1) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
             if(
                 args.size()== 1 
                 && args.get('1') instanceof List<Object>
             ){
                return min((List<Object>)args.get('1')); 
             }         
             return min(args);
        }        
    }
    
    /**
     * MAX(1,2,3) -> 3
     * new Afe_Evaluator('MAX(abc)').bind('abc',new List<Decimal>{1,2,3}).eval() -> 3
     */     
    public class maxFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('max', new System.Type[]{Decimal.class}, Decimal.class, -1),
                       new Afe_FunctionDefinition('max', new System.Type[]{Object.class}, Decimal.class, 1) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
             if(
                 args.size()== 1 
                 && args.get('1') instanceof List<Object>
             ){
                return max((List<Object>)args.get('1')); 
             }         
             return max(args);
        }        
    } 
    
    /**
     * average(1,2,3) -> 2
     * new Afe_Evaluator('average(abc)').bind('abc',new List<Decimal>{1,2,3}).eval() -> 2
     */     
    public class averageFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('average', new System.Type[]{Decimal.class}, Decimal.class, -1),
                       new Afe_FunctionDefinition('average', new System.Type[]{Object.class}, Decimal.class, 1) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
         if(
             args.size()== 1 
             && args.get('1') instanceof List<Object>
         ){
            return round(avg((List<Object>)args.get('1')),ec); 
         }         
         return round(avg(args),ec);
        }        
    } 
    
    /**
     * Returns the trigonometric sine of the angle given in radians
     * SIN(PI()/2) -> 1
     */ 
    public class sinFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('sin', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.sin((Decimal)args.get('1')),ec);
        }        
    } 
    
    /**
     * Returns the hyperbolic sine of a number
     * SINH(PI()/2) -> ~2.301298
     */     
    public class sinhFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('sinh', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.sinh((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the arc sine of an angle, 
     * in the range of -pi/2 through pi/2
     * ASIN(0.5) -> ~0.523599
     */      
    public class asinFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('asin', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.asin((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the trigonometric cos of the angle given in radians
     * COS(PI()) -> -1
     */     
    public class cosFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('cos', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.cos((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the hyperbolic cos of a number
     * COSH(4) -> 27.308233
     */ 
    public class coshFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('cosh', new System.Type[]{Decimal.class}, Decimal.class, 1) 
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.cosh((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the arc cosine of an angle, in the range of 0.0 through pi
     */ 
    public class acosFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('acos', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.acos((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the tangent of the angle given in radians
     */ 
    public class tanFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('tan', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.tan((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the hyperbolic tangent of a number
     * TANH(0) -> 0
     * TANH(-2) -> -0.964
     */ 
    public class tanhFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('tanh', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.tanh((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the arc tangent of an angle
     */ 
    public class atanFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('atan', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.atan((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the arctangent from x- and y-coordinates
     */ 
    public class atan2Function implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	 new Afe_FunctionDefinition('atan2', new System.Type[]{Decimal.class,Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.atan2((Decimal)args.get('1'),(Decimal)args.get('2')),ec);
        }        
    }
    
    /**
     * SQRT(16) -> 4
     * SQRT(16.32) -> ~ 4.039802
     */ 
    public class sqrtFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('sqrt', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.sqrt((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * LN(10) -> ~2.302585
     * LN(e) -> 1
     */ 
    public class lnFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('ln', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.log((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * LOG10(10^5) -> 5
     * LOG10(86) -> ~ 1.934498
     */ 
    public class log10Function implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('log10', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(Math.log10((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * MOD(11,2) -> 1
     * MOD(6.25,1) -> 0.25
     * MOD(100,33) -> 1
     */ 
    public class modFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('mod', new System.Type[]{Decimal.class,Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			return round(mod(args.get('1'),args.get('2')),ec);
        }        
    }
    
    /**
     * POWER(4,2.1) ~ 18.379174
     * POWER(2,8) -> 256
     * POWER(-2,2) -> 4
     */ 
    public class powerFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('power', new System.Type[]{Decimal.class,Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			 return round(Math.pow((Double)args.get('1'),(Double)args.get('2')),ec);
        }        
    }
    
    /**
     * RAND()
     */ 
    public class randFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('rand', null, Decimal.class, 0)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			 return round(Math.random(),ec);
        }        
    }
    
    /**
     * Rounds a given number away from zero, to the nearest multiple of a given number
     * CEILING(2.1) -> 3
     * CEILING(2.5, 1) -> 3
     * CEILING(-2.5, -2) -> -4
     */ 
    public class ceilingFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('ceiling', new System.Type[]{Decimal.class}, Decimal.class, 1),
                       new Afe_FunctionDefinition('ceiling', new System.Type[]{Decimal.class,Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			 return ceiling(args);
        }        
    }
    
    /**
     * Rounds a given number towards zero to the nearest multiple of a specified significance
     * FLOOR(3.7) -> 3
     * FLOOR(3.7,2) -> 2
     * FLOOR(1.58,0.1) -> 1.5
     * FLOOR(0.234,0.01) -> 0.23
     * FLOOR(-2.5,-2) -> -2
     */ 
    public class floorFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                       new Afe_FunctionDefinition('floor', new System.Type[]{Decimal.class}, Decimal.class, 1),
                       new Afe_FunctionDefinition('floor', new System.Type[]{Decimal.class,Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  return floor(args);
        }        
    }
    
    /**
     * Returns the rounded approximation of given number using half-even rounding mode
     * ROUND(20.085537,2) -> 20.09
     * ROUND(20.085537,4) -> 20.0855
     * ROUND(20126.08,-1) -> 20130
     */    
    public class roundFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('round', new System.Type[]{Decimal.class,Decimal.class}, Decimal.class, 2)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  return roundManualScale((Decimal)args.get('1'),(Decimal)args.get('2'),ec);
        }        
    }
    
    /**
     * Returns e raised to the power of number.
     * EXP(3) -> ~20.085537
     */ 
    public class expFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('exp', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  return round(Math.exp((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the absolute value of a number
     * ABS(-1.1) -> 1.1
     * ABS(1.1) -> 1.1
     */ 
    public class absFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('abs', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  return round(Math.abs((Decimal)args.get('1')),ec);
        }        
    }
    
    /**
     * Returns the factorial of a given number
     * FACT(8) -> 40320
     */ 
    public class factFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('fact', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  return fact(((Decimal)args.get('1')).intValue());
        }        
    }  

    /**
     * PI() -> ~3.141593
     */ 
    public class piFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('pi', null, Decimal.class, 0)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  return round(Math.PI,ec);
        }        
    }     
    
    /**
     * RADIANS(180.5) -> ~3.150319
     */     
    public class radiansFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('radians', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
              Decimal v180 = Decimal.valueOf('180');            
			  return round((Decimal)args.get('1') * (Math.PI / v180),ec);
        }        
    } 
    
    /**
     * DEGREES(PI()) -> 180
     */ 
    public class degreesFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('degrees', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
              //Decimal v180 = Decimal.valueOf('180');
			  return round((Decimal)args.get('1') * (180 / Math.PI),ec);
        }        
    }     
    
    /**
     * SEC(PI()/6) -> ~ 1.1547
     */ 
    public class secFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('sec', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Decimal one = Decimal.valueOf('1');
            if(ec.dc!=null){
               return one.divide(Math.cos((Decimal)args.get('1')), ec.dc.precision, ec.dc.rd); 
            }else{
               return one/Math.cos((Decimal)args.get('1'));  
            }
              
        }        
    } 
    
    /**
     * CSC(PI()/6) -> ~2
     */ 
    public class cscFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('csc', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			  //return 1/Math.sin((Decimal)args.get('1'));
            Decimal one = Decimal.valueOf('1');
            if(ec.dc!=null){
               return one.divide(Math.sin((Decimal)args.get('1')), ec.dc.precision, ec.dc.rd); 
            }else{
               return one/Math.sin((Decimal)args.get('1'));  
            }            
        }        
    }    
    
    /**
     * COT(PI()/6) -> 1.73205
     */ 
    public class cotFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('cot', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			 // return 1/Math.tan((Decimal)args.get('1'));
            Decimal one = Decimal.valueOf('1');
            if(ec.dc!=null){
               return one.divide(Math.tan((Decimal)args.get('1')), ec.dc.precision, ec.dc.rd); 
            }else{
               return one/Math.tan((Decimal)args.get('1'));  
            }            
        }        
    }    
	
    /**
     * Returns the cotangent of an angle given in radians
     * ACOT(PI()/6) -> ~1.088448
     */ 
    public class acotFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('acot', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
			 // return Math.atan(1/(Decimal)args.get('1'));
              Decimal one = Decimal.valueOf('1');
              return round(Math.atan(one/(Decimal)args.get('1')),ec);				 
        }        
    }
    
    /**
     * COTH(PI()/6) -> ~2.081283
     */     
    public class cothFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('coth', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
            Decimal one = Decimal.valueOf('1');
            if(ec.dc!=null){
               return one.divide(Math.tanh((Decimal)args.get('1')), ec.dc.precision, ec.dc.rd); 
            }else{
               return one/Math.tanh((Decimal)args.get('1'));  
            }            
        }        
    }    
    
    /**
     * INT(123.4) -> 123
     */     
    public class intFunction implements IFunction{
        public List<Afe_FunctionDefinition> getInfo(){
            return new List<Afe_FunctionDefinition>{
                	new Afe_FunctionDefinition('int', new System.Type[]{Decimal.class}, Decimal.class, 1)
                    };
        }     
        public Object execute(Map<String, Object> args, Afe_Evaluator.EvalContext ec){
              return ((Decimal)args.get('1')).intValue();				 
        }        
    }      
    
    //date time functions
    public static Date toDate(Object year, Object month, Object day){
        return date.newinstance(
            Integer.valueOf(String.valueOf(year)),
            Integer.valueOf(String.valueOf(month)),
            Integer.valueOf(String.valueOf(day))
        );
    }
    
    
    public static Date stringToDate(String value){
        Date parsedDate;
        try{
            parsedDate = Date.parse(value);
        }catch(Exception e){
            parsedDate = Date.valueOf(value);
        }
        return parsedDate;
    }    
    
    public static DateTime toDateTime(Object year, Object month, Object day, Object h, Object m, Object s){
        return DateTime.newinstance(
            year instanceof Decimal ? ((Decimal)year).intValue() : (Decimal.valueOf(String.valueOf(year))).intValue(),
            month instanceof Decimal ? ((Decimal)month).intValue() : (Decimal.valueOf(String.valueOf(month))).intValue(),
            day instanceof Decimal ? ((Decimal)day).intValue() : (Decimal.valueOf(String.valueOf(day))).intValue(),
            h instanceof Decimal ? ((Decimal)h).intValue() : (Decimal.valueOf(String.valueOf(h))).intValue(),
            m instanceof Decimal ? ((Decimal)m).intValue() : (Decimal.valueOf(String.valueOf(m))).intValue(),
            s instanceof Decimal ? ((Decimal)s).intValue() : (Decimal.valueOf(String.valueOf(s))).intValue()    
           /* Integer.valueOf(String.valueOf(year)),
            Integer.valueOf(String.valueOf(month)),
            Integer.valueOf(String.valueOf(day)),
            Integer.valueOf(String.valueOf(h)),
            Integer.valueOf(String.valueOf(m)),
            Integer.valueOf(String.valueOf(s))*/
        );
    }  
    
    public static DateTime stringToDateTime(String value){
        DateTime parsedDatetime;
        try{
            parsedDatetime = DateTime.parse(value);
        }catch(Exception e){
            parsedDatetime = DateTime.valueOf(value);
        }
        return parsedDatetime;
    }     
    public static Time toTime(Object h, Object m, Object s){
        return Time.newinstance(
            h instanceof Decimal ? ((Decimal)h).intValue() : (Decimal.valueOf(String.valueOf(h))).intValue(),
            m instanceof Decimal ? ((Decimal)m).intValue() : (Decimal.valueOf(String.valueOf(m))).intValue(),
            s instanceof Decimal ? ((Decimal)s).intValue() : (Decimal.valueOf(String.valueOf(s))).intValue(),
            0
        );
    }  
    
    public static Integer datedif(Date startDate, Date endDate, String unit){
        if(unit!=null && unit.toLowerCase().equals('d')){
            return startDate.daysBetween(endDate);
        }else if(unit!=null && unit.toLowerCase().equals('m')){
            Integer monthDiff = startDate.monthsBetween(endDate);
            if (endDate.day() < startDate.day()) monthDiff--;
            return monthDiff;
        }else if(unit!=null && unit.toLowerCase().equals('y')){
            Integer monthDiff = startDate.monthsBetween(endDate);
            if (endDate.day() < startDate.day()) monthDiff--;            
            return Decimal.valueOf(monthDiff/12).intValue();
        }else if(unit!=null && unit.toLowerCase().equals('ym')){
            Date stDate = startDate;
            Integer yearDiff = datedif(startDate, endDate, 'y');
            stDate= stDate.addYears(yearDiff);
            return datedif(stDate, endDate, 'm');
        }else if(unit!=null && unit.toLowerCase().equals('yd')){
            Date stDate = startDate;
            Integer yearDiff = datedif(startDate, endDate, 'y');
            stDate= stDate.addYears(yearDiff);
            return datedif(stDate, endDate, 'd');
        }else if(unit!=null && unit.toLowerCase().equals('md')){
            Date stDate = startDate;
            Integer mDiff = datedif(startDate, endDate, 'm');
            stDate= stDate.addMonths(mDiff);
            return datedif(stDate, endDate, 'd');
        }
        throw new Afe_Exception('Please set M or D or Y for UNIT param'); 
    }

 
    
   // left(STRING,COUNT)
   public static String left(String stringValue,Decimal count) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.left(count.intValue());
       }
       return '';
   }
    
   public static String right(String stringValue,Decimal count) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.right(count.intValue());
       }
       return '';
   }
    
   public static String mid(String stringValue, Decimal index,Decimal length) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.mid(index.intValue()-1,length.intValue());
       }
       return '';
   }
    
   public static String leftPad(String stringValue, Decimal length,String padString) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.leftPad(length.intValue(), padString);
       }
       return '';
   } 
    
   public static String rightPad(String stringValue, Decimal length,String padString) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.rightPad(length.intValue(), padString);
       }
       return '';
   }
    
   public static String reverse(String stringValue) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.reverse();
       }
       return '';
   }
    
   public static String lower(String stringValue) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.toLowerCase();
       }
       return '';
   }
    
   public static String upper(String stringValue) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.toUpperCase();
       }
       return '';
   }
    
   public static String trim(String stringValue) {
       if(stringValue!=null && !stringValue.equals('')){
           return stringValue.trim();
       }
       return '';
   }
     
   public static String toTitleCase(String phrase){
        //https://salesforce.stackexchange.com/questions/205076/how-to-set-data-from-all-upper-or-all-lower-case-to-a-camel-case-and-proper-case
        String titlePhrase = '';
        Set<String> forceLower = new Set<String>{};
            
            if(phrase != null && phrase.length() > 0){
                String[] splitPhrase = phrase.trim().split(' ');
                
                for(integer i = 0; i < splitPhrase.size(); i++){
                    if(!forceLower.contains(splitPhrase[i].toLowerCase()) || i == 0 || i == (splitPhrase.size()-1) ){
                        titlePhrase += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
                    }else{
                        titlePhrase += splitPhrase[i].toLowerCase()+' ';
                    }
                }
            }
        return titlePhrase.trim();
    }    
    
   public static Boolean isNumeric (Object value) {
        String stringValue = String.valueOf(value);
        Boolean isNumeric = true;
        Pattern MyPattern = Pattern.compile('^(-?)(0|([1-9][0-9]*))(\\.[0-9]+)?$');    
        Matcher MyMatcher = MyPattern.matcher(stringValue);    
        if (!MyMatcher.matches()) 
        {
            isNumeric = false;
        }
        return isNumeric;
   } 
    
   public static Integer length(Object value) {
       return String.valueOf(value).length();
   }
    
   public static Integer find(Map<String, Object> args) {
       if(args.size()==2){
           return String.valueOf(args.get('2')).indexOf(String.valueOf(args.get('1')));
       }else{
           return String.valueOf(args.get('2')).indexOf(
               String.valueOf(args.get('1')),
               ((Decimal)args.get('3')).intValue() - 1
           );
       }
   }

   public static Integer searchFunc(Map<String, Object> args) {
       if(args.size()==2){
           return String.valueOf(args.get('2')).toLowerCase().indexOf(String.valueOf(args.get('1')).toLowerCase());
       }else{
           return String.valueOf(args.get('2')).toLowerCase().indexOf(
               String.valueOf(args.get('1')).toLowerCase(),
               ((Decimal)args.get('3')).intValue() - 1
           );
       }
   }
    
   //STRING(number)
   public static String toString(Object value) {
       if(value instanceof Decimal){
          return ((Decimal)value).toPlainString(); 
       }
       return String.valueOf(value);
   }

   //BOOL(string)
   public static Boolean toBool(Object value) {
       if(value instanceof Decimal){
           return (Decimal)value==1?true:false;
       }else if(value instanceof String && (String.valueOf(value).equals('1') || String.valueOf(value).equals('0'))){
          return String.valueOf(value).equals('1')?true:false; 
       }
       throw new Afe_Exception('Check argument for method '+'BOOL(), expect 1 or 0'); 
   }    
   //AND(condition1, condition2,...)
   public static Boolean logicalAnd(Map<String, Object> args) {
       for(Object obj:args.values()){
           if(Boolean.valueOf(obj)==false){
               return false;
           }
       }
       return true;
   } 
    
   public static Boolean logicalOr(Map<String, Object> args) {
       for(Object obj:args.values()){
           if(Boolean.valueOf(obj)==true){
               return true;
           }
       }       
       return false;
   } 
    
   public static Boolean logicalXor(Map<String, Object> args) {
       if(args.size()<2){
           throw new Afe_Exception('Too few agrument for method '+'XOR'); 
       }else if(args.size()==2){
           return Boolean.valueOf(args.get('1')) ^ Boolean.valueOf(args.get('2')); 
       }else{
           integer trueCount = 0;
           for(Object obj:args.values()){
               if(Boolean.valueOf(obj)==true){
                   trueCount++;
               }
           } 
           return (trueCount > 0 && math.mod(trueCount,2) == 1);
       }
   }     
       
    
   public static Decimal sum(Map<String, Object> args) {
       Decimal sum = 0;
       for(Object obj:args.values()){
		   sum += (Decimal)obj;
       }
       return sum;
   }    
    
   public static Decimal sum(List<Object> arg) {
       Decimal sum = 0;
       for(Object obj:arg){
           if(!(obj instanceof double)){
               throw new Afe_Exception('SUM of list requires number element'); 
           }
		   sum += (Decimal)obj;
       }
       return sum;
   }   

   public static Object min(Map<String, Object> args) {
       Object minEntry = null;
       for(Object obj:args.values()){
           if (minEntry == null || (Decimal)obj < (Decimal)minEntry) {
              minEntry = obj;
           }           
       }
       return minEntry;
   }    
    
   public static Object min(List<Object> arg) {
       Object minEntry = null;
       for(Object obj:arg){
           if(!(obj instanceof double)){
               throw new Afe_Exception('MIN of list requires number element'); 
           }
		  // min+=Double.valueOf(obj);
           if (minEntry == null || (Decimal)obj < (Decimal)minEntry) {
              minEntry = obj;
           }		  
       }
       return minEntry;
   }

   public static Object max(Map<String, Object> args) {
       Object maxEntry = null;
       for(Object obj:args.values()){
           if (maxEntry == null || (Decimal)obj > (Decimal)maxEntry) {
              maxEntry = obj;
           }           
       }
       return maxEntry;
   }    
    
   public static Object max(List<Object> arg) {
       Object maxEntry = null;
       for(Object obj:arg){
           if(!(obj instanceof double)){
               throw new Afe_Exception('MIN of list requires number element'); 
           }
		  // min+=Double.valueOf(obj);
           if (maxEntry == null || (Decimal)obj > (Decimal)maxEntry) {
              maxEntry = obj;
           }		  
       }
       return maxEntry;
   }
    
   public static Decimal avg(Map<String, Object> args) {
       Decimal sum = 0;
       for(Object obj:args.values()){
           if(!(obj instanceof double)){
               throw new Afe_Exception('Check argument for method '+'AVG'); 
           }
		   sum+= (Decimal) obj;
       }
       return sum/args.size();
   }    
    
   public static Decimal avg(List<Object> arg) {
       Decimal sum = 0;
       for(Object obj:arg){
           if(!(obj instanceof double)){
               throw new Afe_Exception('AVG of list requires number element'); 
           }
		   sum+=(Decimal)obj;
       }
       return sum/arg.size();
   }    
    
    
   public static Decimal mod(Object left, Object right){
       if(left instanceof Decimal && right instanceof Decimal){
           Decimal leftDecimal = (Decimal) left;
           Decimal rightDecimal = (Decimal) right;
           Decimal quotient = Math.Floor(leftDecimal / rightDecimal);
           return leftDecimal - (rightDecimal * quotient);
       } 
       throw new Afe_Exception('Remainder operator can be only apply for integer/long');        
   }
    
   public static Decimal ceiling(Map<String, Object> args){
       if(args.size()==1){
			return Math.ceil((Decimal)args.get('1'));
       }else{
         return Math.ceil((Decimal)args.get('1') / (Decimal)args.get('2')) * (Decimal)args.get('2');           
       }        
   }   
   
   /**
    * floor
    */ 
   public static Decimal floor(Map<String, Object> args){
       if(args.size()==1){
			return Math.floor((Decimal)args.get('1'));
       }else{
         return Math.floor((Decimal)args.get('1') / (Decimal)args.get('2')) * (Decimal)args.get('2');           
       }        
   }     
   
   /**
    * Calculate fact
    * @param n 
    */ 
   public static long fact(final Integer n) {
        if (n < 0){
            return 0;
        }
        return (n < 2) ? 1 : n * fact(n - 1);
   }
    
   /**
    * rounding decimal number with specific scale
    * @param value decimal number to be rounded
    * @param digit scale number
    * @param dc Decimal context
    */     
   public static Decimal roundManualScale(Decimal value, Decimal digit, Afe_Evaluator.EvalContext ec){
       if(ec.dc != null){
          return value.setScale(digit.intValue(), ec.dc.rd); 
       }else{
          return value.setScale(digit.intValue(), RoundingMode.HALF_EVEN);  
       }
   } 
    
   /**
    * rounding decimal number
    * @param value decimal number to be rounded
    * @param dc Decimal context
    */ 
   public static Decimal round(Decimal value, Afe_Evaluator.EvalContext ec){
		//return ec.dc!=null ? value.setScale(ec.dc.precision, ec.dc.rd) : value;
		Integer precision = ec.dc.precision;
        System.debug('scale:'+precision);
		RoundingMode roundingMode = ec.dc.rd;
		Integer numToChop = value.precision() - precision;
        System.debug('numToChop:'+numToChop);
		if (precision == 0 || numToChop <= 0) {
			return value;
		}
		Decimal div = Math.pow(10, Math.min(33 - precision, numToChop));
        System.debug('div:'+div);
		Integer scale = Math.min(33, Math.max(-33, value.scale()));
       	System.debug('scale2:'+scale);
		Decimal rounded = value.divide(div, scale, roundingMode);
        System.debug('rounded:'+rounded);
		rounded = rounded * div;
		return rounded;
   }  
    
   /**
    * stripTrailingZeros
    * @param value Decimal instance of object
    * @return decimal
    */ 
   public static Decimal stripTrailingZeros(Object value){
        Decimal resultDec = (Decimal)value;
        if(resultDec==0){
           return Decimal.valueOf(0);
        }
        resultDec = resultDec.stripTrailingZeros();
        //if(resultDec.scale()<0){
        	//return resultDec.setScale(0);
        //}
        return resultDec;
   }    
    
   /**
    * get Object type
    * @param o instance of object
    * @return String type of object
    */ 
   public static string getType(Object o) {
        if(o==null) return '';              
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  
        if(o instanceof Double)             return 'Double';   
        if(o instanceof List<object>)       return 'List';
        return 'Object';
      }
}