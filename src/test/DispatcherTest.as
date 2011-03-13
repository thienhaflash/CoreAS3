package test 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import org.flexunit.asserts.assertEquals;
	import vn.core.event.Dispatcher;
	import vn.core.event.EventObject;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class DispatcherTest
	{
		protected var _dispatcher : Dispatcher;
		
		public function DispatcherTest() 
		{
			_dispatcher = new Dispatcher();
		}
		
	/********************
	 *		TESTS
	 *******************/
		
		[Test]
		public function getNumberOfListenerOrCallback():void {
			_dispatcher.addListener('Event1', onEvent1);
			assertEquals(1, _dispatcher.numListenerOrCallback('Event1'));
			
			_dispatcher.removeListenerOrCallback('Event1', onEvent1);
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
		}
		 
		[Test]
		public function duplicatedAddEvent():void {
			_dispatcher.addListener('Event1', onEvent1);
			_dispatcher.addListener('Event1', onEvent1);
			_dispatcher.addListener('Event1', onEvent1);
			_dispatcher.addListener('Event1', onEvent1);
			
			assertEquals(1, _dispatcher.numListenerOrCallback('Event1'));
		}
		
		[Test]
		public function normalPriority():void {
			events = '';
			_dispatcher.addListener('Event1', onEvent1);
			_dispatcher.addListener('Event1', onEvent2);
			_dispatcher.addListener('Event1', onEvent3);
			_dispatcher.addListener('Event1', onEvent4);
			_dispatcher.addListener('Event1', onEvent5);
			_dispatcher.dispatch('Event1');
			
			assertEquals(5, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals('12345', events);
			
			events = '';
			_dispatcher.removeListenerOrCallback('Event1', onEvent1);
			_dispatcher.removeListenerOrCallback('Event1', onEvent2);
			_dispatcher.removeListenerOrCallback('Event1', onEvent3);
			_dispatcher.removeListenerOrCallback('Event1', onEvent4);
			_dispatcher.removeListenerOrCallback('Event1', onEvent5);
			_dispatcher.dispatch('Event1');
			
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals('', events);
		}
		
		[Test]
		public function specialPriority():void {
			events = '';
			_dispatcher.addListener('Event1', onEvent1, null, 0);
			_dispatcher.addListener('Event1', onEvent2, null, 2);
			_dispatcher.addListener('Event1', onEvent3, null, 4);
			_dispatcher.addListener('Event1', onEvent4, null, 2); //important : duplicated priority should be sorted by timeStamp (id)
			_dispatcher.addListener('Event1', onEvent5, null, 1);
			_dispatcher.dispatch('Event1');
			
			assertEquals(5, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals('32451', events);
			
			events = '';
			_dispatcher.removeListenerOrCallback('Event1', onEvent1); //important : this trying to remove the last one first
			_dispatcher.removeListenerOrCallback('Event1', onEvent2);
			_dispatcher.removeListenerOrCallback('Event1', onEvent3);
			_dispatcher.removeListenerOrCallback('Event1', onEvent4);
			_dispatcher.removeListenerOrCallback('Event1', onEvent5);
			_dispatcher.dispatch('Event1');
			
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals('', events);
		}
		
		[Test]
		public function callbackAndListener(): void {
			var rnd : int = Math.random();
			_dispatcher.addListener('Event1', onEventWithUD, { id: rnd });
			_dispatcher.dispatch('Event1');
			_dispatcher.removeListenerOrCallback('Event1', onEventWithUD);
			assertEquals(rnd, _id);
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
			
			rnd = Math.random();
			_dispatcher.addCallback('Event1', onEventCallback, [rnd, _dispatcher], 2);
			_dispatcher.dispatch('Event1');
			_dispatcher.removeListenerOrCallback('Event1', onEventCallback);
			assertEquals(rnd, _id);
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
		}
		
		[Test]
		public function batchListen_1Event_5Handlers(): void {
			//multiple handlers to 1 event
			events = '';
			_dispatcher.addListeners('Event1', [onEvent1, onEvent2, onEvent3, onEvent4, onEvent5]);
			_dispatcher.dispatch('Event1');			
			assertEquals(5, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals('12345', events);
			
			_dispatcher.removeListenersOrCallbacks('Event1', [onEvent1, onEvent2, onEvent3, onEvent4, onEvent5]);
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
		}
		
		[Test]
		public function batchListen_5Events_1Handler(): void {	
			events = '';
			_dispatcher.addListeners(['Event1', 'Event2', 'Event3', 'Event4', 'Event5'] , onEvent1);
			_dispatcher.dispatch('Event1');
			_dispatcher.dispatch('Event2');
			_dispatcher.dispatch('Event3');
			_dispatcher.dispatch('Event4');
			_dispatcher.dispatch('Event5');
			assertEquals(1, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event2'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event3'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event4'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event5'));
			assertEquals('11111', events);
			
			_dispatcher.removeListenersOrCallbacks(['Event1', 'Event2', 'Event3', 'Event4', 'Event5'], onEvent1);
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event2'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event3'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event4'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event5'));
		}
		
		[Test]
		public function batchListen_5Events_5Handlers(): void {				
			//multiple events to multiple handlers
			events = '';
			_dispatcher.addListeners( ['Event1', 'Event2', 'Event3', 'Event4', 'Event5']
									, [onEvent1, onEvent2, onEvent3, onEvent4, onEvent5]
									);
			_dispatcher.dispatch('Event1');
			_dispatcher.dispatch('Event2');
			_dispatcher.dispatch('Event3');
			_dispatcher.dispatch('Event4');
			_dispatcher.dispatch('Event5');		
			assertEquals(1, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event2'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event3'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event4'));
			assertEquals(1, _dispatcher.numListenerOrCallback('Event5'));
			assertEquals('12345', events);
			
			_dispatcher.removeListenersOrCallbacks(	['Event1', 'Event2', 'Event3', 'Event4', 'Event5']
												  ,	[onEvent1, onEvent2, onEvent3, onEvent4, onEvent5]);
			assertEquals(0, _dispatcher.numListenerOrCallback('Event1'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event2'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event3'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event4'));
			assertEquals(0, _dispatcher.numListenerOrCallback('Event5'));
		}
		
	/********************
	 *		HELPERS
	 *******************/
		
		protected var events : String;
		
		private function onEvent1(e:EventObject):void 
		{
			events += '1';
		}
		private function onEvent2(e:EventObject):void 
		{
			events += '2';
		}
		private function onEvent3(e:EventObject):void 
		{
			events += '3';
		}
		
		private function onEvent4(e:EventObject):void 
		{
			events += '4';
		}
		private function onEvent5(e:EventObject):void 
		{
			events += '5';
		}
		
		protected var _id : int;
		
		private function onEventWithUD(e: EventObject): void {
			_id = e.userData.id;
		}
		
		protected function onEventCallback(id: int, d: Dispatcher): void {
			_id = id;
		}
		
	}

}