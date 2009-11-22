package org.jbei.ui.dialogs
{
	import flash.events.Event;

	public class ModalDialogEvent extends Event
	{
		public static const SUBMIT:String = "okButtonModalDialogEvent";
		public static const CANCEL:String = "cancelButtonModalDialogEvent";
		
		private var _data:Object;
		
		// Constructor
		public function ModalDialogEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._data = data;
		}
		
		// Properties
		public function get data():Object
		{
			return _data;
		}
	}
}
