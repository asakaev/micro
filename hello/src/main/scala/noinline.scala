/*                     __                                               *\
**     ________ ___   / /  ___     Scala API                            **
**    / __/ __// _ | / /  / _ |    (c) 2002-2007, LAMP/EPFL             **
**  __\ \/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **
** /____/\___/_/ |_/____/_/ | |                                         **
**                          |/                                          **
\*                                                                      */

// $Id$


package scala

/**
 * An annotation on methods that forbids the compiler to inline the
 * method, no matter how safe the inlining appears to be.
 *
 * @author Lex Spoon
 * @version 1.0, 2007-5-21
 */
class noinline extends StaticAnnotation
