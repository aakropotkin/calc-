/** ========================================================================= *
 *
 *
 *
 * -------------------------------------------------------------------------- */

#include <string>
#include <iostream>
#include "driver.hh"


/* -------------------------------------------------------------------------- */

  int
main( int argc, char * argv[] )
{
  int    res = EXIT_SUCCESS;
  driver drv;

  for ( int i = 1; i < argc; ++i )
    {
      if ( argv[i] == std::string_view( "-p" ) )
        {
          drv.trace_parsing = true;
        }
      else if ( argv[i] == std::string_view( "-s" ) )
        {
          drv.trace_scanning = true;
        }
      else if ( ! drv.parse( argv[i] ) )
        {
          std::cout << drv.result << '\n';
        }
      else
        {
          res = EXIT_FAILURE;
        }
    }

  return res;
}


/* -------------------------------------------------------------------------- *
 *
 *
 *
 * ========================================================================== */
