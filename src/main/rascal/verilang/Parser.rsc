module verilang::Parser

import ParseTree;
import verilang::Syntax;

// Parsea un programa VeriLang desde un string
public Tree parseProgram(str src) 
    = parse(#Program, src);