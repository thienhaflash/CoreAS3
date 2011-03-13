package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import test.DispatcherTest;
	import test.LoaderTest;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
		private var core : FlexUnitCore;
		
		public function Main():void 
		{
			core = new FlexUnitCore();
			core.addListener( new TraceListener());
			//core.run(DispatcherTest);
			core.run(LoaderTest);
		}
		
	}
	
}