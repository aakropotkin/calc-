/** ========================================================================= *
 *
 *
 *
 * -------------------------------------------------------------------------- */

#pragma once

#include <string>
#include <map>
#include "parser.hh"


/* -------------------------------------------------------------------------- */

/** @brief Conducting the whole scanning and parsing of Calc++. */
class driver
{

  public:

    std::map<std::string, int> variables;

    int result;

    /* The name of the file being parsed. */
    std::string file;

    /* Whether to generate parser debug traces. */
    bool trace_parsing;

    /* Whether to generate scanner debug traces. */
    bool trace_scanning;

    /* The token's location used by the scanner. */
    yy::location location;


/* -------------------------------------------------------------------------- */

    driver();

    /* Run the parser on @a file.  Return 0 on success. */
    int parse( const std::string & file );

    /* Handling the scanner. */
    void scan_begin();
    void scan_end();

};  /* End class `driver' */


/* -------------------------------------------------------------------------- */

/* Tell Flex the lexer's prototype... */
#define YY_DECL  yy::parser::symbol_type yylex( driver & drv )

/* ... and declare it for the parser's sake. */
YY_DECL;


/* -------------------------------------------------------------------------- *
 *
 *
 *
 * ========================================================================== */
