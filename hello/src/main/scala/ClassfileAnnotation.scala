/*                     __                                               *\
**     ________ ___   / /  ___     Scala API                            **
**    / __/ __// _ | / /  / _ |    (c) 2006-2007, LAMP/EPFL             **
**  __\ \/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **
** /____/\___/_/ |_/____/_/ | |                                         **
**                          |/                                          **
\*                                                                      */

// $Id$


package scala

/** <p>
 *    A base class for classfile annotations. These are stored as
 *    <a href="http://java.sun.com/j2se/1.5.0/docs/guide/language/annotations.html"
 *    target="_top">Java annotations</a> in classfiles.
 *  </p>
 *
 *  @author  Martin Odersky
 *  @version 1.1, 2/02/2007
 */
trait ClassfileAnnotation extends Annotation
