package  com.longame.core
{
	/**
	 * Cogs or Machines can implement the IConditional interface. The main function of this interface is to determine if an object
	 * is true or false at any time. An example would be a "Crouching Cog" which controls a character's crouching. the CrouchingCog
	 * might implement IConditional and the <code>isTrue</code> method return whether or not the cog is in a "crouching" state.
	 * 
	 * <p>This IConditional can be passed into other cogs that have a dependency on it's state, and the conditionals can then be validate
	 * before some dependent method is executed. For instance, the "JumpCog" might have a dependency that the "DuckCog" is false before
	 * it will allow a jump to execute.</p> 
	 * @author ericsmith
	 * 
	 */	
	public interface IConditional
	{
		/**
		 * Returns true if the condition is true, and false if it is false.
		 * AccelerationCog,SurfaceDetectorCog用了它
		 */
		function get isTrue():Boolean;
	}
}