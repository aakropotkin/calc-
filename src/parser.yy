/* -*- C++ -*- */
/** ========================================================================= *
 *
 *
 *
 * -------------------------------------------------------------------------- */

%skeleton "lalr1.cc"
%require  "3.8.1"
%header

%define api.token.raw
%define api.token.constructor
%define api.value.type        variant
%define parse.assert


/* -------------------------------------------------------------------------- */

/* This block is shared by the parser and lexer */
%code {

#include <string>

class driver;

}  /* End `%code' */


/* -------------------------------------------------------------------------- */

%locations

%define parse.trace
%define parse.error detailed
%define parse.lac   full


/* -------------------------------------------------------------------------- */

%code {

#include "driver.hh"

}  /* End */


/* -------------------------------------------------------------------------- */

%define api.token.prefix {TOK_}

%token
  ASSIGN  ":="
  MINUS   "-"
  PLUS    "+"
  STAR    "*"
  SLASH   "/"
  LPAREN  "("
  RPAREN  ")"
;


/* -------------------------------------------------------------------------- */

%token <std::string>  IDENTIFIER "identifier";
%token <int>          NUMBER     "number";
%nterm <int>          exp;


/* -------------------------------------------------------------------------- */

%printer { yyo << $$; }  <*>;


/* -------------------------------------------------------------------------- */

%%
%start unit;
unit: assignments exp  { drv.result = $2; };

assignments:
  %empty                 {}
| assignments assignment {}
;

assignment:
  "identifier" ":=" exp { drv.variables[$1] = $3; }
;

%left "+" "-";
%left "*" "/";
exp:
  "number"
| "identifier"  { $$ = drv.variables[$1]; }
| exp "+" exp   { $$ = $1 + $3; }
| exp "-" exp   { $$ = $1 - $3; }
| exp "*" exp   { $$ = $1 * $3; }
| exp "/" exp   { $$ = $1 / $3; }
| "(" exp ")"   { $$ = $2; }
;
%%


/* -------------------------------------------------------------------------- */

  void
yy::parse::error( const location_type & loc, const std::string & msg )
{
  std::cerr << loc << ": " << msg << std::endl;
}


/* -------------------------------------------------------------------------- *
 *
 *
 *
 * ========================================================================== */
