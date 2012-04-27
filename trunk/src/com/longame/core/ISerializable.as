package  com.longame.core
{
   public interface ISerializable
   {
	   /**
	   * 将对象输出为xml
	   * */
      function serialize():XML;
      /**
	  * 从xml实例化对象
	  * */
      function deserialize(xml:XML):void;
   }
}