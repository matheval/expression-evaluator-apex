global class Afe_Token implements Comparable{
    public enum TokenType {
        TOKEN_ASCII,
        TOKEN_NUMBER_DECIMAL,
        TOKEN_BOOL,
        TOKEN_STRING,
        TOKEN_IDENTIFIER,
        TOKEN_PAREN_OPEN,
        TOKEN_PAREN_CLOSE, 
        TOKEN_COMMA,
        TOKEN_OP,
        TOKEN_UOP,
        TOKEN_IF,
        TOKEN_CASE,
        TOKEN_EOF
	}    
    public TokenType tokenType{get; set;}
    public String identifierValue{get; set;}
    public Decimal doubleValue{get; set;}
    public Integer intNumberValue{get; set;}
    public Boolean boolValue{get; set;}
    public Afe_Token(){
    }    
    public Afe_Token(TokenType tokType){
       this.tokenType = tokType;
    }
    public Afe_Token(TokenType tokType, String identifier){
       this.tokenType = tokType;
       this.identifierValue = identifier;
    }
    public Afe_Token(TokenType tokType, Decimal doubleValue){
       this.tokenType = tokType;
       this.doubleValue = doubleValue;
    }
    public Afe_Token(TokenType tokType, Integer numVal){
       this.tokenType = tokType;
       this.intNumberValue = numVal;
    }      
     public Afe_Token(TokenType tokType, Boolean boolVal){
       this.tokenType = tokType;
       this.boolValue = boolVal;
    }  
    global Integer compareTo(Object compareTo) {
        Afe_Token compareToEmp = (Afe_Token)compareTo;
        if (this.tokenType == Afe_Token.TokenType.TOKEN_EOF
            && compareToEmp.tokenType == Afe_Token.TokenType.TOKEN_EOF) return 0;
        
        if (this.tokenType == Afe_Token.TokenType.TOKEN_PAREN_OPEN
            && compareToEmp.tokenType == Afe_Token.TokenType.TOKEN_PAREN_OPEN) return 0;
        
        if (this.tokenType == Afe_Token.TokenType.TOKEN_PAREN_CLOSE
            && compareToEmp.tokenType == Afe_Token.TokenType.TOKEN_PAREN_CLOSE) return 0;
        
        if (this.tokenType == Afe_Token.TokenType.TOKEN_COMMA
            && compareToEmp.tokenType == Afe_Token.TokenType.TOKEN_COMMA) return 0;
        
        if (this.tokenType == Afe_Token.TokenType.TOKEN_IDENTIFIER
            && compareToEmp.tokenType == Afe_Token.TokenType.TOKEN_IDENTIFIER){
                return this.identifierValue.compareTo(compareToEmp.identifierValue);
            }      
        if (this.tokenType == Afe_Token.TokenType.TOKEN_ASCII
            && compareToEmp.tokenType == Afe_Token.TokenType.TOKEN_ASCII){
                return this.identifierValue.compareTo(compareToEmp.identifierValue);
            }    
        return -1;        
    }
    public override String toString()
    {
        if (this.tokenType == Afe_Token.TokenType.TOKEN_EOF){
            return 'EOF';
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_IDENTIFIER
                 || this.tokenType == Afe_Token.TokenType.TOKEN_ASCII){
            return identifierValue;
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_NUMBER_DECIMAL){
            return String.valueOf(doubleValue);
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_BOOL){
            return String.valueOf(boolValue);
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_PAREN_OPEN){
            return '(';
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_PAREN_CLOSE){
            return ')';
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_COMMA){
            return ',';
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_OP){
            return identifierValue;
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_UOP){
            return identifierValue;
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_IF){
            return 'IF condition';
        }else if (this.tokenType == Afe_Token.TokenType.TOKEN_CASE){
            return 'swtich case condition';
        }
        return '';
    }
    
}