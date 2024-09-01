package scala.runtime

abstract class BoxedArray {
  def apply(index: Int): Any
  def update(index: Int, elem: Any): Unit
  def length: Int
}
