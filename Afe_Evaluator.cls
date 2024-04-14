public class Afe_Evaluator {
    public static final String MSG_WRONG_OP_PARAM = 'The operator {0} is undefined for the argument type(s) {1}, {2}';
    public static final String MSG_WRONG_OP_PARAM_EX = '{0} operator can only be applied to {1}';
    public static final String MSG_WRONG_METH_PARAM = 'Check params for function {0}';
    public static final String MSG_METH_NOTFOUND = 'Function {0} does not exist';
    public static final String MSG_METH_NOT_ALLOWED = 'Function {0} is not alowed. Please contact your system\'s administrator';
    public static final String MSG_UNEXPECT_TOKEN = 'Unexpected token {0}';
    //public static final String MSG_UNEXPECT_TOKEN_AT_POS = 'Unexpected token "{0}" at position {1}';
    public static final String MSG_UNEXPECT_TOKEN_AT_POS = 'Unexpected token "{0}"';
    public static final String MSG_CONDITIONAL_WRONG_PARAMS = 'Incorrect parameter type for function {0}. Expected {1}, received {2}';    
    public static final String MSG_IFELSE_WRONG_CONDITION = 'Incorrect condition type for function IF. Expected Boolean, received {0}';
    public static final String MSG_IFELSE_NESTIF_CONDITION = 'Nested "if" expression in condition param is not accepted!';    
    //public static final String MSG_IFELSE_WRONG_SYNTAX = 'Check ifelse syntax';
    public static final String MSG_CASE_WRONG_PARAMS = 'Incorrect number of parameters for function CASE';    
    public static final String MSG_UNSUPPORT_CONST = 'Unsupported constant type';
    public static final String MSG_PAREN_NULL_BODY = 'Require parentheses body near position {0}';
    public static final String MSG_UNARY_INVALID = 'Invalid unary operator';
    public static final String MSG_UNABLE_PARSE_EXPR = 'Unable to parse expression';    
    public static final String MSG_RESULT_WRONG = 'Result is not a {0}'; 
    public static final String MSG_VAR_NOTSET = 'The value for variable {0} was not set!';     
    public class Afe_Exception extends Exception {}
 	private Afe_Parser parser;
    private Afe_Parser.Node root;
    private EvalContext ec;
    private Map<String,object> variableParams;
    private List<String> notAllowedFunctions;
    
    /**
     * Default constructor
     */ 
    public Afe_Evaluator(){
        this.ec = new EvalContext(new DecimalContext(11,RoundingMode.HALF_EVEN));
        variableParams = new Map<String,object>();
        parser = new Afe_Parser();
    }
    
    /**
     * Constructor with expression
     */
    public Afe_Evaluator(String formular){
        this.ec = new EvalContext(new DecimalContext(15,RoundingMode.HALF_EVEN));
        variableParams = new Map<String,object>();
        parser = new Afe_Parser(formular);  
    }  
    
    /**
     * Return parser instance
     * @return Afe_Parser parser
     *
     */     
    public Afe_Parser getParser(){
        return parser;
    }

    /**
     * Bind value to variable in expression
     * @param key variable name
     * @param value value to bind
     * @return Afe_Evaluator instance
     *
     */     
    public Afe_Evaluator bind(String key,Object value){
        variableParams.put(key.toLowerCase(),value);
        return this;
    }
    
    /**
     * Set expression string for eval
     * @param formular expression string, ex: 1+2
     * @return Afe_Evaluator instance
     *
     */    
    public Afe_Evaluator setExpression(String formular){
        this.gc();
        this.getParser().setFomular(formular);
        return this;
    }  

    /**
     * Set Number precsion digits, default is 15
     * @param precision precsion digits
     * @return Afe_Evaluator instance
     *
     */     
    public Afe_Evaluator setPrecision(Integer precision){
		ec.dc.precision = precision;
        return this;
    }
    
    /**
     * Set Divide operator scale number, default is -1 (this means don't set scale for divide operator)
     * @param scale Scale number
     * @return Afe_Evaluator instance
     *
     */     
    public Afe_Evaluator setDivideScale(Integer scale){
		ec.dc.divideScale = scale;
        return this;
    }    
    
    /**
     * Set Math context rounding mode, default is HALFEVENT
     * @param rd rounding mode
     * @return Afe_Evaluator instance
     */ 
    public Afe_Evaluator setRoundingMode(RoundingMode rd){
		ec.dc.rd = rd;
        return this;
    } 
    
    /**
     * Set holiday
     * @param holidays holidays of period
     * @return Afe_Evaluator instance
     */
    public Afe_Evaluator setHolidays(Date[] holidays){
		ec.holidays = holidays;
        return this;
    } 
    
    /**
     * Disable single function
     * @param functionName function name will be disabled
     * @return Afe_Evaluator instance
     */     
    public Afe_Evaluator disableFunction(String functionName){
        if(functionName!=null && !functionName.trim().equals('')){
            if(notAllowedFunctions==null){
                notAllowedFunctions = new List<String>();
            }
            notAllowedFunctions.add(functionName.trim().toLowerCase());            
        }
        return this;
    }
    
    /**
     * Disable multiple functions
     * @param functionNames List of function name will be disabled
     * @return Afe_Evaluator instance
     */ 
    public Afe_Evaluator disableFunction(String[] functionNames){
        for(String functionName : functionNames){
            if(functionName!=null && !functionName.trim().equals('')){
                if(notAllowedFunctions==null){
                    notAllowedFunctions = new List<String>();
                }
                notAllowedFunctions.add(functionName.trim().toLowerCase());            
            }            
        }
        return this;
    } 
    
    /**
     * Validate expression
     * @return object value
     */     
    public List<String> getError(){
        List<String> errors = new List<String>();
        try{
            if(parser.parseTop()==null){
                errors.add(MSG_UNABLE_PARSE_EXPR);
            } 
        }catch(Exception e){
            errors.add(e.getMessage());
        }
        return errors;
    }
    
    /**
     * Eval expression and return object value
     * @return evaluation result with object type
     */     
    public Object eval(){
        if(root==null){
          root = parser.parseTop();  
        }
        Object result = this.visitNode(root);   
        if(result instanceof Decimal){
            Decimal resultDec = Afe_FunctionDefinition.round((Decimal)result, ec);
            return Afe_FunctionDefinition.stripTrailingZeros(resultDec);
        }
        return result;
    }
    
    /**
     * Eval expression and return number value
     * @return evaluation result with Decimal type
     */ 
    public Decimal evalNumber(){
        if(root==null){
          root = parser.parseTop();  
        }
        Object result = this.visitNode(root);
        if(result instanceof Decimal){
            Decimal resultDec = Afe_FunctionDefinition.round((Decimal)result, ec);
            return Afe_FunctionDefinition.stripTrailingZeros(resultDec);
        }
        throw new Afe_Exception(
				String.format(MSG_RESULT_WRONG,new String[]{'Number'})        
        );         
    }
    
    /**
     * Eval expression and return boolean value
     * @return evaluation result with Boolean type
     */ 
    public Boolean evalBool(){
        if(root==null){
          root = parser.parseTop();  
        }
        Object result = this.visitNode(root);
        if(result instanceof Boolean){
            return (Boolean)result;
        }
        throw new Afe_Exception(
				String.format(MSG_RESULT_WRONG,new String[]{'Boolean'})        
        );
    }    
    
    /**
     * Eval expression and return string value
     * @param forceToString convert to String if eval result is not an instance Of String
     * @return String of eval result
     */ 
    public String evalString(boolean forceToString){
        if(root==null){
          root = parser.parseTop();  
        }
        Object result = this.visitNode(root);
        if(forceToString){
            if(result instanceof Decimal){
                Decimal resultDec = Afe_FunctionDefinition.round((Decimal)result, ec);
                resultDec = Afe_FunctionDefinition.stripTrailingZeros(resultDec);                
                return String.valueOf(resultDec);
            }            
            return String.valueOf(result);
        }else{
            if(result instanceof String){
                return String.valueOf(result);
            }
            throw new Afe_Exception(
                    String.format(MSG_RESULT_WRONG,new String[]{'String'})        
            );           
        }
        
    }
    /**
     * Clear expression 
     */ 
    public void gc(){
        if(root!=null){
          root = null;
        } 
    }  
    
    /**
     * get Variables
     */ 
    public List<String> getVariable(){
        List<String> variables = new List<String>();
        if(root==null){
            root = parser.parseTop(); 
        }
        visitVariableNode(root, variables);
        return variables;
    }
    
    /**
     * visit Variable Node
     */ 
    private void visitVariableNode(Afe_Parser.Node root, List<String> holder){
        if(root instanceof Afe_Parser.VariableNode){
            Afe_Parser.VariableNode varNode = (Afe_Parser.VariableNode) root;
            if(!holder.contains(varNode.name)){
                holder.add(varNode.name);
            }
        }else if(root instanceof Afe_Parser.BinanyNode){
            Afe_Parser.BinanyNode binNode = (Afe_Parser.BinanyNode) root;
            visitVariableNode(binNode.LHS,holder);
            visitVariableNode(binNode.RHS,holder);
        }else if(root instanceof Afe_Parser.IfElseNode){
           Afe_Parser.IfElseNode ifElseNode = (Afe_Parser.IfElseNode) root;
           visitVariableNode(ifElseNode.condition,holder);
           visitVariableNode(ifElseNode.ifTrue,holder);
           visitVariableNode(ifElseNode.ifFalse,holder);
        }else if(root instanceof Afe_Parser.SwitchCaseNode){
            Afe_Parser.SwitchCaseNode caseNode = (Afe_Parser.SwitchCaseNode)root;
            visitVariableNode(caseNode.conditionExpr,holder);
            for(integer i = 0; i < caseNode.varResultExprs.size()-1; i=i+1){
                visitVariableNode(caseNode.varResultExprs.get(i),holder);
            } 
            visitVariableNode(caseNode.defaultExpr,holder);
        }else if(root instanceof Afe_Parser.CallFuncNode){
            Afe_Parser.CallFuncNode callFunc = (Afe_Parser.CallFuncNode)root;
            for(Integer i = 0; i < callFunc.args.size(); i++){
                Afe_Parser.Node expr = callFunc.args.get(i);
                visitVariableNode(expr,holder);
            }            
        }else if(root instanceof Afe_Parser.UnaryNode){
            Afe_Parser.UnaryNode unaryNode = (Afe_Parser.UnaryNode) root;
            visitVariableNode(unaryNode.expr,holder);
        }
    }
    /**
     * Visit tree node method
     * this method can be process recursive itself
     * @return node value
     */ 
    private object visitNode(Afe_Parser.Node root){ 
        if(null == root){
           throw new Afe_Exception(MSG_UNABLE_PARSE_EXPR); 
        }else if(root instanceof Afe_Parser.DoubleNumberNode){
            Afe_Parser.DoubleNumberNode doubleNode = (Afe_Parser.DoubleNumberNode) root;
            if(doubleNode.needRounding)
                return Afe_FunctionDefinition.round(doubleNode.numberValue,ec);
            else 
                return doubleNode.numberValue;
        }else if(root instanceof Afe_Parser.StringNode){
            return ((Afe_Parser.StringNode) root).value;
        }else if(root instanceof Afe_Parser.BoolNode){
            return ((Afe_Parser.BoolNode) root).value;
        }else if(root instanceof Afe_Parser.VariableNode){
            Afe_Parser.VariableNode varNode = (Afe_Parser.VariableNode) root;
            if(!variableParams.containsKey(varNode.name.toLowerCase())){
                throw new Afe_Exception(
                        String.format(MSG_VAR_NOTSET,new String[]{varNode.name})        
                );                
            }
            Object value = variableParams.get(varNode.name.toLowerCase());
            if(value instanceof Decimal){
               return Afe_FunctionDefinition.round((Decimal)value,ec);
            }
            return value;            
        }else if(root instanceof Afe_Parser.BinanyNode){
            Afe_Parser.BinanyNode binNode = (Afe_Parser.BinanyNode) root;
            return binNode.iOp.calculate(
                visitNode(binNode.LHS),
                visitNode(binNode.RHS),
                ec
            );
        }else if(root instanceof Afe_Parser.IfElseNode){
           Afe_Parser.IfElseNode ifElseNode = (Afe_Parser.IfElseNode) root;
           if(ifElseNode.condition instanceof Afe_Parser.IfElseNode){
                throw new Afe_Exception(MSG_IFELSE_NESTIF_CONDITION);
           }
           Object conditionResult = visitNode(ifElseNode.condition);
           if(conditionResult instanceof boolean){
              return Boolean.valueOf(conditionResult)==true ? 
                  this.visitNode(ifElseNode.ifTrue) : 
               		visitNode(ifElseNode.ifFalse);  
           }
           throw new Afe_Exception(
                           String.format(Afe_Evaluator.MSG_IFELSE_WRONG_CONDITION, 
                              new String[]{Afe_FunctionDefinition.getType(conditionResult)})
           );
            
        }else if(root instanceof Afe_Parser.SwitchCaseNode){
            return executeSwitchCase((Afe_Parser.SwitchCaseNode)root);
        }else if(root instanceof Afe_Parser.CallFuncNode){
            return executeCallFunc((Afe_Parser.CallFuncNode)root);
        }else if(root instanceof Afe_Parser.UnaryNode){
            Afe_Parser.UnaryNode unaryNode = (Afe_Parser.UnaryNode) root;
            Object left = visitNode(unaryNode.expr);
            return unaryNode.iop.calculate(left,null,ec);
        }else if(root instanceof Afe_Parser.NullNode){
            return null;
        }       
        throw new Afe_Exception(MSG_UNABLE_PARSE_EXPR);
    } 

    /**
     * Execute call function
     * @return funtion execute result
     */ 
    private Object executeCallFunc(Afe_Parser.CallFuncNode callFunc){
      if(notAllowedFunctions!=null && notAllowedFunctions.contains(callFunc.funcName.toLowerCase())){
          throw new Afe_Exception(
              String.format(MSG_METH_NOT_ALLOWED,new String[]{callFunc.funcName})        
          ); 
      }
      Map<String, Object> args = new Map<String, Object>();
      for(Integer i = 0; i < callFunc.args.size(); i++){
          Afe_Parser.Node expr = callFunc.args.get(i);
          args.put(String.valueOf(i+1),visitNode(expr));
      }
      return callFunc.excuter.execute(args, ec);
    }     
    
    /**
     * Execute switch case condition
     * @return switch condition result 
     */ 
    private Object executeSwitchCase(Afe_Parser.SwitchCaseNode root){
        Object condition = visitNode(root.conditionExpr);
        for(integer i = 0; i < root.varResultExprs.size()-1; i=i+2){
            Object var = visitNode(root.varResultExprs.get(i));
            if(condition == var){
                return visitNode(root.varResultExprs.get(i+1));
            }
        }
        return visitNode(root.defaultExpr);
    }    
    
    /**
     * Decimal math context
     */ 
	public class DecimalContext {
		public Integer precision;
        public Integer divideScale;
		public RoundingMode rd;
		public DecimalContext(Integer precision, RoundingMode rd) {
			this.precision = precision;
			this.rd = rd;
            this.divideScale = -1;
		}
	} 
    
    /**
     * Eval context
     */     
    public class EvalContext{
        public DecimalContext dc;
        public String[] weekends;
        public Date[] holidays;  
		public EvalContext(DecimalContext dc) {
			this.dc = dc;
		}
    }
    
}