public class Afe_Lexer {
    //input expression
    private String fomulaInput;
    
    //current token
    public Afe_Token currentToken{get; set;}
    
    //previous token
    public Afe_Token previousToken{get; set;}
    
    //last char, default is white space
    private String lastChar = ' ';
    
    // last char position;
    public integer lexerPosition = 0;
 
    //Parser instance
    private Afe_Parser parser;
    
    /**
     * Lexer constructor
     */ 
    public Afe_Lexer(String fomulaInput, Afe_Parser parser){
        this.fomulaInput = fomulaInput;
        this.parser = parser;
    }

    /**
     * get processing char of expression
     * @return char
     */ 
    private String getChar(){
        if(lexerPosition<fomulaInput.length()){
          return String.fromCharArray( 
                new List<integer> {fomulaInput.charAt(lexerPosition++)});
        }else return null;     
    }   

    /**
     * View next char of processing char
     * @return char
     */     
    private String viewNextChar(){
        return String.fromCharArray( 
                new List<integer> { 
                    lexerPosition<fomulaInput.length() ? fomulaInput.charAt(lexerPosition) : 10 
                        });
    } 
    
    /**
     * Check if end of expression
     * @return Boolean true if end of expression, otherwise false
     */ 
    public boolean isEof(){
        return lastChar==null;
    }
    
    /**
     * Get next token of expression string
     * Current token will be assigned to previous token
     * @return void
     */ 
    public void getToken(){
        if(currentToken!=null){
          previousToken = currentToken.clone();  
        }
        this.next();
    }
    
    /**
     * Get next token of expression string
     * @return void next token will be assigned to currentToken variable
     */ 
    private void next(){
        //remove all white space
        while(!isEof() && lastChar.isWhitespace()){
            lastChar = getChar();
        } 
		if(isEof()){
            currentToken = new Afe_Token(Afe_Token.TokenType.TOKEN_EOF);
            return;
        }         
        //identifier
		if(lastChar.isAlpha() || lastChar.equals('_')){
            String identifierTemp = lastChar;
            lastChar = getChar();
            while(!isEof() && (lastChar.isAlphanumeric() || lastChar.equals('_'))){
                identifierTemp += lastChar;
                lastChar = getChar();
            }    
            /*if(this.parser.getOperators().containsKey(identifierTemp)){
                currentToken = new Afe_Token(
                    Afe_Token.TokenType.TOKEN_OP,identifierTemp
                );
                return;                
            }*/
            if(identifierTemp.toUpperCase().equals('IF') && !isEof() && lastChar.equals('(')){
                currentToken = new Afe_Token(
                    Afe_Token.TokenType.TOKEN_IF,identifierTemp
                );
                return;                
            }else if(identifierTemp.toUpperCase().equals('CASE') && !isEof() &&  lastChar.equals('(')){
                currentToken = new Afe_Token(
                    Afe_Token.TokenType.TOKEN_CASE,identifierTemp
                );
                return;                
            }else if(identifierTemp.toUpperCase().equals('SWITCH') && !isEof() &&  lastChar.equals('(')){
                currentToken = new Afe_Token(
                    Afe_Token.TokenType.TOKEN_CASE,identifierTemp
                );
                return;                
            }             
            Afe_Token identifierTok = new Afe_Token(
                Afe_Token.TokenType.TOKEN_IDENTIFIER,identifierTemp
            );
            currentToken = identifierTok;
            return;
        }  
        //number 
        else if(lastChar.isNumeric() || (lastChar.equals('.') && viewNextChar().isNumeric())){
            String numberTemp = lastChar;
            lastChar = getChar();
            while(!isEof() && 
                  (
                      lastChar.isNumeric() || 
                      lastChar.equals('.') ||
                      (
                          lastChar.toLowerCase().equals('e') &&
                          !numberTemp.contains('e') &&
                          (viewNextChar().equals('+')||viewNextChar().equals('-'))
                      )
                      ||
                      (
						lastChar.equals('-') && numberTemp.length() > 0 &&
                        numberTemp.right(1).toLowerCase().equals('e') &&
                        viewNextChar().isNumeric()
                      )
                      ||
                      (
						lastChar.equals('+') && numberTemp.length() > 0 &&
                        numberTemp.right(1).toLowerCase().equals('e') &&
                        viewNextChar().isNumeric()  
                      )        
                  )
                 ){
                numberTemp += lastChar;
                lastChar = getChar();
            }  
            currentToken = new Afe_Token(
                Afe_Token.TokenType.TOKEN_NUMBER_DECIMAL,
                Decimal.valueOf(numberTemp)
            );  
            return;
        }else if(lastChar.equals('"')){
            String strTemp = '';
            lastChar = getChar();
            while(!isEof()){
                if(lastChar.equals('"')){
					String nextChar = viewNextChar();
                    if(nextChar.equals('"')){
                       lastChar = getChar();
                       strTemp += lastChar;
                       lastChar = getChar();
                    }else break;
                }else{
                    strTemp += lastChar;
                    lastChar = getChar();                    
                }
            }
            if(!isEof() && lastChar.equals('"')){
                Afe_Token strTok = new Afe_Token(
                    Afe_Token.TokenType.TOKEN_STRING,
                    strTemp
                );
                currentToken = strTok;  
                lastChar = getChar();               
                return;
            }
            throw new Afe_Exception('" is expected!'); 
        }else if(lastChar.equals('(')){
            currentToken = new Afe_Token(Afe_Token.TokenType.TOKEN_PAREN_OPEN);  
            lastChar = getChar();
            return;
        }else if(lastChar.equals(')')){
            currentToken = new Afe_Token(Afe_Token.TokenType.TOKEN_PAREN_CLOSE); 
            lastChar = getChar();
            return;
        }else if(lastChar.equals(',')){
            currentToken = new Afe_Token(Afe_Token.TokenType.TOKEN_COMMA); 
            lastChar = getChar();
            return;
        }else{
            String strTemp = '';
            String matchedOp = '';
            integer lastMatchedPos = -1;
            
            String matchedUop = '';
            integer lastMatchedUopPos = -1;            
            while(
                  !isEof() &&
                  !lastChar.isAlpha() && 
                  !lastChar.isNumeric() && 	
                  !lastChar.isWhitespace() &&
                  !lastChar.equals('(') &&
                  !lastChar.equals(')') &&
                  !lastChar.equals(',') &&
				  !lastChar.equals('"')
                 ){
                    strTemp += lastChar;
                    if(this.parser.getOperators().containsKey(strTemp)){
              			matchedOp = strTemp;
                        lastMatchedPos = this.lexerPosition;
                    } 
                    if(this.parser.getUnaryOperators().containsKey(strTemp)){
              			matchedUop = strTemp;
                        lastMatchedUopPos = this.lexerPosition;
                    }                       
                   lastChar = getChar();  
            	}
                if(previousToken==null || 
                   previousToken.tokenType==Afe_Token.TokenType.TOKEN_OP ||
                   previousToken.tokenType==Afe_Token.TokenType.TOKEN_UOP ||
                   previousToken.tokenType==Afe_Token.TokenType.TOKEN_PAREN_OPEN ||
                   previousToken.tokenType==Afe_Token.TokenType.TOKEN_COMMA 
                  ){
                        if(lastMatchedUopPos != -1){
                            currentToken = new Afe_Token(
                                Afe_Token.TokenType.TOKEN_UOP,matchedUop
                            ); 
                            this.lexerPosition = lastMatchedUopPos;
                            lastChar = getChar();  
                            return;
                        }                    
                  }else{
                        if(lastMatchedPos != -1){
                            currentToken = new Afe_Token(
                                Afe_Token.TokenType.TOKEN_OP,matchedOp
                            ); 
                            this.lexerPosition = lastMatchedPos;
                            lastChar = getChar();  
                            return;
                        }                      
                  }
        		throw new Afe_Exception(
								String.format(Afe_Evaluator.MSG_UNEXPECT_TOKEN_AT_POS, 
                              	new String[]{strTemp, String.valueOf(this.lexerPosition)}));     
        }   
    }  
}