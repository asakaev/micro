
/*                     __                                               *\
**     ________ ___   / /  ___     Scala API                            **
**    / __/ __// _ | / /  / _ |    (c) 2002-2007, LAMP/EPFL             **
**  __\ \/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **
** /____/\___/_/ |_/____/_/ | |                                         **
**                          |/                                          **
\*                                                                      */

// $Id$

// generated by genprod on Thu Apr 19 18:52:00 CEST 2007

package scala


/** <p>
 *    Function with 4 parameters.
 *  </p>
 *
 */
trait Function4[-T1, -T2, -T3, -T4, +R] extends AnyRef {
  def apply(v1:T1, v2:T2, v3:T3, v4:T4): R
  override def toString() = "<function>"

}
