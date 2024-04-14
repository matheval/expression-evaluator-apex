public class Afe_Parser {
    //Lexer
    private Afe_Lexer lexer;
    
    //operator list
    private Map<String,IOperator> operators;
    
    //unary operator list
    private Map<String,IOperator> unaryOperators;
    
    //constant list
    private Map<String,Object> constants;
    
    //Operator assoc
    public enum Assoc {
        LEFT,
        RIGHT
    }  
    
    /**
     * Operator interface
     */ 
    public interface IOperator{
        Integer getPrec();
        String getOp();
        Assoc getAss();
        Object calculate(
            Object left, 
            Object right, 
            Afe_Evaluator.EvalContext ec
        ); 
        System.Type validate(
            System.Type typeLeft, 
            System.Type typeRight
        );         
    }
    
     /**
     * Base operator
     */ 
    public abstract class BaseOperator implements Afe_Parser.IOperator{
        String op;
        Integer prec;
        public virtual String getOp(){
          return this.op;
        }
        public virtual Integer getPrec(){
          return this.prec;
        }        
    }    
    
    /**
     * Base Node
     */
    public abstract class Node{
        public System.Type returnType;
        public Node(){
            returnType = null;
        }
        public Node(System.Type returnType){
            this.returnType = returnType;
        }
    } 
    
    /**
     * Nullnode, used to hold null value
     */ 
    public class NullNode extends Node{
        public NullNode(){
            super(Object.class);
        }
    }  
    
    /**
     * Doublenode, used to hold number value
     */ 
    public class DoubleNumberNode extends Node{
        public Decimal numberValue;
        public Boolean needRounding;
        public DoubleNumberNode(Decimal numberVal, Boolean needRounding){
            super(Decimal.class);
            this.numberValue = numberVal;
            this.needRounding = needRounding;
        }
    }     
    
    /**
     * Stringnode, used to hold string value
     */     
    public class StringNode extends Node{
        public String value;
        public StringNode(String value){
            super(String.class);
            this.value = value;
        }
    } 
    
    /**
     * Boolnode, used to hold boolean value
     */     
    public class BoolNode extends Node{
        public Boolean value;
        public BoolNode(Boolean value){
            super(Boolean.class);
            this.value = value;
        }
    }
    
    /**
     * Variablenode, used to hold variable
     */     
    public class VariableNode extends Node{
        public String name;
        public VariableNode(String name){
            //super(VariableNode.class);
            super(Object.class);
            this.name = name;
        }
    }
    
    /**
     * Binary node
     */     
    public class BinanyNode extends Node{
        public Afe_Parser.Node LHS;
        public Afe_Parser.Node RHS;
        public IOperator iOp;
        public BinanyNode(
            IOperator iop,
            Afe_Parser.Node lhs, 
            Afe_Parser.Node rhs,
            System.Type returnType
        ){
           super(returnType);
           this.iOp = iop;
           this.LHS = lhs;
           this.RHS = rhs;
        }
    }  
    
    /**
     * Unary node, used to hold unary operator
     */     
    public class UnaryNode extends Node{
        public Afe_Parser.Node expr;
        public IOperator iop;
        public UnaryNode(IOperator iop, Afe_Parser.Node expr){
            super(Decimal.class);
            this.iop = iop;
            this.expr = expr;
        }
    }  
    
    /**
     * Condition node, used to hold condition
     */     
    public class IfElseNode extends Node{
        public Afe_Parser.Node condition;
        public Afe_Parser.Node ifTrue;
        public Afe_Parser.Node ifFalse;
        public IfElseNode(
            Afe_Parser.Node condition,
            Afe_Parser.Node ifTrue,
            Afe_Parser.Node ifFalse,
            System.Type returnType
        ){
            super(returnType);
            this.condition = condition;
            this.ifTrue = ifTrue;
            this.ifFalse = ifFalse;
        }
    }
    
    /**
     * Condition node, used to hold CASE condition
     */ 
    public class SwitchCaseNode extends Node{
        public Afe_Parser.Node conditionExpr;
        public List<Afe_Parser.Node> varResultExprs;
        public Afe_Parser.Node defaultExpr;
        public SwitchCaseNode(
			Afe_Parser.Node conditionExpr,
            List<Afe_Parser.Node> varResultExprs,
            Afe_Parser.Node defaultExpr,
            System.Type returnType
        ){
            super(returnType);
			this.conditionExpr = conditionExpr;
            this.varResultExprs = varResultExprs;
            this.defaultExpr = defaultExpr;
        }
    }   
    
    /**
     * Call function node, used to call function
     */ 
    public class CallFuncNode extends Node{
        public String funcName;
        public List<Afe_Parser.Node> args;
        public Afe_FunctionDefinition.IFunction excuter;
        public CallFuncNode(
            String funcName,
            List<Afe_Parser.Node> args,
            System.Type returnType,
            Afe_FunctionDefinition.IFunction excuter
        ){
            super(returnType);
            this.funcName = funcName;
            this.args=args;
            this.excuter = excuter;
        }
    }
    
    /**
     * Base class for executing Unary op
     */     
    public abstract class AbstractUnaryOperator 
        extends BaseOperator implements Afe_Parser.IOperator{
        public AbstractUnaryOperator(String op,Integer precedence){
			this.op = op;
            this.prec = precedence;
        }
        public virtual Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
            if(right!=null){
               throw new Afe_Exception(Afe_Evaluator.MSG_UNARY_INVALID); 
            }
            return null;  
        }

        public Assoc getAss(){
           throw new NoAccessException();
        }    
        public virtual System.Type validate(System.Type typeLeft, System.Type typeRight){
            throw new NoAccessException();
        } 
    }
    
    /**
     * Base class for executing binop
     */      
    public abstract class AbstractBinOperator 
        extends BaseOperator implements Afe_Parser.IOperator{
        protected Assoc assoc;
        public AbstractBinOperator(){    
        }   
        public AbstractBinOperator(String op,Integer precedence){
            this.op = op;
            this.prec = precedence;
            this.assoc = Afe_Parser.Assoc.LEFT;
        }            
        public AbstractBinOperator(String op,Integer precedence, Assoc assoc){
            this.op = op;
            this.prec = precedence;
            this.assoc = assoc;
        }               
        public Assoc getAss(){
           return this.assoc;
        }
        public virtual System.Type validate(System.Type typeLeft, System.Type typeRight){
            //return VariableNode.class;
            return VariableNode.class;
        }             
    } 
    
    /**
     * Unary positive operator
     * Examples:
     * 3++2-+4 -> 1
     */     
    public class UnaryPosOperator extends AbstractUnaryOperator{  
            public UnaryPosOperator(String op, Integer precedence){
                super(op,precedence);
            }
            public override Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                super.calculate(left,right,ec);
        		if(left instanceof Decimal){
                    Decimal retValue = +(Decimal)left;
                    return (Object)retValue;
                }
                throw new Afe_Exception(Afe_Evaluator.MSG_UNARY_INVALID);
            }       
        }
    
    /**
     * Unary negative operator
     * 3+-2--4 -> 5
     */ 
    public class UnaryNegOperator extends AbstractUnaryOperator{  
            public UnaryNegOperator(String op, Integer precedence){
                super(op,precedence);
            }       
            public override Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                super.calculate(left,right,ec);
        		if(left instanceof Decimal){
                    Decimal retValue = -(Decimal)left;
                    return (Object)retValue;
                }
                throw new Afe_Exception(Afe_Evaluator.MSG_UNARY_INVALID);
            }
        }    
    
    /**
     * Or operator
     * Example:
     * (2>1)||(6>7) -> true
     */ 
    public class OrOperator extends AbstractBinOperator{
            public OrOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }             
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof boolean && right instanceof boolean){
                    return (Object)(left==true || right==true);
                } 
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Logical OR','Boolean'})
                );                 
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Boolean.class) && typeRight.equals(Boolean.class)){
                    return Boolean.class;
                }
                return null;
            }         
        } 
    
    /**
     * And operator executer
     * Example:
     * (2>1)&&(6>7) -> false
     */     
    public class AndOperator extends AbstractBinOperator{
            public AndOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }            
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof boolean && right instanceof boolean){
                    return (Object)(left==true && right==true);
                }                
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Logical AND','Boolean'})
                ); 
            }  
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Boolean.class) && typeRight.equals(Boolean.class)){
                    return Boolean.class;
                }
                return null;
            }         
        }  
    
    /**
     * Equal operator executer
     * Example:
     * VALUE("123") == 123 -> true
     */    
    public class EqOperator extends AbstractBinOperator {
            public EqOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = Afe_FunctionDefinition.round((Decimal)left, ec);
                    Decimal rightDecimal = Afe_FunctionDefinition.round((Decimal)right, ec);
                    return (Object)((Decimal)leftDecimal == (Decimal)rightDecimal);
                }else if(left instanceof boolean && right instanceof boolean){
                    return (Object)(Boolean.valueOf(left) == Boolean.valueOf(right));
                }else if(left instanceof string && right instanceof string){
                    return (Object)(String.valueOf(left).equals(String.valueOf(right)));
                }else if(left instanceof Time && right instanceof Time){
                    return (Time)left == (Time)right;
                }else if(left instanceof DateTime && right instanceof DateTime){
                    return (DateTime)left == (DateTime)right;
                }else return left == right;
        		/*throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Comparison','Integer, Boolean, Datetime'})
                );*/                 
            }   
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(
                    (typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)) ||
                    (typeLeft.equals(Boolean.class) && typeRight.equals(Boolean.class)) ||
                    (typeLeft.equals(String.class) && typeRight.equals(String.class))|| 
                    (typeLeft.equals(Time.class) && typeRight.equals(Time.class))|| 
                    (
                        (typeLeft.equals(Date.class)||typeLeft.equals(DateTime.class)) && 
                        (typeRight.equals(Date.class)||typeRight.equals(DateTime.class))
                    )|| typeLeft.equals(Object.class)|| typeRight.equals(Object.class)
                  ){
                    return Boolean.class;
                }
                return null;
            }         
        } 
    
    /**
     * Not equal operator executer
     * Example:
     * VALUE("123") <> 124 -> true
     */    
    public class NeqOperator extends AbstractBinOperator{
            public NeqOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }            
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                 if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = Afe_FunctionDefinition.round((Decimal)left, ec);
                    Decimal rightDecimal = Afe_FunctionDefinition.round((Decimal)right, ec);
                    return (Object)((Decimal)leftDecimal != (Decimal)rightDecimal);
                }else if(left instanceof boolean && right instanceof boolean){
                    return (Object)(Boolean.valueOf(left) != Boolean.valueOf(right));
                }else if(left instanceof string && right instanceof string){
                    return (Object)(!String.valueOf(left).equals(String.valueOf(right)));
                }else if(left instanceof Time && right instanceof Time){
                    return (Time)left != (Time)right;
                }else if(left instanceof DateTime && right instanceof DateTime){
                    return (DateTime)left != (DateTime)right;
                }else return left != right;
        		/*throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Comparison','Integer, Boolean, Datetime'})
                ); */
            }  
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(
                    (typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)) ||
                    (typeLeft.equals(Boolean.class) && typeRight.equals(Boolean.class)) ||
                    (typeLeft.equals(String.class) && typeRight.equals(String.class))|| 
                    (typeLeft.equals(Time.class) && typeRight.equals(Time.class))|| 
                    (
                        (typeLeft.equals(Date.class)||typeLeft.equals(DateTime.class)) && 
                        (typeRight.equals(Date.class)||typeRight.equals(DateTime.class))
                    ) || typeLeft.equals(Object.class) || typeRight.equals(Object.class)
                  ){
                    return Boolean.class;
                }
                return null;
            }      
        } 
    
    /**
     * Less than operator executer
     * Examples:
     * 123 < 124 -> true
     */     
    public class LtOperator extends AbstractBinOperator{
            public LtOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }               
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = Afe_FunctionDefinition.round((Decimal)left, ec);
                    Decimal rightDecimal = Afe_FunctionDefinition.round((Decimal)right, ec);
                    return (Object)((Decimal)leftDecimal < (Decimal)rightDecimal);
                }else if(left instanceof string && right instanceof string){
                    return (Object)(String.valueOf(left).compareTo(String.valueOf(right))<0 );
                }else if(left instanceof Time && right instanceof Time){
                    return (Time)left < (Time)right;
                }else if(left instanceof DateTime && right instanceof DateTime){
                    return (DateTime)left < (DateTime)right;
                }
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Comparison','Integer, Boolean, Datetime'})
                ); 
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(
                    (typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)) ||
                    (typeLeft.equals(String.class) && typeRight.equals(String.class)) || 
                    (typeLeft.equals(Time.class) && typeRight.equals(Time.class)) || 
                    (
                        (typeLeft.equals(Date.class)||typeLeft.equals(DateTime.class)) && 
                        (typeRight.equals(Date.class)||typeRight.equals(DateTime.class))
                    )|| typeLeft.equals(Object.class)|| typeRight.equals(Object.class)
                  ){
                    return Boolean.class;
                }
                return null;
            }      
        } 
    
    /**
     * Less than or equals operator executer
     * Examples:
     * 123 <= 124 -> true
     * 124 <= 124 -> true
     * 124 <= 125 -> true
     */     
    public class LeOperator extends AbstractBinOperator{
            public LeOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }            
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = Afe_FunctionDefinition.round((Decimal)left, ec);
                    Decimal rightDecimal = Afe_FunctionDefinition.round((Decimal)right, ec);
                    return (Object)((Decimal)leftDecimal <= (Decimal)rightDecimal);
                }else if(left instanceof string && right instanceof string){
                    return (Object)(String.valueOf(left).compareTo(String.valueOf(right))<=0 );
                }else if(left instanceof Time && right instanceof Time){
                    return (Time)left <= (Time)right;
                }else if(left instanceof DateTime && right instanceof DateTime){
                    return (DateTime)left <= (DateTime)right;
                }
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Comparison','Integer, Boolean, Datetime'})
                ); 
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(
                    (typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)) ||
                    (typeLeft.equals(String.class) && typeRight.equals(String.class))|| 
                    (typeLeft.equals(Time.class) && typeRight.equals(Time.class)) || 
                    (
                        (typeLeft.equals(Date.class)||typeLeft.equals(DateTime.class)) && 
                        (typeRight.equals(Date.class)||typeRight.equals(DateTime.class))
                    )|| typeLeft.equals(Object.class)|| typeRight.equals(Object.class)
                  ){
                    return Boolean.class;
                }
                return null;
            }      
        } 
    
    /**
     * Greater than operator executer
     * Examples:
     * 124 > 123 -> true
     * 124 > 124 -> false
     * 124 > 125 -> false
     */     
    public class GtOperator extends AbstractBinOperator{
            public GtOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }           
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = Afe_FunctionDefinition.round((Decimal)left, ec);
                    Decimal rightDecimal = Afe_FunctionDefinition.round((Decimal)right, ec);
                    return (Object)((Decimal)leftDecimal > (Decimal)rightDecimal);
                }else if(left instanceof boolean && right instanceof boolean){
                    return (Object)(left==true && right==false);
                }else if(left instanceof string && right instanceof string){
                    return (Object)(String.valueOf(left).compareTo(String.valueOf(right))>0 );
                }else if(left instanceof Time && right instanceof Time){
                    return (Time)left > (Time)right;
                }else if(left instanceof DateTime && right instanceof DateTime){
                    return (DateTime)left > (DateTime)right;
                }
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Comparison','Integer, Boolean, Datetime'})
                ); 
            }  
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(
                    (typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)) ||
                    (typeLeft.equals(Boolean.class) && typeRight.equals(Boolean.class)) ||
                    (typeLeft.equals(String.class) && typeRight.equals(String.class))|| 
                    (typeLeft.equals(Time.class) && typeRight.equals(Time.class)) || 
                    (
                        (typeLeft.equals(Date.class)||typeLeft.equals(DateTime.class)) && 
                        (typeRight.equals(Date.class)||typeRight.equals(DateTime.class))
                    )|| typeLeft.equals(Object.class)|| typeRight.equals(Object.class)
                  ){
                    return Boolean.class;
                }
                return null;
            }       
        }
    
    /**
     * Greater or equal operator executer
     * Examples:
     * 124 >= 123 -> true
     * 124 >= 124 -> true
     * 124 >= 125 -> false
     */     
    public class GeOperator extends AbstractBinOperator{
            public GeOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }               
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = Afe_FunctionDefinition.round((Decimal)left, ec);
                    Decimal rightDecimal = Afe_FunctionDefinition.round((Decimal)right, ec);
                    return (Object)((Decimal)leftDecimal >= (Decimal)rightDecimal);
                }else if(left instanceof boolean && right instanceof boolean){
                    return (Object)(left==true && right==false);
                }else if(left instanceof string && right instanceof string){
                    return (Object)(String.valueOf(left).compareTo(String.valueOf(right))>=0 );
                }else if(left instanceof Time && right instanceof Time){
                    return (Time)left >= (Time)right;
                }else if(left instanceof DateTime && right instanceof DateTime){
                    return (DateTime)left >= (DateTime)right;
                }
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'Comparison','Integer, Boolean, Datetime'})
                ); 
            }
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(
                    (typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)) ||
                    (typeLeft.equals(Boolean.class) && typeRight.equals(Boolean.class)) ||
                    (typeLeft.equals(String.class) && typeRight.equals(String.class))|| 
                    (typeLeft.equals(Time.class) && typeRight.equals(Time.class))|| 
                    (
                        (typeLeft.equals(Date.class)||typeLeft.equals(DateTime.class)) && 
                        (typeRight.equals(Date.class)||typeRight.equals(DateTime.class))
                    )|| typeLeft.equals(Object.class)|| typeRight.equals(Object.class)
                  ){
                    return Boolean.class;
                }
                return null;
            }      
        }    
    /**
     * Definition for PLUS(+) operator
     * Examples:
     * 1+2.5 -> 3.5
     * "abc"+"def" -> abcdef
     * "abc"+ 123 -> abc123
     * TIME(10,10,0)+TIME(10,10,0) -> 20:20:00
     * DATETIME(2021,03,30,10,10,0)+(1/1440/60) -> 2021-03-30 01:10:01 (GMT time), 2021-03-30 10:10:01 (local time)
     * DATE(2021,03,30)+(1/1440/60) -> 2021-03-29 15:00:01 (GMT time), 2021-03-30 00:00:01(Local time)
     */ 
    public class PlusOperator extends AbstractBinOperator{
            public PlusOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }           
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    /*Decimal result =*/ return (Decimal)left + (Decimal)right;
                    //return Afe_FunctionDefinition.round(result,ec);
                }else if(left instanceof string || right instanceof string){
                    if(left instanceof Decimal){
                        left = Afe_FunctionDefinition.stripTrailingZeros(left);
                    }
                    if(right instanceof Decimal){
                        right = Afe_FunctionDefinition.stripTrailingZeros(right);
                    }                    
                    return String.valueOf(left) + String.valueOf(right);
                }else if(left instanceof Datetime && right instanceof Decimal){
                    Datetime dtLeft=(Datetime)left;
                    if(left instanceof Date){
                        dtLeft = Datetime.newInstance((Date)left,Time.newInstance(0, 0, 0, 0));
                    }
                    Decimal dR = Afe_FunctionDefinition.roundManualScale(((Decimal)right)*24*60*60*1000,-3,ec);  
                    return Datetime.newInstance(dtLeft.getTime() + dR.longValue());                    
                }else if(left instanceof Time && right instanceof Time){
                    Time tL = (Time)left, tR = (Time)right;
                    Integer lR = tR.hour()*60*60*1000 + tR.minute()*60*1000 + tR.second()*1000 + tR.millisecond();
                    return tL.addMilliseconds(lR);  
                }else if(left instanceof Datetime && right instanceof Time){
                    Datetime dtLeft=(Datetime)left;
                    if(left instanceof Date){
                        dtLeft = Datetime.newInstance((Date)left,Time.newInstance(0, 0, 0, 0));
                    }
                    Time tR = (Time)right;
                    Long lR = tR.hour()*60*60*1000 + tR.minute()*60*1000 + tR.second()*1000 + tR.millisecond();     
                    return Datetime.newInstance(dtLeft.getTime() + lR);
                }
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'PLUS','numeric, string, date'})
                ); 
            }
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)){
                    return Decimal.class;
                }else if(typeLeft.equals(String.class) || typeRight.equals(String.class)){
                    return String.class;
                }else if(typeLeft.equals(Datetime.class) && typeRight.equals(Decimal.class)){
                    return Datetime.class;
                }else if(typeLeft.equals(Time.class) && typeRight.equals(Time.class)){
                    return Time.class;
                }else if(typeLeft.equals(Datetime.class) && typeRight.equals(Time.class)){
                    return Datetime.class;
                }
                return null;
            }        
        }
    
    /**
     * Concat string operator
     * Example:
     * "abc"&"def" -> abcdef
     */    
    public class ConcatOperator extends AbstractBinOperator{
            public ConcatOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }           
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal){
                    left = Afe_FunctionDefinition.stripTrailingZeros(left);
                }
                if(right instanceof Decimal){
                    right = Afe_FunctionDefinition.stripTrailingZeros(right);
                }                
                return String.valueOf(left) + String.valueOf(right);
            }
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                return String.class;
            }       
        }

	/**
     * Definition for MINUS(-) operator
     * Examples:
     * 1+2 -> 3
     * VALUE("1")+VALUE("2") -> 3
     * ---+(-(++-2)) -> -2
     * TIME(10,10,0)-TIME(9,2,0) -> 01:08:00
	 * DATE(2021,2,28)-DATETIME(2021,2,21,23,0,0) -> 6.04167 (days)
	 * DATETIME(2021,2,28,15,50,0)-DATETIME(2021,2,21,23,0,0) -> 6.70139 (days)
	 * DATETIME(2021,2,28,15,50,0)-TIME(2,10,0) -> 2021-02-28 04:40:00 ( gio GMT)
	 */                         
    public class MinusOperator extends AbstractBinOperator{
            public MinusOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }             
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                   /* Decimal result =*/ return (Decimal)left - (Decimal)right;
                   // return Afe_FunctionDefinition.round(result,ec);
                }else if(left instanceof Datetime && right instanceof Decimal){
                    Datetime dtLeft=(Datetime)left;
                    if(left instanceof Date){
                        dtLeft = Datetime.newInstance((Date)left,Time.newInstance(0, 0, 0, 0));
                    }
                    Decimal dR = Afe_FunctionDefinition.roundManualScale(((Decimal)right)*24*60*60*1000,-3,ec);  
                    return Datetime.newInstance(dtLeft.getTime() - dR.longValue()); 
                }else if(left instanceof Time && right instanceof Time){
                    Time tL = (Time)left, tR = (Time)right;
                    Integer lR = tR.hour()*60*60*1000 + tR.minute()*60*1000 + tR.second()*1000 + tR.millisecond();
                    return tL.addMilliseconds(-lR);  
                }else if(left instanceof Datetime && right instanceof Datetime){
                    Datetime dtLeft=(Datetime)left, dtRight= (Datetime)right;
                    if(left instanceof Date){
                        dtLeft = Datetime.newInstance((Date)left,Time.newInstance(0, 0, 0, 0));
                    }
                    if(right instanceof Date){
                        dtRight = Datetime.newInstance((Date)right,Time.newInstance(0, 0, 0, 0));
                    }      
                    return Afe_FunctionDefinition.round(Decimal.valueOf(dtLeft.getTime()-dtRight.getTime())/1000/60/60/24,ec);
                }else if(left instanceof Datetime && right instanceof Time){
                    Datetime dtLeft=(Datetime)left;
                    if(left instanceof Date){
                        dtLeft = Datetime.newInstance((Date)left,Time.newInstance(0, 0, 0, 0));
                    }
                    Time tR = (Time)right;
                    Long lR = tR.hour()*60*60*1000 + tR.minute()*60*1000 + tR.second()*1000 + tR.millisecond();     
                    return Datetime.newInstance(dtLeft.getTime() - lR);
                }
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'MINUS','numeric'})
                );
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)){
                    return Decimal.class;
                }else if(typeLeft.equals(Datetime.class) && typeRight.equals(Datetime.class)){
                    return Decimal.class;
                }else if(typeLeft.equals(Datetime.class) && typeRight.equals(Time.class)){
                    return Datetime.class;
                }else if(typeLeft.equals(Time.class) && typeRight.equals(Time.class)){
                    return Time.class;
                }else if(typeLeft.equals(Datetime.class) && typeRight.equals(Decimal.class)){
                    return Datetime.class;
                }
                return null;
            }        
        }
    /**
     * Mul operator executer
     * Example:
     * 3*5 -> 15
     */ 
    public class MulOperator extends AbstractBinOperator{
            public MulOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }             
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    //Decimal result = (Decimal)left * (Decimal)right;
                    //return Afe_FunctionDefinition.round(result,ec);
                    return (Decimal)left * (Decimal)right;
                } 
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'MUL','numeric'})
                );
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)){
                    return Decimal.class;
                }
                return null;
            }          
        }
    
    /**
     * Div operator executer
     * Example:
     * 15/5 -> 3
     */
    public class DivOperator extends AbstractBinOperator{
            public DivOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }            
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = (Decimal)left;
                    Decimal rightDecimal = (Decimal)right;
                    if(ec.dc != null && ec.dc.divideScale > 0)
                        return leftDecimal.divide(rightDecimal, ec.dc.divideScale, ec.dc.rd);
                    else 
                        return leftDecimal/rightDecimal;
                } 
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'DIV','numeric'})
                ); 
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)){
                    return Decimal.class;
                }
                return null;
            }         
        }
    /**
     * Definition for power operator
     * Examples:
     * -2^2 -> -4
     * -2^3^-4 -> -1.008594
     * 3^2 -> 9
     */
    public class PowerOperator extends AbstractBinOperator{
            public PowerOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }            
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    /*Decimal result =*/return Decimal.valueOf(
                        Math.pow(
                            ((Decimal)left).doubleValue() 
                            , ((Decimal)right).doubleValue()
                        )                
                    );
                    //return Afe_FunctionDefinition.round(result,ec);
                } 
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'POWER','numeric'})
                );
            } 
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)){
                    return Decimal.class;
                }
                return null;
            }         
        }
	
    /**
     * Remainder operator executer
     * Examples:
     * 9 % 2 -> 1
     * -2 % 1.5 -> 1
     */ 
    public class RemainderOperator extends AbstractBinOperator{
            public RemainderOperator(String op,Integer precedence, Assoc assoc){
                super(op,precedence,assoc);
            }               
            public Object calculate(Object left, Object right, Afe_Evaluator.EvalContext ec){
                if(left instanceof Decimal && right instanceof Decimal){
                    Decimal leftDecimal = (Decimal) left;
                    Decimal rightDecimal = (Decimal) right;
                    Decimal quotient = Math.Floor(leftDecimal / rightDecimal);
                    Decimal result = leftDecimal - (rightDecimal * quotient);
                    return result;//Afe_FunctionDefinition.round(result,ec);
                } 
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_WRONG_OP_PARAM_EX, new String[]{'REMAINDER','numeric'})
                );
            }
            public override System.Type validate(System.Type typeLeft, System.Type typeRight){
                if(typeLeft.equals(Decimal.class) && typeRight.equals(Decimal.class)){
                    return Decimal.class;
                }
                return null;
            }          
        }
    
    /**
     * Parser constructor with no param
     */ 
    public Afe_Parser(){
        this.initOperators();
        this.initConstants();
    }
    
    /**
     * Parser constructor with expression
     * @param fumular input expression
     */     
    public Afe_Parser(String formular){
        this.initOperators();
        this.initConstants();
        this.lexer = new Afe_Lexer(formular,this); 
        this.lexer.getToken();
    }
    
    /**
     * Provide expression for lexer
     * @param fumular input expression
     */     
    public void setFomular(String formular){
        this.lexer = new Afe_Lexer(formular,this); 
        this.lexer.getToken();        
    }
    
    /**
     * Add operator 
     * @param op Operator instance
     */ 
    public void addOperator(IOperator op){
        if(operators == null){
            operators = new Map<String,IOperator>();
        }
        operators.put(op.getOp(), op);
    }
    
    /**
     * Add unary operator 
     * @param op Unary operator instance
     */    
    public void addUnaryOperator(IOperator op){
        if(unaryOperators == null){
            unaryOperators = new Map<String,IOperator>();
        }
        unaryOperators.put(op.getOp(), op);        
    }
    
    /**
     * Get operator list
     * @return Map operators
     */    
    public Map<String,IOperator> getOperators(){
        return operators;
    }
    
    /**
     * Get unary operator list
     * @return Map unray operators
     */      
    public Map<String,IOperator> getUnaryOperators(){
        return unaryOperators;       
    }
    
    /**
     * Add constant
     * @param constantName constant name
     * @param value Constant value
     */   
    public void addConstant(String constantName, Object value){
        if(constants == null){
            constants = new Map<String,Object>();
        }
        constants.put(constantName.toLowerCase(), value);
    }
    
    /**
     * Init operators
     */        
    private void initOperators(){
        addOperator( new OrOperator('||',100, Assoc.LEFT));
        addOperator( new AndOperator('&&',200, Assoc.LEFT));     
        addOperator( new EqOperator('==',300, Assoc.LEFT));
        addOperator( new EqOperator('=',300, Assoc.LEFT));
        addOperator( new NeqOperator('!=',300, Assoc.LEFT));
        addOperator( new NeqOperator('<>',300, Assoc.LEFT));
        
        addOperator( new LtOperator('<',400, Assoc.LEFT));
        addOperator( new LeOperator('<=',400, Assoc.LEFT));
        addOperator( new GtOperator('>',400, Assoc.LEFT));
        addOperator( new GeOperator('>=',400, Assoc.LEFT));
        
        addOperator( new PlusOperator('+',500, Assoc.LEFT));
        addOperator( new ConcatOperator('&',500, Assoc.LEFT));
        addOperator( new MinusOperator('-',500, Assoc.LEFT));
        
        addOperator( new MulOperator('*',600, Assoc.LEFT));
        addOperator( new DivOperator('/',600, Assoc.LEFT));
        addOperator( new RemainderOperator('%',600, Assoc.LEFT)); 
        
        addUnaryOperator( new UnaryPosOperator('+', 700));
        addUnaryOperator( new UnaryNegOperator('-', 700));        
        
        addOperator( new PowerOperator('^',800, Assoc.RIGHT));
    }
    
    /**
     * Init constants
     */ 
    private void initConstants(){
        addConstant('e',Math.E);
        addConstant('pi',Math.Pi);
        addConstant('true',true);
        addConstant('false',false);
        addConstant('null',null);
    }   
    
    /**
     * Parse Number
     * @return Node Base node instance
     */ 
    private Afe_Parser.Node parseDoubleNumber(){
        Afe_Parser.DoubleNumberNode nbrNode = new Afe_Parser.DoubleNumberNode(
            lexer.currentToken.doubleValue,
            true
        );
        lexer.getToken();
        return nbrNode;
    }  
    
    /**
     * Parse String
     * @return Node Base node instance
     */ 
    private Afe_Parser.Node parseString(){
        Afe_Parser.StringNode strNode = new Afe_Parser.StringNode(
            lexer.currentToken.identifierValue
        );
        lexer.getToken();
        return strNode;
    }  
    
    /**
     * Parse Boolean
     * @return Node Base node instance
     */  
    /*private Afe_Parser.Node parseBool(){
        Afe_Parser.BoolNode boolNode = new Afe_Parser.BoolNode(
            lexer.currentToken.boolValue
        );
        lexer.getToken();
        return boolNode;
    }*/  
    
    /**
     * Parse constant
     * @return Node Base node instance
     */    
    private Afe_Parser.Node parseConstant(String identifier){
        if(constants.containsKey(identifier)){
 			Object constant = constants.get(identifier);
            if(constant==null){
                return new NullNode();
            }else if(constant instanceof Decimal){
                if(!identifier.equals('pi') && !identifier.equals('e')){
                   return new Afe_Parser.DoubleNumberNode((Decimal)constant, true);  
                }else{
                   return new Afe_Parser.DoubleNumberNode((Decimal)constant, false);  
                }
            }else if(constant instanceof String){
                return new Afe_Parser.StringNode(String.valueOf(constant));
            }else if(constant instanceof Boolean){
                return new Afe_Parser.BoolNode((Boolean)constant);            
            }else throw new Afe_Exception(Afe_Evaluator.MSG_UNSUPPORT_CONST);            
        }else return null;
    }
    
    /**
     * parse variable, function call and constant
     * @return Node Base node instance
     */
    private Afe_Parser.Node parseIdentifier(){
        String identifierStr = lexer.currentToken.identifierValue;
        lexer.getToken();
        if(lexer.currentToken.tokenType 
           != Afe_Token.TokenType.TOKEN_PAREN_OPEN){
            Afe_Parser.Node constantNode;
            if((constantNode=parseConstant(identifierStr.toLowerCase()))!=null){
               return constantNode;
            }   
            Afe_Parser.VariableNode node = new Afe_Parser.VariableNode(identifierStr);
            return node;
        }else{
            lexer.getToken();// eat (
            List<Afe_Parser.Node> args = new List<Afe_Parser.Node>();
            if(lexer.currentToken.tokenType 
               != Afe_Token.TokenType.TOKEN_PAREN_CLOSE){
                while(true){
                    Afe_Parser.Node arg = parseEx();
                    args.add(arg);
                    if(lexer.currentToken.tokenType 
                       == Afe_Token.TokenType.TOKEN_PAREN_CLOSE){
                        break;
                    }
                    if(lexer.currentToken.tokenType 
                       != Afe_Token.TokenType.TOKEN_COMMA){
                        throw new Afe_Exception(
                                String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})        
                        ); 
                    }
                    lexer.getToken();
                }
            }
            lexer.getToken();// eat  )
            Type t = Type.forName('Afe_FunctionDefinition.'+identifierStr.toLowerCase()+'Function');
            if(t==null){
                throw new Afe_Exception(String.format(Afe_Evaluator.MSG_METH_NOTFOUND, new String[]{identifierStr.toUpperCase()}));
            }            
            Afe_FunctionDefinition.IFunction funcExecuter = (Afe_FunctionDefinition.IFunction) t.newInstance();
            List<Afe_FunctionDefinition> functionInfos = funcExecuter.getInfo();
            for(Afe_FunctionDefinition functionInfo : functionInfos){
                //getParamCount() = -1 when params is unlimited
                if((functionInfo.paramCount != -1 && args.size() != functionInfo.paramCount)||
                    (functionInfo.paramCount == -1 && args.size() < 1)){
					continue;
                }
                Boolean paramsValid = true;
                for(Integer i = 0; i<args.size(); i++){
                    Afe_Parser.Node arg = args.get(i);
                    System.Type compareTarget = functionInfo.paramCount == -1 ? functionInfo.params[0] : functionInfo.params[i];
                    if(
                        //!arg.returnType.equals(VariableNode.class) &&
                        !arg.returnType.equals(Object.class) &&
                        !functionInfo.params[ functionInfo.paramCount == -1 ? 0 : i].equals(Object.class)&&
                        !arg.returnType.equals(compareTarget)
                    ){
                        paramsValid = false;
                    }
                }
                if(paramsValid){
                    Afe_Parser.CallFuncNode callFuncNode = new Afe_Parser.CallFuncNode(
                        identifierStr,
                        args,
                        functionInfo.returnType,
                        funcExecuter
                    );
                    return callFuncNode;                       
                }                
            }            
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_WRONG_METH_PARAM, new String[]{identifierStr.toUpperCase()})
            );
        }   
    }    
    
    /**
     * Parse Pr of math expression
     * @return Node Base node instance
     */
    private Afe_Parser.Node parsePr(){
        lexer.getToken();
        //check if Parentheses has null body
        if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_PAREN_CLOSE){
            lexer.getToken();
            throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_PAREN_NULL_BODY, 
                                  new String[]{String.valueOf(lexer.lexerPosition)})        
            );             
        }
        // Parse Parentheses body
        Afe_Parser.Node subNode = parseEx();
        if(lexer.currentToken.tokenType 
           != Afe_Token.TokenType.TOKEN_PAREN_CLOSE){
            throw new Afe_Exception(
				String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
            );
        }
        lexer.getToken();
        return subNode;
    }    
    
    /**
     * Parse Top of math expression
     * @return Node Base node instance
     */ 
    public Afe_Parser.Node parseTop(){
 		Afe_Parser.Node root = parseEx();
        if(lexer.currentToken.tokenType
          != Afe_Token.TokenType.TOKEN_EOF){
            throw new Afe_Exception(
				String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})            
            );
        }
        return root;
    }  
    
    /**
     * Parse Ex of math expression
     * @return Node Base node instance
     */    
    private Afe_Parser.Node parseEx(){
        Afe_Parser.Node lhs = parsePrm();
        if(null != lhs){           
            return parseBo(100, lhs);
        }
        throw new Afe_Exception(Afe_Evaluator.MSG_UNABLE_PARSE_EXPR); 
    }
    
    /**
     * Parse Bo of math expression
     * @param inputPrec
     * @param lhs
     */
    private Afe_Parser.Node parseBo(integer inputPrec, Afe_Parser.Node lhs){
        while(true){ 
            IOperator iopCurr = getOperator();
            if(iopCurr==null || iopCurr.getPrec() < inputPrec){
                return lhs;
            }            
            lexer.getToken();
            Afe_Parser.Node rhs = parsePrm();
            if(rhs == null){
                throw new Afe_Exception(Afe_Evaluator.MSG_UNABLE_PARSE_EXPR); 
            }
            while(true){ 
                IOperator iopNext = getOperator();
                if(iopNext==null || 
                   !(
                       iopCurr.getPrec() < iopNext.getPrec() ||
                       (
                       	iopCurr.getPrec() == iopNext.getPrec() &&
                        iopNext.getAss() == Assoc.RIGHT
                       )
                   )
                  ){
                   break; 
                }
                rhs = parseBo(iopNext.getPrec(), rhs);                
            } 
            System.Type t = iopCurr.validate(lhs.returnType, rhs.returnType);
            if(t==null){
                //if(!lhs.returnType.equals(VariableNode.class) && !rhs.returnType.equals(VariableNode.class)){
                if(!lhs.returnType.equals(Object.class) && !rhs.returnType.equals(Object.class)){
                    throw new Afe_Exception(
                        String.format(
                            Afe_Evaluator.MSG_WRONG_OP_PARAM, 
                            new String[]{iopCurr.getOp(), lhs.returnType.toString(),rhs.returnType.toString()}
                        )
                    );
                     
                }else if(!lhs.returnType.equals(Object.class)){  
                   lhs = new Afe_Parser.BinanyNode(iopCurr,lhs,rhs,lhs.returnType); 
                }else if(!rhs.returnType.equals(Object.class)){  
                   lhs = new Afe_Parser.BinanyNode(iopCurr,lhs,rhs,rhs.returnType); 
                }else{   
                   lhs = new Afe_Parser.BinanyNode(iopCurr,lhs,rhs,Object.class); 
                }                
            }else{
                lhs = new Afe_Parser.BinanyNode(iopCurr,lhs,rhs,t);
            }
        }
        return lhs;
    }
    
    /**
     * Get relate operator excuter
     * @return IOperator operator executer
     */ 
    private IOperator getOperator(){
        String op = lexer.currentToken.identifierValue;
        return (lexer.currentToken.tokenType == 
            Afe_Token.TokenType.TOKEN_OP && operators.containsKey(op))
            ?
            operators.get(op) 
            : null;
    }  
    
     /**
     * Parse unary operator
     * @return Node Base node instance
     */    
    private Afe_Parser.Node parseUnary(){
        String op = lexer.currentToken.identifierValue;
        IOperator iop = unaryOperators.get(op);
        lexer.getToken();//eat +,-
       // Afe_Parser.Ast expr = parsePrm();
        Afe_Parser.Node lhs = parsePrm();
        /*Afe_Parser.Node expr = parseBo(iop.getPrec(), lhs);        
        if(expr == null){
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
            );             
        }*/
        return new Afe_Parser.UnaryNode(iop,/*expr*/parseBo(iop.getPrec(), lhs));
    }
    
     /**
     * Parse ifelse condition
     * @return Node Base node instance
     * Example:
     * new Afe_Evaluator('IF(abc > 1 && true,if(cde + 1 <6.5, "amazing", "n/a"), "n/a")')
     * .bind('abc',2).bind('cde',3).eval() -> return "amazing"
     */   
    private Afe_Parser.Node parseIfElse(){
        lexer.getToken();
        //parse IF condition
        /*if(lexer.currentToken.tokenType 
           != Afe_Token.TokenType.TOKEN_PAREN_OPEN){
        		throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                                  new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
                );  
        }*/
        lexer.getToken();//eat (
        Afe_Parser.Node condition = parseEx();
        //parse if true condition
        if(lexer.currentToken.tokenType != Afe_Token.TokenType.TOKEN_COMMA){ 
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
            );
        }
        lexer.getToken(); //eat ,
        Afe_Parser.Node ifTrueNode = parseEx();
        
        //parse if false condition
        if(lexer.currentToken.tokenType != Afe_Token.TokenType.TOKEN_COMMA){ 
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
            );
        }
        lexer.getToken(); //eat ,
        Afe_Parser.Node ifFalseNode = parseEx();  
      
        //check endif token
        if(lexer.currentToken.tokenType 
           != Afe_Token.TokenType.TOKEN_PAREN_CLOSE){
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
            );
        }
        lexer.getToken(); //eat )
        if(
            //!condition.returnType.equals(VariableNode.class) &&  
            !condition.returnType.equals(Object.class) && 
            !condition.returnType.equals(Boolean.class)
        ){
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_IFELSE_WRONG_CONDITION, 
                              new String[]{condition.returnType.toString()})
            );    
        }else if(
            	//!ifTrueNode.returnType.equals(VariableNode.class) && 
                //!ifFalseNode.returnType.equals(VariableNode.class) &&   
            	!ifTrueNode.returnType.equals(Object.class) && 
                !ifFalseNode.returnType.equals(Object.class) &&             
                !ifTrueNode.returnType.equals(ifFalseNode.returnType)
        ){
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_CONDITIONAL_WRONG_PARAMS, 
                              new String[]{'IF',ifTrueNode.returnType.toString(),ifFalseNode.returnType.toString()})
            );             
        }
//        if(ifTrueNode.returnType.equals(VariableNode.class) || ifFalseNode.returnType.equals(VariableNode.class)){
//            return new Afe_Parser.IfElseNode(condition,ifTrueNode,ifFalseNode,VariableNode.class);
     
/*        if(ifTrueNode.returnType.equals(Object.class) || ifFalseNode.returnType.equals(Object.class)){
            return new Afe_Parser.IfElseNode(condition,ifTrueNode,ifFalseNode,Object.class);
        }else{
           return new Afe_Parser.IfElseNode(condition,ifTrueNode,ifFalseNode,ifTrueNode.returnType); 
        }*/
        
		if(!ifTrueNode.returnType.equals(Object.class)){
            return new Afe_Parser.IfElseNode(condition,ifTrueNode,ifFalseNode,ifTrueNode.returnType);
        }else if(!ifFalseNode.returnType.equals(Object.class)){
            return new Afe_Parser.IfElseNode(condition,ifTrueNode,ifFalseNode,ifFalseNode.returnType);
        }{
           return new Afe_Parser.IfElseNode(condition,ifTrueNode,ifFalseNode,Object.class); 
        }        
    }
    
     /**
     * Parse switch, case condition
     * @return Node Base node instance
     * Example:
     * new Afe_Evaluator('CASE(abc,1,"amazing",2,"good",3,"bad","n/a")').bind('abc',2).eval() -> return "good"
     */
    private Afe_Parser.Node parseSwitchCase(){
        lexer.getToken();//eat Switch, case
        //parse switch condition
        /*if(lexer.currentToken.tokenType 
           != Afe_Token.TokenType.TOKEN_PAREN_OPEN ){
            throw new Afe_Exception(
                String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
            );
        }*/
        lexer.getToken();//eat (
        Afe_Parser.Node condition = parseEx();
        if(condition==null){
            throw new Afe_Exception(
                Afe_Evaluator.MSG_CASE_WRONG_PARAMS
            );             
        }
        //Parse var and result.
        List<Afe_Parser.Node> varResultExprs = new List<Afe_Parser.Node>();
        while(true){
            if(
              lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_PAREN_CLOSE
              ){ 
                if(varResultExprs.size()<1){
                      throw new Afe_Exception(
                          Afe_Evaluator.MSG_CASE_WRONG_PARAMS
                      );                     
                }else if(Math.mod(varResultExprs.size(), 2)==0){
                      throw new Afe_Exception(
                          Afe_Evaluator.MSG_CASE_WRONG_PARAMS
                      );                     
                }
                lexer.getToken(); //eat )  			
                
                System.Type temp = null;//varResultExprs.get(varResultExprs.size()-1).returnType;                
                for(integer i = 1; i < varResultExprs.size()-1; i=i+2){
                    if(temp != null && varResultExprs.get(i).returnType != Object.class && !temp.equals(varResultExprs.get(i).returnType)){
                        throw new Afe_Exception(
                            String.format(Afe_Evaluator.MSG_CONDITIONAL_WRONG_PARAMS, 
                                          new String[]{'SWITCH',temp.toString(),varResultExprs.get(i).returnType.toString()})
                        );                         
                    }
                    temp = varResultExprs.get(i).returnType;
                }                  
                  
				return new Afe_Parser.SwitchCaseNode(
                    condition,
                    varResultExprs,
                    varResultExprs.get(varResultExprs.size()-1),
                    temp==null ? Object.class : temp
                );
            }            
            if(lexer.currentToken.tokenType != Afe_Token.TokenType.TOKEN_COMMA){ 
                throw new Afe_Exception(
                    String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                                  new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})
                );
            }
            lexer.getToken(); //eat ,
            Afe_Parser.Node tempExpr = parseEx();
			varResultExprs.add(tempExpr);
        } 
        return null;
    }
    
    /**
     * Start parse anything inside a binary expression
     * @return Node Base node instance
     */  
    private Afe_Parser.Node parsePrm(){
        if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_IDENTIFIER){
            return parseIdentifier();
        }else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_IF){
            return parseIfElse();
        }else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_CASE){
            return parseSwitchCase();
        }else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_NUMBER_DECIMAL){
            return parseDoubleNumber();
        }else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_STRING){
            return parseString();
        }/*else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_BOOL){
            return parseBool();
        }*/else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_PAREN_OPEN){
            return parsePr();
        }else if(lexer.currentToken.tokenType == Afe_Token.TokenType.TOKEN_UOP){
            return parseUnary();
        }
        throw new Afe_Exception(
				String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              new String[]{lexer.currentToken.toString(), String.valueOf(lexer.lexerPosition)})        
        ); 
    }
}