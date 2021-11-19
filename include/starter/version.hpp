#ifndef STARTER_VERSION_HPP
#define STARTER_VERSION_HPP

/**
 * @file version.hpp
 * @author Matt Williams (matt@dmgblockchain.com)
 * @brief Adds version support for project, used by Cmake
 * @date 2021-11-19
 */

#define STARTER_VER_MAJOR 0
#define STARTER_VER_MINOR 1
#define STARTER_VER_PATCH 0

#define STARTER_VERSION \
  (STARTER_VER_MAJOR * 1000 + STARTER_VER_MINOR * 100 + STARTER_VER_PATCH)


#endif // STARTER_VERSION_HPP
