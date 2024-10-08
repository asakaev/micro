/*                     __                                               *\
**     ________ ___   / /  ___     Scala API                            **
**    / __/ __// _ | / /  / _ |    (c) 2003-2007, LAMP/EPFL             **
**  __\ \/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **
** /____/\___/_/ |_/____/_/ | |                                         **
**                          |/                                          **
\*                                                                      */

// $Id$


package scala.collection.mutable

import Predef._

/** This class is used internally to implement data structures that
 *  are based on resizable arrays.
 *  //todo enrich with more efficient operations
 *
 *  @author  Matthias Zenger, Burak Emir
 *  @version 1.0, 03/05/2004
 */
trait ResizableArray[A] extends RandomAccessSeq[A] {

  protected val initialSize: Int = 16
  protected var array: Array[A] = new Array[A](initialSize)
  private var size1: Int = 0
  protected def size0: Int = size1
  protected def size0_=(sz: Int) { size1 = sz }

  //##########################################################################
  // implement/override methods of Seq[A]

  /** Returns the length of this resizable array.
   */
  def length: Int = size0

  def apply(i: Int) = array(i)

  /** remove elements of this array at indices after <code>sz</code>
   */
  def reduceToSize(sz: Int) {
    if (sz > size0) throw new IllegalArgumentException
    size0 = sz
  }

  /** Fills the given array <code>xs</code> with the elements of
   *  this sequence starting at position <code>start</code>.
   *
   *  @param  xs the array to fill.
   *  @param  start starting index.
   */
  override def copyToArray[B >: A](xs: Array[B], start: Int) {
    Array.copy(array, 0, xs, start, size0)
  }

  /** Copy all elements to a buffer
   *  @param   The buffer to which elements are copied
   */
  override def copyToBuffer[B >: A](dest: Buffer[B]) {
//    dest.++=(array.asInstanceOf[Array[B]], 0, size0)
    throw new Throwable("NotImplemented")
  }

  /** Returns a new iterator over all elements of this resizable array.
   */
  override def elements: Iterator[A] = new Iterator[A] {
    var i = 0
    def hasNext: Boolean = i < size0
    def next(): A = { i = i + 1; array(i - 1) }
  }

  //##########################################################################

  /** ensure that the internal array has at n cells */
  protected def ensureSize(n: Int) {
    if (n > array.length) {
      var newsize = array.length * 2
      while (n > newsize)
        newsize = newsize * 2
      val newar: Array[A] = new Array(newsize)
      Array.copy(array, 0, newar, 0, size0)
      array = newar
    }
  }

  /** Swap two elements of this array.
   */
  protected def swap(a: Int, b: Int) {
    val h = array(a)
    array(a) = array(b)
    array(b) = h
  }

  /** Move parts of the array.
   */
  protected def copy(m: Int, n: Int, len: Int) {
    Array.copy(array, m, array, n, len)
  }
}
