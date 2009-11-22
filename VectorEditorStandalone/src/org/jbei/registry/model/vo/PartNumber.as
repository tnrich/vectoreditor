package org.jbei.registry.model.vo
{
	[RemoteClass(alias="org.jbei.registry.lib.models.PartNumber")]
	public class PartNumber
	{
		private var _id:int;
		private var _partNumber:String;
		private var _entry:Entry;
		
		// Constructor
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void	
		{
			_id = value;
		}
		
		public function PartNumber(partNumber:String = null)	
		{
			_partNumber = partNumber;
		}
		
		// Properties
		public function get partNumber():String	
		{
			return _partNumber;
		}
		
		public function set partNumber(value:String):void	
		{
			_partNumber = value;
		}
		
		public function get entry():Entry
		{
			return _entry;
		}
		
		public function set entry(value:Entry):void	
		{
			_entry = value;
		}
	}
}
