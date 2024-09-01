package scala

object Mirror {
  def isInt(c: Class[_]): Boolean = c.getName == "int"
  def isLong(c: Class[_]): Boolean = c.getName == "long"
  def isChar(c: Class[_]): Boolean = c.getName == "char"
  def isByte(c: Class[_]): Boolean = c.getName == "byte"
  def isShort(c: Class[_]): Boolean = c.getName == "short"
  def isBoolean(c: Class[_]): Boolean = c.getName == "boolean"

  def as[A](any: Any): A = throw new Throwable("NotImplemented")
}
