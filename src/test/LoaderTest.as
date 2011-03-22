package test 
{
	import flash.display.MovieClip;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import vn.core.load.core.LdQueue;
	/**
	 * ...
	 * @author 
	 */
	public class LoaderTest extends MovieClip
	{
		protected var _queue : LdQueue = new LdQueue('main');
		public function LoaderTest() {
			//ldQueue_test();
			ldData_test();
			ldAudio_test();
			ldVideo_test();
			
			//ldData_test();
			//ldAudio_test();
			//ldVideo_test();
			
		}
		
		public function ldQueue_test(): void {
			_queue.on_QUEUE_ITEM_ADDED(trace, ['QUEUE_ITEM_ADDED'])
					.on_QUEUE_STATUS(function(): void {
						trace('QUEUE STATUS : ', _queue.status);
					});
		}
		
		public function ldData_test(): void {
			_queue.addURL('index.html')
					.configData()
					.on_COMPLETED(function(): void {
						trace('ldData COMPLETE : '+ String(_queue.currentLoader.dataVars.loadedContent).length);
						//trace('ldData COMPLETE : ', _queue.currentLoader.loadedContent);
					});
		}
		
		public function ldAudio_test(): void {
			_queue.addURL('asset/1.mp3')
					//.configAudio()
					//.on_ERROR(trace, ['ldAudio :: ERROR'])
					.on_COMPLETED(function():void {
						trace('ldAudio COMPLETE : ', _queue.currentLoader.audioVars.duration);
						//for (var s: String in cl.id3) {
							//trace(s+':'+cl.id3[s]);
						//}
					});
		}
		
		public function ldVideo_test(): void {
			_queue.addURL('asset/1.flv')
					//.on_STARTED(trace, ['START'])
					//.on_PROGRESS(trace, ['PROGRESS'])
					//.on_INFO(trace, ['INFO'])
					.on_COMPLETED(function(): void {
						trace('ldVideo COMPLETE : ', _queue.currentLoader.videoVars.metaData);
					});
		}
		
		
		
		
		
	}

}