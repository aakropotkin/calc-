%{ /* -*- C++ -*- */
/** ========================================================================= *
 *
 *
 *
 * -------------------------------------------------------------------------- */

#include <unistd.h>
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <cstring>
#include <string>
#include "driver.hh"
#include "parser.hh"

/* Work around an incompatibility in flex (at least versions
 * 2.5.31 through 2.5.33): it generates code that does
 * not conform to C89.  See Debian bug 333231
 * <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=333231>. */
#undef yywrap
#define yywrap() 1

/* Pacify warnings in yy_init_buffer (observed with Flex 2.6.4)
 * and GCC 7.3.0. */
#if ( defined __GNUC__ ) && ( 7 <= __GNUC__ )
#pragma GCC diagnostic ignored "-Wnull-dereference"
#endif  /* ( defined __GNUC__ ) && ( 7 <= __GNUC__ ) */

%}

%option noyywrap nounput noinput batch debug


id    [a-zA-Z][a-zA-Z_0-9]*
int   [0-9]+
blank [ \t\r]

%{
/* Code run each time a pattern is matched. */
#define YY_USER_ACTION  loc.columns( yyleng );
%}

%%

%{
/* A handy shortcut to the location held by the driver. */
yy::location & loc = drv.location;
/* Code run each time yylex is called. */
loc.step();
%}

{blank}+   { loc.step(); }
\n+        { loc.lines( yyleng ); loc.step(); }

"-"        { return yy::parser::make_MINUS( loc ); }
"+"        { return yy::parser::make_PLUS( loc ); }
"*"        { return yy::parser::make_STAR( loc ); }
"/"        { return yy::parser::make_SLASH( loc ); }
"( "       { return yy::parser::make_LPAREN(loc ); }
" )"       { return yy::parser::make_RPAREN( loc ); }
":="       { return yy::parser::make_ASSIGN( loc ); }

{int} {
  errno = 0;
  long n = strtol( yytext, NULL, 10 );
  if ( ! ( ( INT_MIN <= n ) && ( n <= INT_MAX ) && ( errno != ERANGE ) ) )
    {
      throw yy::parser::syntax_error(
        loc
      , "integer is out of range: " + std::string( yytext )
      );
    }
  return yy::parser::make_NUMBER( static_cast<int>( n ), loc );
}

{id}       { return yy::parser::make_IDENTIFIER( yytext, loc ); }
.          {
             throw yy::parser::syntax_error(
                     loc
                   , "invalid character: " + std::string( yytext )
                   );
           }
<<EOF>>    { return yy::parser::make_YYEOF( loc ); }

%%

/* -------------------------------------------------------------------------- */

  void
driver::scan_begin()
{
  yy_flex_debug = trace_scanning;

  if ( this->file.empty() || ( this->file == "-" ) )
    {
      yyin = stdin;
    }
  else if ( ! ( ( yyin = fopen( this->file.c_str(), "r" ) ) ) )
    {
      std::cerr << "cannot open " << this->file << ": " << strerror( errno )
                << std::endl;
      exit( EXIT_FAILURE );
    }
}


/* -------------------------------------------------------------------------- */

void driver::scan_end() { fclose( yyin ); }


/* -------------------------------------------------------------------------- *
 *
 *
 *
 * ========================================================================== */
