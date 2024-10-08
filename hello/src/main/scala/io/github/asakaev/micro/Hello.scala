package io.github.asakaev.micro

import javax.microedition.lcdui.{Display, Form}
import javax.microedition.midlet.MIDlet

final class Hello() extends MIDlet {

  def destroyApp(b: Boolean): Unit = {
    notifyDestroyed()
  }

  def pauseApp(): Unit = {}

  def startApp(): Unit = {
    val form = new Form("It's alive!")
    val m = Message("Scala 2.6.1", "JVM 1.3")
    form.append(m.scala) // TODO: toString not working, String.lastIndexOf
    val display = Display.getDisplay(this)
    display.setCurrent(form)
  }

}
