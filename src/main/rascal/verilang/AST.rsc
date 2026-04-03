module verilang::AST

// ============================================================
// Abstract Syntax Tree for VeriLang
// ============================================================

// Program ::= module
data Program
    = program(Module module)
    ;

// module ::= "defmodule" name { import } { definition } "end"
data Module
    = module(str name, list[Import] imports, list[Definition] definitions)
    ;

// import ::= "using" name
data Import
    = using(str name)
    ;

// definition ::= space | opdeclarator | vardeclarator | rule | exdeclaration
data Definition
    = spaceDef(Space space)
    | operatorDef(OpDeclaration opDecl)
    | variableDef(VarDeclarator varDecl)
    | ruleDef(Rule rule)
    | expressionDef(ExDeclaration exprDecl)
    ;

// space ::= "defspace" name [ "<" name ] "end"
data Space
    = space(str name, MaybeName parent)
    ;

// opdeclarator ::= "defoperator" operator ":" domain { "->" domain } [ attributes ] "end"
data OpDeclaration
    = opDeclaration(Operator op, Domain firstDomain, list[Domain] otherDomains, MaybeAttributes attrs)
    ;

// opapplication ::= name { expression }
data OpApplication
    = opApplication(str name, list[Expression] args)
    ;

// vardeclarator ::= "defvar" variable { "," variable } "end"
data VarDeclarator
    = varDeclarator(list[Variable] variables)
    ;

// variable ::= name ":" domain
data Variable
    = variable(str name, Domain domain)
    ;

// rule ::= "defrule" "(" opapplication ")" "->" "(" opapplication ")" "end"
data Rule
    = rule(OpApplication lhs, OpApplication rhs)
    ;

// exdeclaration ::= "defexpression" "(" expression ")" "end"
data ExDeclaration
    = exDeclaration(Expression expr)
    ;

// expression ::= quantifiedex | logicalex | opapplication | name | "(" expression ")"
data Expression
    = quantifiedExp(QuantifiedEx q)
    | logicalExp(LogicalEx l)
    | applicationExp(OpApplication app)
    | nameExp(str name)
    | groupedExp(Expression expr)
    ;

// quantifiedex ::= ( "forall" | "exists" ) name "in" name "." expression
data QuantifiedEx
    = forallExp(str var, str domainName, Expression body)
    | existsExp(str var, str domainName, Expression body)
    ;

// logicalex ::= expression ( "and" | "or" | "≡" ) expression | "neg" expression
data LogicalEx
    = andExp(Expression lhs, Expression rhs)
    | orExp(Expression lhs, Expression rhs)
    | equivExp(Expression lhs, Expression rhs)
    | negExp(Expression expr)
    ;

// attributes ::= "[" attribute { attribute } "]"
data Attributes
    = attributes(list[Attribute] attrs)
    ;

// attribute ::= name | name ":" ( name | operator )
data Attribute
    = simpleAttr(str name)
    | mappedNameAttr(str key, str value)
    | mappedOperatorAttr(str key, Operator op)
    ;

// domain ::= name
data Domain
    = domain(str name)
    ;

// operator ::= name | "<" | ">" | "<=" | ">=" | "<>" | "=" | "->" | "=>" | "≡" | "+" | "-" | "*" | "/" | "%" | "**"
data Operator
    = namedOperator(str name)
    | lt()
    | gt()
    | le()
    | ge()
    | ne()
    | eq()
    | arrow()
    | bigArrow()
    | equiv()
    | plus()
    | minus()
    | times()
    | div()
    | mod()
    | pow()
    ;

// ============================================================
// Optional helpers
// ============================================================

data MaybeName
    = noName()
    | someName(str name)
    ;

data MaybeAttributes
    = noAttributes()
    | someAttributes(Attributes attrs)
    ;
