#include "catch.hpp"
#include <starter/addition.hpp>

SCENARIO("Showcase how to test application specific code", "[test_addition]") {
  int32_t expected = 4;
  REQUIRE(starter::add(2, 2) == expected);
}
