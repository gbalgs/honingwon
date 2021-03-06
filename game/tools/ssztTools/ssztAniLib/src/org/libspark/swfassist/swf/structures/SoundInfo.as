/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.swf.structures
{
	public class SoundInfo
	{
		private var _syncStop:Boolean = false;
		private var _syncNoMultiple:Boolean = false;
		private var _hasEnvelope:Boolean = false;
		private var _hasLoops:Boolean = false;
		private var _hasOutPoint:Boolean = false;
		private var _hasInPoint:Boolean = false;
		private var _inPoint:uint = 0;
		private var _outPoint:uint = 0;
		private var _loopCount:uint = 1;
		private var _envelopeRecords:Array = [];
		
		public function get syncStop():Boolean
		{
			return _syncStop;
		}
		
		public function set syncStop(value:Boolean):void
		{
			_syncStop = value;
		}
		
		public function get syncNoMultiple():Boolean
		{
			return _syncNoMultiple;
		}
		
		public function set syncNoMultiple(value:Boolean):void
		{
			_syncNoMultiple = value;
		}
		
		public function get hasEnvelope():Boolean
		{
			return _hasEnvelope;
		}
		
		public function set hasEnvelope(value:Boolean):void
		{
			_hasEnvelope = value;
		}
		
		public function get hasLoops():Boolean
		{
			return _hasLoops;
		}
		
		public function set hasLoops(value:Boolean):void
		{
			_hasLoops = value;
		}
		
		public function get hasOutPoint():Boolean
		{
			return _hasOutPoint;
		}
		
		public function set hasOutPoint(value:Boolean):void
		{
			_hasOutPoint = value;
		}
		
		public function get hasInPoint():Boolean
		{
			return _hasInPoint;
		}
		
		public function set hasInPoint(value:Boolean):void
		{
			_hasInPoint = value;
		}
		
		public function get inPoint():uint
		{
			return _inPoint;
		}
		
		public function set inPoint(value:uint):void
		{
			_inPoint = value;
		}
		
		public function get outPoint():uint
		{
			return _outPoint;
		}
		
		public function set outPoint(value:uint):void
		{
			_outPoint = value;
		}
		
		public function get loopCount():uint
		{
			return _loopCount;
		}
		
		public function set loopCount(value:uint):void
		{
			_loopCount = value;
		}
		
		public function get numEnvelopeRecords():uint
		{
			return envelopeRecords.length;
		}
		
		public function get envelopeRecords():Array
		{
			return _envelopeRecords;
		}
		
		public function set envelopeRecords(value:Array):void
		{
			_envelopeRecords = value;
		}
	}
}