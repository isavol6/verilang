module verilang::Syntax

// ============================================================
// Layout
// ============================================================
// Solo espacios en blanco.
layout WS = [\ \t\n\r\f]* ;

// ============================================================
// Keywords
// ============================================================
// Palabras reservadas de VeriLang.
keyword Keyword
    = "defmodule"
    | "using"
    | "defspace"
    | "defoperator"
    | "defvar"
    | "defrule"
    | "defexpression"
    | "end"
    | "forall"
    | "exists"
    | "in"
    | "and"
    | "or"
    | "neg"
    ;

// ============================================================
// Lexical rules
// ============================================================
// name ::= letter { letter | digit | "-" }
// letter ::= "a" | ... | "z"
// digit ::= "0" | ... | "9"
//
lexical Name = [a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-] \ Keywords;

// ============================================================
// Start symbol
// ============================================================
// program ::= module
start syntax Program
    = program: Module module
    ;

// ============================================================
// Module creation
// ============================================================
// module ::= "defmodule" name { import } { definition } "end"
syntax Module
    = module: "defmodule" Name name Import* imports Definition* definitions "end"
    ;

// import ::= "using" name
syntax Import
    = using: "using" Name name
    ;

syntax Definition
    = spaceDef: Space space
    | opDef: OpDeclarator op
    | variableDef: VarDeclarator var
    | ruleDef: Rule rule
    | expressionDef: ExDeclaration expr
    ;

// ============================================================
// Space creation
// ============================================================
// space ::= "defspace" name [ "<" name ] "end"
syntax Space
    = space: "defspace" Name name SubSpaceOpt subSpace "end"
    ;

syntax SubSpaceOpt
    = noSubSpace:
    | subSpace: "<" Name parent
    ;
// ============================================================
// Operator definitions
// ============================================================
// opdeclarator ::= "defoperator" operator ":" domain { "->" domain } [ attributes ] "end"

syntax OpDeclarator
    = opNoAttr: "defoperator" Operator op ":" Domain firstDomain ArrowDomain* otherDomains "end"
    | opWithAttr: "defoperator" Operator op ":" Domain firstDomain ArrowDomain* otherDomains Attributes attrs "end"
    ;

syntax ArrowDomain
    = arrowDomain: "->" Domain domain
    ;

// opapplication ::= name { expression }
syntax OpApplication
    = opapplication: Name name Expression* args
    ;
// ============================================================
// Variable definitions
// ============================================================
// vardeclarator ::= "defvar" variable { "," variable } "end"
syntax VarDeclarator
    = vardeclarator: "defvar" Variable ("," Variable)* "end"
    ;

// variable ::= name ":" domain
syntax Variable
    = variable: Name name ":" Domain domain
    ;

// ============================================================
// Rules
// ============================================================
// rule ::= "defrule" "(" opapplication ")" "->" "(" opapplication ")" "end"
syntax Rule
    = rule: "defrule" "(" OpApplication lhs ")" "->" "(" OpApplication rhs ")" "end"
    ;

// ============================================================
// Expressions
// ============================================================
// exdeclaration ::= "defexpression" "(" expression ")" "end"
syntax ExDeclaration
    = exdeclaration: "defexpression" "(" Expression expr ")" "end"
    ;

// expression ::= quantifiedex
//              | logicalex
//              | opapplication
//              | name
//              | "(" expression ")"
//
syntax Expression
    = quantifiedExp: QuantifiedEx q
    | logicalExp: LogicalEx l
    | applicationExp: OpApplication app
    | nameExp: Name name
    | groupedExp: "(" Expression expr ")"
    ;

// quantifiedex ::= ("forall" | "exists") name "in" name "." expression
syntax QuantifiedEx
    = forallExp: "forall" Name var "in" Name domain "." Expression body
    | existsExp: "exists" Name var "in" Name domain "." Expression body
    ;

// logicalex ::= expression ("and" | "or" | "≡") expression
//             | "neg" expression
//
syntax LogicalEx
    = negExp:   "neg" Expression expr
    > andExp:   Expression lhs "and" Expression rhs
    > orExp:    Expression lhs "or"  Expression rhs
    > equivExp: Expression lhs "≡"   Expression rhs
    ;
// ============================================================
// Attributes
// ============================================================
// attributes ::= "[" attribute { attribute } "]"

syntax Attributes
    = attributes: "[" Attribute+ attrs "]"
    ;

// attribute ::= name | name ":" ( name | operator )

syntax Attribute
    = simpleAttr: Name name
    | mappedAttrName: Name key ":" Name value
    | mappedAttrOp: Name key ":" SymbolicOperator op
    ;

// ============================================================
// Domain
// ============================================================
// domain ::= name
syntax Domain
    = domain: Name name
    ;

// ============================================================
// Operators
// ============================================================
// operator ::= name | "<" | ">" | "<=" | ">=" | "<>" | "=" |
//              "->" | "=>" | "≡" | "+" | "-" | "*" | "/" | "%" | "**"
//

syntax Operator
    = namedOperator: Name name
    | symbolicOperator: SymbolicOperator op
    ;

syntax SymbolicOperator
    = le: "<="
    | ge: ">="
    | ne: "<>"
    | arrow: "->"
    | bigArrow: "=>"
    | pow: "**"
    | gt: ">"
    | eq: "="
    | equiv: "≡"
    | plus: "+"
    | minus: "-"
    | times: "*"
    | div: "/"
    | mod: "%"
    | lt: "<"
    ;

