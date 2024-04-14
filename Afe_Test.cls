@isTest
public class Afe_Test {
    public class TestOperator extends Afe_Parser.AbstractBinOperator {
            public TestOperator(String op,Integer precedence){
                super(op,precedence);
            }             
            public Object calculate(Object left, Object right,Afe_Evaluator.EvalContext ec){
			  return 333;
            }
        }   
    public class TestUnaryOperator extends Afe_Parser.AbstractUnaryOperator {
            public TestUnaryOperator(String op,Integer precedence){
                super(op,precedence);
            }             
            public override Object calculate(Object left, Object right,Afe_Evaluator.EvalContext ec){
			  return 333;
            }
        }    
    @isTest static void testOpPlus() {
        System.assertEquals(4.5,new Afe_Evaluator('1+3.5').evalNumber());
        System.assertEquals('helloword',new Afe_Evaluator('"hello"+"word"').evalString(false));
        System.assertEquals('hello1.5',new Afe_Evaluator('"hello"+1.5').evalString(false));
        System.assertEquals('1.5hello',new Afe_Evaluator('1.5+"hello"').evalString(true));
        System.assertEquals(Time.newInstance(20, 20, 0, 0),
                            new Afe_Evaluator('TIME(10,10,0)+TIME(10,10,0)').eval()); 
        System.assertEquals(DateTime.newInstance(2021,03,30, 22, 10, 36),
                            new Afe_Evaluator('DATE(2021,03,30)+TIME(22,10,36)').eval());  
        System.assertEquals(DateTime.newInstance(2021,02,28, 15, 50, 0),
                            new Afe_Evaluator('DATETIME(2021,2,26,15,50,0)+2').eval());  
        //System.assertEquals(Date.newInstance(2021,02,28),
        //                    new Afe_Evaluator('DATE(2021,2,26)+2').eval());        
    }
     
    
    @isTest static void testOpConcat() {
        System.assertEquals('helloword',new Afe_Evaluator('"hello"&"word"').evalString(false));
        System.assertEquals('hello123',new Afe_Evaluator('"hello"&123').evalString(false));        
    }

    @isTest static void testOpSubtract() {
       System.assertEquals(-2.5,new Afe_Evaluator('1-3.5').evalNumber());
       System.assertEquals(Time.newInstance(1, 8, 0, 0),
                            new Afe_Evaluator('TIME(10,10,0)-TIME(9,2,0)').eval());   
       System.assertEquals(6.701389,////////////////////so le
                            new Afe_Evaluator('DATETIME(2021,2,28,15,50,0)-DATETIME(2021,2,21,23,0,0)').setPrecision(7).evalNumber());   
        System.assertEquals(DateTime.newInstance(2021,02,28, 13, 40, 0),
                            new Afe_Evaluator('DATETIME(2021,2,28,15,50,0)-TIME(2,10,0)').eval());  
        System.assertEquals(DateTime.newInstance(2021,02,26, 15, 50, 0),
                            new Afe_Evaluator('DATETIME(2021,2,28,15,50,0)-2').eval());  
        //System.assertEquals(Date.newInstance(2021,02,26),
        //                    new Afe_Evaluator('DATE(2021,2,28)-2').eval());          
    }  
    

    @isTest static void testOpMul() {
        Afe_Evaluator t = new Afe_Evaluator();
		t.setExpression('2.4*3');
        System.assertEquals(7.2,t.evalNumber());
        t.setExpression('2.4*-3.33');
        System.assertEquals(-7.992,t.evalNumber());        
    }
    
    
    @isTest static void testOpDiv() {
        System.assertEquals(-0.720720720720721,
                            new Afe_Evaluator('2.4/-3.33').evalNumber());
        System.assertEquals(2,
                            new Afe_Evaluator('6/3').evalNumber());        
    }  

 
    
    @isTest static void testOpPower() {
        System.assertEquals(0.102,
                            new Afe_Evaluator('2^-3.3').setPrecision(3).evalNumber());
        System.assertEquals(8,
                            new Afe_Evaluator('2^3').evalNumber());        
    }
     

    @isTest static void testOpMod() {
        System.assertEquals(2,
                            new Afe_Evaluator('2%3').evalNumber());
        System.assertEquals(1,
                            new Afe_Evaluator('21%20').evalNumber());        
    }  
    

    @isTest static void testOpGe1() {
        System.assertEquals(true,
                            new Afe_Evaluator('a >= 1.23').bind('a', 1.23).eval());
        System.assertEquals(true,
                            new Afe_Evaluator('a >= 1.23').bind('a', 1.24).eval());  
        System.assertEquals(false,
                            new Afe_Evaluator('a >= 1.23').bind('a', 1.22).eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('true >= false').eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('a >= "abc"').bind('a', 'abc').eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('a >= "axyz"').bind('a', 'bxyz').eval());        
    }
    
    @isTest static void testOpGe2() {

        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,10) >= TIME(10,10,10)').eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,10) >= TIME(10,10,9)').eval());   
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,10) >= TIME(10,10,11)').eval());    
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) >= DATETIME(2021,11,01,10,10,11)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) >= DATETIME(2021,11,01,10,10,10)').eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) >= DATETIME(2021,11,01,10,10,9)').eval());         
    }      
   

    @isTest static void testOpGt1() {
        System.assertEquals(false,
                            new Afe_Evaluator('a > 1.23').bind('a', 1.23).eval());
        System.assertEquals(true,
                            new Afe_Evaluator('a > 1.23').bind('a', 1.24).eval());
        System.assertEquals(true,
                            new Afe_Evaluator('true > false').eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('true > false').eval()); 
        System.assertEquals(false,
                            new Afe_Evaluator('a > "abc"').bind('a', 'abc').eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('a > "axyz"').bind('a', 'bxyz').eval());        
    }


    @isTest static void testOpGt2() {
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,10) > TIME(10,10,10)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,10) > TIME(10,10,9)').eval()); 
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,10) > TIME(10,10,11)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) > DATETIME(2021,11,01,10,10,11)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) > DATETIME(2021,11,01,10,10,10)').eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) > DATETIME(2021,11,01,10,10,9)').eval());        
    } 
            
    @isTest static void testOpLe1() {
        System.assertEquals(true,
                            new Afe_Evaluator('a <= 1.23').bind('a', 1.23).eval());
        System.assertEquals(true,
                            new Afe_Evaluator('a <= 1.23').bind('a', 1.22).eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('a <= "abc"').bind('a', 'abc').eval());  
        System.assertEquals(true,
                            new Afe_Evaluator('a <= "bxyz"').bind('a', 'a123').eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,10) <= TIME(10,10,10)').eval());        
    } 
    

    
    @isTest static void testOpLe6() {
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,9) <= TIME(10,10,10)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,11) <= TIME(10,10,10)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,11) <= DATETIME(2021,11,01,10,10,10)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) <= DATETIME(2021,11,01,10,10,10)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,9) <= DATETIME(2021,11,01,10,10,10)').eval());        
    }    


	@isTest static void testOpLt1() {
        System.assertEquals(false,
                            new Afe_Evaluator('a < 1.23').bind('a', 1.23).eval());
        System.assertEquals(true,
                            new Afe_Evaluator('a < 1.23').bind('a', 1.22).eval()); 
        System.assertEquals(false,
                            new Afe_Evaluator('a < "abc"').bind('a', 'abc').eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('a < "bxyz"').bind('a', 'axyz').eval());  
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,10) < TIME(10,10,10)').eval());        
    } 
    
    @isTest static void testOpLt2() {
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,9) < TIME(10,10,10)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,11) < TIME(10,10,10)').eval()); 
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,11) < DATETIME(2021,11,01,10,10,10)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) < DATETIME(2021,11,01,10,10,10)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,9) < DATETIME(2021,11,01,10,10,10)').eval());        
    }    
        
	@isTest static void testOpEq1() {
        System.assertEquals(true,
                            new Afe_Evaluator('a = null').bind('a', null).eval());        
        System.assertEquals(true,
                            new Afe_Evaluator('a = 1.23').bind('a', 1.23).eval());
        System.assertEquals(false,
                            new Afe_Evaluator('a = 1.23').bind('a', 1.22).eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('a = "abc"').bind('a', 'abc').eval()); 
        System.assertEquals(false,
                            new Afe_Evaluator('a = "abc"').bind('a', 'aBc').eval());        
        System.assertEquals(false,
                            new Afe_Evaluator('a = "bxyz"').bind('a', 'axyz').eval());       
    } 
    
    @isTest static void testOpEq2() {
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,10) = TIME(10,10,10)').eval());           
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,9) = TIME(10,10,10)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,11) = DATETIME(2021,11,01,10,10,10)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) = DATETIME(2021,11,01,10,10,10)').eval());       
    }     
    
	@isTest static void testOpNeq1() {
        System.assertEquals(false,
                            new Afe_Evaluator('a <> 1.23').bind('a', 1.23).eval());
        System.assertEquals(true,
                            new Afe_Evaluator('a <> 1.23').bind('a', 1.22).eval()); 
        System.assertEquals(false,
                            new Afe_Evaluator('a <> "abc"').bind('a', 'abc').eval()); 
        System.assertEquals(true,
                            new Afe_Evaluator('a <> "abc"').bind('a', 'aBc').eval());        
        System.assertEquals(true,
                            new Afe_Evaluator('a <> "bxyz"').bind('a', 'axyz').eval());       
    } 
    
    @isTest static void testOpNeq2() {
        System.assertEquals(false,
                            new Afe_Evaluator('TIME(10,10,10) <> TIME(10,10,10)').eval());           
        System.assertEquals(true,
                            new Afe_Evaluator('TIME(10,10,9) <> TIME(10,10,10)').eval());
        System.assertEquals(true,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,11) <> DATETIME(2021,11,01,10,10,10)').eval());
        System.assertEquals(false,
                            new Afe_Evaluator('DATETIME(2021,11,01,10,10,10) <> DATETIME(2021,11,01,10,10,10)').eval());       
    }    
    
    @isTest static void testOpOpUnary() {
        System.assertEquals(-8,
                            new Afe_Evaluator('-9---+(-(++-2))+3').evalNumber());        
    } 
    
    @isTest static void testOpPrecedence() {
        System.assertEquals(-4,
                            new Afe_Evaluator('-2^2').evalNumber());        
        System.assertEquals(34.599653,
                            new Afe_Evaluator('9+8*3.2-1.1/6^(1.5%2+3)').setPrecision(8).evalNumber());
    }
    
    @isTest static void testaddCustomOperator() {
    	Afe_Evaluator t = new Afe_Evaluator();
            t.getParser().addOperator(
                new TestOperator('@',550)
            );
        System.assertEquals(333, t.setExpression('"abc"@"def"').evalNumber());
    }    
    
    @isTest static void testaddCustomUnaryOperator() {
    	Afe_Evaluator t = new Afe_Evaluator();
        Afe_Parser.IOperator iUop = new TestUnaryOperator('$',560);
        t.getParser().addUnaryOperator(iUop);
        try{
            iUop.getAss();
            System.assert(false);
        }catch(NoAccessException e){
            System.assert(true);
        }
        
        try{
            iUop.validate(Boolean.class,Boolean.class);
            System.assert(false);
        }catch(NoAccessException e){
            System.assert(true);
        }       
        System.assertEquals(333, t.setExpression('$10').evalNumber());
    }      
    
    @isTest static void testOpPlusWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.PlusOperator('+',500, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    }  

    @isTest static void testOpSubtractWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.MinusOperator('-',500, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    }
    
    @isTest static void testOpDivWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.DivOperator('/',600, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    } 
    
    @isTest static void testOpMulWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.MulOperator('*',600, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    }    
    
    @isTest static void testOpLtWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.LtOperator('<',400, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    }     
    
    @isTest static void testOpLeWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.LeOperator('<=',400, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    } 

    @isTest static void testOpGtWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.GtOperator('>',400, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    }  
    
    @isTest static void testOpGeWrongParam() {
        Afe_Evaluator.EvalContext ec = new Afe_Evaluator.EvalContext(
            new Afe_Evaluator.DecimalContext(9,RoundingMode.HALF_EVEN)
        );
        try{
           Afe_Parser.IOperator iopPlus = new Afe_Parser.GeOperator('>=',400, Afe_Parser.Assoc.LEFT);
           iopPlus.calculate(true,Date.today(),ec);
           System.assert(false);
        }catch(Exception e){
           System.assert(true);
        }	        
    }    
       

    @isTest static void testWrongExpression1() {
        System.assertNotEquals(0, new Afe_Evaluator('2+1*').getError().size());
		System.assertNotEquals(0, new Afe_Evaluator('2+1)').getError().size());
		System.assertNotEquals(0, new Afe_Evaluator('()').getError().size()); 
        System.assertNotEquals(0, new Afe_Evaluator('(3+2').getError().size());        
    }    
    
    @isTest static void testAndOr() {
        System.assertEquals(false,
                            new Afe_Evaluator('true&&false').evalBool());
        System.assertEquals(true,
                            new Afe_Evaluator('(3>2) && (1>3 || 8>7)').evalBool());
        System.assertEquals(false,
                            new Afe_Evaluator('1>2 || 3 > 2 && 6 > 7 ').evalBool());        
    }
      

    @isTest static void testIfelse1() {
        System.assertEquals(true,
                            new Afe_Evaluator('if(a>b,true,false)')
                            .bind('a', 10).bind('b', 9).evalBool());
        System.assertEquals(false, 
                                new Afe_Evaluator('if(a>b,true,if(1>2,true,false))')
                                .bind('a', 8).bind('b', 9).evalBool());        
    }

    
    
    @isTest static void testIfelse2() {
        System.assertNotEquals(0, new Afe_Evaluator('if(a>b,true,3)')
                               .bind('a', 10).bind('b', 9).getError().size());
        System.assertNotEquals(0, new Afe_Evaluator('if(if(true,true,false),true,3)')
                               .bind('a', 10).bind('b', 9).getError().size());
        System.assertNotEquals(0, new Afe_Evaluator('if(true,12)').getError().size());
        System.assertNotEquals(0, new Afe_Evaluator('if(2>1)').getError().size());
		System.assertNotEquals(0, new Afe_Evaluator('if(2>1,true,false').getError().size());
        System.assertNotEquals(0, new Afe_Evaluator('if(2+1,true,false)').getError().size());       
    }     
    
    @isTest static void testSwitchCase5() {
         System.assertEquals('mango', new Afe_Evaluator('switch(a,1,"apple",2,"mango","n/a")').bind('a', 2).eval());
         System.assertNotEquals(0, new Afe_Evaluator('switch(a,1,pi,2,"mango",e)').bind('a', 2).getError().size());
         System.assertNotEquals(0, new Afe_Evaluator('switch(a)').bind('a', 2).getError().size());
         System.assertNotEquals(0, new Afe_Evaluator('switch(a,1,2,3,4)').bind('a', 2).getError().size());
         System.assertNotEquals(0, new Afe_Evaluator('switch(a,1(2,3;4;5)').bind('a', 2).getError().size());

    }
    
    
     @isTest static void testFunctionString1() {
         System.assertEquals('he', new Afe_Evaluator('left("helloword",2)').eval());
		 System.assertEquals('helloword', new Afe_Evaluator('left("helloword",20)').eval());
         System.assertEquals('rd', new Afe_Evaluator('right("helloword",2)').eval());
		 System.assertEquals('helloword', new Afe_Evaluator('left("helloword",20)').eval());
         System.assertEquals('ab', new Afe_Evaluator('MID("abcd",1,2)').eval());
         System.assertEquals('0000000001', new Afe_Evaluator('LPAD("1",10,"0")').eval());
         System.assertEquals('1000000000', new Afe_Evaluator('RPAD("1",10,"0")').eval());
    } 
    
     @isTest static void testFunctionString2() {
         System.assertEquals('dcba', new Afe_Evaluator('reverse("abcd")').eval());
         System.assertEquals(true, new Afe_Evaluator('ISNUMBER("0.23")').eval());
         System.assertEquals(false, new Afe_Evaluator('ISNUMBER("0.2a3")').eval());
         System.assertEquals('abc', new Afe_Evaluator('LOWER("aBc")').eval());
		 System.assertEquals('ABC', new Afe_Evaluator('UPPER("aBc")').eval());
         System.assertEquals('Capitalize The First', new Afe_Evaluator('PROPER("capitalize the first")').eval());
         System.assertEquals('abc', new Afe_Evaluator('TRIM(" abc ")').eval());
         System.assertEquals('xxxxx', new Afe_Evaluator('REPT("x",5)').eval());
    }
    
    @isTest static void testFunctionString3() {
         System.assertEquals(4, new Afe_Evaluator('len("abcd")').eval());
         System.assertEquals(0, new Afe_Evaluator('len("")').eval());
		 System.assertEquals(1, new Afe_Evaluator('len(" ")').eval());
         System.assertEquals(1, new Afe_Evaluator('len("\n")').eval());
         System.assertEquals('23-01-2021', 
                             new Afe_Evaluator('TEXT(DATEVALUE("2021-01-23"),"dd-MM-yyyy")').eval());
        System.assertEquals('2', new Afe_Evaluator('TEXT(0.1,"h")').eval());
        System.assertEquals('62', new Afe_Evaluator('TEXT(2.61,"[hh]")').eval());
        System.assertEquals('14-38-24', new Afe_Evaluator('TEXT(2.61,"hh-mm-ss")').eval());
        //System.assertEquals('334.5', new Afe_Evaluator('TEXT(334)').eval());
        System.assertEquals('a', new Afe_Evaluator('CHAR(97)').eval());
		System.assertEquals(97, new Afe_Evaluator('CODE("a")').eval());  
    }
    
    @isTest static void testFunctionString4() {
        System.assertEquals('ABC456', new Afe_Evaluator('REPLACE("ABC123",4,3,"456")').eval());
        System.assertEquals('1234553321', new Afe_Evaluator('REPLACE("123-455-3321","-","")').eval());
        System.assertEquals('1234553321', new Afe_Evaluator('SUBSTITUTE("123-455-3321","-","")').eval());        
        System.assertEquals(11, new Afe_Evaluator('FIND("ab","ABCDabcABCabc",6)').eval());
        System.assertEquals(5, new Afe_Evaluator('FIND("a","ABCDabcABCabc")').eval());
        System.assertEquals(1, new Afe_Evaluator('SEARCH("A","ABC")').eval());
        System.assertEquals(4, new Afe_Evaluator('SEARCH("A","AEHABC",4)').eval());
        System.assertEquals('ABC', new Afe_Evaluator('CONCAT("A","B","C")').eval());
        System.assertEquals(true, new Afe_Evaluator('ISBLANK("")').eval());
        System.assertEquals(true, new Afe_Evaluator('ISBLANK(NULL)').eval());
    }
    
    @isTest static void testFunctionNumber1() {
        System.assertEquals(9, new Afe_Evaluator('BITAND(13,25)').eval());
        System.assertEquals(31, new Afe_Evaluator('BITOR(23,10)').eval());        
        System.assertEquals(6, new Afe_Evaluator('BITXOR(5,3)').eval());
        System.assertEquals(-7, new Afe_Evaluator('BITNOT(6)').eval());
        System.assertEquals(16, new Afe_Evaluator('BITLSHIFT(4,2)').eval());
        System.assertEquals(3, new Afe_Evaluator('BITRSHIFT(13,2)').eval());
        System.assertEquals(123, new Afe_Evaluator('VALUE("123")').eval());
        
    } 
    
    @isTest static void testFunctionNumber2() {
        System.assertEquals(true, new Afe_Evaluator('AND(2>1,3<9/2)').eval());
        System.assertEquals(true, new Afe_Evaluator('OR(2>1,3>9/2)').eval());
        System.assertEquals(1, new Afe_Evaluator('IF(OR(2>1,3>9/2),1,2)').eval());
        System.assertEquals(false, new Afe_Evaluator('XOR(2>1,3<9/2)').eval());
        System.assertEquals(false, new Afe_Evaluator('XOR(2>1,3<9/2,6<10,100<200)').eval());
        System.assertEquals(true, new Afe_Evaluator('XOR(2>1,3<9/2,6<10)').eval());
        System.assertEquals(false, new Afe_Evaluator('NOT(true)').eval());
    } 
    
    @isTest static void testFunctionNumber3() {
        System.assertEquals(6, new Afe_Evaluator('SUM(1,2,3)').eval());
        System.assertEquals(6, new Afe_Evaluator('SUM(abc)').bind('abc',new List<Decimal>{1,2,3}).eval());
        
        System.assertEquals(1, new Afe_Evaluator('MIN(1,2,3)').eval());
        System.assertEquals(1, new Afe_Evaluator('MIN(abc)').bind('abc',new List<Decimal>{1,2,3}).eval());
        
        System.assertEquals(3, new Afe_Evaluator('MAX(1,2,3)').eval());
        System.assertEquals(3, new Afe_Evaluator('MAX(abc)').bind('abc',new List<Decimal>{1,2,3}).eval());

        System.assertEquals(2, new Afe_Evaluator('average(1,2,3)').eval());
        System.assertEquals(2, new Afe_Evaluator('average(abc)').bind('abc',new List<Decimal>{1,2,3}).eval());        

    }    
    
    @isTest static void testFunctionNumber4() {
        System.assertEquals(1, new Afe_Evaluator('SIN(PI()/2)').eval());
        
        System.assertEquals(2.3013, new Afe_Evaluator('SINH(PI()/2)').setPrecision(5).eval());////////////
        System.assertEquals(0.5236, new Afe_Evaluator('ASIN(0.5)').setPrecision(4).eval());
        System.assertEquals(-1, new Afe_Evaluator('COS(PI())').eval());
        System.assertEquals(27.3082, new Afe_Evaluator('COSH(4)').setPrecision(6).eval());
        
        System.assertEquals(120, new Afe_Evaluator('ACOS(-0.5)*180/PI()').eval());
        System.assertEquals(0.9992, new Afe_Evaluator('TAN(0.785)').setPrecision(4).eval());
        
        System.assertEquals(0, new Afe_Evaluator('TANH(0)').eval());
        System.assertEquals(-0.96403, new Afe_Evaluator('TANH(-2)').setPrecision(5).eval());
    }

    @isTest static void testFunctionNumber4b() {
        System.assertEquals(0.7854, new Afe_Evaluator('ATAN(1)').setPrecision(5).eval());
        System.assertEquals(45, new Afe_Evaluator('ATAN(1)*180/PI()').eval());
        System.assertEquals(45, new Afe_Evaluator('DEGREES(ATAN(1))').eval());
        
        System.assertEquals(0.785398163397448, new Afe_Evaluator('ATAN2(1, 1)').eval());
        
        System.assertEquals(1.1547, new Afe_Evaluator('SEC(PI()/6)').setPrecision(5).eval());
        
        System.assertEquals(2, new Afe_Evaluator('CSC(PI()/6)').eval());
        System.assertEquals(1.732, new Afe_Evaluator('COT(PI()/6)').setPrecision(4).eval());
        System.assertEquals(1.088, new Afe_Evaluator('ACOT(PI()/6)').setPrecision(4).eval());
        
        System.assertEquals(2.0813, new Afe_Evaluator('COTH(PI()/6)').setPrecision(5).eval());
        
    }    
    
    @isTest static void testFunctionNumber5() {
        System.assertEquals(4, new Afe_Evaluator('SQRT(16)').eval());
        System.assertEquals(1, new Afe_Evaluator('MOD(16,3)').eval());
        System.assertEquals(0.25, new Afe_Evaluator('MOD(6.25,1)').eval());
        System.assertEquals(1, new Afe_Evaluator('LN(e)').eval());
        System.assertEquals(2.3026, new Afe_Evaluator('LN(10)').setPrecision(5).eval());
        System.assertEquals(5, new Afe_Evaluator('LOG10(10^5)').setPrecision(5).eval());
        System.assertEquals(true, new Afe_Evaluator('RAND()').setPrecision(5).evalNumber()<=1);
        System.assertEquals(true, new Afe_Evaluator('RAND()').setPrecision(5).evalNumber()>=0);

    } 
     @isTest static void testFunctionNumber6() {
        System.assertEquals(20.0855, new Afe_Evaluator('EXP(3)').setPrecision(6).eval());
        System.assertEquals(1.1, new Afe_Evaluator('ABS(-1.1)').eval());
        System.assertEquals(40320, new Afe_Evaluator('FACT(8)').eval());
        System.assertEquals(3.14, new Afe_Evaluator('PI()').setPrecision(3).eval());
        System.assertEquals(3.1503, new Afe_Evaluator('RADIANS(180.5)').setPrecision(5).eval());
        System.assertEquals(180, new Afe_Evaluator('DEGREES(PI())').evalNumber());
        System.assertEquals(123, new Afe_Evaluator('INT(123.4)').evalNumber());

    }   
    @isTest static void testFunctionNumber7() {
        System.assertEquals(3, new Afe_Evaluator('CEILING(2.1)').eval());
        System.assertEquals(3, new Afe_Evaluator('CEILING(2.5, 1)').eval());
        System.assertEquals(-4, new Afe_Evaluator('CEILING(-2.5, -2)').eval());
        System.assertEquals(3, new Afe_Evaluator('FLOOR(3.7)').eval());
        System.assertEquals(2, new Afe_Evaluator('FLOOR(3.7,2)').eval());
        System.assertEquals(-2, new Afe_Evaluator('FLOOR(-2.5,-2)').eval());
        System.assertEquals(20.09, new Afe_Evaluator('ROUND(20.085537,2)').eval());
        System.assertEquals(20130, new Afe_Evaluator('ROUND(20126.08,-1)').eval());
		System.assertEquals(-8, new Afe_Evaluator('POWER(-2, 3)').eval());
    }
    
    @isTest static void testFunctionDatetime1() {
        System.assertEquals(Datetime.newInstance(2021, 10, 21, 18, 20, 0), new Afe_Evaluator('DATETIMEVALUE("2021-10-21 18:20:00")').eval());
        
        System.assertEquals(10, new Afe_Evaluator('SECOND(TIME(12,21,10))').eval());
        System.assertEquals(13, new Afe_Evaluator('SECOND(DATETIME(2021,03,11,12,21,13))').eval());
        System.assertEquals(0, new Afe_Evaluator('SECOND(DATE(2021,03,11))').eval());
        
        System.assertEquals(21, new Afe_Evaluator('MINUTE(TIME(12,21,10))').eval());
        System.assertEquals(21, new Afe_Evaluator('MINUTE(DATETIME(2021,03,11,12,21,10))').eval());
        System.assertEquals(0, new Afe_Evaluator('MINUTE(DATE(2021,03,11))').eval());        

        System.assertEquals(12, new Afe_Evaluator('HOUR(TIME(12,21,10))').eval());
        System.assertEquals(12, new Afe_Evaluator('HOUR(DATETIME(2021,03,11,12,21,10))').eval());
        System.assertEquals(0, new Afe_Evaluator('HOUR(DATE(2021,03,11))').eval()); 
    }

    @isTest static void testFunctionDatetime2() {       
        System.assertEquals(17, new Afe_Evaluator('DAY(DATEVALUE("2021-10-17"))').eval());
        System.assertEquals(10, new Afe_Evaluator('MONTH(DATEVALUE("2021-10-17"))').eval());
        System.assertEquals(2021, new Afe_Evaluator('YEAR(DATEVALUE("2021-10-17"))').eval()); 
        
        System.assertNotEquals(null, new Afe_Evaluator('NOW()').eval()); 
        System.assertNotEquals(null, new Afe_Evaluator('TODAY()').eval());
        System.assertEquals(Date.newInstance(2008, 9, 13), new Afe_Evaluator('EDATE(DATEVALUE("2008-07-13"),2)').eval());
        System.assertEquals(Datetime.newInstance(2008, 9, 13, 13, 20, 0)
                            , new Afe_Evaluator('EDATE(DATEVALUE("2008-07-13")+TIME(13,20,0),2)').eval());        
    } 
    
    @isTest static void testFunctionDatetime3() {       
        System.assertEquals(5, new Afe_Evaluator('WEEKDAY(DATEVALUE("2008-02-14"))').eval());
        System.assertEquals(7, new Afe_Evaluator('WEEKNUM(DATEVALUE("2008-02-14"))').eval());
        System.assertEquals(Date.newInstance(2021, 6, 23), new Afe_Evaluator('WORKDAY(DATEVALUE("2021-03-30"),61)').eval()); 
        System.assertEquals(Date.newInstance(2021, 3, 24), new Afe_Evaluator('WORKDAY(DATEVALUE("2021-03-30"),-3.01)').eval());
        System.assertEquals(295, new Afe_Evaluator('NETWORKDAYS(DATEVALUE("2021-03-30"),DATEVALUE("2022-05-16"))').eval());
        
        System.assertEquals(Date.newInstance(2021, 4, 30), new Afe_Evaluator('EOMONTH(DATE(2021,01,01),3)').eval()); 
        System.assertEquals(Date.newInstance(2021, 4, 30), new Afe_Evaluator('EOMONTH(DATETIME(2021,01,01,12,0,0),3)').eval()); 
    }
    
    @isTest static void testFunctionDatetime4() {       
        System.assertEquals(8, new Afe_Evaluator('DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"Y")').eval());
        System.assertEquals(102, new Afe_Evaluator('DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"M")').eval());
        System.assertEquals(3132, new Afe_Evaluator('DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"D")').eval()); 
        System.assertEquals(6, new Afe_Evaluator('DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"YM")').eval());
        System.assertEquals(29, new Afe_Evaluator('DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"MD")').eval());    
        System.assertEquals(2, new Afe_Evaluator('DAYS(DATEVALUE("2021-01-05"),DATEVALUE("2021-01-03"))').eval()); 
    }     
    
    @isTest static void testFunctionDatetime5() {
        System.assertEquals('Boolean', Afe_FunctionDefinition.getType(true));
        System.assertEquals('Decimal', Afe_FunctionDefinition.getType(Decimal.valueOf(5)));
        System.assertEquals('String', Afe_FunctionDefinition.getType('abc'));
        System.assertEquals('Datetime', Afe_FunctionDefinition.getType(Datetime.now()));
        System.assertEquals('Date', Afe_FunctionDefinition.getType(Date.today()));
        System.assertEquals('Time', Afe_FunctionDefinition.getType(Time.newInstance(10, 10, 0, 0)));
        System.assertEquals('List', Afe_FunctionDefinition.getType(new List<String>()));
    }
    
    @isTest static void testSetHoliday() {
        Afe_Evaluator eval =new Afe_Evaluator('NETWORKDAYS(DATEVALUE("2021-03-30"),DATEVALUE("2022-05-16"))');
        eval.setHolidays(new Date[]{Date.newInstance(2021, 03, 31), Date.newInstance(2021, 4, 1)});
        System.assertEquals(293, eval.eval());
    }
    
    @isTest static void testGetVariable() {
        Afe_Evaluator eval =new Afe_Evaluator('IF(a>b,SUM(c,d) + e + 1.5, switch(f,1,2,3,4,--g) )');
        System.assertEquals(6, eval.getVariable().size());
    } 

    @isTest static void testDisableFunction() {
        Afe_Evaluator eval =new Afe_Evaluator('SIN(PI())');
        eval.disableFunction('pi');
        try{
            eval.eval();
            system.assert(false);
        }catch(Exception e){
            system.assert(true);
        }
    }
    
    @isTest static void testDisableFunctions() {
        Afe_Evaluator eval =new Afe_Evaluator('SIN(PI())');
        eval.disableFunction(new String[]{'pi','sin'});
        try{
            eval.eval();
            system.assert(false);
        }catch(Exception e){
            system.assert(true);
        }
    }

    
    @isTest static void testSetRoundingMode() {
        Afe_Evaluator eval =new Afe_Evaluator('25/100');
        eval.setRoundingMode(RoundingMode.CEILING);
        eval.setDivideScale(1);
        System.assertEquals(0.3, eval.eval());
    } 
    
    @isTest static void testConstant() {
        Afe_Evaluator eval =new Afe_Evaluator('pi*power(r,2)');
        eval.bind('r',2.33333333333333333333334);
        System.assertEquals(17.1042266695444, eval.eval());
    }
    
    @isTest static void testSetConstant1() {
        Afe_Evaluator eval =new Afe_Evaluator('IF(inputSalary >= BASESALARY,true,false)');
        eval.getParser().addConstant('BASESALARY',10000);
        System.assertEquals(true, eval.bind('inputSalary',10001).eval());
    }  
    
    @isTest static void testSetConstant2() {
        Afe_Evaluator eval =new Afe_Evaluator('SWITCH(department,RD,1,HR,2,-1)');
        eval.getParser().addConstant('RD','Research and Development');
        eval.getParser().addConstant('HR','Human Resource');
        System.assertEquals(2, eval.bind('department','Human Resource').eval());
    }    
}