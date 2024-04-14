# expression-evaluator-apex

new Afe_Evaluator('a >= 1.23').bind('a', 1.23).eval()

new Afe_Evaluator('2.4/-3.33').evalNumber()

new Afe_Evaluator('DATETIME(2021,2,28,15,50,0)-DATETIME(2021,2,21,23,0,0)').setPrecision(7).evalNumber()

new Afe_Evaluator('TIME(10,10,0)-TIME(9,2,0)').eval()

new Afe_Evaluator('"hello"&"word"').evalString(false)

new Afe_Evaluator('9+8*3.2-1.1/6^(1.5%2+3)').setPrecision(8).evalNumber()

new Afe_Evaluator('if(a>b,true,false)')
                            .bind('a', 10).bind('b', 9).evalBool()

new Afe_Evaluator('if(a>b,true,if(1>2,true,false))')
                                .bind('a', 8).bind('b', 9).evalBool()

new Afe_Evaluator('switch(a,1,"apple",2,"mango","n/a")').bind('a', 2).eval()


new Afe_Evaluator('TEXT(DATEVALUE("2021-01-23"),"dd-MM-yyyy")').eval()


new Afe_Evaluator('SUM(abc)').bind('abc',new List<Decimal>{1,2,3}).eval()

new Afe_Evaluator('WEEKDAY(DATEVALUE("2008-02-14"))').eval()


new Afe_Evaluator('NETWORKDAYS(DATEVALUE("2021-03-30"),DATEVALUE("2022-05-16"))').eval()

new Afe_Evaluator('DATEDIF(DATEVALUE("2021-01-31"),DATEVALUE("2029-08-29"),"D")').eval()



Afe_Evaluator eval =new Afe_Evaluator('IF(a>b,SUM(c,d) + e + 1.5, switch(f,1,2,3,4,--g) )');
System.assertEquals(6, eval.getVariable().size());


Afe_Evaluator eval =new Afe_Evaluator('SWITCH(department,RD,1,HR,2,-1)');
eval.getParser().addConstant('RD','Research and Development');
eval.getParser().addConstant('HR','Human Resource');
System.assertEquals(2, eval.bind('department','Human Resource').eval());



new Afe_Evaluator('1>2 || 3 > 2 && 6 > 7 ').evalBool()
