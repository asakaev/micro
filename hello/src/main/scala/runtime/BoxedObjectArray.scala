package scala.runtime

final class BoxedObjectArray(val value: Array[AnyRef]) extends BoxedArray {
  override def apply(index: int): Any = throw new Throwable("NotImplemented")
  override def update(index: int, elem: Any): unit = throw new Throwable("NotImplemented")
  override def length: int = 0
}
