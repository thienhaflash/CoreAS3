package test 
{
	import flash.display.MovieClip;
	import vn.core.load.constant.LdStatus;
	import vn.core.load.core.LdQueue;
	import vn.core.load.core.LdVars;
	import vn.core.load.utils.loadURL;
	/**
	 * ...
	 * @author 
	 */
	public class LoaderTest extends MovieClip
	{
		protected var _queue : LdQueue = new LdQueue('main');
		public function LoaderTest() {
			ldQueue_test();
		}
		[Test]
		public function ldQueue_test(): void {
			
			_queue.add(new LdVars('1.jpg'))
						.on_STARTED(trace, ['START'])
						.on_PROGRESS(trace, ['PROGRESS'])
						.on_INFO(trace, ['INFO'])
						.on_ERROR(trace, ['ERROR']);
		}
		
	}

}