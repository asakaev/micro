package scala.runtime

final class BoxedAnyArray(val length: Int) extends BoxedArray {
  override def apply(index: int): Any = throw new Throwable("NotImplemented")
  override def update(index: int, elem: Any): unit = throw new Throwable("NotImplemented")
}
