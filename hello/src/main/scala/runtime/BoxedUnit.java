/*                     __                                               *\
**     ________ ___   / /  ___     Scala API                            **
**    / __/ __// _ | / /  / _ |    (c) 2002-2007, LAMP/EPFL             **
**  __\ \/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **
** /____/\___/_/ |_/____/_/ | |                                         **
**                          |/                                          **
\*                                                                      */

// $Id$


package scala.runtime;


public final class BoxedUnit
{

    public final static BoxedUnit UNIT = new BoxedUnit();

    private BoxedUnit() { }

    public boolean equals(java.lang.Object other) {
	return this == other;
    }

    public int hashCode() {
	return 0;
    }

    public String toString() {
	return "()";
    }
}
