/*                     __                                               *\
**     ________ ___   / /  ___     Scala API                            **
**    / __/ __// _ | / /  / _ |    (c) 2005-2007, LAMP/EPFL             **
**  __\ \/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **
** /____/\___/_/ |_/____/_/ | |                                         **
**                          |/                                          **
\*                                                                      */

// $Id$

package scala

/** This object contains utility methods to build responders.
 *
 *  @author Martin Odersky
 *  @author Burak Emir
 *  @version 1.0
 *
 *  @see class Responder
 */
object Responder {

  /** Creates a responder that answer continuations with the constant
   *  <code>a</code>.
   *
   *  @param x ...
   *  @return ...
   */
  def constant[A](x: A) = new Responder[A] {
    def respond(k: A => Unit) = k(x)
  }

  /** Executes <code>x</code> and returns <code>true</code>, useful
   *  as syntactic convenience in for comprehensions.
   *
   *  @param x ...
   *  @return ...
   */
  def exec[A](x: => Unit): Boolean = { x; true }

  /** runs a responder, returning an optional result
  */
  def run[A](r: Responder[A]): Option[A] = {
    var result: Option[A] = None
    r.foreach(x => result = Some(x))
    result
  }

  def loop[A](r: Responder[Unit]): Responder[Nothing] =
    for (_ <- r; val y <- loop(r)) yield y

  def loopWhile[A](cond: => Boolean)(r: Responder[Unit]): Responder[Unit] =
    if (cond) for (_ <- r; val y <- loopWhile(cond)(r)) yield y
    else constant(())

}

/** Instances of responder are the building blocks of small programs
 *  written in continuation passing style. By using responder classes
 *  in for comprehensions, one can embed domain-specific languages in
 *  Scala while giving the impression that programs in these DSLs are
 *  written in direct style.
 *
 *  @author Martin Odersky
 *  @author Burak Emir
 *  @version 1.0
 */
abstract class Responder[+A] {

  def respond(k: A => Unit): Unit

  def foreach(k: A => Unit) { respond(k) }

  def map[B](f: A => B) = new Responder[B] {
    def respond(k: B => Unit) {
      Responder.this.respond(x => k(f(x)))
    }
  }

  def flatMap[B](f: A => Responder[B]) = new Responder[B] {
    def respond(k: B => Unit) {
      Responder.this.respond(x => f(x).respond(k))
    }
  }

  def filter(p: A => Boolean) = new Responder[A] {
    def respond(k: A => Unit) {
      Responder.this.respond(x => if (p(x)) k(x) else ())
    }
  }
}

