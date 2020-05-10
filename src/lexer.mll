{
open Lexing
open Parser

exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }


}

let int = '-'? ['0'-'9'] ['0'-'9']*
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token =
    parse
    | white                     { token lexbuf; }
    | newline                   { next_line lexbuf; token lexbuf }
    | '+'                       { PLUS }
    | '-'                       { MINUS }
    | '*'                       { MULTIPLY }
    | '/'                       { DIVIDE }
    | '%'                       { MODULUS }
    | '<'                       { LT }
    | '>'                       { GT }
    | '!'                       { NOT }
    | "int"                     { INT }
    | "bool"                    { BOOL }
    | "<="                      { LTE }
    | ">="                      { GTE }
    | "=="                      { EQUAL_TO }
    | "="                       { EQUAL }
    | "!="                      { NEQ }
    | "&&"                      { AND }
    | "||"                      { OR }
    | "//"                      { comment lexbuf; }
    | "if"                      { IF }
    | "else"                    { ELSE }
    | "discrete"                { DISCRETE }
    | "then"                    { THEN }
    | "true"                    { TRUE }
    | "false"                   { FALSE }
    | "let"                     { LET }
    | "fst"                     { FST }
    | "snd"                     { SND }
    | "in"                      { IN }
    | "iterate"                 { ITERATE }
    | "observe"                 { OBSERVE }
    | "flip"                    { FLIP }
    | "fun"                     { FUN }
    | '('                       { LPAREN }
    | ')'                       { RPAREN }
    | '{'                       { LBRACE }
    | '}'                       { RBRACE }
    | ';'                       { SEMICOLON }
    | ':'                       { COLON }
    | ','                       { COMMA }
    | int as i                  { INT_LIT(int_of_string i); }
    | float as num              { FLOAT_LIT(float_of_string num); }
    | id as ident               { ID(ident); }
    | eof                       { EOF }
and comment =
    parse
    | '\n'                      { token lexbuf }
    | _                         { comment lexbuf }
